#lang racket/base

(require
 racket/class
 racket/set
 "dist-matrix.rkt"
 "cache-merge-strategy.rkt")

(provide
 max-merge-strategy%
 max-merge-strategy)

(define max-merge-strategy%
  (class* object% (merge-strategy<%>)
    (super-new)

    (define/public (get-dist parent merge-pair b)
      (max (send parent get-elem-dist (car merge-pair) b)
           (send parent get-elem-dist (cdr merge-pair) b)))))

(define max-merge-strategy
  (cache-merge-strategy (new max-merge-strategy%)))
