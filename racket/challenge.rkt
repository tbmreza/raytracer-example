#lang racket

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

(module+ test (require rackunit)
  ; Scenario: A tuple with w=1.0 is a point
  (check-true (point? (tuple 4.3 -4.2 3.1 1.0)))
  (check-false (vec? (tuple 4.3 -4.2 3.1 1.0)))

  ; Scenario: A tuple with w=0 is a vector
  (check-false (point? (tuple 4.3 -4.2 3.1 0.0)))
  (check-true (vec? (tuple 4.3 -4.2 3.1 0.0)))

  ; Scenario: Adding two tuples
  (check-equal? (add (tuple 3 -2 5 1) (tuple -2 3 1 0))
                (tuple 1 1 6 1))

  ; Scenario: Subtracting two points
  (check-equal? (sub (point 3 2 1) (point 5 6 7))
                (vec -2 -4 -6))

  ; Scenario: Negating a tuple
  (check-equal? (neg (tuple 1 -2 3 -4))
                (tuple -1 2 -3 4))

  ; Scenario: Multiplying a tuple by a scalar
  (check-equal? (mul (tuple 1 -2 3 -4) 3.5)
                (tuple 3.5 -7.0 10.5 -14.0))

  ; Scenario: Computing the magnitude of vector
  (check-equal? (mag (vec 0 1 0))
                1.0)

  ; Scenario: The cross product of two vectors
  (define a (vec 1 2 3))
  (define b (vec 2 3 4))
  (check-equal? (cross a b)
                (vec -1 2 -1))
  (check-equal? (cross b a)
                (vec 1 -2 1))

  ; Scenario: Colors are (red, green, blue) tuples
  (check-equal? (color-red (color -0.5 0.4 1.7))
                -0.5)
  (check-equal? (color-green (color -0.5 0.4 1.7))
                0.4)

  ; Scenario: Multiplying a color by a scalar
  (check-equal? (mul (color 0.2 0.3 0.4) 2)
                (color 0.4 0.6 0.8))

  ; Scenario: Multiplying colors
  (check-equal? (product (color 1. 0.2 0.4) (color 0.9 1. 1.))  ; ?? 0.4 * 0.1 ieee bug
                (color 0.9 0.2 0.4))
  )
