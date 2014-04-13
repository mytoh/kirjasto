;;; test.scm

(import (scheme base)
        (scheme write)
        (gauche base)
        (gauche test)
        (kirjasto koukku))

(test-start "kirjasto koukku")

(test-section "test1")
(test* "define hook"
       '()
       (begin
         (define-hook test-hook '())
         (car (test-hook))))
(test* "adding-hook"
       #t
       (begin
         (add-hook test-hook (lambda () (+ 1 2)))
         (test-hook))
       (lambda (expected result)
         (if (list? result) #t #f)))

(test-end :exit-on-failure #t)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:
