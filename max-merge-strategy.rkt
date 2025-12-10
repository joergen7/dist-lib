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
      (define leaf
        (send parent get-leaf))
      (define set1
        (set-union (send parent get-leaf-elem-set (car merge-pair))
                   (send parent get-leaf-elem-set (cdr merge-pair))))
      (define set2
        (send parent get-leaf-elem-set b))
      (for/fold ([m1 0.0])
                ([x (in-set set1)])
        (max m1
             (for/fold ([m2 0.0])
                       ([y (in-set set2)])
               (max m2
                    (send leaf get-dist x y))))))))

(define max-merge-strategy
  (cache (new max-merge-strategy%)))
