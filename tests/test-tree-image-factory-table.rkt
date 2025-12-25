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

(module+ test

  (require
   rackunit
   "test-util.rkt"
   "../tree-image-factory-table.rkt")

  (define tree-display
    (make-tree-display tree-image-factory/table%))

  (let ([tree "a"])
    (tree-display tree))

  (let ([tree '("a" 2 "b" 2)])
    (tree-display tree))

  (let ([tree '(("a" 2 "b" 2) 1 "c" 3)])
    (tree-display tree))

  (let ([tree '(("a" 2 "b" 2) 1 ("c" 2 "d" 2) 1)])
    (tree-display tree))

  (let ([tree '(("a" 2 "b" 2) 1 (("c" 1 "d" 1) 1 "e" 2) 1)])
    (tree-display tree))

  (let ([tree '((("example a" 8.5 "example b" 8.5) 2.5 "example e" 11.0) 6.5 ("example c" 14.0 "example d" 14.0) 3.5)])
    (tree-display tree))


  )
