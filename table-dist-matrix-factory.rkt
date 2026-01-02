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
 racket/future
 "dist-matrix-factory.rkt"
 "hash-dist-matrix.rkt"
 "lcs-dp-strategy.rkt"
 "wpgma-merge-strategy.rkt")

(provide
 table-dist-matrix-factory%)

(define/contract (table-dist-matrix-factory% dp-table-factory-class)
  (-> class? class?)
  (class* object% (dist-matrix-factory<%>)
    (super-new)

    (init-field
     table
     [dp-strategy    (new lcs-dp-strategy%)]
     [merge-strategy (new wpgma-merge-strategy%)])

    (define/public (get-dist-matrix)

      (define key-list
        (hash-keys table))

      (define alist-future-list
        (make-alist-future-list key-list))

      (define dist-table
        (make-hash
         (apply append
                (map touch alist-future-list))))

      (new hash-dist-matrix%
           [dist-table     dist-table]
           [merge-strategy merge-strategy]))

    (define/private (make-alist-future-list key-list)
      (cond
        [(< (length key-list) 2)
         '()]
        [else
         (cons (make-alist-future dp-table-factory-class dp-strategy table (car key-list) (cdr key-list))
               (make-alist-future-list (cdr key-list)))]))))


(define (make-alist-future dp-table-factory-class dp-strategy table key-a key-b-list)
  (define a
    (hash-ref table key-a))
  (define b-list
    (for/list ([key-b (in-list key-b-list)])
      (hash-ref table key-b)))
  (future
   (lambda ()
     (for/list ([key-b (in-list key-b-list)]
                [b     (in-list b-list)])
       (make-assoc dp-table-factory-class dp-strategy key-a a key-b b)))))
           
(define (make-assoc dp-table-factory-class dp-strategy key-a a key-b b)
  (cons (cons key-a key-b)
        (send (send (new dp-table-factory-class
                         [a           a]
                         [b           b]
                         [dp-strategy dp-strategy])
                    get-dp-table)
              get-dist)))

                 
