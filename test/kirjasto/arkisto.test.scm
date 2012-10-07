
(use kirjasto.arkisto)

(use test.gasmine)

(print "kirjast arkisto")

(describe "kirjasto arkisto"
          (it "should detects archive file type bz2"
              (expect (file-is-archive? "test.bz2") eq? #t))
          (it "should detects archive file type tar"
              (expect (file-is-archive? "test.tar") eq? #t))
          (it "should detects archive file type zip"
              (expect (file-is-archive? "test.zip") eq? #t))
          (it "should detects archive file type rar"
              (expect (file-is-archive? "test.rar") eq? #t))
          (it "should detects archive file type xz"
              (expect (file-is-archive? "test.xz") eq? #t))
          (it "should detects archive file type gz"
              (expect (file-is-archive? "test.gz") eq? #t))
          (it "should detects archive file type cbz"
              (expect (file-is-archive? "test.cbz") eq? #t))
          (it "should detects archive file type cbx"
              (expect (file-is-archive? "test.cbx") eq? #t)))



(run-suites '() 'tap-colours)
