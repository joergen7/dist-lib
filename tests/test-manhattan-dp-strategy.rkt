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
   "test-util.rkt"
   "../manhattan-dp-strategy.rkt")

  (define check-dist
    (make-check-dist (new manhattan-dp-strategy%)))

  
  (check-dist "" "" 0.0)
  (check-dist "a" "a" 0.0)
  (check-dist "a" "b" 1.0)
  (check-dist "ab" "ab" 0.0)
  (check-dist "ab" "ac" 1.0)
  (check-dist "ab" "cb" 1.0)
  (check-dist "ab" "cc" 2.0)
  
  (check-dist "abc" "abc" 0.0)
  (check-dist "0abc" "abc" 1.0)
  (check-dist "00abc" "abc" 2.0)
  (check-dist "abc0" "abc" 1.0)
  (check-dist "abc00" "abc" 2.0)
  (check-dist "abc" "0abc" 1.0)
  (check-dist "abc" "00abc" 2.0)
  (check-dist "abc" "abc0" 1.0)
  (check-dist "abc" "abc00" 2.0)

  (check-dist "abc" "abx" 1.0)
  (check-dist "abc" "axc" 1.0)
  (check-dist "abc" "xbc" 1.0)
  (check-dist "abc" "axx" 2.0)
  (check-dist "abc" "xbx" 2.0)
  (check-dist "abc" "xxc" 2.0)
  (check-dist "abc" "xxx" 3.0)
  (check-dist "0abc" "abx" 2.0)
  (check-dist "0abc" "axc" 2.0)
  (check-dist "0abc" "xbc" 2.0)
  (check-dist "0abc" "axx" 3.0)
  (check-dist "0abc" "xbx" 3.0)
  (check-dist "0abc" "xxc" 3.0)
  (check-dist "0abc" "xxx" 4.0)
  (check-dist "abc0" "abx" 2.0)
  (check-dist "abc0" "axc" 2.0)
  (check-dist "abc0" "xbc" 2.0)
  (check-dist "abc0" "axx" 3.0)
  (check-dist "abc0" "xbx" 3.0)
  (check-dist "abc0" "xxc" 3.0)
  (check-dist "abc0" "xxx" 4.0)

  (check-dist "abc" "0abx" 2.0)
  (check-dist "abc" "0axc" 2.0)
  (check-dist "abc" "0xbc" 2.0)
  (check-dist "abc" "0axx" 3.0)
  (check-dist "abc" "0xbx" 3.0)
  (check-dist "abc" "0xxc" 3.0)
  (check-dist "abc" "0xxx" 4.0)

  (check-dist "abc" "abx0" 2.0)
  (check-dist "abc" "axc0" 2.0)
  (check-dist "abc" "xbc0" 2.0)
  (check-dist "abc" "axx0" 3.0)
  (check-dist "abc" "xbx0" 3.0)
  (check-dist "abc" "xxc0" 3.0)
  (check-dist "abc" "xxx0" 4.0)


  )
