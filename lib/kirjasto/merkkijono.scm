
 (define-library (kirjasto merkkijono)
    (export
      print-strings
      concat
      port->incomplete-string
      split-words
      underscore
      dasherize
      pluralize
      conc
      println)
  (import
    (scheme base)
    (scheme write)
    (gauche base)
    (text tr)
    (text unicode)
    (gauche uvector))

  (begin

    (define print-strings
      (lambda (string-lst)
        (cond
          ((null? string-lst)
           (values))
          (else
              (println (car  string-lst))
            (print-strings (cdr string-lst))))))

    (define (println . strings)
      (for-each display strings)
      (newline))

    (define-syntax concat
      (syntax-rules ()
        ((_ lst)
         (string-concatenate lst))
        ((_ str ...)
         (string-append (x->string str) ...))))

    (define (port->incomplete-string port)
      (let ((strport (open-output-string))
            (u8buf (make-u8vector 4096)))
        (let loop ((len (read-block! u8buf port)))
             (cond ((eof-object? len)
                    (get-output-string strport))
                   (else
                       (write-block u8buf strport 0 len)
                     (loop (read-block! u8buf port)))))))


    (define (split-words s)
      "function from github.com/magnars/s.el"
      (string-split
       (regexp-replace-all* s
                            #/([a-z])([A-Z])/  "\\1 \\2"
                            #/-/               " "
                            #/_/               " ")
       #/\s+/))

    (define (underscore s)
      "function from github.com/flatland/useful"
      (string-join
          (map (lambda (word)
                 (string-downcase word))
            (split-words s))
        "_"))

    (define (dasherize s)
      "function from github.com/flatland/useful"
      (string-join
          (map (lambda (word)
                 (string-downcase word))
            (split-words s))
        "-"))

    (define (pluralize num singular . optionals)
      " (plural 5 \"month\") => \"5 months\"
    (plural 9 \"radius\" \"radii\") => \"9 radii\"
  function from github.com/flatland/useful"
      (let ((plural? (if (null? optionals) #false #true)))
        (concat num " "
                (if (= 1 num)
                  singular
                  (or plural?
                    (concat singular "s"))))))

    (define (conc . args)
      (apply string-append (map x->string args)))

    ))
