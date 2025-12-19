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
 "dp-table.rkt"
 "edit-script.rkt")

(provide
 abstract-dp-table%)

(define abstract-dp-table%
  (class* object% (dp-table<%>)
    (super-new)

    (abstract
     get-dp-strategy
     get-length-a
     get-length-b
     match?)

    (define/public (get-dist)
      (get-score (get-length-a) (get-length-b)))

    (define/public (get-edit-script)
      (let recur ([x           (get-length-a)]
                  [y           (get-length-b)]
                  [edit-script '()])
        (define score0
          (get-score x y))
        (cond
          [(and (zero? x)
                (zero? y))
           edit-script]
          [(zero? x)
           (define score-del
             (get-score x (sub1 y)))
           (define op
             (list 'del (- score0 score-del)))
           (recur x (sub1 y) (cons op edit-script))]
          [(zero? y)
           (define score-ins
             (get-score (sub1 x) y))
           (define op
             (list 'ins (- score0 score-ins)))
           (recur (sub1 x) y (cons op edit-script))]
          [else
           (define score-del
             (get-score (sub1 x) y))
           (define score-ins
             (get-score x (sub1 y)))
           (define score-match
             (get-score (sub1 x) (sub1 y)))
           (define-values (x1 y1 op)
             (cond
               [(and (< score-del score-ins)
                     (< score-del score-match))
                (values (sub1 x)
                        y
                        (list 'del (- score0 score-del)))]
               [(< score-ins score-match)
                (values x
                        (sub1 y)
                        (list 'ins (- score0 score-ins)))]
               [else
                (values (sub1 x)
                        (sub1 y)
                        (list 'match (- score0 score-match)))]))
           (recur x1 y1 (cons op edit-script))])))

    (define/public (get-score x y)
      (send (get-dp-strategy) get-score this x y))))



