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
      (define leaf
        (send parent get-leaf))
      (define set1
        (set-union (send parent get-leaf-elem-set (car merge-pair))
                   (send parent get-leaf-elem-set (cdr merge-pair))))
      (define set2
        (send parent get-leaf-elem-set b))
      ;; we can safely assume these sets are never empty
      (define v
        (for/sum ([x (in-set set1)])
          (for/sum ([y (in-set set2)])
            (send leaf get-dist x y))))
    
      (/ v
         (exact->inexact
          (* (set-count set1)
             (set-count set2)))))))

(define upgma-merge-strategy
  (cache (new upgma-merge-strategy%)))
