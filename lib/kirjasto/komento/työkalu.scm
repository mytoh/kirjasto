
(define-library (kirjasto komento työkalu)
    (export
      run-command
      run-command-null
      run-command-sudo
      mkdir
      cd)
  (import
    (scheme base)
    (gauche base)
    (gauche process)
    (file util))


  (begin
    (define-syntax run-command
      (syntax-rules ()
        ((_ c1)
         (run-process c1 :wait #t))
        ((_ c1 c2 ...)
         (begin
           (run-process c1 :wait #t)
           (run-command c2 ...)))))

    (define-syntax run-command-null
      (syntax-rules ()
        ((_ c1)
         (run-process c1 :wait #t :output :null))
        ((_ c1 c2 ...)
         (begin
           (run-process c1 :wait #t :output :null)
           (run-command c2 ...)))))


    (define (run-command-sudo command)
      (run-process (append '(sudo) command) :wait #t))

    (define (mkdir kansio)
      (if (not (file-exists? kansio))
        (make-directory* kansio)))


    (define (cd kansio)
      (if (file-is-directory? kansio)
        (current-directory kansio)))))
