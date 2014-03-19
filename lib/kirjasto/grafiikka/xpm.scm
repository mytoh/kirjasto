;; -*- coding: utf-8 -*-

(define-library (kirjasto grafiikka xpm)
    (export
      make-xpm)
  (import
    (scheme base)
    (gauche base)
    (file util))

  (begin
    (define-syntax make-xpm
      (syntax-rules ()
        ((_ ?name ?data ...)
         (cond
           ((file-is-readable? ?name)
            ?name)
           (else
               (call-with-output-file
                   ?name
                 (lambda (out)
                   (format
                       out ?data
                       ...))
                 :if-exists #false
                 :if-does-not-exist :create)
             ?name)))))))

;; (define arrow-left
;;   "/* XPM */

;;   static char * arrow_left[] = {
;;   /* <width/cols> <height/rows> <colors> <char on pixel>*/
;;   \"10 12 2 1\",
;;   \". c ~a\",
;;   \"  c ~a\",
;;   \"         .\",
;;   \"        ..\",
;;   \"       ...\",
;;   \"      ....\",
;;   \"     .....\",
;;   \"    ......\",
;;   \"    ......\",
;;   \"     .....\",
;;   \"      ....\",
;;   \"       ...\",
;;   \"        ..\",
;;   \"         .\",
;;   };
;;   "
;;   )

;; (define arrow-left-xpm
;;   (lambda (c1 c2)
;;     (let ((icon-name
;;             (build-path (string-append
;;                           "arrow-left"
;;                           "_"
;;                           (string-trim  c1 #\#) "_"
;;                           (string-trim  c2 #\#)
;;                           ".xpm"))))
;;       (make-xpm icon-name arrow-left c1 c2))))
