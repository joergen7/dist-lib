#lang racket/base

(require
 racket/class
 racket/set
 racket/string
 "dist-matrix.rkt")

(provide
 abstract-dist-matrix%
 merge-dist-matrix%)

(define abstract-dist-matrix%
  (class* object% (dist-matrix<%>)
    (super-new)

    (abstract
     get-depth
     get-elem-dist
     get-elem-set
     get-leaf-count
     get-max-dist
     get-merge-strategy
     get-elem-tree)

    (define/public (get-elem-count)
      (set-count (get-elem-set)))

    (define/public (get-min-pair)
      (define pair-list
        (get-pair-list))
      (define pair0
        (car pair-list))
      (define dist0
        (get-elem-dist (car pair0) (cdr pair0)))
      (define-values (opt-pair _)
        (for/fold ([opt-pair pair0]
                   [opt-dist dist0])
                  ([pair (in-list (cdr pair-list))])
          (define dist
            (get-elem-dist (car pair) (cdr pair)))
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

    (define/public (get-tree)
      (define result
        (reduce))
      (define root
        (car (set->list (send result get-elem-set))))
      (send result get-elem-tree root))
    
    (define/private (get-pair-list)
      (let recur ([l (set->list (get-elem-set))])
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
            (recur l1))])))))

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
         (* 0.5 (send parent get-elem-dist (car merge-pair) (cdr merge-pair)))]
        [else
         (send parent get-depth a)]))

    (define/override (get-elem-dist a b)
      (cond
        [(equal? a b)
         0.0]
        [(equal? b merge-name)
         (get-elem-dist b a)]
        [(equal? a merge-name)
         (send (get-merge-strategy) get-dist parent merge-pair b)]
        [else
         (send parent get-elem-dist a b)]))

    (define/override (get-elem-set)
      (for/set ([x (in-set (send parent get-elem-set))])
        (cond
          [(equal? x (car merge-pair))
           merge-name]
          [(equal? x (cdr merge-pair))
           merge-name]
          [else
           x])))

    (define/override (get-leaf-count a)
      (cond
        [(equal? a merge-name)
         (+ (send parent get-leaf-count (car merge-pair))
            (send parent get-leaf-count (cdr merge-pair)))]
        [else
         (send parent get-leaf-count a)]))

    (define/override (get-max-dist)
      (send parent get-max-dist))

    (define/override (get-merge-strategy)
      (send parent get-merge-strategy))

    (define/override (get-elem-tree a)
      (cond
        [(equal? a merge-name)
         (define d
           (send parent get-elem-dist (car merge-pair) (cdr merge-pair)))
         (list (send parent get-elem-tree (car merge-pair))
               (- (* 0.5 d) (send parent get-depth (car merge-pair)))
               (send parent get-elem-tree (cdr merge-pair))
               (- (* 0.5 d) (send parent get-depth (cdr merge-pair))))]
        [else
         (send parent get-elem-tree a)]))))

