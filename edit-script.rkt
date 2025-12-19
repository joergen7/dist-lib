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
 racket/contract
 racket/math
 "distance.rkt")

(provide
 edit-script?
 edit-script-dist
 edit-script-equal?)

(define edit-script?
  (listof (list/c (symbols 'match 'ins 'del) rational?)))

(define/contract (edit-script-dist edit-script)
  (-> edit-script? distance?)
  (exact->inexact
   (for/sum ([x (in-list edit-script)])
     (cadr x))))

(define/contract (edit-script-equal? a b)
  (-> edit-script? edit-script? boolean?)
  (or
   (and (null? a)
        (null? b))
   (and (not (null? a))
        (not (null? b))
        (let ([head-a (car a)]
              [head-b (car b)])
          (and
           (eq? (list-ref head-a 0)
                (list-ref head-b 0))
           (= (list-ref head-a 1)
              (list-ref head-b 1))
           (edit-script-equal? (cdr a) (cdr b)))))))
