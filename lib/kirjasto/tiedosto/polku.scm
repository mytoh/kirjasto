;;; path.scm

 (define-library (kirjasto tiedosto polku)
    (export
      add-extension
      absolute
      parent
      child
      file
      join)
  (import (scheme base)
          (scheme write)
          (scheme case-lambda)
          (srfi 1)
          (srfi 13)
          (gauche base)
          (file util))

  (begin

    (define (add-extension name ext)
      (cond
        ((equal? (string-ref ext 0) #\.)
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

    (define join
      (case-lambda
       ((path)
        (cond ((or (string= "" path)
                 (string= "." path)
                 (string= "/" path))
               path)
              (else path)))
       (paths
        (cond ((string= "" (car paths))
               (let ((normalized (normalize-paths (cdr paths))))
                 (string-join normalized "/")))
              (else
                  (string-join (map remove-trailing-slash paths) "/"))))))

    (define (remove-trailing-slash path)
      (string-trim-right path #\/))

    (define (remove-empty-paths paths)
      (remove
          (lambda (p) (string=? "" p))
        paths))

    (define (normalize-paths paths)
      (map remove-trailing-slash
        (remove-empty-paths paths)))

    ))
