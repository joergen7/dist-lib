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
 racket/math
 paint-lib
 "tree.rkt")

(provide
 tree-image-factory%)

(define tree-image-factory%
  (class* object% (image-factory<%>)
    (super-new)

    (init-field
     tree
     [draw-labels #t]
     [width       18])

    (define factor
      (/ width (tree-depth tree)))

    (define/public (get-image)
      (apply make-image (get-path-list (make-path) tree)))

    (define/private (get-path-list path tree)
      (cond
        [(string? tree)
         (list
          (with-path ((send path hatch))
            (label
             (if draw-labels
                 tree
                 "")
             1)))]
        [else
         (define lhs
           (list-ref tree 0))
         (define lhs-depth
           (list-ref tree 1))
         (define lhs-width
           (add1 (tree-level-right lhs)))
         (define rhs
           (list-ref tree 2))
         (define rhs-depth
           (list-ref tree 3))
         (define rhs-width
           (add1 (tree-level-left rhs)))
         (define lhs-stem-path
           (with-path ((send path hatch))
             (turn (* 1/2 pi))
             (forward (* 0.7 lhs-width))
             (turn (* -1/2 pi))
             (forward (* factor lhs-depth))))
         (define lhs-child-path-list
           (get-path-list lhs-stem-path lhs))
         (define rhs-stem-path
           (with-path ((send path hatch))
             (turn (* -1/2 pi))
             (forward (* 0.7 rhs-width))
             (turn (* 1/2 pi))
             (forward (* factor rhs-depth))))
         (define rhs-child-path-list
           (get-path-list rhs-stem-path rhs))
         (append (list lhs-stem-path
                       rhs-stem-path)
                 lhs-child-path-list
                 rhs-child-path-list)]))))

