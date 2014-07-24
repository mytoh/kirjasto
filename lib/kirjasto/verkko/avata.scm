(define-library (kirjasto verkko avata)
    (export
      open
      swget)
  (import
    (scheme base)
    (scheme file)
    (gauche)
    (gauche net)
    (rfc http)
    (rfc uri)
    (file util)
    (kirjasto merkkijono) ; whitespace->dash
    (srfi 11))

  (begin

    (define (open uri . options)
      (let-keywords options ((proxy  :proxy  #false)
                             (secure :secure #false)
                             (file   :file   #false)
                             . rest)
                    (let-values (((scheme user-info hostname port-number path query fragment)
                                  (uri-parse uri)))
                      ;; returns html body
                      (cond (file (call-with-output-file
                                      file
                                    (lambda (in)
                                      (http-get hostname (or  path "/")
                                                :proxy proxy
                                                :secure secure
                                                :sink in
                                                :flusher (lambda _ #true)))))
                            (else
                                (values-ref (http-get hostname (or  path "/")
                                                      :proxy proxy
                                                      :secure secure)
                                            2))))))

    (define (swget uri)
      (let-values (((scheme user-info hostname port-number path query fragment)
                    (uri-parse uri)))
        (let* ((file (receive (a fname ext)
                       (decompose-path (dasherize path))
                       (string-append fname "." ext)))
               (flusher (lambda (s h) (print file) #true)))
          (if (not (file-is-readable? file))
            (call-with-output-file
                file
              (cut http-get hostname path
                   :sink <> :flusher flusher))))))))
