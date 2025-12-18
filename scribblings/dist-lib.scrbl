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

#lang scribble/manual
@require[@for-label[racket/base
		    racket/class
		    racket/math
		    paint-lib
		    dist-lib]]

@title{dist-lib}
@author{Jörgen Brandt}

@defmodule[dist-lib]

@racket[dist-lib] is a library for distance-related algorithms.

@table-of-contents{}

@section{Distances}

@defproc[(distance? [x any/c]) boolean?]{
  A distance is a non-negative, inexact rational number. This predicate returns @racket[#t] exactly if all three criteria are fulfilled.
}

@section{Hierarchical clustering}

A @link["https://en.wikipedia.org/wiki/Hierarchical_clustering"]{hierarchical clustering} consumes a distance matrix and produces a dendogram tree. Such trees can then be visualized as a bitmap.

@subsection{Dendogram Trees}

The end result of a hierarchical clustering is a dendogram tree.

@defthing[tree/c contract?]{
  A tree is the racket representation of a dendrogram representing a hierarchical clustering.
}

@defproc[(tree-elem-list [tree tree/c]) (listof string?)]{
  Return the tree's leaf labels in a list.
}

@defproc[(tree-elem-count [tree tree/c]) natural?]{
  Return the number of leaves in the tree.
}

@defproc[(tree-depth [tree tree/c]) distance?]{
  Return the depth of the tree, i.e., the distance covered, walking from the root to any leaf.
}

@defproc[(tree-level-left [tree tree/c]) natural?]{
  Return the number of branches traversed if always turning left.
}

@defproc[(tree-level-right [tree tree/c]) natural?]{
  Return the number of branches traversed if always turning right.
}

@defproc[(tree-equal? [tree tree/c]) boolean?]{
  Predicate comparing two trees. Two trees are equal if they have the same structure, the same leaf labels, and the same depth annotation. Left and right subtrees are interchangeable.
}

@defclass[tree-image-factory/table% abstract-tree-image-factory% ()]{
  @defconstructor[([tree tree/c] [draw-labels boolean? #t] [depth natural? 10])]{
    Construct an instance of @racket[image-factory<%>] from a dendogram tree to be plotted in table form. If @racket[draw-labels] is @racket[#t] then labels are drawn on the leaves of the tree. The drawing algorithm normalizes the tree's depth to the value of @racket[depth].
  }

  @defmethod[(get-image) (is-a?/c image<%>)]{
    Return the image constructed from the dendogram tree.
  }
}

@defclass[tree-image-factory/tree% abstract-tree-image-factory% ()]{
  @defconstructor[([tree tree/c] [draw-labels boolean? #t] [depth natural? 10])]{
    Construct an instance of @racket[image-factory<%>] from a dendogram tree to be plotted in tree form. If @racket[draw-labels] is @racket[#t] then labels are drawn on the leaves of the tree. The drawing algorithm normalizes the tree's depth to the value of @racket[depth].
  }

  @defmethod[(get-image) (is-a?/c image<%>)]{
    Return the image constructed from the dendogram tree.
  }
}
@subsection{Distance Matrices}

The starting point of a hierarchical clustering is a distance matrix represented in form of a @racket[dist-matrix<%>] instance.

@definterface[dist-matrix<%> ()]{
  Interface representing distance matrix objects.

  @defmethod[(get-depth [a string?]) distance?]{
    Returns the distance of a given entry @racket[a] from the leaf layer of the clustering.
  }

  @defmethod[(get-elem-count) natural?]{
    Returns the number of entries at the current layer of the clustering.
  }

  @defmethod[(get-elem-dist [a string?] [b string?]) distance?]{
    Returns the distance between the entries labeled @racket[a] and @racket[b] at the current layer of the clustering.
  }

  @defmethod[(get-elem-set) (set/c string?)]{
    Returns the labels of all entries at the current layer of the clustering.
  }
}

@section{Edit distance}

@link["https://en.wikipedia.org/wiki/Edit_distance"]{Edit distance}