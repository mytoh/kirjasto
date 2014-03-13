(define-library (kirjasto komento)
    (export
      run-command
      run-command-null
      run-command-sudo
      mkdir
      cd)
  (import
    (kirjasto komento työkalu)))
