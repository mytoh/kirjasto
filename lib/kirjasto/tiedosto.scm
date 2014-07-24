
(define-library (kirjasto tiedosto)
    (export
      path-add-extension
      cat-file
      read-lines-list
      temp-name
      temp-create
      temp-file
      temp-dir
      with-cwd
      absolute-path
      parent
      file
      copy
      copy+
      spit
      slurp)
  (import
    (scheme base)
    (scheme file)
    (srfi 11)
    (srfi  13)
    (gauche)
    (gauche process)
    (gauche sequence)
    (file util)
    (util list)
    (kirjasto verkko avata)
    (kirjasto verkko työkalu)
    )

  (begin
    (define (cat-file args)
      (cond
        ((list? args)
         (for-each (^ (file)
                      (call-with-input-file file
                        (^ (in)
                           (copy-port in (current-output-port)))))
           args))
        ((string? args)
         (call-with-input-file args
           (^ (in)
              (copy-port in (current-output-port)))))))

    (define (read-lines-list filename)
      ;; github.com/chujoii/battery-scheme
      ;; http://newsgroups.derkeiler.com/Archive/Comp/comp.lang.scheme/2008-05/msg00036.html
      (call-with-input-file filename
        (lambda (p)
          (let loop ((line (read-line p))
                     (result '()))
               (if (eof-object? line)
                 (begin (close-input-port p)
                        (reverse result))
                 (loop (read-line p) (cons line result)))))))


    (define (path-add-extension name ext)
      (cond
        ((equal? (ref ext 0) #\.)
         (path-swap-extension name (string-trim ext #\.)))
        (else
            (path-swap-extension name ext))))

    (define (temp-name prefix . suffix)
      (cond
        ((null? suffix) (temp-name prefix ""))
        (else (format "~a~a-~a~a" prefix (sys-time)
                      (sys-random) (car suffix)))))

    (define (temp-create prefix suffix fproc)
      (let ((tmp (build-path (temporary-directory)
                             (temp-name prefix suffix))))
        (when (fproc tmp)
          tmp)))

    (define (temp-file prefix . suffix)
      (cond
        ((null? suffix) (temp-file prefix ""))
        (else (temp-create prefix (car suffix) touch-file))))

    (define (temp-dir prefix . suffix)
      (cond
        ((null? suffix) (temp-dir prefix ""))
        (else (temp-create prefix suffix make-directory*))))
                                        ;
    ;; (define-macro (with-cwd dir . body)
    ;;   `(let ((cur (current-directory))
    ;;          (dest ,dir))
    ;;      (current-directory dest)
    ;;      ,@body
    ;;      (current-directory cur)))

    (define-syntax with-cwd
      (syntax-rules ()
        ((_ dir body ...)
         (let ((cur (current-directory))
               (dest dir))
           (current-directory dest)
           body ...
           (current-directory cur)))))

    (define (absolute-path path)
      (sys-normalize-pathname path :absolute #true :canonicalize #true)
      )

    (define (file path)
      (absolute-path path))

    (define (parent path)
      ;; "Return the parent path."
      (sys-dirname (absolute-path path)))

    (define (copy from to)
      ;; "Copy a file from 'from' to 'to'. Return 'to'."
      (copy-file (file from) (file to) :if-exists :error)
      to)

    (define (copy+ src dest)
      ;; "Copy src to dest, create directories if needed."
      (make-directory* (parent dest))
      (copy src dest))

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

    (define (spit file s :key (append? #false))
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

    ))
