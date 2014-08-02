
(define-library (kirjasto config)
    (export
      read-config
      load-config
      )
  (import
    (scheme base)
    (gauche base)
    (gauche parameter)
    (file util))

  (begin
    (define (read-config filename :optional :key (optional? #false))
      (if (file-exists? filename)
        (let ((forms (file->sexp-list filename)))
          (if-let1 error-message (cond ((null? forms) "No config data in %s")
                                       ((< 1 (length forms)) "Too many forms in %s")
                                       (else #false))
                   (errorf error-message filename)
                   (car forms)))
        (if (not optional?)
          (error (string-append  "Cannot find config resource " filename))
          #false)))

    (define (load-config filename . args)
      (eval (apply read-config filename args) (interaction-environment)))))
