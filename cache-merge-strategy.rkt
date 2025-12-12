#lang racket/base

(require
 racket/class
 racket/contract
 "dist-matrix.rkt")

(provide
 cache-merge-strategy%
 cache-merge-strategy)

(define cache-merge-strategy%
  (class* object% (merge-strategy<%>)
    (super-new)

    (init-field
     merge-strategy
     [cache (make-hash)])

    (define/public (get-dist dist-matrix merge-pair b)
      (define key
        (cons merge-pair b))
      (cond
        [(hash-has-key? cache key)
         (hash-ref cache key)]
        [else
         (define dist
           (send merge-strategy get-dist dist-matrix merge-pair b))
         (hash-set! cache key dist)
         dist]))))

(define/contract (cache-merge-strategy merge-strategy)
  (-> (is-a?/c merge-strategy<%>) (is-a?/c merge-strategy<%>))
  (new cache-merge-strategy%
       [merge-strategy merge-strategy]))
