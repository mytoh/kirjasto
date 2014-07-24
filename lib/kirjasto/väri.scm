(define-library (kirjasto väri)
    (export
      colour-string
      colour-command)
  (import
    (scheme base)
    (gauche)
    (gauche process)
    (srfi 13))

  (begin
    (define (colour-string colour-number s)
      ;; take number, string -> return string
      (cond
        ((string? s)
         (string-concatenate
             `("[38;5;" ,(number->string colour-number) "m"
               ,s
               "[0m")))
        (else
            (string-concatenate
                `("[38;5;" ,(number->string colour-number) "m"
                  ,s
                  "[0m")))))


    (define-syntax colour-command
      (syntax-rules ()
        ((_ ?command ?r1 ?s1 ...)
         (with-input-from-process
          ?command
          (lambda ()
            (port-for-each
             (lambda (in)
               (print
                (regexp-replace* in
                                 ?r1 ?s1
                                 ...
                                 ;; example:
                                 ;; #/^>>>/   "[38;5;99m\\0[0m"
                                 ;; #/^=*>/   "[38;5;39m\\0[0m"
                                 )))
             read-line))))))))
