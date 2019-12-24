#lang racket

(provide init-residual
         is-static-symb?
         extend-bb
         extend-code
         first-command
         bb-tail
         extend-vs
         block-name
         extend-unmarked
         add-to-marked
         eval-expr
         initial-code
         is-static-expr?
         reduce
         normalize-blocks
         dynamic-labels
         live-vars)

(require racket/format)
(require "../flowchart/util.rkt")

(define (init-residual program division)
  (define (is-dynamic-symb? symb) (not (is-static-symb? symb division)))
  `(,(filter is-dynamic-symb? (read-stmt program))))

(define (is-static-symb? symb division) (member symb (car division)))

(define (extend-bb bb cmd) (append bb `(,cmd)))

(define (extend-code code bb) (append code `(,bb)))

(define (first-command bb) (cadr bb))

(define (bb-tail bb) (append `(,(car bb)) (cddr bb)))

(define (extend-vs vs x expr)
  (cond
    [(null? vs) `(,x ,expr)]
    [(equal? x (caar vs)) (cons `(,x . ,expr) (cdr vs))]
    [else (cons (car vs) (extend-vs (cdr vs) x expr))]))

(define (block-name pp vs0 live-variables)
  (define vs
    (filter (λ (v) (set-member? (hash-ref live-variables pp) (car v))) vs0))
  `(,pp . ,vs))

(define (extend-unmarked pending ps marked live-variables)
  (define (extend-once ps p)
    (cond
      [(member (block-name (car p) (cadr p) live-variables) marked) ps]
      [else (append ps (list p))]))
  (extend-once (extend-once pending (car ps)) (cadr ps)))

(define (eval-expr expr vs0 imports)
  (define vs (expand-vs0 vs0 imports))
  (define ns (make-base-namespace))
  (define (extend-once kv)
    (match kv
      [(cons key value) (namespace-set-variable-value! key value #f ns)]))
  (map extend-once vs)
  (parameterize ([current-namespace ns]) (eval expr)))

(define (initial-code pp vs lv) `(,(block-name pp vs lv)))

(define (is-static-expr-cnt? expr division qql)
  (define (is-dynamic-symb? symb) (member symb (cadr division)))
  (define (ans-symb symb) (not (is-dynamic-symb? symb)))
  (define (ans-rec expr division qql)
    (define (self-ap e)    (ans-rec e division qql))
    (define (self-ap-qq e) (ans-rec e division (+ qql 1)))
    (define (self-ap-uq e) (ans-rec e division (- qql 1)))
    (match expr
      [(list 'quote v ...)      #t]
      [(list 'quasiquote v ...) (andmap self-ap-qq v)]
      [(list 'unquote v ...)    (andmap self-ap-uq v)]
      [(list v vv ...)          (and (self-ap v) (self-ap vv))]
      [(var symb)               (cond
                                  [(> qql 0) #t]
                                  [else (ans-symb symb)])]))
  (ans-rec expr division qql))

(define (is-static-expr? expr division)
  (is-static-expr-cnt? expr division 0))

(define (expand-division division imports)
  (define (expand-division-once d v)
    (match v
      [(cons var val) `(,(append (car d) `(,var)) ,(cadr d))]))
  (define (run d v)
    (match v
      [(list) d]
      [(list v ...) (run (expand-division-once d (car v)) (cdr v))]))
  (match imports
    [(list 'import v ...) (run division v)]
    [(list) division]))

(define (expand-vs0 vs0 imports)
  (define (expand-vs0-once vs0 v)
    (append `(,v) vs0))
  (define (run d v)
    (match v
      [(list) d]
      [(list v ...) (run (expand-vs0-once d (car v)) (cdr v))]))
  (match imports
    [(list 'import v ...) (run vs0 v)]
    [(list) vs0]))

; (define (reduce expr vs0 div imports)
;   (define division (expand-division div imports))
;   (define vs (expand-vs0 vs0 imports)) 
;   (define (ans-rec expr vs division qql)
;     (define (self-ap    e) (ans-rec e vs division qql))
;     (define (self-ap-qq e) (ans-rec e vs division (+ qql 1)))
;     (define (self-ap-uq e) (ans-rec e vs division (- qql 1)))
;     (match expr
;       [(list 'quote      v ...) expr]
;       [(list 'quasiquote v)     (cond
;                                   [(is-static-expr-cnt? expr division qql) (eval-expr expr vs imports)]
;                                   [else                                    (cons 'quasiquote `(,(self-ap-qq v)))])]
;       [(list 'unquote    v)     (cond
;                                   [(is-static-expr-cnt? expr division qql) (self-ap-uq v)]
;                                   [else                                    (cons 'unquote `(,(self-ap-uq v)))])]
;       [(list             v ...) (cond
;                                   [(is-static-expr-cnt? expr division qql) (eval-expr expr vs imports)]
;                                   [else                                    (map self-ap v)])]
;       [(var symb)               (cond
;                                   [(> qql 0)                       expr]
;                                   [(is-static-symb? symb division) (eval-expr expr vs imports)]
;                                   [else                            expr])]))
;   (match expr
;     [(list 'quote v ...)      (ans-rec expr vs division 0)]
;     [(list 'quasiquote v ...) (ans-rec expr vs division 0)]
;     [(list v ...)             (cond
;                                 [(is-static-expr? expr division) (cons 'quote `(,(ans-rec expr vs division 0)))]
;                                 [else                            (ans-rec expr vs division 0)])]
;     [(var symb)               (ans-rec expr vs division 0)]))

(define (reduce expr vs0 div imports)
  (define (handle-error e) 
    (match e
      [(list es ...) (map do-eval e)]
      [_  e]))
  (define (do-eval e)
    (with-handlers
      ([exn:fail? (λ (err) (handle-error e))])
      `',(eval-expr e vs0 imports)))
  (do-eval expr))

(define (normalize-blocks program)
  (define h (make-hash))
  (define max-id (make-hash))
  (define (norm-add-id id)
    (define new-id (+ 1 (hash-ref max-id (car id))))
    (define upd-id (string->symbol (string-append (symbol->string (car id)) "!" (~v new-id))))
    (hash-set! max-id (car id) new-id)
    (hash-set! h id upd-id)
    upd-id)
  (define (norm-id id)
    (cond
      [(hash-has-key? h id) (hash-ref h id)]
      [else (norm-add-id id)]))
  (define (norm-new-id id)
    (hash-set! max-id (car id) -1)
    (norm-add-id id))
  (define (normalize-id id)
    (cond
      [(hash-has-key? max-id (car id)) (norm-id id)]
      [else (norm-new-id id)]))
  (define (normalize-cmd cmd)
    (match cmd
      [(list 'debug v ...) cmd]
      [(list ':= v ...) cmd]
      [(list 'if expr g1 g2) `(if ,expr ,(normalize-id g1) ,(normalize-id g2))]
      [(list 'goto g) `(goto ,(normalize-id g))]
      [(list 'return expr) cmd]))
  (define (normalize-block block)
    (append `(,(normalize-id (car block))) (map normalize-cmd (cdr block))))
  (define beginning
    (cond
      [(equal? (caar program) 'import) `(,(car program) ,(cadr program))]
      [else `(,(car program))]))
  (append beginning (map normalize-block (lbl-blocks program))))

(define (dynamic-labels program d)
  (define division (expand-division d (import-stmt program)))
  (define (check-pp pp division)
    (match pp
      [(list 'if expr l1 l2) (cond
                               [(is-static-expr? expr division) '()]
                               [else `(,l1 ,l2)])]
      [_ '()]))
  (define (check-bb bb division)
    (define (ap pp) (check-pp pp division))
    (append* (map ap (cdr bb))))
  (define (ap bb) (check-bb bb division))
  (append `(,(car (initial-block program)))
          (append* (map ap (lbl-blocks program)))))

(define (add-to-marked ps marked)
  (define (extend-once p marked)
    (cond
      [(member p marked) marked]
      [else (cons p marked)]))
  (match ps
    [(list) marked]
    [(list p pp ...) (add-to-marked pp (extend-once p marked))]))

(define (live-vars program division)
  (define mut-at  (make-hash))
  (define used-at (make-hash))

  (define (used-in var expr)
    (define (app e qql)
      (define (self-ap-qq ex) (app ex (+ qql 1)))
      (define (self-ap-uq ex) (app ex (- qql 1)))
      (define (self-ap ex)    (app ex qql))
      (match e
        [(list 'quote es ...)      #f]
        [(list 'quasiquote es ...) (ormap self-ap-qq es)]
        [(list 'unquote es ...)    (ormap self-ap-uq es)]
        [(list eh et ...)          (or (self-ap eh) (self-ap et))]
        [(var symb)                (cond
                                     [(> qql 0) #f]
                                     [else (equal? symb var)])]))
    (app expr 0))

  (define (get-mut-used bb)
    (define mut  (mutable-set))
    (define used (mutable-set))
    (define (add-used var)
      (when (not (set-member? mut var))
        (set-add! used var)))
    (define (add-all-used expr)
      (map (λ (v) (when (used-in v expr) (add-used v))) (car division)))
    (define (app stmt)
      (match stmt
        [(list ':= var expr)
            (add-all-used expr)
            (set-add! mut var)]
        [(list 'return expr)
            (add-all-used expr)]
        [(list 'goto label) '()]
        [(list 'if expr l1 l2)
            (add-all-used expr)]
        [_ '()]))
    (map app (cdr bb))
    `(,mut ,used))

  (map
    (λ (bb)
      (match (get-mut-used bb)
        [(list mut used)
            (hash-set! mut-at (car bb) mut)
            (hash-set! used-at (car bb) used)]))
    (lbl-blocks program))

  (define (next lbl)
    (match (last (lookup lbl program))
      [(list 'return expr) '()]
      [(list 'goto lbl) `(,lbl)]
      [(list 'if e l1 l2) `(,l1 ,l2)]))

  (define (dfs lbl var vis)
    (cond [(set-member? vis lbl) #f] [else
      (set-add! vis lbl)
      (cond [(set-member? (hash-ref used-at lbl) var) #t] [else
        (cond [(set-member? (hash-ref mut-at lbl) var) #f] [else
          (ormap (λ (nlbl) (dfs nlbl var vis)) (next lbl))])])]))

  (define (vars-for lbl)
    (filter (λ (var) (dfs lbl var (mutable-set))) (car division)))

  (define ret (make-hash))
  (map (λ (lbl) (hash-set! ret lbl (vars-for lbl))) (dynamic-labels program division))
  ret)
