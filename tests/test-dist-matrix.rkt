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
   racket/set
   rackunit
   "../hash-dist-matrix.rkt")

  (let ([dm (new hash-dist-matrix%
                 [dist-table (hash
                              (cons "a" "b") 1.0
                              (cons "a" "c") 2.0
                              (cons "b" "c") 1.0)])])
    
    (check-equal? (send dm get-elem-set)
                  (set "a" "b" "c"))
    (define dm1
      (send dm filter (lambda (x) (set-member? (set "a" "b") x))))

    (check-equal? (send dm1 get-elem-set)
                  (set "a" "b"))

    (check-equal? (send dm1 get-elem-dist "a" "b")
                  1.0)))
    
    
