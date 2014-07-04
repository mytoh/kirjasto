(define-library (kirjasto työkalu)
    (export
      loop-forever
      get-os-type
      tap
      daemonize
      check
      nothing
      blockc
      loopc
      flip
      eval-string
      implications)
  (import (scheme base)
          (gauche base)
          (text tr)
          (gauche net)
          (gauche process)
          (gauche sequence)
          (file util)
          (rfc http)
          (rfc uri)
          (srfi 1)
          (srfi 11)
          (srfi  13)
          (kirjasto merkkijono))
  (begin

    (define-syntax loop-forever
      ;;macro for endless loop
      (syntax-rules ()
        ((_ body ...)
         (let loop ()
              body
              ...
              (sys-sleep #e3e1) ; sleep
              (loop)))))

    (define get-os-type
                                        ; returns symbol
      (lambda ()
        (string->symbol (string-downcase
                            (car (sys-uname))))))

    (define (tap f x)
      (f x) x)

    (define (daemonize)
      ;;make daemon process, function from gauche cookbook
      (proc)
      (when (positive? (sys-fork))
        (sys-exit 0))
      (sys-setsid)
      (sys-chdir "/")
      (sys-umask 0)
      (call-with-input-file "/dev/null"
        (cut port-fd-dup! (standard-input-port) <>))
      (call-with-output-file "/dev/null"
        (lambda (out)
          (port-fd-dup! (standard-output-port) out)
          (port-fd-dup! (standard-error-port) out))))

    (define (eval-string s)
      (eval (read-from-string s)
        'user))

    (define nothing
      (lambda ()
        (values)))


    (define (flip f)
      (lambda args (apply f (reverse args))))


    ;; from info combinator page
    (define safe-length (every-pred list? length))

    (define (check pred obj)
      (if (pred obj)
        obj #false))

    ;; http://people.csail.mit.edu/jhbrown/scheme/macroslides03.pdf
    ;; http://valvallow.blogspot.jp/2010/05/implecations.html
    (define-syntax implications
      (syntax-rules (=>)
        ((_ (pred => body ...) ...)
         (begin
           (when pred body ...) ...))))


    ;; http://www.geocities.co.jp/SiliconValley-PaloAlto/7043/index.html#continuation

    (define-syntax blockc
      (syntax-rules ()
        ((_ tag body1 body2 ...)
         (call-with-current-continuation
             (lambda (tag)
               body1 body2 ...)))))

    (define-syntax loopc
      (syntax-rules ()
        ((_ tag body1 body2 ...)
         (blockc tag
                 (let rec ()
                      body1 body2 ...
                      (rec))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; http://rosettacode.org/wiki/Y_combinator#Scheme
    (define Y
      (lambda (f)
        ((lambda (x) (x x))
         (lambda (g)
           (f (lambda args (apply (g g) args)))))))

    (define fac
      (Y
       (lambda (f)
         (lambda (x)
           (if (< x 2)
             1
             (* x (f (- x 1))))))))

    (define fib
      (Y
       (lambda (f)
         (lambda (x)
           (if (< x 2)
             x
             (+ (f (- x 1)) (f (- x 2))))))))

    ))
