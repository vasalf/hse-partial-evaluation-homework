#lang racket

(provide int)

(require racket/match)

(define (int program data)
  (define read-bounds
    (match (car program)
      [(list 'read v ...) v]))
  (define lbl-blocks (cdr program))
  (define first-block (cdr (car lbl-blocks)))
  (define ns (make-base-namespace))
  (define (eval-expr expr) (parameterize ([current-namespace ns]) (eval expr)))
  (define (assign-noeval var value) (parameterize ([current-namespace ns])
                              (namespace-set-variable-value! var value)))
  (define (assign var expr) (assign-noeval var (eval-expr expr)))
  (define (eval-assignment assignment)
    (match assignment
      [(list ':= var expr) (assign var expr)]))
  (define (eval-jump jump)
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
  
  (map assign-noeval read-bounds data)
  (map bind-block lbl-blocks)
  (eval-block first-block))
