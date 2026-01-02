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
 "dp-table-factory.rkt"
 "lcs-dp-strategy.rkt"
 "simple-dp-table.rkt")

(provide
 abstract-dp-table-factory%)

(define abstract-dp-table-factory%
  (class* object% (dp-table-factory<%>)
    (super-new)

    (init-field
     [dp-strategy (new lcs-dp-strategy%)])

    (abstract
     get-length-a
     get-length-b
     match?)

    (define/public (get-dp-table)

      (define length-a
        (get-length-a))

      (define length-b
        (get-length-b))

      (define score-table
        (let outer ([score-table (hash)]
                    [y-list      (build-list
                                  (add1 (get-length-b))
                                  (lambda (i) i))])
          (cond
            [(null? y-list)
             score-table]
            [else
             (define score-table1
               (let inner ([score-table      score-table]
                           [y                (car y-list)]
                           [x-list           (build-list
                                              (add1 (get-length-a))
                                              (lambda (i) i))]
                           [prev-del-score    #f]
                           )
                 (cond
                   [(null? x-list)
                    score-table]
                   [else
                    (define x
                      (car x-list))
                    (define prev-ins-score
                      (if (zero? y)
                          #f
                          (hash-ref score-table
                                    (cons x (sub1 y)))))
                    (define prev-match-score
                      (if (or (zero? x)
                              (zero? y))
                          #f
                          (hash-ref score-table
                                    (cons (sub1 x) (sub1 y)))))
                    (define mtch
                      (and prev-match-score
                           (match? (sub1 x) (sub1 y))))
                    (define score
                      (send dp-strategy
                            get-score
                            length-a
                            length-b
                            prev-del-score
                            prev-ins-score
                            prev-match-score
                            mtch))
                    (define score-table1
                      (hash-set score-table
                                (cons x y)
                                score))
                    (inner score-table1
                           y
                           (cdr x-list)
                           score)])))
             (outer score-table1 (cdr y-list))])))
      
      (new simple-dp-table%
           [length-a    length-a]
           [length-b    length-b]
           [score-table score-table]))))
