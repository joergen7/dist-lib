#lang racket/base

(require
 racket/class
 "dist-matrix.rkt"
 "cache-merge-strategy.rkt")

(provide
 wpgma-merge-strategy%
 wpgma-merge-strategy)

(define wpgma-merge-strategy%
  (class* object% (merge-strategy<%>)
    (super-new)

    (define/public (get-dist parent merge-pair b)
      (* 0.5
         (+ (send parent get-elem-dist (car merge-pair) b)
            (send parent get-elem-dist (cdr merge-pair) b))))))

(define wpgma-merge-strategy
  (cache-merge-strategy (new wpgma-merge-strategy%)))
