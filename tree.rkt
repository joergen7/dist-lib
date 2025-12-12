#lang racket/base

(require
 racket/contract
 racket/set)

(provide
 tree/c
 tree-elem-set
 tree-equal?)

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

(define/contract (tree-equal? a b)
  (-> tree/c tree/c boolean?)
  (or
   (and (string? a)
        (string? b)
        (equal? a b))
   (and (list? a)
        (list? b)
        (or
         (and (tree-equal? (list-ref a 0)
                           (list-ref b 0))
              (= (list-ref a 1)
                 (list-ref b 1))
              (tree-equal? (list-ref a 2)
                           (list-ref b 2))
              (= (list-ref a 3)
                 (list-ref b 3)))
         (and (tree-equal? (list-ref a 0)
                           (list-ref b 2))
              (= (list-ref a 1)
                 (list-ref b 3))
              (tree-equal? (list-ref a 2)
                           (list-ref b 0))
              (= (list-ref a 3)
                 (list-ref b 1)))))))
