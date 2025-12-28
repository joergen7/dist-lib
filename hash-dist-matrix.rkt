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
 racket/set
 racket/match
 "abstract-dist-matrix.rkt"
 "wpgma-merge-strategy.rkt")

(provide
 hash-dist-matrix%)

(define hash-dist-matrix%
  (class abstract-dist-matrix%
    (super-new)

    (init-field
     dist-table
     [merge-strategy (new wpgma-merge-strategy%)])

    (define/override (get-depth a)
      0.0)

    (define/override (get-elem-dist a b)
      (cond
        [(equal? a b)
         0.0]
        [(hash-has-key? dist-table (cons a b))
         (hash-ref dist-table (cons a b))]
        [else
         (hash-ref dist-table (cons b a))]))

    (define/override (get-elem-set)
      (for/fold
          ([result (set)])
          ([pair (in-list (hash-keys dist-table))])
        (match pair
          [(cons a b)
           (set-add (set-add result a) b)])))

    (define/override (get-leaf-count a)
      1)
    
    (define/override (get-max-dist)
      (apply max (hash-values dist-table)))
    
    (define/override (get-merge-strategy)
      merge-strategy)

    (define/override (get-elem-tree a)
      a)

    (define/override (filter pred)
      (define dist-table1
        (for/fold ([result (hash)])
                  ([(pair dist) (in-hash dist-table)])
          (if (and (pred (car pair))
                   (pred (cdr pair)))
              (hash-set result pair dist)
              result)))
      (new hash-dist-matrix%
           [dist-table     dist-table1]
           [merge-strategy merge-strategy]))))


