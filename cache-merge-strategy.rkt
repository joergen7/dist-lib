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
 "dist-matrix.rkt")

(provide
 cache-merge-strategy%
 cache-merge-strategy)

(define cache-merge-strategy%
  (class* object% (merge-strategy<%>)
    (super-new)

    (init-field
     merge-strategy
     [cache (make-hash)])

    (define/public (get-dist dist-matrix merge-pair b)
      (define key
        (cons merge-pair b))
      (cond
        [(hash-has-key? cache key)
         (hash-ref cache key)]
        [else
         (define dist
           (send merge-strategy get-dist dist-matrix merge-pair b))
         (hash-set! cache key dist)
         dist]))))

(define/contract (cache-merge-strategy merge-strategy)
  (-> (is-a?/c merge-strategy<%>) (is-a?/c merge-strategy<%>))
  (new cache-merge-strategy%
       [merge-strategy merge-strategy]))
