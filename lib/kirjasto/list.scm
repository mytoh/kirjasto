;;; list.scm

(define-library (kirjasto list)
    (export
      flatten)
  (import (scheme base)
          (scheme write)
          (srfi 1))

  (begin

    (define (flatten xs)
      (cond
        ((null? xs)
         '())
        ((pair? xs)
         (append-map flatten xs))
        (else
            (list xs))))

    ))
