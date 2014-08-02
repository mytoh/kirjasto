
(define-library (clojure string)
    (export
      str join
      )
  (import
    (scheme base)
    (srfi 1)
    (gauche base))

  (begin
    ;; (define (str . strings)
    ;;   (let ((s (map (lambda (x) (if (null? x) "" (x->string x)))
    ;;                 strings)))
    ;;     (let loop ((st (car s))
    ;;                (ss (cdr s)))
    ;;       (if (null? ss)
    ;;         st
    ;;         (loop (string-append st (car ss)) (cdr ss))))))

    (define (str st . xst)
      (fold (lambda (x xs)
              (string-append (x->string xs) (x->string x)))
        st xst))

    (define (join sep slist)
      (string-join slist sep))
    ))
