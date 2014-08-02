;;; kv.scm

 (define-library (kirjasto avain)
    (export get
            update
            add
            remove)
  (import
    (scheme base)
    (scheme write)

    (srfi 1)

    (kirjasto työkalu))

  (begin

    (define (get key kv)
      (fcond kv
             (null?
                 #false)
             (alist?
              (get-alist key kv))
             (klist?
              (get-klist key kv))
             (else #false)))

    (define (get-alist key kv)
      (let ((v (assoc key kv)))
        (if v
          (cdr v)
          #false)))

    (define (get-klist key kv)
      (if (null? kv)
        #false
        (if (eq? key (car kv))
          (cadr kv)
          (get-klist key (cddr kv)))))

    (define (add key datum kv)
      (cond ((alist? kv)
             (append kv (list (cons key datum))))
            ((klist? kv)
             (append kv (list key datum)))))

    (define (remove key kv)
      (cond ((alist? kv)
             (remove-alist key kv))
            ((klist? kv)
             (remove-klist key kv))
            (else #false)))

    (define (remove-alist key  kv)
      (if (assoc key kv)
        (let loop ((kv kv)
                   (res '()))
             (if (null? kv)
               (reverse res)
               (if (equal? key (car (car kv)))
                 (loop (cdr kv)
                       res)
                 (loop (cdr kv)
                       (cons (car kv)
                         res)))))
        kv))

    (define (remove-klist key kvl)
      (if (get-klist key kvl)
        (let loop ((kv kvl)
                   (res '()))
             (if (null? kv)
               res
               (if (eq? key (car kv))
                 (loop (cddr kv)
                       res)
                 (loop (cddr kv)
                       (append res
                         (list (car kv) (cadr kv)))))))
        kvl))

    (define (update key datum kv)
      (cond ((alist? kv)
             (update-alist key datum kv))
            ((klist? kv)
             (update-klist key datum kv))
            (else #false)))

    (define (update-alist key datum kv)
      (if (assoc key kv)
        (let ((proc (if (procedure? datum)
                      datum (constant datum))))
          (let loop ((kv kv)
                     (res '()))
               (if (null? kv)
                 (reverse res)
                 (if (equal? key (car (car kv)))
                   (loop (cdr kv)
                         (alist-cons key (proc (cdr (car kv))) res))
                   (loop (cdr kv)
                         (cons (car kv)
                           res))))))
        (if (procedure? datum) kv
            (add key datum kv))))

    (define (update-klist key datum kv)
      (if (get-klist key kv)
        (let ((proc (if (procedure? datum)
                      datum (constant datum))))
          (let loop ((kv kv)
                     (res '()))
               (if (null? kv)
                 res
                 (if (equal? key (car kv))
                   (loop (cddr kv)
                         (append res (list key (proc (cadr kv)))))
                   (loop (cddr kv)
                         (append
                             res
                           (list (car kv) (cadr kv))))))))
        (if (procedure? datum) kv
            (add key datum kv))))

    (define (alist? x)
      (if (list? x)
        (let ((e (car x)))
          (and (pair? e)
            (not (list? e))))
        #false))

    (define (klist? x)
      (and (list? x)
        (even? (length x))))

    ))
