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
  (display "I Futamura Projection:\n")
  (define tm-int-division
    '((program ptail curp elem)
      (right left tmp)))
  (define tm-int-vs
    `((program . ,tm-example)
      (ptail . '())
      (curp . '())
      (elem . '())))
  (prettyprint (int mix-naïve `(,tm-int ,tm-int-division ,tm-int-vs)))
  (define interpret (int mix-naïve `(,tm-int ,tm-int-division ,tm-int-vs)))
  (print (int interpret'((1 1 1 0 1 0 1))))

  (display "\n\nII Futamura Projection, naïve version:\n")
  (define mix-naïve-division
    '((program division)
      (vs0 pending marked residual pp bb vs code command x e ift iff nift niff ps)))
  (define mix-naïve-vs
    `((program . ,tm-int)
      (division . ,tm-int-division)))
  (prettyprint (int mix-naïve `(,mix-naïve ,mix-naïve-division ,mix-naïve-vs)))
  (display "\nAs expected, it did nothing. The reason is that in the naïve mix virtually all variables are static. And the next task is to fix it.\n")
  '())

(main)