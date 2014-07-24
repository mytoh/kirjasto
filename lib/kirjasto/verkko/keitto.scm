;; -*- coding: utf-8 -*-

(define-library (kirjasto verkko keitto)
    (export
      find-all-tags)
  (import
    (scheme base)
    (gauche)
    (rfc uri))

  (begin
    (define find-all-tags
      (lambda (tag body)
        (let loop ((str body))
             (let ((match (rxmatch
                           (string->regexp
                            (string-append "<" tag "[^>]*>.*?<\/" tag ">"))
                           str)))
               (cond
                 (match
                  (cons (match) (loop (match 'after))))
                 (else
                     '()))))))))
