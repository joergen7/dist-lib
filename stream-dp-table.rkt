#lang racket/base

(require
 racket/class
 racket/stream
 "abstract-dp-table.rkt"
 "levenshtein-dp-strategy.rkt")

(provide
 stream-dp-table%)

(define stream-dp-table%
  (class abstract-dp-table%
    (super-new)

    (init-field
     a
     b
     [dp-strategy (levenshtein-dp-strategy)])

    (define/override (get-dp-strategy)
      dp-strategy)

    (define/override (get-length-a)
      (stream-length a))

    (define/override (get-length-b)
      (stream-length b))

    (define/override (match? x y)
      (equal? (stream-ref a x)
              (stream-ref b y)))))

