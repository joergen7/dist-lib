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
      (define leaf
        (send parent get-leaf))
      (define set1
        (set-union (send parent get-leaf-elem-set (car merge-pair))
                   (send parent get-leaf-elem-set (cdr merge-pair))))
      (define set2
        (send parent get-leaf-elem-set b))
      (define max-dist
        (send leaf get-max-dist))
      (for/fold ([m1 max-dist])
                ([x (in-set set1)])
        (min m1
             (for/fold ([m2 max-dist])
                       ([y (in-set set2)])
               (min m2
                    (send leaf get-dist x y))))))))

(define min-merge-strategy
  (cache (new min-merge-strategy%)))

