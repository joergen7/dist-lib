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
    [get-dist           (->m string? string? distance?)]
    [get-elem-count     (->m natural?)]
    [get-elem-set       (->m (set/c string?))]
    [get-leaf           (recursive-contract (->m (is-a?/c dist-matrix<%>)))]
    [get-leaf-elem-set  (->m string? (set/c string?))]
    [get-max-dist       (->m distance?)]
    [get-merge-strategy (recursive-contract (->m (is-a?/c merge-strategy<%>)))]
    [get-min-pair       (->m (cons/c string? string?))]
    [get-tree-root      (->m tree/c)]
    [get-tree           (->m string? tree/c)]
    [merge              (recursive-contract (->m string? string? (is-a?/c dist-matrix<%>)))]
    [reduce             (recursive-contract (->m (is-a?/c dist-matrix<%>)))]))

(define merge-strategy<%>
  (interface ()
    [get-dist (->m (is-a?/c dist-matrix<%>) (cons/c string? string?) string? distance?)]))
