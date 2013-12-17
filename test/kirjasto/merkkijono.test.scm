
(use test.gasmine)
(use kirjasto.merkkijono)

(describe "pluralize"
          (it "is 10 dogs"
             (expect (pluralize 10 "dog") equal? "10 dogs"))
          (it "is 1 cat"
             (expect (pluralize 1 "cat") equal? "1 cat"))
          (it "is 0 octopodes"
             (expect (pluralize 0 "octopus" "octopodes") equal? "0 octopodes"))
          (it "is 1 fish"
             (expect (pluralize 1 "fish") equal? "1 fish"))
          )

(describe "dasherize"
          (it "should return set-size"
              (expect (dasherize "setSize") equal? "set-size"))
          (it "should return the-url"
              (expect (dasherize "theURL") equal? "the-url"))
          (it "should return class-name"
              (expect (dasherize "ClassName") equal? "class-name"))
          (it "should return loud-constant"
              (expect (dasherize "LOUD_CONSTANT") equal? "loud-constant"))
          (it "should return the-crazy-train"
              (expect (dasherize "the_CRAZY_train") equal? "the-crazy-train"))
          (it "should return with-dashes"
              (expect (dasherize "with-dashes") equal? "with-dashes"))
          (it "should return with-underscores"
              (expect (dasherize "with_underscores") equal? "with-underscores"))
          )

(describe "underscore"
          (it "should return set_size"
              (expect (underscore "setSize") equal? "set_size"))
          (it "should return the_url"
              (expect (underscore "theURL") equal? "the_url"))
          (it "should return class_name"
              (expect (underscore "ClassName") equal? "class_name"))
          (it "should return loud_constant"
              (expect (underscore "LOUD_CONSTANT") equal? "loud_constant"))
          (it "should return the_crazy_train"
              (expect (underscore "the_CRAZY_train") equal? "the_crazy_train"))
          (it "should return with_dashes"
              (expect (underscore "with-dashes") equal? "with_dashes"))
          (it "should return with_underscores"
              (expect (underscore "with_underscores") equal? "with_underscores"))
          )

(run-suites '() 'tap-colour)
