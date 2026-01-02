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
   "../string-dp-table-factory.rkt"
   "../lcs-dp-strategy.rkt"
   "../levenshtein-dp-strategy.rkt")
  
  (define dp-table1
    (send (new string-dp-table-factory%
               [a "abcd"]
               [b "acbad"]
               [dp-strategy (new lcs-dp-strategy%)])
          get-dp-table))

  (check-equal? (send dp-table1 get-dist)
                2.0)

  (check-equal? (send dp-table1 get-edit-script)
  '((match -1.0) (ins 0.0) (match -1.0) (match 0.0) (match -1.0)))

  (define dp-table2
    (send (new string-dp-table-factory%
               [a "abcd"]
               [b "acbad"]
               [dp-strategy (new levenshtein-dp-strategy%)])
          get-dp-table))

  (check-equal? (send dp-table2 get-dist)
                2.0)

  (check-equal? (send dp-table2 get-edit-script)
                '((match 0.0) (ins 1.0) (match 0.0) (match 1.0) (match 0.0)))

  (define dp-table3
    (send (new string-dp-table-factory%
               [a "abc123"]
               [b "321abc"]
               [dp-strategy (new lcs-dp-strategy%)])
          get-dp-table))

  (check-equal? (send dp-table3 get-dist)
                3.0)

  (check-equal? (send dp-table3 get-edit-script)
                '((ins 0.0) (ins 0.0) (ins 0.0) (match -1.0) (match -1.0) (match -1.0) (del 0.0) (del 0.0) (del 0.0)))

  (define dp-table4
    (send (new string-dp-table-factory%
               [a "abc123"]
               [b "321abc"]
               [dp-strategy (new levenshtein-dp-strategy%)])
          get-dp-table))

  (check-equal? (send dp-table4 get-dist)
                6.0)

  (check-equal? (send dp-table4 get-edit-script)
                '((match 1.0) (match 1.0) (match 1.0) (match 1.0) (match 1.0) (match 1.0))))

         
