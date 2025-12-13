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
 "dist-matrix.rkt"
 "cache-merge-strategy.rkt")

(provide
 max-merge-strategy%
 max-merge-strategy)

(define max-merge-strategy%
  (class* object% (merge-strategy<%>)
    (super-new)

    (define/public (get-dist parent merge-pair b)
      (max (send parent get-elem-dist (car merge-pair) b)
           (send parent get-elem-dist (cdr merge-pair) b)))))

(define max-merge-strategy
  (cache-merge-strategy (new max-merge-strategy%)))
