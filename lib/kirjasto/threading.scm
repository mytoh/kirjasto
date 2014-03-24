;; author "Moritz Heidkamp"

(define-library (kirjasto threading)
    (export
      doto
      ->
      ->*
      ->>
      ->>*)
  (import
    (scheme base))

  (begin
    (define-syntax doto
      (syntax-rules ()
        ((_ x) x)
        ((_ x (fn args ...) ...)
         (let ((val x))
           (fn val args ...)
           ...
           val))))

    (define-syntax ->
      (syntax-rules ()
        ((_ x (f v ...) f2 ...)
         (-> (f x v ...) f2 ...))
        ((_ x f f2 ...)
         (-> (f x) f2 ...))
        ((_ x (f v ...))
         (-> (f x v ...)))
        ((_ x f)
         (f x))
        ((_ x) x)))

    (define-syntax ->>
      (syntax-rules ()
        ((_ x (y ...) rest ...)
         (->> (y ... x) rest ...))
        ((_ x) x)))

    (define-syntax ->*
      (syntax-rules ()
        ((_ x (y z ...) rest ...)
         (->* (receive args x
                       (apply y (append args (list z ...))))
              rest ...))
        ((_ x) x)))

    (define-syntax ->>*
      (syntax-rules ()
        ((_ x) x)
        ((_ x (y z ...) rest ...)
         (->>* (receive args x
                        (apply y (append (list z ...) args)))
               rest ...))))
    ))
