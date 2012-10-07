
(use text.tree)





(define (notes)
  (tree->string
    '("o4" "l8" "F#" "D" "<A>" "D" "E" ">A<" "~8." "<A>" "E" "F#" "E" "<A>" "D2"))
  ; fa re "la" re  mi 'la' - "la"  mi fa mi "la" re -
  )


(define (main args)
  (call-with-output-file
    "/dev/speaker"
    (lambda (in)
      (display (notes)
               in)))
  )
