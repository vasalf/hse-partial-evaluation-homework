#lang racket

(require "flowchart/main.rkt")
(require "flowchart/prettyprint.rkt")
(require "tm/main.rkt")
(require "mix/naive.rkt")
(require "mix/main.rkt")

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
      (right left tmp)
      (program ptail curp elem)))
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
      (vs0 pending marked residual pp bb vs code command x e ift iff nift niff ps)
      (program division)))
  (define mix-naïve-vs
    `((program . ,tm-int)
      (division . ,tm-int-division)))
  (define mix-naïve-compiler (int mix-naïve `(,mix-naïve ,mix-naïve-division ,mix-naïve-vs)))
  (prettyprint mix-naïve-compiler)
  (define mix-naïve-tm-program
    (int mix-naïve-compiler `(,tm-int-vs)))
  (prettyprint mix-naïve-tm-program)
  (print (int mix-naïve-tm-program '((1 1 1 0 1 0 1))))
  (display "\n\nAs expected, it did nothing. The reason is that in the naïve mix virtually all variables are static. And the next task is to fix it.\n")

  (display "\nI Futamura Projection:\n")
  (define interpret2 (int mix `(,tm-int ,tm-int-division ,tm-int-vs)))
  (prettyprint interpret2)
  (print (int interpret2 '((1 1 1 0 1 0 1))))

  (display "\n\n II Futamura Projection:\n")
  (define mix-division
    '((program division labels ppp bb command x e ift iff bbh)
      (vs0 pending marked residual pp vs code nift niff ps ex)
      (ppp command)))
  (define mix-vs
    `((program . ,tm-int)
      (division . ,tm-int-division)
      (labels . '())
      (ppp . '())
      (bb . '())
      (command . '())
      (x . '())
      (e . '())
      (ift . '())
      (iff . '())
      (bbh . '())))
  (define mix-compiler (int mix `(,mix ,mix-division ,mix-vs)))
  (prettyprint mix-compiler)
  (define mix-tm-program
    (int mix-compiler `(,tm-int-vs)))
  (prettyprint mix-tm-program)
  (print (int mix-tm-program '((1 1 1 0 1 0 1))))
  '())

(main)
