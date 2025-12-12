#lang racket/base

(require
 racket/class
 racket/contract
 "distance.rkt"
 "dp-table.rkt"
 "cache-dp-strategy.rkt")

(provide
 levenshtein-dp-strategy%
 levenshtein-dp-strategy)

(define levenshtein-dp-strategy%
  (class* object% (dp-strategy<%>)
    (super-new)

    (init-field
     [delta-ins   1.0]
     [delta-del   1.0]
     [delta-match 1.0])

    (define/public (get-score dp-table x y)
      (cond
        [(zero? x)
         (exact->inexact y)]
        [(zero? y)
         (exact->inexact x)]
        [else
         (define score-del
           (+ (send dp-table get-score (sub1 x) y)
              delta-del))
         (define score-ins
           (+ (send dp-table get-score x (sub1 y))
              delta-ins))
         (define score-match
           (+ (send dp-table get-score (sub1 x) (sub1 y))
              (if (send dp-table match? (sub1 x) (sub1 y))
                  0.0
                  delta-match)))
         (min score-del score-ins score-match)]))))

(define/contract (levenshtein-dp-strategy #:delta-ins   [delta-ins   1.0]
                                          #:delta-del   [delta-del   1.0]
                                          #:delta-match [delta-match 1.0])
  (->* ()
       (#:delta-ins   distance?
        #:delta-del   distance?
        #:delta-match distance?)
       (is-a?/c dp-strategy<%>))
  (cache-dp-strategy
   (new levenshtein-dp-strategy%
        [delta-ins delta-ins]
        [delta-del delta-del]
        [delta-match delta-match])))
