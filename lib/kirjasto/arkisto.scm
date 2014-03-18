
(define-library (kirjasto arkisto)
    (export
      file-is-archive?
      file-is-zip?)
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
        (if extension
          (any (lambda (s)
                 (string=? extension s))
            (supporting-extensions))
          #false)))

    (define (file-type file)
      (let ((extension (path-extension file)))
        (find (lambda (e) (string=? e extension))
          (supporting-extensions))))

    (define (file-is-zip? file)
      (and (file-is-archive? file)
        (string=? "zip" (file-type file))))

    ))
