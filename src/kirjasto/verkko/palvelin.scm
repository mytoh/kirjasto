;; -*- coding: utf-8 -*-

(define-module kirjasto.verkko.palvelin
  (export
   define-page
   )
  (use makiki))
(select-module kirjasto.verkko.palvelin)


(define define-page
  (lambda (rx proc)
    (add-http-handler!
     rx
     (lambda (req app)
       (respond/ok
        req
        (proc req))))))

