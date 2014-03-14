
(define-library (kirjasto tiedosto)
    (export
      path-add-extension
      cat-file
      read-lines-list)
  (import
    (scheme base)
    (gauche base)
    (gauche process)
    (gauche sequence)
    (file util)
    (kirjasto verkko avata)
    (srfi 11)
    (srfi  13)))

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
          (path-swap-extension name ext)))))
