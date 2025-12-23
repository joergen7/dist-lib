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

(require
 racket/class
 racket/contract
 "dist-matrix-factory.rkt"
 "hash-dist-matrix.rkt"
 "lcs-dp-strategy.rkt"
 "wpgma-merge-strategy.rkt")

(provide
 table-dist-matrix-factory%)

(define/contract (table-dist-matrix-factory% dp-table-class)
  (-> class? class?)
  (class* object% (dist-matrix-factory<%>)
    (super-new)

    (init-field
     table
     [dp-strategy    (lcs-dp-strategy)]
     [merge-strategy wpgma-merge-strategy])

    (define/public (get-dist-matrix)
      (define dist-table
        (cond
          [(< (hash-count table) 2)
           (hash)]
          [else
           (make-dist-table (hash-keys table))]))
      (new hash-dist-matrix%
           [dist-table     dist-table]
           [merge-strategy merge-strategy]))

    (define/private (extend-dist-table dist-table key-a key-b)
      (define a
        (hash-ref table key-a))
      (define b
        (hash-ref table key-b))
      (define dp
        (new dp-table-class
             [a a]
             [b b]
             [dp-strategy dp-strategy]))
      (hash-set dist-table
                (cons key-a key-b)
                (send dp get-dist)))

    (define/private (make-dist-table key-list)
      (cond
        [(eq? (length key-list) 2)
         (define key-a
           (car key-list))
         (define key-b
           (cadr key-list))
         (extend-dist-table (hash) key-a key-b)]
        [else
         (define key-a
           (car key-list))
         (for/fold ([result (make-dist-table (cdr key-list))])
                   ([key-b (in-list (cdr key-list))])
           (extend-dist-table result key-a key-b))]))))
                 
