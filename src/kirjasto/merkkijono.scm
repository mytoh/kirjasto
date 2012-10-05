
(define-module kirjasto.merkkijono
  (use text.tr)
  (use gauche.uvector)
  (require-extension
    (srfi 13))
  (export
    print-strings
    concat
    port->incomplete-string
    split-words
    snake-case
    dashed-words
    ))

(select-module kirjasto.merkkijono)



(define print-strings
  (lambda (string-lst)
    (cond
      ((null? string-lst)
       (values))
      (else
        (print (car  string-lst))
        (print-strings (cdr string-lst))))))

(define-syntax concat
  (syntax-rules ()
    ((_ lst)
     (string-concatenate lst))
    ((_ str ...)
     (string-append str ...))))

(define (port->incomplete-string port)
  (let ((strport (open-output-string))
        (u8buf (make-u8vector 4096)))
    (let loop ((len (read-block! u8buf port)))
      (cond ((eof-object? len)
             (get-output-string strport)
             (else
               (write-block u8buf strport 0 len)
               (loop (read-block! u8buf port))))))))


(define (split-words s)
  "function from github.com/magnars/s.el"
  (string-split
    (regexp-replace-all* s
                         #/([a-z])([A-Z])/  "\\1 \\2"
                         #/-/               " "
                         #/_/               " ")
    #/\s+/))

(define (snake-case s)
  "function from github.com/magnars/s.el"
  (string-join
    (map (lambda (word)
           (string-downcase word))
    (split-words s))
    "_"))

(define (dashed-words s)
  "function from github.com/magnars/s.el"
  (string-join
    (map (lambda (word)
           (string-downcase word))
    (split-words s))
    "-"))
