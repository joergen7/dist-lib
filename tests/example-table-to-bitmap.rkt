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
   racket/class
   rackunit
   "../table-dist-matrix-factory.rkt"
   "../string-dp-table.rkt"
   "../tree-image-factory-radial.rkt"
   "../lcs-dp-strategy.rkt")

  (define table
    (hash "abba" "abba"
          "anna" "anna"
          "otto" "otto"
          "karo" "karo"
          "mama" "mama"
          "oma"  "oma"
          "baba" "baba"
          "yeye" "yeye"
          "gugu" "gugu"))

  (define dist-matrix-factory
    (new (table-dist-matrix-factory% string-dp-table%)
         [table table]
         [dp-strategy (new lcs-dp-strategy%)]))

  (define dist-matrix
    (send dist-matrix-factory
          get-dist-matrix))

  (define tree
    (send dist-matrix
          get-tree))

  (define image-factory
    (new tree-image-factory/radial%
         [tree tree]))

  (define image
    (send image-factory
          get-image))

  (send image
        get-bitmap 400))
         
    
