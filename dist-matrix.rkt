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
 racket/set
 racket/math
 "distance.rkt"
 "tree.rkt")

(provide
 dist-matrix<%>
 merge-strategy<%>)


;; the distance relation is reflexive and symmetric

(define dist-matrix<%>
  (interface ()
    [get-depth          (->m string? distance?)]
    [get-elem-count     (->m natural?)]
    [get-elem-dist      (->m string? string? distance?)]
    [get-elem-set       (->m (set/c string?))]
    [get-elem-tree      (->m string? tree/c)]
    [get-leaf-count     (->m string? natural?)]
    [get-max-dist       (->m distance?)]
    [get-merge-strategy (recursive-contract (->m (is-a?/c merge-strategy<%>)))]
    [get-min-pair       (->m (cons/c string? string?))]
    [get-tree           (->m tree/c)]
    [merge              (recursive-contract (->m string? string? (is-a?/c dist-matrix<%>)))]
    [reduce             (recursive-contract (->m (is-a?/c dist-matrix<%>)))]))

(define merge-strategy<%>
  (interface ()
    [get-elem-dist (->m (is-a?/c dist-matrix<%>) (cons/c string? string?) string? distance?)]))
