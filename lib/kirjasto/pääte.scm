
(define-module kirjasto.pääte
  (use file.util)
  (use gauche.process)
  (use gauche.parseopt)
  (use util.match)
  (use srfi-1)
  (use util.list)
  (use kirjain)

  (export
    screen-title
    print-repeat
    puts-columns

    tput-cr
    tput-cursor-invisible
    tput-cursor-normal
    tput-clr-bol
    tput-clr-eol))
(select-module kirjasto.pääte)

(define (screen-title command)
  (cond (equal?  (sys-basename (sys-getenv "SHELL"))
                 "tcsh")
    (display (string-append "_" command ""))
    (else
      (display (string-append "k" command "\\")))))

(define (window-name command)
  (display  (string-append "]2;" command  "\a")))

(define (print-repeat string-list inter)
  (for-each (^i (format #t  "~a\r" i)
              (flush)
              (sys-select #f #f #f inter))
            string-list))

(define (tput-cr)
  (run-process '(tput cr) :wait #t))

(define (tput-cursor-invisible)
  (run-process '(tput civis) :wait #t))

(define (tput-cursor-normal)
  (run-process '(tput cnorm) :wait #t))

(define (tput-clr-bol)
  (run-process '(tput el1) :wait #t))

(define (tput-clr-eol)
  (run-process '(tput el) :wait #t))




(define (string-longest string-list)
  (fold (lambda (s r)
          (if (< r (string-length s))
            (string-length s)
            r))
        0 string-list))

(define (puts-columns items)
  (let* ((console-width (if (< 80 (string->number (process-output->string "tput cols" ))) 
                                           80 (string->number (process-out-put->string "tput cols"))))
         (longest (string-longest items))
         (optimal-col-width (floor->exact (/. console-width (+ longest 2))))
         (cols (if (< 1 optimal-col-width ) optimal-col-width 1)))
    (let loop ((itm items))
      (cond
        ((< (length itm) cols)
         (for-each
           (lambda (s) (format #t (string-append
                                    "~" (number->string (+  longest 2)) "a")
                               s))
           (take* itm cols)))
        (else
          (for-each
            (lambda (s) (format #t (string-append
                                     "~" (number->string (+ longest 2)) "a")
                                s))
            (take* itm cols))
          (newline)
          (loop (drop* itm cols)))))
    (newline)))
