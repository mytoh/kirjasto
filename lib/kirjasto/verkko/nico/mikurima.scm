(define-library (kirjasto verkko nico mikurima)
    (export
      mik:mik->sxml
      mik:nico-playlist->mik)
  (import
    (scheme base)
    (gauche base)
    (srfi 11)
    (sxml ssax)
    (file util)
    (rfc uri)
    (kirjasto verkko avata))

  (begin
    (define mik:mik->sxml
      (lambda (mik-playlist)
        (ssax:xml->sxml
         (open-input-file mik-playlist)
         '())))

    (define watch-url->getthumbinfo
      (lambda (url)
        (let-values
            (((s u h pt id query frap)
              (uri-parse url)))
          (uri-merge "http://ext.nicovideo.jp/api/getthumbinfo/" (sys-basename id)))))

    (define mylist-url->thumb_mylist
      (lambda (url)
        (let-values
            (((s u h pt id query frap)
              (uri-parse url)))
          (uri-merge "http://ext.nicovideo.jp/thumb_mylist/" (sys-basename id)))))

    (define getthumbinfo
      (lambda (url)
        (open (watch-url->getthumbinfo url)))
      )

    (define mylist->video-url-list
      (lambda (url)
        (let* ((html (open (mylist-url->thumb_mylist url)))
               (div (rxmatch->string
                     #/<div[^>]*>.*<\/div[^>]*>/
                     html))
               (a-tags ((lambda (str)
                          (let loop ((str str))
                               (let ((match (rxmatch #/<a href=\"(.*?)\"[^>]*>.*?<\/a[^>]*>/ str)))
                                 (cond
                                   (match
                                    (cons (match 1) (loop (match 'after))))
                                   (else
                                       '())))))
                        div)))
          a-tags)))


    (define mik:nico-playlist->mik
      (lambda (url)
        (let* ((html (open (mylist-url->thumb_mylist url)))
               (div (rxmatch->string
                     #/<div[^>]*>.*<\/div[^>]*>/
                     html))
               )
          (map
              getthumbinfo
            (cdr (mylist->video-url-list url)))
          )))))
