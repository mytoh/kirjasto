
(define-library (kirjasto hash)
    (export
      define-hash)
  (import
    (scheme base)
    (util list))
  (begin
    (define-syntax define-hash
      (syntax-rules ()
        ((_ name alist)
         (define name
           (alist->hash-table alist)))
        ((_ name type alist)
         (define name
           (alist->hash-table alist type)))
        ((_ name type alist ...)
         (define name
           (hash-table type alist ...)))))
    ))
