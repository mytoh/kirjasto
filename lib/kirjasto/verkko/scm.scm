;; -*- coding: utf-8 -*-

(define-library (kirjasto verkko scm)
    (export
      url-is-git?
      url-is-hg?
      url-is-svn?
      url-is-cvs?
      url-is-bzr?
      url-is-fossil?)
  (import
    (scheme base)
    (gauche)
    (file util)
    (rfc uri)
    (srfi 11))

  (begin
    (define url-is-git?
      (lambda (url)
        (let-values (((scheme user-info hostname port-number path query fragment)
                      (uri-parse url)))
          (cond
            ((string=? scheme "git")
             #true)
            ((if (string? (path-extension path))
               (string=?  (path-extension path) "git")
               #false)
             #true)
            (else #false)))))


    (define (url-is-hg? url)
      (or ( #/^https?:\/\/(.+?\.)?googlecode\.com\/hg/ url)
        ( #/^hg:\/\// url)
        ( #/^http:\/\/hg\./ url)
        ( #/^http:\/\/(.+?\/)\/hg/ url)))

    (define (url-is-svn? url)
      (or ( #/^https?:\/\/(.+?\.)?googlecode\.com\/svn/ url)
        ( #/^https?:\/\/(.+?\.)?sourceforge\.net\/svnroot/ url)
        ( #/^svn:\/\// url)
        ( #/^svn\+http:\/\// url)
        ( #/^http:\/\/svn.apache.org\/repos/ url)
        ( #/^http:\/\/svn\./ url)))

    (define (url-is-bzr? url)
      (cond (( #/^bzr:\/\// url) #true)
            (else #false)))

    (define (url-is-fossil? url)
      (cond (( #/^fossil:\/\// url) #true)
            (else #false)))

    (define (url-is-cvs? url)
      (cond (( #/^cvs:\/\// url) #true)
            (else #false)))))
