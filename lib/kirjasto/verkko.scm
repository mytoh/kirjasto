
(define-library (kirjasto verkko)
    (export
      open
      swget

      find-all-tags

      html5
      robots-noindex

      ;; define-page

      url-is-git?
      url-is-hg?
      url-is-svn?
      url-is-cvs?
      url-is-bzr?
      url-is-fossil?

      string->sxml
      string-is-url?
      )
  (import
    (scheme base)
    (gauche base)
    (kirjasto verkko nico)
    (kirjasto verkko avata)
    (kirjasto verkko keitto)
    (kirjasto verkko merkintä)
    ;; kirjasto verkko palvelin
    (kirjasto verkko scm)
    (kirjasto verkko työkalu)
    ))
