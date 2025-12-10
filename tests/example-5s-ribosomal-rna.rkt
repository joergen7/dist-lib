#lang racket/base

(module+ test

  (require
   racket/class
   racket/set
   rackunit
   "../hash-dist-matrix.rkt"
   "../min-merge-strategy.rkt")

  (define dist-table
    (hash (cons "a" "b") 17.0
          (cons "a" "c") 21.0
          (cons "a" "d") 31.0
          (cons "a" "e") 23.0
          (cons "b" "c") 30.0
          (cons "b" "d") 34.0
          (cons "b" "e") 21.0
          (cons "c" "d") 28.0
          (cons "c" "e") 39.0
          (cons "d" "e") 43.0))
  
  (define dm-min
    (new hash-dist-matrix%
         [dist-table     dist-table]
         [merge-strategy min-merge-strategy]))

  #|
  (check-equal?
   (send dm-min get-dist "a" "b")
   17.0)

  (check-equal?
   (send dm-min get-dist "b" "a")
   17.0)

  (check-equal?
   (send dm-min get-dist "a" "a")
   0.0)

  (check-equal?
   (send dm-min get-dist "b" "b")
   0.0)

  (check-equal?
   (send dm-min get-depth "a")
   0.0)

  (check-equal?
   (send dm-min get-depth "b")
   0.0)

  (let ([min-pair (send dm-min get-min-pair)])
    (check-equal? (set (car min-pair) (cdr min-pair))
                  (set "a" "b")))

  |#
  (displayln (send dm-min get-tree-root))
  )
