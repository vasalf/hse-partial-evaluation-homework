## `test.rkt` output:

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
'(1 1 0 1)

II Futamura Projection, naïve version:
read vs0;
init!0:    pending := (quasiquote (((unquote init) unquote vs0)));
           marked := null;
           residual := ((read right));
           if (null? pending) end!0 loopb!0;
end!0:     return (#<procedure:normalize-blocks> residual);
loopb!0:   pp := (caar pending);
           vs := (cdar pending);
           pending := (cdr pending);
           marked := (cons (quasiquote ((unquote pp) unquote vs)) marked);
           bb := (#<procedure:lookup> pp ((read program right) (init (:= ptail program) (:= left (quote ())) (goto loop0)) (loop0 (if (null? ptail) ret loop1)) (loop1 (:= curp (cdar ptail)) (if (equal? (car curp) (quote left)) pleft loop2)) (loop2 (if (equal? (car curp) (quote right)) pright loop3)) (loop3 (if (equal? (car curp) (quote write)) pwrite loop4)) (loop4 (if (equal? (car curp) (quote goto)) pgoto loop5)) (loop5 (if (equal? (car curp) (quote if)) pif ret)) (pleft (if (null? left) plnull plnn)) (plnull (:= right (cons   right)) (goto next)) (plnn (:= tmp (car left)) (:= left (cdr left)) (:= right (cons tmp right)) (goto next)) (pright (if (null? right) prnull prnn)) (prnull (:= left (cons   left)) (goto next)) (prnn (:= tmp (car right)) (:= left (cons tmp left)) (:= right (cdr right)) (goto next)) (pwrite (:= elem (cadr curp)) (if (null? right) wrnull wrnn)) (wrnull (:= right (quasiquote ((unquote elem)))) (goto next)) (wrnn (:= right (cons elem (cdr right))) (goto next)) (pgoto (:= ptail program) (goto gtloop)) (gtloop (if (equal? (cadr curp) (caar ptail)) loop0 gtiter)) (gtiter (:= ptail (cdr ptail)) (goto gtloop)) (pif (if (null? right) ifnull ifnn)) (ifnull (if (equal? (cadr curp)  ) ifgt next)) (ifnn (if (equal? (cadr curp) (car right)) ifgt next)) (ifgt (:= curp (cddr curp)) (goto pgoto)) (next (:= ptail (cdr ptail)) (goto loop0)) (ret (return right))));
           code := (#<procedure:initial-code> pp vs);
           if (< (length bb) 2) endbb!0 loopbbb!0;
endbb!0:   residual := (#<procedure:extend-code> residual code);
           if (null? pending) end!0 loopb!0;
loopbbb!0: command := (#<procedure:first-command> bb);
           bb := (#<procedure:bb-tail> bb);
           if (equal? (car command) (quote debug)) loopbb!0 casebb1!0;
loopbb!0:  if (< (length bb) 2) endbb!0 loopbbb!0;
casebb1!0: if (equal? (car command) (quote :=)) cassign!0 casebb2!0;
cassign!0: if (#<procedure:is-static-symb?> (cadr command) ((program ptail curp elem) (right left tmp))) sassign!0 dassign!0;
casebb2!0: if (equal? (car command) (quote goto)) cgoto!0 casebb3!0;
sassign!0: vs := (#<procedure:extend-vs> vs (cadr command) (#<procedure:eval-expr> (caddr command) vs));
           if (< (length bb) 2) endbb!0 loopbbb!0;
dassign!0: x := (cadr command);
           e := (caddr command);
           vs := (#<procedure:reduce-vs> vs x);
           code := (#<procedure:extend-bb> code (quasiquote (:= (unquote x) (unquote (#<procedure:reduce> e vs ((program ptail curp elem) (right left tmp)) ())))));
           if (< (length bb) 2) endbb!0 loopbbb!0;
cgoto!0:   bb := (#<procedure:lookup> (cadr command) ((read program right) (init (:= ptail program) (:= left (quote ())) (goto loop0)) (loop0 (if (null? ptail) ret loop1)) (loop1 (:= curp (cdar ptail)) (if (equal? (car curp) (quote left)) pleft loop2)) (loop2 (if (equal? (car curp) (quote right)) pright loop3)) (loop3 (if (equal? (car curp) (quote write)) pwrite loop4)) (loop4 (if (equal? (car curp) (quote goto)) pgoto loop5)) (loop5 (if (equal? (car curp) (quote if)) pif ret)) (pleft (if (null? left) plnull plnn)) (plnull (:= right (cons   right)) (goto next)) (plnn (:= tmp (car left)) (:= left (cdr left)) (:= right (cons tmp right)) (goto next)) (pright (if (null? right) prnull prnn)) (prnull (:= left (cons   left)) (goto next)) (prnn (:= tmp (car right)) (:= left (cons tmp left)) (:= right (cdr right)) (goto next)) (pwrite (:= elem (cadr curp)) (if (null? right) wrnull wrnn)) (wrnull (:= right (quasiquote ((unquote elem)))) (goto next)) (wrnn (:= right (cons elem (cdr right))) (goto next)) (pgoto (:= ptail program) (goto gtloop)) (gtloop (if (equal? (cadr curp) (caar ptail)) loop0 gtiter)) (gtiter (:= ptail (cdr ptail)) (goto gtloop)) (pif (if (null? right) ifnull ifnn)) (ifnull (if (equal? (cadr curp)  ) ifgt next)) (ifnn (if (equal? (cadr curp) (car right)) ifgt next)) (ifgt (:= curp (cddr curp)) (goto pgoto)) (next (:= ptail (cdr ptail)) (goto loop0)) (ret (return right))));
           if (< (length bb) 2) endbb!0 loopbbb!0;
casebb3!0: if (equal? (car command) (quote if)) cif!0 casebb4!0;
cif!0:     if (#<procedure:is-static-expr?> (cadr command) ((program ptail curp elem) (right left tmp))) sif!0 dif!0;
casebb4!0: if (equal? (car command) (quote return)) creturn!0 casebb5!0;
sif!0:     if (#<procedure:eval-expr> (cadr command) vs) sift!0 siff!0;
dif!0:     ift := (caddr command);
           iff := (cadddr command);
           nift := (#<procedure:block-name> ift vs);
           niff := (#<procedure:block-name> iff vs);
           ps := (quasiquote (((unquote ift) unquote vs) ((unquote iff) unquote vs)));
           pending := (#<procedure:extend-unmarked> pending ps marked);
           e := (#<procedure:reduce> (cadr command) vs ((program ptail curp elem) (right left tmp)) ());
           code := (#<procedure:extend-bb> code (quasiquote (if (unquote e) (unquote nift) (unquote niff))));
           if (< (length bb) 2) endbb!0 loopbbb!0;
creturn!0: code := (#<procedure:extend-bb> code (quasiquote (return (unquote (#<procedure:reduce> (cadr command) vs ((program ptail curp elem) (right left tmp)) ())))));
           if (< (length bb) 2) endbb!0 loopbbb!0;
casebb5!0: return (quote error);
sift!0:    bb := (#<procedure:lookup> (caddr command) ((read program right) (init (:= ptail program) (:= left (quote ())) (goto loop0)) (loop0 (if (null? ptail) ret loop1)) (loop1 (:= curp (cdar ptail)) (if (equal? (car curp) (quote left)) pleft loop2)) (loop2 (if (equal? (car curp) (quote right)) pright loop3)) (loop3 (if (equal? (car curp) (quote write)) pwrite loop4)) (loop4 (if (equal? (car curp) (quote goto)) pgoto loop5)) (loop5 (if (equal? (car curp) (quote if)) pif ret)) (pleft (if (null? left) plnull plnn)) (plnull (:= right (cons   right)) (goto next)) (plnn (:= tmp (car left)) (:= left (cdr left)) (:= right (cons tmp right)) (goto next)) (pright (if (null? right) prnull prnn)) (prnull (:= left (cons   left)) (goto next)) (prnn (:= tmp (car right)) (:= left (cons tmp left)) (:= right (cdr right)) (goto next)) (pwrite (:= elem (cadr curp)) (if (null? right) wrnull wrnn)) (wrnull (:= right (quasiquote ((unquote elem)))) (goto next)) (wrnn (:= right (cons elem (cdr right))) (goto next)) (pgoto (:= ptail program) (goto gtloop)) (gtloop (if (equal? (cadr curp) (caar ptail)) loop0 gtiter)) (gtiter (:= ptail (cdr ptail)) (goto gtloop)) (pif (if (null? right) ifnull ifnn)) (ifnull (if (equal? (cadr curp)  ) ifgt next)) (ifnn (if (equal? (cadr curp) (car right)) ifgt next)) (ifgt (:= curp (cddr curp)) (goto pgoto)) (next (:= ptail (cdr ptail)) (goto loop0)) (ret (return right))));
           if (< (length bb) 2) endbb!0 loopbbb!0;
siff!0:    bb := (#<procedure:lookup> (cadddr command) ((read program right) (init (:= ptail program) (:= left (quote ())) (goto loop0)) (loop0 (if (null? ptail) ret loop1)) (loop1 (:= curp (cdar ptail)) (if (equal? (car curp) (quote left)) pleft loop2)) (loop2 (if (equal? (car curp) (quote right)) pright loop3)) (loop3 (if (equal? (car curp) (quote write)) pwrite loop4)) (loop4 (if (equal? (car curp) (quote goto)) pgoto loop5)) (loop5 (if (equal? (car curp) (quote if)) pif ret)) (pleft (if (null? left) plnull plnn)) (plnull (:= right (cons   right)) (goto next)) (plnn (:= tmp (car left)) (:= left (cdr left)) (:= right (cons tmp right)) (goto next)) (pright (if (null? right) prnull prnn)) (prnull (:= left (cons   left)) (goto next)) (prnn (:= tmp (car right)) (:= left (cons tmp left)) (:= right (cdr right)) (goto next)) (pwrite (:= elem (cadr curp)) (if (null? right) wrnull wrnn)) (wrnull (:= right (quasiquote ((unquote elem)))) (goto next)) (wrnn (:= right (cons elem (cdr right))) (goto next)) (pgoto (:= ptail program) (goto gtloop)) (gtloop (if (equal? (cadr curp) (caar ptail)) loop0 gtiter)) (gtiter (:= ptail (cdr ptail)) (goto gtloop)) (pif (if (null? right) ifnull ifnn)) (ifnull (if (equal? (cadr curp)  ) ifgt next)) (ifnn (if (equal? (cadr curp) (car right)) ifgt next)) (ifgt (:= curp (cddr curp)) (goto pgoto)) (next (:= ptail (cdr ptail)) (goto loop0)) (ret (return right))));
           if (< (length bb) 2) endbb!0 loopbbb!0;

As expected, it did nothing. The reason is that in the naïve mix virtually all variables are static. And the next task is to fix it.
'()
```
