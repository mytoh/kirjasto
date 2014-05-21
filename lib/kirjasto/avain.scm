;;; kv.scm

(define-library (kirjasto avain)
    (export get
            update
            alist?)
  (import (scheme base)
          (scheme write)
          (srfi 1))

  (begin

    (define (get key kv)
      (cond
        ((alist? kv)
         (let ((v (assoc key kv)))
           (if v
             (cdr v)
             #false)))
        (else #false)))

    (define (update key datum kv)
      (if (alist? kv)
        (let loop ((kv kv)
                   (res '()))
             (if (null? kv)
               (reverse res)
               (if (equal? key (car (car kv)))
                 (loop (cdr kv)
                       (alist-cons key datum res))
                 (loop (cdr kv)
                       (cons (car kv)
                         res)))))
        #false))

    (define (alist? x)
      (if (list? x)
        (let ((e (car x)))
          (and (pair? e)
            (not (list? e))))
        #false))

    ))
