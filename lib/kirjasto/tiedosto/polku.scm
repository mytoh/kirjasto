;;; path.scm

(define-library (kirjasto tiedosto polku)
    (export
      add-extension
      absolute
      parent
      child
      file)
  (import (scheme base)
          (scheme write)
          (srfi 1)
          (srfi 13)
          (gauche base)
          (file util))

  (begin

    (define (add-extension name ext)
      (cond
        ((equal? (ref ext 0) #\.)
         (path-swap-extension name (string-trim ext #\.)))
        (else
            (path-swap-extension name ext))))

    (define (absolute path)
      (sys-normalize-pathname path ':absolute #true ':canonicalize #true))

    (define (file path)
      (absolute path))

    (define (parent path)
      ;; "Return the parent path."
      (sys-dirname (absolute path)))

    (define (child path)
      (sys-basename (absolute path)))

    ))
