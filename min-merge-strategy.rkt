#lang racket/base

(require
 racket/class
 racket/set
 "dist-matrix.rkt"
 "cache-merge-strategy.rkt")

(provide
 min-merge-strategy%
 min-merge-strategy)

(define min-merge-strategy%
  (class* object% (merge-strategy<%>)
    (super-new)

    (define/public (get-dist parent merge-pair b)
      (min (send parent get-elem-dist (car merge-pair) b)
           (send parent get-elem-dist (cdr merge-pair) b)))))

(define min-merge-strategy
  (cache-merge-strategy (new min-merge-strategy%)))

