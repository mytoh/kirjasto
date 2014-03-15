
(define-library (clojure core)
    (export
      if-not
      condp
      comment
      slurp
      spit)
  (import
    (scheme base)
    (scheme file)
    (gauche base)
    (kirjasto verkko avata)
    (kirjasto verkko työkalu)
    (srfi-11)
    (util list)
    (file util))

  (begin
    (define-syntax slurp
      (syntax-rules ()
        ((_ file)
         (cond
           ((file-exists? file)
            (file->string file))
           ((string-is-url? file)
            (open file))
           (else
               (print "file not exists"))))))

    (define (spit file s :key (append? #f))
      (cond
        (append?
         (call-with-output-file file
           (^ (in)
              (display s in))
           :if-exists :append))
        (else
            (call-with-output-file file
              (^ (in)
                 (display s in))))))

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
         (or
             (if (pred test-expr expr)
               result-expr
               #f)
           ...))))

    (define-syntax if-not
      (syntax-rules ()
        ((_ test then)
         (if-not test then #f))
        ((_ test then else)
         (if (not test) then else))))))
