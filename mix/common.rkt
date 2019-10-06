#lang racket

(provide init-residual
         is-static-symb?
         extend-bb
         extend-code
         first-command
         bb-tail
         extend-vs
         reduce-vs
         block-name
         extend-unmarked
         eval-expr
         initial-code
         is-static-expr?
         reduce
         normalize-blocks)

(require racket/format)
(require "../flowchart/util.rkt")

(define (init-residual program division)
  (define (is-dynamic-symb? symb) (not (is-static-symb? symb division)))
  (cond
    [(equal? (caar program) 'import) `(,(import-stmt program)
                                       ,(filter is-dynamic-symb? (read-stmt program)))]
    [else `(,(filter is-dynamic-symb? (read-stmt program)))]))

(define (is-static-symb? symb division) (member symb (car division)))

(define (extend-bb bb cmd) (append bb `(,cmd)))

(define (extend-code code bb) (append code `(,bb)))

(define (first-command bb) (cadr bb))

(define (bb-tail bb) (append `(,(car bb)) (cddr bb)))

(define (extend-vs vs x expr)
  (cond
    [(null? vs) `(,x . ,expr)]
    [(equal? x (caar vs)) (cons `(,x . ,expr) (cdr vs))]
    [else (cons (car vs) (extend-vs (cdr vs) x expr))]))

(define (reduce-vs vs x)
  (cond
    [(null? vs) '()]
    [(equal? x (caar vs)) (cdr vs)]
    [else (cons (car vs) (reduce-vs (cdr vs) x))]))

(define (block-name pp vs) `(,pp . ,vs))

(define (extend-unmarked pending ps marked)
  (define (extend-once ps p)
    (cond
      [(member p marked) ps]
      [else (append ps (list p))]))
  (extend-once (extend-once pending (car ps)) (cadr ps)))

(define (eval-expr expr vs)
  (define ns (make-base-namespace))
  (define (extend-once kv)
    (match kv
      [(cons key value) (namespace-set-variable-value! key value #f ns)]))
  (map extend-once vs)
  (parameterize ([current-namespace ns]) (eval expr)))

(define (initial-code pp vs) `(,(block-name pp vs)))

(define (is-static-expr? expr division)
  (define (is-dynamic-symb? symb) (member symb (cadr division)))
  (define (self-ap e) (is-static-expr? e division))
  (define (ans-symb symb)
    (cond
      [(is-static-symb? symb division) #t]
      [(is-dynamic-symb? symb) #f]
      [else #t]))
  (match expr
    [(list 'quote v ...) #t]
    [(list v ...) (andmap self-ap v)]
    [(var symb)   (ans-symb symb)]))

(define (reduce expr vs division)
  (define (self-ap e) (reduce e vs division))
  (match expr
    [(list 'quote v ...) expr]
    [(list v ...) (cond
                    [(is-static-expr? expr division) (eval-expr expr vs)]
                    [else (map self-ap v)])]
    [(var symb) (cond
                  [(is-static-symb? symb division) (eval-expr expr vs)]
                  [else expr])]))

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