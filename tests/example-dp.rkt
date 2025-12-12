#lang racket/base

(module+ test

  (require
   racket/class
   rackunit
   "../edit-script.rkt"
   "../stream-dp-table.rkt"
   "../levenshtein-dp-strategy.rkt")

  (define a
    (string->list "kitten"))

  (define b
    (string->list "sitting"))

  (define dp-table-ab
    (new stream-dp-table%
         [a a]
         [b b]
         [dp-strategy (levenshtein-dp-strategy)]))

  (check-true
   (edit-script-equal?
    (send dp-table-ab get-edit-script)
    '((match 1.0) (match 0.0) (match 0.0) (match 0.0) (match 1.0) (match 0.0) (ins 1.0))))

  (check-equal? (send dp-table-ab get-dist) 3.0)
  (check-equal? (edit-script-dist (send dp-table-ab get-edit-script)) 3.0)

  (define c
    (string->list "saturday"))

  (define d
    (string->list "sunday"))

  (define dp-table-cd
    (new stream-dp-table%
         [a c]
         [b d]
         [dp-strategy (levenshtein-dp-strategy)]))

  (check-true
   (edit-script-equal?
    (send dp-table-cd get-edit-script)
    '((match 0.0) (del 1.0) (del 1.0) (match 0.0) (match 1.0) (match 0.0) (match 0.0) (match 0.0))))

  (check-equal? (send dp-table-cd get-dist) 3.0)
  (check-equal? (edit-script-dist (send dp-table-cd get-edit-script)) 3.0)
  )
