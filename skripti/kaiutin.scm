
":"; exec gosh -- <|0|> "$@"
;; -*- coding: utf-8 -*-

(use text.tree)

(define (famima)
  (tree->string
    '("o4" "l8" "F#" "D" "<A>" "D" "E" ">A<" "P8." "<A>" "E" "F#" "E" "<A>" "D2"))
  ; fa re "la" re  mi 'la' - "la"  mi fa mi "la" re -
    ; "o4l8F#D<A>DE>A<P8.<A>EF#E<A>D2"
  )

(define (marisa)
"T155MLL16E-FG-2.P8FG-L2A->D-<B-1PL4B->D-E-2E-G-F.D-.<A-G-.A-.B-F2L8F.G-.A-G-2.P8L16FG-A-2>D-2E-1L8PG-F4E-.<B-.>D-L4D-.<B.A->D.E-.FF.E-2"
)


(define (kaiutin notes)
 (call-with-output-file
    "/dev/speaker"
    (lambda (in)
      (display (notes)
               in)))
  )

(define (main args)
  (kaiutin marisa)
  )
