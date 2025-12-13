#lang info
(define collection "dist-lib")
(define deps '("base" "draw-lib"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/dist-lib.scrbl" ())))
(define pkg-desc "A library for distance-based algorithms.")
(define version "0.0")
(define pkg-authors '(joergen))
(define license 'Apache-2.0)
