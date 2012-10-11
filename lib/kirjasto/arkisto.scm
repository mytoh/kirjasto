
(define-module kirjasto.arkisto
  (export
    file-is-archive?
    )
  (use gauche.parameter)
  (use file.util))
(select-module kirjasto.arkisto)


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
      (supporting-extensions))))

