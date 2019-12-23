#lang racket

(provide int)

(require racket/match)

(define (int program data)
  (define (read-block program)
    (match (car program)
      [(list 'read v ...) (car program)]
      [(list 'import v ...) (cadr program)]))
  (define read-bounds
    (match (read-block program)
      [(list 'read v ...) v]))
  (define import-list
    (match (car program)
      [(list 'read v ...) '()]
      [(list 'import v ...) v]))
  (define lbl-blocks
    (match (car program)
      [(list 'read v ...) (cdr program)]
      [(list 'import v ...) (cddr program)]))
  (define first-block (cdr (car lbl-blocks)))
  (define ns (make-base-namespace))
  (define (eval-expr expr) (parameterize ([current-namespace ns]) (eval expr)))
  (define (assign-noeval var value) (parameterize ([current-namespace ns])
                              (namespace-set-variable-value! var value)))
  (define (assign-noeval/pair p)
    (match p
      [(cons symbol value) (assign-noeval symbol value)]))
  (define (assign var expr) (assign-noeval var (eval-expr expr)))
  (define (eval-assignment assignment)
    ; (println assignment)
    (match assignment
      [(list ':= var expr) (assign var expr)]
      [(list 'pause) (read-line (current-input-port) 'any)]
      [(list 'debug exprs ...) (println (map eval-expr exprs))]))
  (define (eval-jump jump)
    ; (println jump)
    (define (goto label) (eval-block (eval-expr label)))
    (match jump
      [(list 'goto label) (goto label)]
      [(list 'if expr l1 l2)
       (if (eval-expr expr) (goto l1) (goto l2))]
      [(list 'return expr) (eval-expr expr)]))
  (define (eval-block block)
    (match block
      [(list assignments ... jump)
       (map eval-assignment assignments)
       (eval-jump jump)]))
  (define (bind-block lbl-block) (assign-noeval (car lbl-block) (cdr lbl-block)))

  (map assign-noeval/pair import-list)
  (map assign-noeval read-bounds data)
  (map bind-block lbl-blocks)
  (eval-block first-block))

