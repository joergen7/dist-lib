#lang racket/base

(require
 racket/class
 racket/set
 "dist-matrix.rkt"
 "cache-merge-strategy.rkt")

(provide
 upgma-merge-strategy%
 upgma-merge-strategy)

(define upgma-merge-strategy%
  (class* object% (merge-strategy<%>)
    (super-new)

    (define/public (get-dist parent merge-pair b)
      (define dist1
        (send parent get-elem-dist (car merge-pair) b))
      (define dist2
        (send parent get-elem-dist (cdr merge-pair) b))
      (define count1
        (send parent get-leaf-count (car merge-pair)))
      (define count2
        (send parent get-leaf-count (cdr merge-pair)))
      (define count3
        (send parent get-leaf-count b))
      (define raw-dist1
        (* count1 count3 dist1))
      (define raw-dist2
        (* count2 count3 dist2))
      (define count4
        (* (+ count1 count2) count3))
      (/ (+ raw-dist1 raw-dist2) count4))))
      

(define upgma-merge-strategy
  (cache-merge-strategy (new upgma-merge-strategy%)))
