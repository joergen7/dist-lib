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
 lcs-dp-strategy%)

(define lcs-dp-strategy%
  (class* object% (dp-strategy<%>)
    (super-new)

    (define/public (get-score dp-table x y)
      (cond
        [(zero? x)
         (get-base-score dp-table)]
        [(zero? y)
         (get-base-score dp-table)]
        [else
         (if (send dp-table match? (sub1 x) (sub1 y))
             (- (send dp-table get-score (sub1 x) (sub1 y))
                1.0)
             (min (send dp-table get-score (sub1 x) y)
                  (send dp-table get-score x (sub1 y))))]))

    (define/private (get-base-score dp-table)
      (exact->inexact
       (max (send dp-table get-length-a)
            (send dp-table get-length-b))))))




