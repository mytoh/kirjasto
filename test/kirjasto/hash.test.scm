

(use test.gasmine)
(use kirjasto.hash)


(describe "define-hash"
          (it "should make hash-table (name alist)"
              (define-hash h1
                           '((a . 1) (b .1)))
             (expect (hash-table? h1) eq? #t))
          (it "should make hash-table (name type alist)"
              (define-hash h2
                           'eq?
                           '((a . 1) (b .1)))
             (expect (hash-table? h2) eq? #t))
          (it "should make hash-table (name type alist ...)"
              (define-hash h3
                           'eq?
                          '(a . 1)
                          '(b .1))
             (expect (hash-table? h3) eq? #t))
          )

(describe "define-hash"
          (it "should make hash has key a"
          (define-hash hteq
                       '((a . 1) (b . 2)))
              (expect (ref hteq 'a) eq? 1))
          (it "should make hash has key string a"
          (define-hash htstr
                       'string=?
                       '(("a" . 1) ("b" . 2)))
              (expect (ref htstr "a") equal? 1))
          )

(run-suites '() 'tap-colour)
