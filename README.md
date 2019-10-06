## Вывод `test.rkt` на сейчас:

```
==== HW1 ====
2
(1 1 0 1)

==== HW2 (big, hard, painful, and a bit philosophical) ====
I Futamura Projection:
read right;
init!0:   left := (quote ());
          if (null? right) ifnull!0 ifnn!0;
ifnull!0: if (null? right) prnull!0 prnn!0;
ifnn!0:   if (equal? 0 (car right)) ifgt!0 next!0;
prnull!0: left := (cons   left);
          if (null? right) ifnull!0 ifnn!0;
prnn!0:   tmp := (car right);
          left := (cons tmp left);
          right := (cdr right);
          if (null? right) ifnull!0 ifnn!0;
ifgt!0:   if (null? right) wrnull!0 wrnn!0;
next!0:   if (null? right) prnull!0 prnn!0;
wrnull!0: right := (1);
          return right;
wrnn!0:   right := (cons 1 (cdr right));
          return right;
'(1 1 0 1)'()
```
