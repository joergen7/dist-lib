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
   "test-util.rkt"
   "../levenshtein-dp-strategy.rkt")

  (define check-dist
    (make-check-dist
     (levenshtein-dp-strategy)))
    

  (check-dist "" "" 0.0)
  (check-dist "" "a" 1.0)
  (check-dist "a" "a" 0.0)
  (check-dist "a" "b" 1.0)
  (check-dist "a" "" 1.0)
  (check-dist "a" "ab" 1.0)
  (check-dist "a" "ba" 1.0)
  (check-dist "ab" "ab" 0.0)
  (check-dist "ab" "ac" 1.0)
  (check-dist "ab" "cb" 1.0)
  (check-dist "ab" "abc" 1.0)
  (check-dist "ab" "acb" 1.0)
  (check-dist "ab" "cab" 1.0)

  (check-dist "abba" "anna" 2.0)
  (check-dist "abba" "otto" 4.0)
  (check-dist "abba" "karo" 4.0)
  (check-dist "abba" "mama" 3.0)
  (check-dist "abba" "oma" 3.0)
  (check-dist "abba" "baba" 2.0)
  (check-dist "abba" "yeye" 4.0)
  (check-dist "abba" "gugu" 4.0)
  (check-dist "anna" "otto" 4.0)
  (check-dist "anna" "karo" 4.0)
  (check-dist "anna" "mama" 3.0)
  (check-dist "anna" "oma" 3.0)
  (check-dist "anna" "baba" 3.0)
  (check-dist "anna" "yeye" 4.0)
  (check-dist "anna" "gugu" 4.0)
  (check-dist "otto" "karo" 3.0)
  (check-dist "otto" "mama" 4.0)
  (check-dist "otto" "oma" 3.0)
  (check-dist "otto" "baba" 4.0)
  (check-dist "otto" "yeye" 4.0)
  (check-dist "otto" "gugu" 4.0)
  (check-dist "karo" "mama" 3.0)
  (check-dist "karo" "oma" 4.0)
  (check-dist "karo" "baba" 3.0)
  (check-dist "karo" "yeye" 4.0)
  (check-dist "karo" "gugu" 4.0)
  (check-dist "mama" "oma" 2.0)
  (check-dist "mama" "baba" 2.0)
  (check-dist "mama" "yeye" 4.0)
  (check-dist "mama" "gugu" 4.0)
  (check-dist "oma" "baba" 3.0)
  (check-dist "oma" "yeye" 4.0)
  (check-dist "oma" "gugu" 4.0)
  (check-dist "baba" "yeye" 4.0)
  (check-dist "baba" "gugu" 4.0)
  (check-dist "yeye" "gugu" 4.0)
  )
