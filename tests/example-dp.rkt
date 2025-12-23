;; Copyright 2025 Jörgen Brandt
;;
;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;;     http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

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
         [dp-strategy (new levenshtein-dp-strategy%)]))

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
         [dp-strategy (new levenshtein-dp-strategy%)]))

  (check-true
   (edit-script-equal?
    (send dp-table-cd get-edit-script)
    '((match 0.0) (del 1.0) (del 1.0) (match 0.0) (match 1.0) (match 0.0) (match 0.0) (match 0.0))))

  (check-equal? (send dp-table-cd get-dist) 3.0)
  (check-equal? (edit-script-dist (send dp-table-cd get-edit-script)) 3.0)
  )
