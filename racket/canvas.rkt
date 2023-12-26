#lang racket

(require math/array)

;; mod types  ??
(require racket/generic)

(define-generics self
  [point?  self]
  [vec?    self]
  [neg     self]
  [mag     self]

  [mul  self scalar]

  [cross    self rhs]
  [add      self rhs]
  [sub      self rhs]
  [product  self rhs])

(struct tuple [x y z w]
  #:transparent
  #:methods gen:self
  [(define (add self rhs)
     (tuple (+ (tuple-x self) (tuple-x rhs))
            (+ (tuple-y self) (tuple-y rhs))
            (+ (tuple-z self) (tuple-z rhs))
            (+ (tuple-w self) (tuple-w rhs))))
   (define (sub self rhs)
     (tuple (- (tuple-x self) (tuple-x rhs))
            (- (tuple-y self) (tuple-y rhs))
            (- (tuple-z self) (tuple-z rhs))
            (- (tuple-w self) (tuple-w rhs))))
   (define (cross self rhs)
     (vec (- (* (tuple-y self) (tuple-z rhs)) (* (tuple-z self) (tuple-y rhs)))
          (- (* (tuple-z self) (tuple-x rhs)) (* (tuple-x self) (tuple-z rhs)))
          (- (* (tuple-x self) (tuple-y rhs)) (* (tuple-y self) (tuple-x rhs)))))
   (define (product self rhs)  ; ?? contract color
     (color (* (color-red self) (color-red rhs))
            (* (color-green self) (color-green rhs))
            (* (color-blue self) (color-blue rhs))))

   (define (mul self scalar)
     (tuple (* scalar (tuple-x self))
            (* scalar (tuple-y self))
            (* scalar (tuple-z self))
            (* scalar (tuple-w self))))

   (define (neg self)
     (tuple (- (tuple-x self))
            (- (tuple-y self))
            (- (tuple-z self))
            (- (tuple-w self))))

   (define (mag self)  ; ?? contract vec?. mag :: vec -> number
     (sqrt (+ (tuple-x self)(tuple-y self)(tuple-z self)(tuple-w self))))

   (define (point? self)
     (equal? 1.0 (tuple-w self)))

   (define (vec? self)
     (equal? 0.0 (tuple-w self)))

   ])

(define (point x y z)
  (tuple x y z 1.0))
(define (vec x y z)
  (tuple x y z 0.0))
(define color vec)
(define color-red tuple-x)
(define color-green tuple-y)
(define color-blue tuple-z)
;; types mod

(define (pixel-at self ij)
  (array-ref self ij))

(define ppm-header #<<unnamed
P3
5 3
255
unnamed
  )

;; (define (write-pixel! c ij pixel-color)
;;   (array-set! c ij pixel-color))
(define write-pixel! array-set!)

(define/contract (canvas->ppm c) (-> any/c string?)
  "a")

(define c1 (make-array (vector 2) (color 0. 0. 0.)))
;; (map c1 color->rgb-string) ??

(module+ test (require rackunit)
  ;; Scenario: Creating a canvas
  (define c (make-array (vector 10 20) (color 0. 0. 0.)))
  (check-true
    (match (array-shape c) ['#(10 20)  #true]))
  (check-equal? (pixel-at c #(3 2)) (color 0. 0. 0.))

  ;; Scenario: Writing pixels to a canvas
  (define red (color 1. 0. 0.))
  (define mut-c (array->mutable-array c))
  (write-pixel! mut-c #(3 2) red)
  (check-equal? (pixel-at mut-c #(3 2)) red)

  ;; Scenario: Constructing the PPM header
  ;; (check-equal? ppm-header (head-3 (canvas->ppm c)))  ??

  ;; Scenario: Constructing the PPM pixel data
  (define cc (make-array (vector 2 3) (color 0. 0. 0.)))
  (define zero-15x "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0")
  )
