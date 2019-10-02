#lang racket

(provide lbl-blocks
         initial-block
         lookup
         import-stmt
         read-stmt)

(require racket/match)

(define (lbl-blocks program)
  (match (car program)
    [(list 'read v ...) (cdr program)]
    [(list 'import v ...) (cddr program)]))

(define (initial-block program)
  (car (lbl-blocks program)))

(define (lookup pp program)
  (define (lookup-rec blocks)
    (cond
      [(empty? blocks) '()]
      [(equal? (caar blocks) pp) (car blocks)]
      [else (lookup-rec (cdr blocks))]))
  (lookup-rec (lbl-blocks program)))

(define (import-stmt program)
  (match (car program)
    [(list 'read v ...) '()]
    [(list 'import v ...) (car program)]))

(define (read-stmt program)
  (match (car program)
    [(list 'read v ...) (car program)]
    [(list 'import v ...) (cadr program)]))