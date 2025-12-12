#lang racket/base

(require
 racket/contract
 racket/math
 "distance.rkt")

(provide
 edit-script?
 edit-script-dist
 edit-script-equal?)

(define edit-script?
  (listof (list/c (symbols 'match 'ins 'del) distance?)))

(define/contract (edit-script-dist edit-script)
  (-> edit-script? distance?)
  (exact->inexact
   (for/sum ([x (in-list edit-script)])
     (cadr x))))

(define/contract (edit-script-equal? a b)
  (-> edit-script? edit-script? boolean?)
  (or
   (and (null? a)
        (null? b))
   (and (not (null? a))
        (not (null? b))
        (let ([head-a (car a)]
              [head-b (car b)])
          (and
           (eq? (list-ref head-a 0)
                (list-ref head-b 0))
           (= (list-ref head-a 1)
              (list-ref head-b 1))
           (edit-script-equal? (cdr a) (cdr b)))))))
