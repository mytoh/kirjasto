
(define-module kirjasto.verkko.työkalu
  (export
    string->sxml
    string-is-url?)
  (use sxml.ssax)
  )
(select-module kirjasto.verkko.työkalu)


(define (string-is-url? str)
  (or ( #/^https?:\/\// str)
    ( #/^http:\/\// str)))

(define (string->sxml stg)
  (call-with-input-string stg
    (lambda (in)
      (ssax:xml->sxml in '()))))
