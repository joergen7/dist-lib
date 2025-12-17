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
   racket/set
   rackunit
   "../tree.rkt"
   "../hash-dist-matrix.rkt"
   "../min-merge-strategy.rkt"
   "../max-merge-strategy.rkt"
   "../upgma-merge-strategy.rkt"
   "../wpgma-merge-strategy.rkt")

  (define (pair-equal? a b)
    (or (equal? a b)
        (equal? a (cons (cdr b) (car b)))))

  (define dist-table
    (hash (cons "a" "b") 17.0
          (cons "a" "c") 21.0
          (cons "a" "d") 31.0
          (cons "a" "e") 23.0
          (cons "b" "c") 30.0
          (cons "b" "d") 34.0
          (cons "b" "e") 21.0
          (cons "c" "d") 28.0
          (cons "c" "e") 39.0
          (cons "d" "e") 43.0))
  
  (define dm-min
    (new hash-dist-matrix%
         [dist-table     dist-table]
         [merge-strategy min-merge-strategy]))

  (check-equal?
   (send dm-min get-elem-dist "a" "b")
   17.0)

  (check-equal?
   (send dm-min get-elem-dist "b" "a")
   17.0)

  (check-equal?
   (send dm-min get-elem-dist "a" "a")
   0.0)

  (check-equal?
   (send dm-min get-elem-dist "b" "b")
   0.0)

  (check-equal?
   (send dm-min get-depth "a")
   0.0)

  (check-equal?
   (send dm-min get-depth "b")
   0.0)

  (let ([min-pair (send dm-min get-min-pair)])
    (check-true (pair-equal? min-pair (cons "a" "b"))))


  (check-true
   (tree-equal? (send dm-min get-tree)
                '(("e" 10.5 ("c" 10.5 ("a" 8.5 "b" 8.5) 2.0) 0.0) 3.5 "d" 14.0)))

  (define dm-max
    (new hash-dist-matrix%
         [dist-table     dist-table]
         [merge-strategy max-merge-strategy]))

  (check-true
   (tree-equal? (send dm-max get-tree)
                '(("c" 14.0 "d" 14.0) 7.5 ("e" 11.5 ("a" 8.5 "b" 8.5) 3.0) 10.0)))


  (define dm-upgma
    (new hash-dist-matrix%
         [dist-table     dist-table]
         [merge-strategy upgma-merge-strategy]))

  (check-true
   (tree-equal? (send dm-upgma get-tree)
                '((("a" 8.5 "b" 8.5) 2.5 "e" 11.0) 5.5 ("c" 14.0 "d" 14.0) 2.5)))

  (define dm-wpgma
    (new hash-dist-matrix%
         [dist-table     dist-table]
         [merge-strategy wpgma-merge-strategy]))

  (check-true
   (tree-equal? (send dm-wpgma get-tree)
                '((("a" 8.5 "b" 8.5) 2.5 "e" 11.0) 6.5 ("c" 14.0 "d" 14.0) 3.5)))
)
