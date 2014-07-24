
(define-library (clojure core)
    (export
      if-not
      condp
      comment)
  (import
    (scheme base)
    (scheme file)
    (gauche)
    (srfi 11)
    (util list)
    (file util))

  (begin

    (define-syntax comment
      (syntax-rules ()
        ((_ x ...)
         (values))))

    ;; not full implementation
    (define-syntax condp
      (syntax-rules ()
        ((_ pred expr
            (test-expr result-expr)
            ...)
         (or (if (pred test-expr expr)
               result-expr
               #false)
           ...))))

    (define-syntax if-not
      (syntax-rules ()
        ((_ test then)
         (if-not test then #false))
        ((_ test then else)
         (if (not test) then else))))))
