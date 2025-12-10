#lang racket/base

(require
 racket/contract)

(provide
 distance?)

(define distance?
  (and/c (not/c negative?)
         inexact?
         rational?))

