
(define-library (clojure fs)
    (export
      temp-name
      temp-create
      temp-file
      temp-dir
      with-cwd
      absolute-path
      parent
      file
      copy
      copy+)
  (import
    (clojure fs core)))
