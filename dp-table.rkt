#lang racket/base

(require
 racket/class
 racket/math
 racket/contract
 "distance.rkt"
 "edit-script.rkt")

(provide
 dp-table<%>
 dp-strategy<%>)

(define dp-table<%>
  (interface ()
    [get-dist        (->m distance?)]
    [get-dp-strategy (recursive-contract (->m (is-a?/c dp-strategy<%>)))]
    [get-edit-script (->m edit-script?)]
    [get-length-a    (->m natural?)]
    [get-length-b    (->m natural?)]
    [get-score       (->m natural? natural? distance?)]
    [match?          (->m natural? natural? boolean?)]))

(define dp-strategy<%>
  (interface ()
    [get-score (->m (is-a?/c dp-table<%>) natural? natural? distance?)]))

