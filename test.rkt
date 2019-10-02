#lang racket

(require "flowchart/main.rkt")
(require "flowchart/prettyprint.rkt")
(require "tm/main.rkt")
(require "mix/naive.rkt")

(define (main)
  (define find-name
    '((read name namelist valuelist)
      (search (if (equal? name (car namelist)) found cont))
      (cont (:= valuelist (cdr valuelist))
            (:= namelist  (cdr namelist))
            (goto search))
      (found (return (car valuelist)))
      ))

  (display "==== HW1 ====\n")
  (display (int find-name '(y (x y z) (1 2 3))))
  (display "\n")

  (define tm-example
    '((0 if 0 goto 3)
      (1 right)
      (2 goto 0)
      (3 write 1)))

  (display (int tm-int `(,tm-example (1 1 1 0 1 0 1))))
  (display "\n\n")

  (display "==== HW2 (big, hard, painful, and a bit philosophical) ====\n")
  (define fc-example
    '((read x y)
      (block (return x))))
  
  (prettyprint (int mix-naïve `(,fc-example ((x) (y)) ((x . 179)))))

  )

(main)