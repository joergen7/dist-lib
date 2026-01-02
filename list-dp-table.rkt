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
 "abstract-dp-table.rkt"
 "lcs-dp-strategy.rkt")

(provide
 list-dp-table%)

(define list-dp-table%
  (class abstract-dp-table%
    (super-new)

    (init-field
     a
     b
     [dp-strategy (new lcs-dp-strategy%)])

    (define/override (get-dp-strategy)
      dp-strategy)

    (define/override (get-length-a)
      (length a))

    (define/override (get-length-b)
      (length b))

    (define/override (match? x y)
      (equal? (list-ref a x)
              (list-ref b y)))))

