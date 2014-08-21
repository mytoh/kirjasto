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
      implications
      cond-list
      fcond
      constant
      compose
      partial
      ^
      let1
      if-let1
      rlet1
      keep
      because
      )
  (import
    (scheme base)
    (scheme file)
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
    (kirjasto merkkijono)
    (kirjasto komento))
  (begin

    (define-syntax loop-forever
      ;;macro for endless loop
      (syntax-rules ()
        ((_ body ...)
         (let loop ()
              body
              ...
              (run-command '(sleep 10))
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
    (define (safe-length x)
      (and (list? x)
        (length x)))

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

    ;; cond-list - a syntax to construct a list
    ;;
    ;;   (cond-list clause clause2 ...)
    ;;
    ;;   clause : (test expr ...)
    ;;          | (test => proc)
    ;;          | (test @ expr ...) ;; splice
    ;;          | (test => @ proc)  ;; splice

    (define-syntax cond-list
      (syntax-rules (=> @)
        ((_) '())
        ((_ (test) . rest)
         (let* ((tmp test)
                (r (cond-list . rest)))
           (if tmp (cons tmp r) r)))
        ((_ (test => proc) . rest)
         (let* ((tmp test)
                (r (cond-list . rest)))
           (if tmp (cons (proc tmp) r) r)))
        ((_ (test => @ proc) . rest)
         (let* ((tmp test)
                (r (cond-list . rest)))
           (if tmp (append (proc tmp) r) r)))
        ((_ (test @ . expr) . rest)
         (let* ((tmp test)
                (r (cond-list . rest)))
           (if tmp (append (begin . expr) r) r)))
        ((_ (test . expr) . rest)
         (let* ((tmp test)
                (r (cond-list . rest)))
           (if tmp (cons (begin . expr) r) r)))))

    ;; ^ == lambda
    (define-syntax ^
      (syntax-rules ()
        ((_ formals . body)
         (lambda formals . body))))

    (define-syntax let1
      ;; single variable bind
      (syntax-rules ()
        ((_ var exp . body)
         (let ((var exp)) . body))))

    (define-syntax if-let1
      ;; like aif in On Lisp, but explicit var
      (syntax-rules ()
        ((_ var exp then . else)
         (let ((var exp)) (if var then . else)))))

    (define-syntax rlet1
      ;; begin0 + let1.  name is arguable.
      (syntax-rules ()
        ((_ var exp body ...)
         (let ((var exp)) body ... var))))


    ;; fcond - a syntax to one function cond
    ;;
    ;;   (fcond value clause clause2 ...)
    ;;
    ;;   clause : (test expr ...)
    ;;          | (test)
    ;;          | (else expr)
    ;;
    ;; (fcond 'a
    ;;        (number? 'number)
    ;;        (string? 'string)
    ;;        (symbol? 'symbol)
    ;;        (else #false))

    (define-syntax fcond
      (syntax-rules (else)
        ((_ x (else expr))
         expr)
        ((_ x (test))
         (let ((tmp (test x)))
           (if tmp #true #false)))
        ((_ x (test) . rest)
         (let ((tmp (test x)))
           (if tmp #true (fcond x . rest))))
        ((_ x (test . expr))
         (let ((tmp (test x)))
           (if tmp (begin . expr) #false)))
        ((_ x (test . expr) . rest)
         (let ((tmp (test x)))
           (if tmp (begin . expr) (fcond x . rest))))))


    ;; combinator from gauche's lib/gauche/procedure.scm
    (define (compose . fns)
      (cond ((null? fns) values)
            ((null? (cdr fns)) (car fns))
            ((null? (cddr fns))
             (lambda args (call-with-values (lambda ignore (apply (cadr fns) args)) (car fns))))
            (else (compose (car fns) (apply compose (cdr fns))))))

    (define (partial fn . args)                  ;partial apply
      (^ more-args (apply fn (append args more-args))))

    (define (constant x)
      (^ args x))

    (define (keep f lst)
      (remove not
        (map f lst)))

    (define-syntax because
      (syntax-rules ()
        ((_ ((v e) (v2 e2) . rest) body ...)
         (let ((v e))
           (and v
             (because ((v2 e2) . rest) body ...))))
        ((_ ((v e)) body ...)
         (let ((v e))
           (and v
             (begin
               body ...))))
        ((_ (v e) body ...)
         (let ((v e))
           (and v
             (begin
               body ...))))))

    ))
