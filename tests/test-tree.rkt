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
   "../tree.rkt")

  (let ([tree "a"])
    (check-equal? (tree-elem-list tree)
                  '("a"))
    (check-equal? (tree-elem-count tree)
                  1)
    (check-equal? (tree-depth tree)
                  0.0))

  (let ([tree '(("a" 1.0 "b" 1.0) 2 "c" 3.0)])
    (check-equal? (tree-elem-list tree)
                  '("a" "b" "c"))
    (check-equal? (tree-elem-count tree)
                  3)
    (check-equal? (tree-depth tree)
                  3.0)))


