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
             (plist?
              (get-plist key kv))
             (else #false)))

    (define (get-alist key kv)
      (let ((v (assoc key kv)))
        (if v
          (cdr v)
          #false)))

    (define (get-plist key kv)
      (let ((v (assoc key kv)))
        (if v
          (cadr v)
          #false)))

    (define (get-klist key kv)
      (if (null? kv)
        #false
        (if (eq? key (car kv))
          (cadr kv)
          (get-klist key (cddr kv)))))

    (define (add key datum kv)
      (fcond kv
             (alist?
              (append kv (list (cons key datum))))
             (plist?
              (append kv (list (list key datum))))
             (klist?
              (append kv (list key datum)))))

    (define (remove key kv)
      (fcond kv
             (alist?
              (remove-alist key kv))
             (plist?
              (remove-plist key kv))
             (klist?
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

    (define (remove-plist key  kv)
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
      (fcond kv
             (alist?
              (update-alist key datum kv))
             (plist?
              (update-plist key datum kv))
             (klist?
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
                 (let ((elem (car kv)))
                   (if (null? elem)
                     (loop (cdr kv)
                           (cons elem res))
                     (if (equal? key (car elem))
                       (loop (cdr kv)
                             (alist-cons key (proc (cdr elem)) res))
                       (loop (cdr kv)
                             (cons elem  res))))))))
        (if (procedure? datum) kv
            (add key datum kv))))

    (define (update-plist key datum kv)
      (if (assoc key kv)
        (let ((proc (if (procedure? datum)
                      datum (constant datum))))
          (let loop ((kv kv)
                     (res '()))
               (if (null? kv)
                 (reverse res)
                 (let ((elem (car kv)))
                   (if (null? elem)
                     (loop (cdr kv)
                           (cons elem res))
                     (if (equal? key (car elem))
                       (loop (cdr kv)
                             (cons (list key (proc (cadr elem))) res))
                       (loop (cdr kv)
                             (cons elem res))))))))
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

    ;; alist
    ;; ((a . 1) (b . 2) (c . 3))
    (define (alist? x)
      (if (list? x)
        (let ((e (car x)))
          (and (pair? e)
            (not (list? e))))
        #false))

    ;; klist
    ;; (a  1 b  2 c  3)
    (define (klist? x)
      (and (list? x)
        (not-pair? (car x))
        (even? (length x))))

    ;; plist
    ;; ((a 1) (b 2) (c 3))
    (define (plist? x)
      (and (list? x)
        (list? (car x))))

    ))
