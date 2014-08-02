(define-library (kirjasto komento)
    (export
      run-command
      run-command-null
      run-command-sudo
      command-output
      mkdir
      cd)
  (import
    (kirjasto komento työkalu)))
