#lang racket/base

(require
 racket/class
 racket/contract
 racket/set
 racket/math
 "distance.rkt"
 "tree.rkt")

(provide
 dist-matrix<%>
 merge-strategy<%>)


;; the distance relation is reflexive and symmetric

(define dist-matrix<%>
  (interface ()
    [get-depth          (->m string? distance?)]
    [get-elem-count     (->m natural?)]
    [get-elem-dist      (->m string? string? distance?)]
    [get-elem-set       (->m (set/c string?))]
    [get-elem-tree      (->m string? tree/c)]
    [get-leaf-count     (->m string? natural?)]
    [get-max-dist       (->m distance?)]
    [get-merge-strategy (recursive-contract (->m (is-a?/c merge-strategy<%>)))]
    [get-min-pair       (->m (cons/c string? string?))]
    [get-tree           (->m tree/c)]
    [merge              (recursive-contract (->m string? string? (is-a?/c dist-matrix<%>)))]
    [reduce             (recursive-contract (->m (is-a?/c dist-matrix<%>)))]))

(define merge-strategy<%>
  (interface ()
    [get-dist (->m (is-a?/c dist-matrix<%>) (cons/c string? string?) string? distance?)]))
