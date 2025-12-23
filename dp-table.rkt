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
 racket/math
 racket/contract
 "distance.rkt"
 "edit-script.rkt")

(provide
 dp-table<%>
 dp-strategy<%>)

(define dp-table<%>
  (interface ()
    [get-dist        (->m distance?)]
    [get-dp-strategy (recursive-contract (->m (is-a?/c dp-strategy<%>)))]
    [get-edit-script (->m edit-script?)]
    [get-length-a    (->m natural?)]
    [get-length-b    (->m natural?)]
    [get-score       (->m natural? natural? distance?)]
    [match?          (->m natural? natural? boolean?)]))

(define dp-strategy<%>
  (interface ()
    [get-score (->m (is-a?/c dp-table<%>) natural? natural? distance?)]))
