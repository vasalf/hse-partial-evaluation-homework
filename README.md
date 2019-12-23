## `test.rkt` output:

```
==== HW1 ====
2
(1 1 0 1)

==== HW2 (big, hard, painful, and a bit philosophical) ====
I Futamura Projection:
read right;
init!0:   left := '();
          if ((quote #<procedure:null?>) right) ifnull!0 ifnn!0;
ifnull!0: if ((quote #<procedure:null?>) right) prnull!0 prnn!0;
ifnn!0:   if ((quote #<procedure:equal?>) (quote 0) ((quote #<procedure:car>) right)) ifgt!0 next!0;
prnull!0: left := ('#<procedure:cons> '" " left);
          if ((quote #<procedure:null?>) right) ifnull!0 ifnn!0;
prnn!0:   tmp := ('#<procedure:car> right);
          left := ('#<procedure:cons> tmp left);
          right := ('#<procedure:cdr> right);
          if ((quote #<procedure:null?>) right) ifnull!0 ifnn!0;
ifgt!0:   if ((quote #<procedure:null?>) right) wrnull!0 wrnn!0;
next!0:   if ((quote #<procedure:null?>) right) prnull!0 prnn!0;
wrnull!0: right := '(1);
          return right;
wrnn!0:   right := ('#<procedure:cons> '1 ('#<procedure:cdr> right));
          return right;
'(1 1 0 1)

II Futamura Projection, naïve version:
read vs0;
init!0:    pending := `((,'init ,vs0));
           marked := '();
           residual := '((read right));
           if ((quote #<procedure:null?>) pending) end!0 loopb!0;
end!0:     return ((quote #<procedure:normalize-blocks>) residual);
loopb!0:   pp := ('#<procedure:caar> pending);
           vs := ('#<procedure:cadar> pending);
           pending := ('#<procedure:cdr> pending);
           marked := ('#<procedure:cons> ('#<procedure:block-name> pp vs '((program ptail curp elem) (right left tmp) (program ptail curp elem))) marked);
           bb := ('#<procedure:lookup> pp '((read program right) (init (:= ptail program) (:= left '()) (goto loop0)) (loop0 (if (null? ptail) ret loop1)) (loop1 (:= curp (cdar ptail)) (if (equal? (car curp) 'left) pleft loop2)) (loop2 (if (equal? (car curp) 'right) pright loop3)) (loop3 (if (equal? (car curp) 'write) pwrite loop4)) (loop4 (if (equal? (car curp) 'goto) pgoto loop5)) (loop5 (if (equal? (car curp) 'if) pif ret)) (pleft (if (null? left) plnull plnn)) (plnull (:= right (cons " " right)) (goto next)) (plnn (:= tmp (car left)) (:= left (cdr left)) (:= right (cons tmp right)) (goto next)) (pright (if (null? right) prnull prnn)) (prnull (:= left (cons " " left)) (goto next)) (prnn (:= tmp (car right)) (:= left (cons tmp left)) (:= right (cdr right)) (goto next)) (pwrite (:= elem (cadr curp)) (if (null? right) wrnull wrnn)) (wrnull (:= right `(,elem)) (goto next)) (wrnn (:= right (cons elem (cdr right))) (goto next)) (pgoto (:= ptail program) (goto gtloop)) (gtloop (if (equal? (cadr curp) (caar ptail)) loop0 gtiter)) (gtiter (:= ptail (cdr ptail)) (goto gtloop)) (pif (if (null? right) ifnull ifnn)) (ifnull (if (equal? (cadr curp) " ") ifgt next)) (ifnn (if (equal? (cadr curp) (car right)) ifgt next)) (ifgt (:= curp (cddr curp)) (goto pgoto)) (next (:= ptail (cdr ptail)) (goto loop0)) (ret (return right))));
           code := ('#<procedure:initial-code> pp vs '((program ptail curp elem) (right left tmp) (program ptail curp elem)));
           if ((quote #<procedure:<>) ((quote #<procedure:length>) bb) (quote 2)) endbb!0 loopbbb!0;
endbb!0:   residual := ('#<procedure:extend-code> residual code);
           if ((quote #<procedure:null?>) pending) end!0 loopb!0;
loopbbb!0: command := ('#<procedure:first-command> bb);
           bb := ('#<procedure:bb-tail> bb);
           if ((quote #<procedure:equal?>) ((quote #<procedure:car>) command) (quote debug)) loopbb!0 casebb1!0;
loopbb!0:  if ((quote #<procedure:<>) ((quote #<procedure:length>) bb) (quote 2)) endbb!0 loopbbb!0;
casebb1!0: if ((quote #<procedure:equal?>) ((quote #<procedure:car>) command) (quote :=)) cassign!0 casebb2!0;
cassign!0: if ((quote #<procedure:is-static-symb?>) ((quote #<procedure:cadr>) command) (quote ((program ptail curp elem) (right left tmp) (program ptail curp elem)))) sassign!0 dassign!0;
casebb2!0: if ((quote #<procedure:equal?>) ((quote #<procedure:car>) command) (quote goto)) cgoto!0 casebb3!0;
sassign!0: vs := ('#<procedure:extend-vs> vs ('#<procedure:cadr> command) ('#<procedure:eval-expr> ('#<procedure:caddr> command) vs '()));
           if ((quote #<procedure:<>) ((quote #<procedure:length>) bb) (quote 2)) endbb!0 loopbbb!0;
dassign!0: x := ('#<procedure:cadr> command);
           e := ('#<procedure:caddr> command);
           code := ('#<procedure:extend-bb> code `(:= ,x ,('#<procedure:reduce> e vs '((program ptail curp elem) (right left tmp) (program ptail curp elem)) '())));
           if ((quote #<procedure:<>) ((quote #<procedure:length>) bb) (quote 2)) endbb!0 loopbbb!0;
cgoto!0:   bb := ('#<procedure:lookup> ('#<procedure:cadr> command) '((read program right) (init (:= ptail program) (:= left '()) (goto loop0)) (loop0 (if (null? ptail) ret loop1)) (loop1 (:= curp (cdar ptail)) (if (equal? (car curp) 'left) pleft loop2)) (loop2 (if (equal? (car curp) 'right) pright loop3)) (loop3 (if (equal? (car curp) 'write) pwrite loop4)) (loop4 (if (equal? (car curp) 'goto) pgoto loop5)) (loop5 (if (equal? (car curp) 'if) pif ret)) (pleft (if (null? left) plnull plnn)) (plnull (:= right (cons " " right)) (goto next)) (plnn (:= tmp (car left)) (:= left (cdr left)) (:= right (cons tmp right)) (goto next)) (pright (if (null? right) prnull prnn)) (prnull (:= left (cons " " left)) (goto next)) (prnn (:= tmp (car right)) (:= left (cons tmp left)) (:= right (cdr right)) (goto next)) (pwrite (:= elem (cadr curp)) (if (null? right) wrnull wrnn)) (wrnull (:= right `(,elem)) (goto next)) (wrnn (:= right (cons elem (cdr right))) (goto next)) (pgoto (:= ptail program) (goto gtloop)) (gtloop (if (equal? (cadr curp) (caar ptail)) loop0 gtiter)) (gtiter (:= ptail (cdr ptail)) (goto gtloop)) (pif (if (null? right) ifnull ifnn)) (ifnull (if (equal? (cadr curp) " ") ifgt next)) (ifnn (if (equal? (cadr curp) (car right)) ifgt next)) (ifgt (:= curp (cddr curp)) (goto pgoto)) (next (:= ptail (cdr ptail)) (goto loop0)) (ret (return right))));
           if ((quote #<procedure:<>) ((quote #<procedure:length>) bb) (quote 2)) endbb!0 loopbbb!0;
casebb3!0: if ((quote #<procedure:equal?>) ((quote #<procedure:car>) command) (quote if)) cif!0 casebb4!0;
cif!0:     if ((quote #<procedure:is-static-expr?>) ((quote #<procedure:cadr>) command) (quote ((program ptail curp elem) (right left tmp) (program ptail curp elem)))) sif!0 dif!0;
casebb4!0: if ((quote #<procedure:equal?>) ((quote #<procedure:car>) command) (quote return)) creturn!0 casebb5!0;
sif!0:     if ((quote #<procedure:eval-expr>) ((quote #<procedure:cadr>) command) vs (quote ())) sift!0 siff!0;
dif!0:     ift := ('#<procedure:caddr> command);
           iff := ('#<procedure:cadddr> command);
           nift := ('#<procedure:block-name> ift vs '((program ptail curp elem) (right left tmp) (program ptail curp elem)));
           niff := ('#<procedure:block-name> iff vs '((program ptail curp elem) (right left tmp) (program ptail curp elem)));
           ps := `((,ift ,vs) (,iff ,vs));
           pending := ('#<procedure:extend-unmarked> pending ps marked '((program ptail curp elem) (right left tmp) (program ptail curp elem)));
           e := ('#<procedure:reduce> ('#<procedure:cadr> command) vs '((program ptail curp elem) (right left tmp) (program ptail curp elem)) '());
           code := ('#<procedure:extend-bb> code `(if ,e ,nift ,niff));
           if ((quote #<procedure:<>) ((quote #<procedure:length>) bb) (quote 2)) endbb!0 loopbbb!0;
creturn!0: code := ('#<procedure:extend-bb> code `(return ,('#<procedure:reduce> ('#<procedure:cadr> command) vs '((program ptail curp elem) (right left tmp) (program ptail curp elem)) '())));
           if ((quote #<procedure:<>) ((quote #<procedure:length>) bb) (quote 2)) endbb!0 loopbbb!0;
casebb5!0: return (quote error);
sift!0:    bb := ('#<procedure:lookup> ('#<procedure:caddr> command) '((read program right) (init (:= ptail program) (:= left '()) (goto loop0)) (loop0 (if (null? ptail) ret loop1)) (loop1 (:= curp (cdar ptail)) (if (equal? (car curp) 'left) pleft loop2)) (loop2 (if (equal? (car curp) 'right) pright loop3)) (loop3 (if (equal? (car curp) 'write) pwrite loop4)) (loop4 (if (equal? (car curp) 'goto) pgoto loop5)) (loop5 (if (equal? (car curp) 'if) pif ret)) (pleft (if (null? left) plnull plnn)) (plnull (:= right (cons " " right)) (goto next)) (plnn (:= tmp (car left)) (:= left (cdr left)) (:= right (cons tmp right)) (goto next)) (pright (if (null? right) prnull prnn)) (prnull (:= left (cons " " left)) (goto next)) (prnn (:= tmp (car right)) (:= left (cons tmp left)) (:= right (cdr right)) (goto next)) (pwrite (:= elem (cadr curp)) (if (null? right) wrnull wrnn)) (wrnull (:= right `(,elem)) (goto next)) (wrnn (:= right (cons elem (cdr right))) (goto next)) (pgoto (:= ptail program) (goto gtloop)) (gtloop (if (equal? (cadr curp) (caar ptail)) loop0 gtiter)) (gtiter (:= ptail (cdr ptail)) (goto gtloop)) (pif (if (null? right) ifnull ifnn)) (ifnull (if (equal? (cadr curp) " ") ifgt next)) (ifnn (if (equal? (cadr curp) (car right)) ifgt next)) (ifgt (:= curp (cddr curp)) (goto pgoto)) (next (:= ptail (cdr ptail)) (goto loop0)) (ret (return right))));
           if ((quote #<procedure:<>) ((quote #<procedure:length>) bb) (quote 2)) endbb!0 loopbbb!0;
siff!0:    bb := ('#<procedure:lookup> ('#<procedure:cadddr> command) '((read program right) (init (:= ptail program) (:= left '()) (goto loop0)) (loop0 (if (null? ptail) ret loop1)) (loop1 (:= curp (cdar ptail)) (if (equal? (car curp) 'left) pleft loop2)) (loop2 (if (equal? (car curp) 'right) pright loop3)) (loop3 (if (equal? (car curp) 'write) pwrite loop4)) (loop4 (if (equal? (car curp) 'goto) pgoto loop5)) (loop5 (if (equal? (car curp) 'if) pif ret)) (pleft (if (null? left) plnull plnn)) (plnull (:= right (cons " " right)) (goto next)) (plnn (:= tmp (car left)) (:= left (cdr left)) (:= right (cons tmp right)) (goto next)) (pright (if (null? right) prnull prnn)) (prnull (:= left (cons " " left)) (goto next)) (prnn (:= tmp (car right)) (:= left (cons tmp left)) (:= right (cdr right)) (goto next)) (pwrite (:= elem (cadr curp)) (if (null? right) wrnull wrnn)) (wrnull (:= right `(,elem)) (goto next)) (wrnn (:= right (cons elem (cdr right))) (goto next)) (pgoto (:= ptail program) (goto gtloop)) (gtloop (if (equal? (cadr curp) (caar ptail)) loop0 gtiter)) (gtiter (:= ptail (cdr ptail)) (goto gtloop)) (pif (if (null? right) ifnull ifnn)) (ifnull (if (equal? (cadr curp) " ") ifgt next)) (ifnn (if (equal? (cadr curp) (car right)) ifgt next)) (ifgt (:= curp (cddr curp)) (goto pgoto)) (next (:= ptail (cdr ptail)) (goto loop0)) (ret (return right))));
           if ((quote #<procedure:<>) ((quote #<procedure:length>) bb) (quote 2)) endbb!0 loopbbb!0;
read right;
init!0:   left := '();
          if ((quote #<procedure:null?>) right) ifnull!0 ifnn!0;
ifnull!0: if ((quote #<procedure:null?>) right) prnull!0 prnn!0;
ifnn!0:   if ((quote #<procedure:equal?>) (quote 0) ((quote #<procedure:car>) right)) ifgt!0 next!0;
prnull!0: left := ('#<procedure:cons> '" " left);
          if ((quote #<procedure:null?>) right) ifnull!0 ifnn!0;
prnn!0:   tmp := ('#<procedure:car> right);
          left := ('#<procedure:cons> tmp left);
          right := ('#<procedure:cdr> right);
          if ((quote #<procedure:null?>) right) ifnull!0 ifnn!0;
ifgt!0:   if ((quote #<procedure:null?>) right) wrnull!0 wrnn!0;
next!0:   if ((quote #<procedure:null?>) right) prnull!0 prnn!0;
wrnull!0: right := '(1);
          return right;
wrnn!0:   right := ('#<procedure:cons> '1 ('#<procedure:cdr> right));
          return right;
'(1 1 0 1)

As expected, it did nothing. The reason is that in the naïve mix virtually all variables are static. And the next task is to fix it.

I Futamura Projection:
'(10)
read right;
init!0:   left := '();
          if ((quote #<procedure:null?>) right) ifnull!0 ifnn!0;
ifnull!0: if ((quote #<procedure:null?>) right) prnull!0 prnn!0;
ifnn!0:   if ((quote #<procedure:equal?>) (quote 0) ((quote #<procedure:car>) right)) ifgt!0 next!0;
prnull!0: left := ('#<procedure:cons> '" " left);
          if ((quote #<procedure:null?>) right) ifnull!0 ifnn!0;
prnn!0:   tmp := ('#<procedure:car> right);
          left := ('#<procedure:cons> tmp left);
          right := ('#<procedure:cdr> right);
          if ((quote #<procedure:null?>) right) ifnull!0 ifnn!0;
ifgt!0:   if ((quote #<procedure:null?>) right) wrnull!0 wrnn!0;
next!0:   if ((quote #<procedure:null?>) right) prnull!0 prnn!0;
wrnull!0: right := '(1);
          return right;
wrnn!0:   right := ('#<procedure:cons> '1 ('#<procedure:cdr> right));
          return right;
'(1 1 0 1)

 II Futamura Projection:
'(403)

...
See <compiler.fc>, as it is *really* large;
I'm working on it.
...

read right;
init!0:   left := '();
          if ((quote #<procedure:null?>) right) ifnull!0 ifnn!0;
ifnull!0: if ((quote #<procedure:null?>) right) prnull!0 prnn!0;
ifnn!0:   if ((quote #<procedure:equal?>) (quote 0) ((quote #<procedure:car>) right)) ifgt!0 next!0;
prnull!0: left := ('#<procedure:cons> '" " left);
          if ((quote #<procedure:null?>) right) ifnull!0 ifnn!0;
prnn!0:   tmp := ('#<procedure:car> right);
          left := ('#<procedure:cons> tmp left);
          right := ('#<procedure:cdr> right);
          if ((quote #<procedure:null?>) right) ifnull!0 ifnn!0;
ifgt!0:   if ((quote #<procedure:null?>) right) wrnull!0 wrnn!0;
next!0:   if ((quote #<procedure:null?>) right) prnull!0 prnn!0;
wrnull!0: right := '(1);
          return right;
wrnn!0:   right := ('#<procedure:cons> '1 ('#<procedure:cdr> right));
          return right;
'(1 1 0 1)'()
```
