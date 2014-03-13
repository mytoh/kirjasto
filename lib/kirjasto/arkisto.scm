
(define-library (kirjasto arkisto)
    (export
      file-is-archive?     )
  (import
    (scheme base)
    (gauche base)
    (gauche parameter)
    (file util))
  (begin

    (define supporting-extensions
      (make-parameter
          '("tar" "xz" "gz" "bz2"
            "cbz" "cbr" "cbx"
            "rar"
            "zip")))

    (define (file-is-archive? file)
      (let ((extension (path-extension file)))
        (any
            (lambda (s)
              (string=? extension s))
          (supporting-extensions))))))
