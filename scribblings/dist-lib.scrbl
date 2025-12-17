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
@require[@for-label[dist-lib
                    racket/base
		    racket/math]]

@title{dist-lib}
@author{Jörgen Brandt}

@defmodule[dist-lib]

@racket[dist-lib] is a library for distance-related algorithms.

@table-of-contents{}

@section{Data Types}

@defproc[(distance? [x any/c]) boolean?]{
  A distance is a non-negative, inexact rational number. This predicate returns @racket[#t] exactly if all three criteria are fulfilled.
}

@defthing[tree/c contract?]{
  A tree is the racket representation of a dendrogram representing a hierarchical clustering.
}

@section{Hierarchical clustering}

A @link["https://en.wikipedia.org/wiki/Hierarchical_clustering"]{hierarchical clustering} consumes a distance matrix and produces a dendogram, i.e., a tree representing the clustering. Such trees can then be visualized as a bitmap. The starting point is a distance matrix represented in form of a @racket[dist-matrix<%>] instance.

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