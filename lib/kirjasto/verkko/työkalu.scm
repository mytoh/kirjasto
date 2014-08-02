
(define-library (kirjasto verkko työkalu)
    (export
      string->sxml
      string-is-url?)
  (import
    (scheme base)
    (gauche base)
    (sxml ssax))

  (begin
    (define (string-is-url? str)
      (or ( #/^https?:\/\// str)
        ( #/^http:\/\// str)))

    (define (string->sxml stg)
      (call-with-input-string stg
                              (lambda (in)
                                (ssax:xml->sxml in '()))))))
