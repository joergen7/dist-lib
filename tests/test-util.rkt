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
 racket/string
 racket/draw
 rackunit
 "../tree.rkt"
 "../distance.rkt"
 "../dp-table.rkt"
 "../string-dp-table.rkt")

(provide
 make-check-dist
 make-tree-display)

(define/contract (make-check-dist make-dp-strategy)
  (-> (is-a?/c dp-strategy<%>) (-> string? string? distance? void?))
  (lambda (a b dist)
    (define dp
      (new string-dp-table%
           [a a]
           [b b]
           [dp-strategy make-dp-strategy]))
    (check-= (send dp get-dist) dist 0.000001 (string-join (list a b)))))

(define/contract (make-tree-display tree-image-factory-class)
  (-> class? (-> tree/c (is-a?/c bitmap%)))
  (lambda (tree)
    (define image-factory
      (new tree-image-factory-class
           [tree tree]))
    (define image
      (send image-factory
            get-image))
    (send image
          get-bitmap 300)))
