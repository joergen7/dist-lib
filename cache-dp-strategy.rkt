#lang racket/base

(require
 racket/class
 racket/contract
 "dp-table.rkt")

(provide
 cache-dp-strategy%
 cache-dp-strategy)

(define cache-dp-strategy%
  (class* object% (dp-strategy<%>)
    (super-new)

    (init-field
     dp-strategy
     [cache (make-hash)])

    (define/public (get-score dp-table x y)
      (define key
        (cons x y))
      (cond
        [(hash-has-key? cache key)
         (hash-ref cache key)]
        [else
         (define score
           (send dp-strategy get-score dp-table x y))
         (hash-set! cache key score)
         score]))))

(define/contract (cache-dp-strategy dp-strategy)
  (-> (is-a?/c dp-strategy<%>) (is-a?/c dp-strategy<%>))
  (new cache-dp-strategy%
       [dp-strategy dp-strategy]))
