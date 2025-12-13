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
 "dp-table.rkt")

(provide
 cache-dp-strategy%
 cache-dp-strategy)

(define cache-dp-strategy%
  (class* object% (dp-strategy<%>)
    (super-new)

    (init-field
     dp-strategy
     [cache (make-hash)])

    (define/public (get-score dp-table x y)
      (define key
        (cons x y))
      (cond
        [(hash-has-key? cache key)
         (hash-ref cache key)]
        [else
         (define score
           (send dp-strategy get-score dp-table x y))
         (hash-set! cache key score)
         score]))))

(define/contract (cache-dp-strategy dp-strategy)
  (-> (is-a?/c dp-strategy<%>) (is-a?/c dp-strategy<%>))
  (new cache-dp-strategy%
       [dp-strategy dp-strategy]))
