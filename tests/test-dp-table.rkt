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
   racket/stream
   rackunit
   "../dp-table.rkt"
   "../lcs-dp-strategy.rkt"
   "../levenshtein-dp-strategy.rkt")
  
  (define dp-table1
    (make-dp-table/string
     "abcd"
     "acbad"
     #:dp-strategy (lcs-dp-strategy)))

  (check-equal? (dp-table-dist dp-table1)
                2.0)

  (check-equal? (dp-table-edit-script dp-table1)
  '((match -1.0) (ins 0.0) (match -1.0) (match 0.0) (match -1.0)))

  (define dp-table2
    (make-dp-table/string
     "abcd"
     "acbad"
     #:dp-strategy (levenshtein-dp-strategy)))

  (check-equal? (dp-table-dist dp-table2)
                2.0)

  (check-equal? (dp-table-edit-script dp-table2)
                '((match 0.0) (ins 1.0) (match 0.0) (match 1.0) (match 0.0)))

  (define dp-table3
    (make-dp-table/string
     "abc123"
     "321abc"
     #:dp-strategy (lcs-dp-strategy)))

  (check-equal? (dp-table-dist dp-table3)
                3.0)

  (check-equal? (dp-table-edit-script dp-table3)
                '((ins 0.0) (ins 0.0) (ins 0.0) (match -1.0) (match -1.0) (match -1.0) (del 0.0) (del 0.0) (del 0.0)))

  (define dp-table4
    (make-dp-table/string
     "abc123"
     "321abc"
     #:dp-strategy (levenshtein-dp-strategy)))

  (check-equal? (dp-table-dist dp-table4)
                6.0)

  (check-equal? (dp-table-edit-script dp-table4)
                '((match 1.0) (match 1.0) (match 1.0) (match 1.0) (match 1.0) (match 1.0))))

         
