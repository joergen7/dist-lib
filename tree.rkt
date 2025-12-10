#lang racket/base

(require
 racket/contract
 racket/set)

(provide
 tree/c
 tree-elem-set)

(define tree/c
  (recursive-contract
   (or/c string?
         (list/c tree/c rational? tree/c rational?))))

(define/contract (tree-elem-set tree)
  (-> tree/c (set/c string?))
  (cond
    [(string? tree)
     (set tree)]
    [else
     (set-union (tree-elem-set (list-ref tree 0))
                (tree-elem-set (list-ref tree 2)))]))
