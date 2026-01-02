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
 racket/bool
 racket/flonum
 "dp-strategy.rkt")

(provide
 levenshtein-dp-strategy%)

(define levenshtein-dp-strategy%
  (class* object% (dp-strategy<%>)
    (super-new)

    (init-field
     [delta-ins   1.0]
     [delta-del   1.0]
     [delta-match 1.0])

    (define/public (get-score length-a length-b prev-del-score prev-ins-score prev-match-score mtch)
      (cond
        [(and (false? prev-del-score)
              (false? prev-ins-score))
         0.0]
        [(false? prev-del-score) ; x was zero
         (fl+ prev-ins-score delta-ins)]
        [(false? prev-ins-score) ; y was zero
         (fl+ prev-del-score delta-del)]
        [else
         (define score-del
           (fl+ prev-del-score
                delta-del))
         (define score-ins
           (fl+ prev-ins-score
                delta-ins))
         (define score-match
           (fl+ prev-match-score
                (if mtch
                    0.0
                    delta-match)))
         (min score-del score-ins score-match)]))))
