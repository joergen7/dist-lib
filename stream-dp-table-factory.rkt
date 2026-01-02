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
 racket/stream
 "abstract-dp-table-factory.rkt")

(provide
 stream-dp-table-factory%)

(define stream-dp-table-factory%
  (class abstract-dp-table-factory%
    (super-new)

    (init-field
     a
     b
     [eq equal?])

    (define/override (get-length-a)
      (stream-length a))

    (define/override (get-length-b)
      (stream-length b))

    (define/override (match? x y)
      (eq (stream-ref a x)
          (stream-ref b y)))))

