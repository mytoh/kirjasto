
(use test.gasmine)
(use kirjasto.config)


(describe "reading"
          (it "should read 1 sexp from config"
              (expect (read-config "test/config1.scm") equal? '(size 1)))
          (it "should not raise error with optional? keyword"
              (expect (read-config "not_exists.scm" :optional? #t) eq? #f))
          )

(describe "loading"
          (it "should read and eval config"
              (expect (load-config "test/config2.scm") equal? '((x 1) (y 1))))
          (it "should raise error"
              (TODO))
          (it "should not raise erro with optional? keyword"
              (expect (load-config "not_exists.scm" :optional? #t) eq? #f))
          )


(run-suites '() 'tap-colour)
