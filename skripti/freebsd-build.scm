(use gauche.process)
(use file.util)
(use util.match)
(require-extension (srfi 13))


(define-syntax colour-command
  (syntax-rules ()
    ((_ ?command ?regexp ?string ...)
     (with-input-from-process
       ?command
       (lambda ()
         (port-for-each
           (lambda (in)
             (print
               (regexp-replace* in
                                ?regexp ?string
                                ...)))
           read-line))))))

(define (process command)
  (print  (string-concatenate `("[38;5;80m" "==> " "[0m" ,command)))
  (colour-command command
                  #/^>>>/   "[38;5;2m\\0[0m"
                  #/^=*>/   "[38;5;3m\\0[0m"
                  #/^-*/    "[38;5;4m\\0[0m"
                  #/^(cc|c\+\+|sed|awk|ctfconvert|mkdep)\s/  "[38;5;5m\\0[0m"
                  #/\/(\w*\.(cpp|c|o|S|so|td|po|gz|h|sh))/  "/[38;5;6m\\1[0m"
                  #/(-\w*)/  "/[38;5;7m\\1[0m"
                  #/(zfs|libc\+\+|clang|llvm|MYKERNEL)/  "/[38;5;8m\\1[0m"
                  #/\(\w*\)/   "/[38;5;9m\\0[0m"
                  #/\^*/    "/[38;5;1m\\0[0m"
                  #/[A-Z]*/ "/[38;5;11m\\0[0m"
                  )
  (print  (string-concatenate `("[38;5;80m" "==> " "[0m finished " ,command))))

(define (first)
  (current-directory "/usr/src")
  (when (file-exists? "/usr/obj")
    (process "sudo make cleandir")
    (process "sudo make cleandir")
    (process "sudo rm -rfv /usr/obj"))
  (process "sudo make -j 10 buildworld")
  (process "sudo make -j 10 buildkernel")
  (process "sudo make installkernel")
  (print "REBOOT!"))


(define (second)
  (process "mount -u /" )
  (process "mount -a -t ufs" )
  (run-process '(mergemaster -p ) :wait #t)
  (current-directory "/usr/src")
  (process "make installworld" )
  (process "yes y | make delete-old" )
  (run-process '(mergemaster ) :wait #t)
  (print "please reboot")
  (print
    " # reboot
    # mount -u /
    # mount -a -t ufs
    # cd /usr/src
    # make delete-old-libs "))

(define (third)
  (process "mount -u /" )
  (process "mount -a -t ufs" )
  (current-directory "/usr/src")
  (process "yes y | make delete-old-libs" ))




(define (main args)
  (match (cadr args)
    ("first"
     (first))
    ("second"
     (second))
    ("third"
     (third))))
