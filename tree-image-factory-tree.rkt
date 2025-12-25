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
 "abstract-tree-image-factory.rkt")

(provide
 tree-image-factory/tree%)

(define tree-image-factory/tree%
  (class abstract-tree-image-factory%
    (super-new)

    (inherit
     label-path
     get-depth-factor
     get-tree)

    (init-field
     [phi1  0.6]
     [phi2  -0.2])

    (define/override (get-image)
      (apply make-image (get-path-list (make-path) (get-tree))))

    (define/private (get-main-path-list tree)
      (cond
        [(string? tree)
         (list
          (label-path (make-path) tree))]
        [else
         (define lhs
           (list-ref tree 0))
         (define lhs-depth
           (list-ref tree 1))
         (define rhs
           (list-ref tree 2))
         (define rhs-depth
           (list-ref tree 3))
         (define path1
           (with-path ()
             (forward
              (* (get-depth-factor)
                 rhs-depth))))
         (define path2
           (with-path ()
             (turn pi)
             (forward
              (* (get-depth-factor)
                 lhs-depth))))
         (append
          (list path1
                path2)
          (get-path-list path1 lhs)
          (get-path-list path2 rhs))]))

    (define/private (get-path-list path tree)
      (cond
        [(string? tree)
         (list
          (label-path path tree))]
        [else
         (define lhs
           (list-ref tree 0))
         (define lhs-depth
           (list-ref tree 1))
         (define rhs
           (list-ref tree 2))
         (define rhs-depth
           (list-ref tree 3))
         (define path1
           (with-path ((hatch path))
             (turn phi1)
             (forward
              (* (get-depth-factor)
                 lhs-depth))))
         (define path2
           (with-path ((hatch path))
             (turn phi2)
             (forward
              (* (get-depth-factor)
                 rhs-depth))))
         (append
          (list path1
                path2)
          (get-path-list path1 lhs)
          (get-path-list path2 rhs))]))))
         
             
             
