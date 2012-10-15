
;; -*- coding: utf-8 -*-

(define-module kirjasto.sysutil
  (export
    lookup-environment-variable
    current-process-environment
    extend-process-environment
    find-exec-path
    ; host-info
    )
  (use srfi-1)
  (use file.util)
  )
(select-module kirjasto.sysutil)

;; //github.com/rotty/spells

(define lookup-environment-variable get-environment-variable)
(define current-process-environment get-environment-variables)

(define (extend-process-environment env)
  "(extend-process-environment '((\"NEWENV\" . test)))"
  (let ((current-env (remove (lambda (x) (assoc (car x) env))
                             (current-process-environment))))
    (append env current-env)))

(define (find-exec-path name)
  (find-file-in-paths name))
