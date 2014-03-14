
(define-library (kirjasto sysutil)
    (export
      lookup-environment-variable
      current-process-environment
      extend-process-environment
      find-exec-path
      ;; host-info
      )
  (import
    (scheme base)
    (srfi 1)
    (file util))

  (begin
    ;; //github.com/rotty/spells

    (define lookup-environment-variable get-environment-variable)
    (define current-process-environment get-environment-variables)

    (define (extend-process-environment env)
      ;; "(extend-process-environment '((\"NEWENV\" . test)))"
      (let ((current-env (remove (lambda (x) (assoc (car x) env))
                           (current-process-environment))))
        (append env current-env)))

    (define (find-exec-path name)
      (find-file-in-paths name))))
