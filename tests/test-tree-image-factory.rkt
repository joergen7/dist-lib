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
   paint-lib
   "../tree-image-factory.rkt")

  (define tree
    '((("example a" 8.5 "example b" 8.5) 2.5 "example e" 11.0) 6.5 ("example c" 14.0 "example d" 14.0) 3.5))

  (define image-factory
    (new tree-image-factory%
         [tree tree]))

  (define image
    (send image-factory get-image))

  (get-bitmap image 400))
