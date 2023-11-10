#lang racket

(require rackunit)
(require racket/generic)

(define-generics self
  [point?  self]
  [vec?    self]
  [add     self rhs]
  [sub     self rhs])

(struct tuple (x y z w)
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

   (define (point? self)
     (equal? 1.0 (tuple-w self)))

   (define (vec? self)
     (equal? 0.0 (tuple-w self)))

   ])

(define (point x y z)
  (tuple x y z 1.0))
(define (vec x y z)
  (tuple x y z 0.0))

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
