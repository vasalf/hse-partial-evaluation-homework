#lang racket

(require "flowchart/main.rkt")
(require "tm/main.rkt")

(define find-name
  '((read name namelist valuelist)
    (search (if (equal? name (car namelist)) found cont))
    (cont (:= valuelist (cdr valuelist))
          (:= namelist  (cdr namelist))
          (goto search))
    (found (return (car valuelist)))
   ))

(display (int find-name '(y (x y z) (1 2 3))))

(display "\n")

(define tm-example
  '((0 if 0 goto 3)
    (1 right)
    (2 goto 0)
    (3 write 1)))

(display (int tm-int `(,tm-example (1 1 1 0 1 0 1))))