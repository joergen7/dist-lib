#lang racket/base

(require
 racket/class
 "abstract-dp-table.rkt"
 "levenshtein-dp-strategy.rkt")

(provide
 string-dp-table%)

(define string-dp-table%
  (class abstract-dp-table%
    (super-new)

    (init-field
     a
     b
     [dp-strategy (levenshtein-dp-strategy)])

    (define/override (get-dp-strategy)
      dp-strategy)

    (define/override (get-length-a)
      (string-length a))

    (define/override (get-length-b)
      (string-length b))

    (define/override (match? x y)
      (eq? (string-ref a x)
           (string-ref b y)))))

    
