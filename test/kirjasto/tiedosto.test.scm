
(use kirjasto.tiedosto)

(use test.gasmine)

(print "kirjasto tiedosto")

(describe "kirjato tiedosto"
          (it "should return path with extension with dot"
              (expect (path-add-extension "test" ".scm") equal? "test.scm"))
          (it "should return path with extension without dot"
              (expect (path-add-extension "test" "scm") equal? "test.scm"))
          )




(run-suites)
