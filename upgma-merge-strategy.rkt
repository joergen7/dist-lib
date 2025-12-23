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
 "dist-matrix.rkt")

(provide
 upgma-merge-strategy%)

(define upgma-merge-strategy%
  (class* object% (merge-strategy<%>)
    (super-new)

    (define/public (get-elem-dist parent merge-pair b)
      (define dist1
        (send parent get-elem-dist (car merge-pair) b))
      (define dist2
        (send parent get-elem-dist (cdr merge-pair) b))
      (define count1
        (send parent get-leaf-count (car merge-pair)))
      (define count2
        (send parent get-leaf-count (cdr merge-pair)))
      (define count3
        (send parent get-leaf-count b))
      (define raw-dist1
        (* count1 count3 dist1))
      (define raw-dist2
        (* count2 count3 dist2))
      (define count4
        (* (+ count1 count2) count3))
      (/ (+ raw-dist1 raw-dist2) count4))))
      
