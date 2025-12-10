#lang racket/base

(require
 racket/class
 racket/contract
 racket/match
 racket/math
 racket/set
 racket/string)

;; distance matrices are reflexive and symmetric

(define distance?
  (and/c (not/c negative?)
         inexact?
         rational?))

(define tree/c
  (recursive-contract
   (or/c string?
         (list/c tree/c rational? tree/c rational?))))

(define merge-strategy<%>
  (interface ()
    [get-dist (recursive-contract (->m (is-a?/c dist-matrix<%>) (cons/c string? string?) string? distance?))]))

(define max-merge-strategy%
  (class* object% (merge-strategy<%>)
    (super-new)

    (define/public (get-dist parent merge-pair b)
      (define leaf
        (send parent get-leaf))
      (define set1
        (set-union (send parent get-leaf-elem-set (car merge-pair))
                   (send parent get-leaf-elem-set (cdr merge-pair))))
      (define set2
        (send parent get-leaf-elem-set b))
      (for/fold ([m1 0.0])
                ([x (in-set set1)])
        (max m1
             (for/fold ([m2 0.0])
                       ([y (in-set set2)])
               (max m2
                    (send leaf get-dist x y))))))))

(define min-merge-strategy%
  (class* object% (merge-strategy<%>)
    (super-new)

    (define/public (get-dist parent merge-pair b)
      (define leaf
        (send parent get-leaf))
      (define set1
        (set-union (send parent get-leaf-elem-set (car merge-pair))
                   (send parent get-leaf-elem-set (cdr merge-pair))))
      (define set2
        (send parent get-leaf-elem-set b))
      (for/fold ([m1 1000000000.0])
                ([x (in-set set1)])
        (min m1
             (for/fold ([m2 1000000000.0])
                       ([y (in-set set2)])
               (min m2
                    (send leaf get-dist x y))))))))

(define upgma-merge-strategy%
  (class* object% (merge-strategy<%>)
    (super-new)

    (define/public (get-dist parent merge-pair b)
      (define leaf
        (send parent get-leaf))
      (define set1
        (set-union (send parent get-leaf-elem-set (car merge-pair))
                   (send parent get-leaf-elem-set (cdr merge-pair))))
      (define set2
        (send parent get-leaf-elem-set b))
      ;; we can safely assume these sets are never empty
      (define v
        (for/sum ([x (in-set set1)])
          (for/sum ([y (in-set set2)])
            (send leaf get-dist x y))))
    
      (/ v
         (exact->inexact
          (* (set-count set1)
             (set-count set2)))))))

(define wpgma-merge-strategy%
  (class* object% (merge-strategy<%>)
    (super-new)

    (define/public (get-dist parent merge-pair b)
      (* 0.5
         (+ (send parent get-dist (car merge-pair) b)
            (send parent get-dist (cdr merge-pair) b))))))


(define dist-matrix<%>
  (interface ()
    [get-depth          (->m string? distance?)]
    [get-dist           (->m string? string? distance?)]
    [get-elem-count     (->m natural?)]
    [get-elem-set       (->m (set/c string?))]
    [get-leaf           (recursive-contract (->m (is-a?/c dist-matrix<%>)))]
    [get-leaf-elem-set  (->m string? (set/c string?))]
    [get-merge-strategy (->m (is-a?/c merge-strategy<%>))]
    [get-min-pair       (->m (cons/c string? string?))]
    [get-tree           (->m string? tree/c)]
    [merge              (recursive-contract (->m string? string? (is-a?/c dist-matrix<%>)))]
    [reduce             (recursive-contract (->m (is-a?/c dist-matrix<%>)))]))

(define abstract-dist-matrix%
  (class* object% (dist-matrix<%>)
    (super-new)

    (abstract
     get-depth
     get-dist
     get-elem-set
     get-leaf
     get-leaf-elem-set
     get-merge-strategy
     get-tree)

    (define/public (get-elem-count)
      (set-count (get-elem-set)))

    (define/public (get-min-pair)
      (define pair-list
        (get-pair-list))
      (define pair0
        (car pair-list))
      (define dist0
        (get-dist (car pair0) (cdr pair0)))
      (define-values (opt-pair _)
        (for/fold ([opt-pair pair0]
                   [opt-dist dist0])
                  ([pair (in-list (cdr pair-list))])
          (define dist
            (get-dist (car pair) (cdr pair)))
          (if (< dist opt-dist)
              (values pair dist)
              (values opt-pair opt-dist))))
      opt-pair)

    (define/public (merge a b)
      (new merge-dist-matrix%
           [parent         this]
           [merge-name     (string-join (list a b) "_")]
           [merge-pair     (cons a b)]))

    (define/public (reduce)
      (cond
        [(> (get-elem-count) 1)
         (define min-pair
           (get-min-pair))
         (send (merge (car min-pair) (cdr min-pair))
               reduce)]
        [else
         this]))

    (define/private (get-pair-list)

      (define (comb l)
        (cond
          [(null? l)
           '()]
          [else
           (define x
             (car l))
           (define l1
             (cdr l))
           (append
            (for/list ([y (in-list l1)])
              (cons x y))
            (comb l1))]))

      (comb (set->list (get-elem-set))))))

(define hash-dist-matrix%
  (class abstract-dist-matrix%
    (super-new)

    (init-field
     dist-table
     merge-strategy)

    (define/override (get-depth a)
      0.0)

    (define/override (get-dist a b)
      (cond
        [(equal? a b)
         0.0]
        [(hash-has-key? dist-table (cons a b))
         (hash-ref dist-table (cons a b))]
        [else
         (hash-ref dist-table (cons b a))]))

    (define/override (get-elem-set)
      (for/fold
          ([result (set)])
          ([pair (in-list (hash-keys dist-table))])
        (match pair
          [(cons a b)
           (set-add (set-add result a) b)])))

    (define/override (get-leaf)
      this)

    (define/override (get-leaf-elem-set a)
      (set a))
    
    (define/override (get-merge-strategy)
      merge-strategy)

    (define/override (get-tree a)
      a)))

(define merge-dist-matrix%
  (class abstract-dist-matrix%

    (super-new)
    
    (init-field
     parent
     merge-name
     merge-pair)

    (define/override (get-depth a)
      (cond
        [(equal? a merge-name)
         (* 0.5 (send parent get-dist (car merge-pair) (cdr merge-pair)))]
        [else
         (send parent get-depth a)]))

    (define/override (get-dist a b)
      (cond
        [(equal? a b)
         0.0]
        [(equal? b merge-name)
         (get-dist b a)]
        [(equal? a merge-name)
         (send (get-merge-strategy) get-dist parent merge-pair b)]
        [else
         (send parent get-dist a b)]))

    (define/override (get-elem-set)
      (for/set ([x (in-set (send parent get-elem-set))])
        (cond
          [(equal? x (car merge-pair))
           merge-name]
          [(equal? x (cdr merge-pair))
           merge-name]
          [else
           x])))

    (define/override (get-leaf)
      (send parent get-leaf))

    (define/override (get-leaf-elem-set a)
      (cond
        [(equal? a merge-name)
         (set-union (send parent get-leaf-elem-set (car merge-pair))
                    (send parent get-leaf-elem-set (cdr merge-pair)))]
        [else
         (send parent get-leaf-elem-set a)]))

    (define/override (get-merge-strategy)
      (send parent get-merge-strategy))

    (define/override (get-tree a)
      (cond
        [(equal? a merge-name)
         (define d
           (send parent get-dist (car merge-pair) (cdr merge-pair)))
         (list (send parent get-tree (car merge-pair))
               (- (* 0.5 d) (send parent get-depth (car merge-pair)))
               (send parent get-tree (cdr merge-pair))
               (- (* 0.5 d) (send parent get-depth (cdr merge-pair))))]
        [else
         (send parent get-tree a)]))))

    
                



;; assume a distance matrix

(define dm1
  (new hash-dist-matrix%
       [dist-table     (hash (cons "a" "b") 17.0
                             (cons "a" "c") 21.0
                             (cons "a" "d") 31.0
                             (cons "a" "e") 23.0
                             (cons "b" "c") 30.0
                             (cons "b" "d") 34.0
                             (cons "b" "e") 21.0
                             (cons "c" "d") 28.0
                             (cons "c" "e") 39.0
                             (cons "d" "e") 43.0)]
       [merge-strategy (new min-merge-strategy%)]))




(define dm2
  (send dm1 merge "a" "b"))

(define dm3
  (send dm2 merge "a_b" "e"))

(define dmr
  (send dm1 reduce))
