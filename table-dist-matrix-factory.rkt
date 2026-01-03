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
 racket/stream
 ; "simple-par.rkt"
 "dp-strategy.rkt"
 "dp-table.rkt"
 "dist-matrix-factory.rkt"
 "hash-dist-matrix.rkt"
 "lcs-dp-strategy.rkt"
 "wpgma-merge-strategy.rkt")

(provide
 table-dist-matrix-factory%)

(define/contract (table-dist-matrix-factory% dp-table-factory-class)
  (-> (->* (any/c any/c)
           (#:eq          (-> any/c any/c boolean?)
            #:dp-strategy dp-strategy/c)
           dp-table?)
      class?)
  (class* object% (dist-matrix-factory<%>)
    (super-new)

    (init-field
     table
     [eq             equal?]
     [dp-strategy    (lcs-dp-strategy)]
     [merge-strategy (new wpgma-merge-strategy%)])

    (define/public (get-dist-matrix)

      (define key-list
        (hash-keys table))

      (define dist-table
        (for/hash ([key-pair (in-stream (get-key-pair-stream key-list))])
          (define key-a
            (car key-pair))
          (define key-b
            (cdr key-pair))
          (define a
            (hash-ref table key-a))
          (define b
            (hash-ref table key-b))
          (values key-pair
                  (dp-table-dist
                   (dp-table-factory-class
                    a
                    b
                    #:eq          eq
                    #:dp-strategy dp-strategy)))))

      (new hash-dist-matrix%
           [dist-table     dist-table]
           [merge-strategy merge-strategy]))))

(define (get-key-pair-stream key-list)
  (cond
    [(eq? 2 (length key-list))
     (stream
      (cons (car key-list)
            (cadr key-list)))]
    [else
     (define a
       (car key-list))
     (stream-append
      (for/stream ([b (in-list (cdr key-list))])
        (cons a b))
      (get-key-pair-stream (cdr key-list)))]))

                 
