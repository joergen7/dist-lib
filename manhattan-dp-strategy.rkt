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
 "dp-table.rkt")

(provide
 manhattan-dp-strategy%)

(define manhattan-dp-strategy%
  (class* object% (dp-strategy<%>)
    (super-new)

    (define/public (get-score dp-table x y)
      (cond
        [(zero? x)
         (exact->inexact y)]
        [(zero? y)
         (exact->inexact x)]
        [else
         (define score-match
           (+ (send dp-table get-score (sub1 x) (sub1 y))
              (if (send dp-table match? (sub1 x) (sub1 y))
                  0.0
                  1.0)))
         (cond
           [(and (eq? (send dp-table get-length-a) x)
                 (eq? (send dp-table get-length-b) y))
            (min (+ 1.0 (send dp-table get-score x (sub1 y)))
                 (+ 1.0 (send dp-table get-score (sub1 x) y))
                 score-match)]
           [(eq? (send dp-table get-length-a) x)
            (min (+ 1.0 (send dp-table get-score x (sub1 y)))
                 score-match)]
           [(eq? (send dp-table get-length-b) y)
            (min (+ 1.0 (send dp-table get-score (sub1 x) y))
                 score-match)]
           [else
            score-match])]))))
         
