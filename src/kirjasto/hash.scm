

(define-module kirjasto.hash
  (use util.list)
  (export
    define-hash
    ))
(select-module kirjasto.hash)



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
       (hash-table type alist ...)))
    ))

