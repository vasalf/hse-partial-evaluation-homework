#lang racket

(require "flowchart/main.rkt")

(define find-name
  '((read name namelist valuelist)
    (search (if (equal? name (car namelist)) found cont))
    (cont (:= valuelist (cdr valuelist))
          (:= namelist  (cdr namelist))
          (goto search))
    (found (return (car valuelist)))
   ))

(display (int find-name '(y (x y z) (1 2 3))))