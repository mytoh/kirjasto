

(define-module kirjasto.config
  (export
    read-config
    load-config
    )
  (use gauche.parameter)
  (use file.util))
(select-module kirjasto.config)


(define (read-config filename :optional :key (optional? #f))
  (if (file-exists? filename)
    (let ((forms (file->sexp-list filename)))
      (if-let1 error-message (cond ((null? forms) "No config data in %s")
                       ((< 1 (length forms)) "Too many forms in %s")
                       (else #f))
        (errorf error-message filename)
        (car forms)))
    (if (not optional?)
      (error (string-append  "Cannot find config resource " filename))
      #f)))

(define (load-config filename . args)
  (eval (apply read-config filename args) (interaction-environment)))

