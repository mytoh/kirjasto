
(define-library (kirjasto komento työkalu)
    (export
      run-command
      run-command-null
      run-command-sudo
      command-output
      mkdir
      cd)
  (import
    (scheme base)
    (scheme file)
    (gauche base)
    (gauche process)
    (file util)

    (kirjasto tiedosto))

  (begin
    (define-syntax run-command
      (syntax-rules ()
        ((_ c1)
         (run-process c1 :wait #true))
        ((_ c1 c2 ...)
         (begin
           (run-process c1 :wait #true)
           (run-command c2 ...)))))

    (define-syntax run-command-null
      (syntax-rules ()
        ((_ c1)
         (run-process c1 :wait #true :output :null))
        ((_ c1 c2 ...)
         (begin
           (run-process c1 :wait #true :output :null)
           (run-command c2 ...)))))

    (define (run-command-sudo command)
      (run-process (append '(sudo) command) :wait #true))

    (define (command-output command)
      (process-output->string command))

    (define (mkdir kansio)
      (unless (file-exists? kansio)
        (make-directory* kansio)))

    (define (cd kansio)
      (if (file-directory? kansio)
        (current-directory kansio)))))
