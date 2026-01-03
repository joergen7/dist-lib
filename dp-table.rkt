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
 racket/math
 racket/contract
 racket/flonum
 racket/stream
 "distance.rkt"
 "edit-script.rkt"
 "dp-strategy.rkt"
 "lcs-dp-strategy.rkt")

(provide
 (struct-out dp-table)
 dp-table-get-score
 dp-table-dist
 dp-table-edit-script
 make-dp-table
 make-dp-table/string
 make-dp-table/stream
 make-dp-table/list)

(struct dp-table
  (length-a
   length-b
   score-table))

(define/contract (dp-table-get-score t x y)
  (-> dp-table? natural? natural? distance?)
  (hash-ref (dp-table-score-table t)
            (cons x y)))

(define/contract (dp-table-dist t)
  (-> dp-table? distance?)
  (dp-table-get-score
   t
   (dp-table-length-a t)
   (dp-table-length-b t)))


(define/contract (dp-table-edit-script t)
  (-> dp-table? edit-script?)
  (let recur ([x           (dp-table-length-a t)]
              [y           (dp-table-length-b t)]
              [edit-script '()])
    (define score0
      (dp-table-get-score t x y))
    (cond
      [(and (zero? x)
            (zero? y))
       edit-script]
      [(zero? y)
       (define score-del
         (dp-table-get-score t (sub1 x) y))
       (define op
         (list 'del (fl- score0 score-del)))
       (recur (sub1 x) y (cons op edit-script))]
      [(zero? x)
       (define score-ins
         (dp-table-get-score t x (sub1 y)))
       (define op
         (list 'ins (fl- score0 score-ins)))
       (recur x (sub1 y) (cons op edit-script))]
      [else
       (define score-del
         (dp-table-get-score t (sub1 x) y))
       (define score-ins
         (dp-table-get-score t x (sub1 y)))
       (define score-match
         (dp-table-get-score t (sub1 x) (sub1 y)))
       (define-values (x1 y1 op)
         (cond
           [(and (< score-del score-ins)
                 (< score-del score-match))
            (values (sub1 x)
                    y
                    (list 'del (fl- score0 score-del)))]
           [(< score-ins score-match)
            (values x
                    (sub1 y)
                    (list 'ins (fl- score0 score-ins)))]
           [else
            (values (sub1 x)
                    (sub1 y)
                    (list 'match (fl- score0 score-match)))]))
       (recur x1 y1 (cons op edit-script))])))

(define/contract (make-dp-table a b len ref eq dp-strategy)
  (-> any/c
      any/c
      (-> any/c natural?)
      (-> any/c natural? any/c)
      (-> any/c any/c boolean?)
      dp-strategy/c
      dp-table?)
  (define length-a
    (len a))
  (define length-b
    (len b))
  (define score-table
    (let outer ([score-table (hash)]
                [y-list      (build-list
                              (add1 length-b)
                              (lambda (i) i))])
      (cond
        [(null? y-list)
         score-table]
        [else
         (define score-table1
           (let inner ([score-table      score-table]
                       [y                (car y-list)]
                       [x-list           (build-list
                                          (add1 length-a)
                                          (lambda (i) i))]
                       [prev-del-score    #f])
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
                       (eq (ref a (sub1 x))
                           (ref b (sub1 y)))))
                (define score
                  (dp-strategy
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
  
  (dp-table
   length-a
   length-b
   score-table))

(define/contract (make-dp-table/string a b #:eq [eq eq?] #:dp-strategy [dp-strategy (lcs-dp-strategy)])
  (->* (string?
        string?)
       (#:eq          (-> any/c any/c boolean?)
        #:dp-strategy dp-strategy/c)
       dp-table?)
  (make-dp-table
   a
   b
   string-length
   string-ref
   eq?
   dp-strategy))

(define/contract (make-dp-table/stream a b #:eq [eq equal?] #:dp-strategy [dp-strategy (lcs-dp-strategy)])
  (->* ((stream/c any/c)
        (stream/c any/c))
       (#:eq          (-> any/c any/c boolean?)
        #:dp-strategy dp-strategy/c)
       dp-table?)
  (make-dp-table
   a
   b
   stream-length
   stream-ref
   eq
   dp-strategy))

(define/contract (make-dp-table/list a b #:eq [eq equal?] #:dp-strategy [dp-strategy (lcs-dp-strategy)])
  (->* ((listof any/c)
        (listof any/c))
       (#:eq          (-> any/c any/c boolean?)
        #:dp-strategy dp-strategy/c)
       dp-table?)
  (make-dp-table
   a
   b
   length
   list-ref
   eq
   dp-strategy))
