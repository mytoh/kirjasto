
(use test.gasmine)
(use kirjasto.config)


(describe "reading"
          (it "should read 1 sexp from config"
              (expect (read-config "config1.scm") equal? '(size 1)))
          (it "should not raise error with optional? keyword"
              (expect (read-config "config3.scm" :optional? #t) eq? #f))
          )

(describe "loading"
          (it "should read and eval config"
              (expect (load-config "config2.scm") equal? '((x 1) (y 1))))
          (it "should raise error"
              (TODO))
          (it "should not raise erro with optional? keyword"
              (expect (load-config "config3.scm" :optional? #t) eq? #f))
          )


(run-suites '() 'tap-colour)
