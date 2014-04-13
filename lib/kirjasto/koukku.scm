;;; koukku.scm

(define-library (kirjasto koukku)
    (export define-hook
            add-hook
            remove-hook
            run-hooks)
  (import (scheme base)
          (scheme write)
          (gauche base))

  (begin

    (define-syntax define-hook
      (syntax-rules ()
        ((_ name value)
         (define name
           (make-parameter (list value))))))

    (define (add-hook name fn)
      (if (null? (null? (car (name))))
        (name (list fn))
        (name (append (name) (list fn)))))

    (define (remove-hook name fn)
      (let ((old (name)))
        (name
         (remove
             (lambda (x) (eq? x fn))
           old))))

    (define (run-hooks . hooks)
      (for-each
          (lambda (hook)
            (for-each
                (lambda (h)
                  (if (not (null? h))
                    (h)))
              (hook)))
        hooks))

    ))
