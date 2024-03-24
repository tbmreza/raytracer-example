use std::ops::{Add, Sub};

#[derive(Default)]
struct Tuple(f64, f64, f64, f64);

trait Point {
    fn is_point(&self) -> bool;
}
trait Vector {
    fn is_vector(&self) -> bool;
}
impl Point for Tuple {
    fn is_point(&self) -> bool {
        self.3 == 1.0
    }
}
impl Vector for Tuple {
    fn is_vector(&self) -> bool {
        self.3 == 0.0
    }
}

impl Add for Tuple {
    type Output = Self;
    fn add(self, rhs: Self) -> Self::Output {
        Tuple(self.0 + rhs.0, self.1 + rhs.1, self.2 + rhs.2, self.3 + rhs.3)
    }
}

fn main() {
    let res = Tuple::default() + Tuple::default();
}

// (module+ test (require rackunit)
//   ; Scenario: A tuple with w=1.0 is a point
//   (check-true (point? (tuple 4.3 -4.2 3.1 1.0)))
//   (check-false (vec? (tuple 4.3 -4.2 3.1 1.0)))
//
//   ; Scenario: A tuple with w=0 is a vector
//   (check-false (point? (tuple 4.3 -4.2 3.1 0.0)))
//   (check-true (vec? (tuple 4.3 -4.2 3.1 0.0)))
//
//   ; Scenario: Adding two tuples
//   (check-equal? (add (tuple 3 -2 5 1) (tuple -2 3 1 0))
//                 (tuple 1 1 6 1))
//
//   ; Scenario: Subtracting two points
//   (check-equal? (sub (point 3 2 1) (point 5 6 7))
//                 (vec -2 -4 -6))
//
//   ; Scenario: Negating a tuple
//   (check-equal? (neg (tuple 1 -2 3 -4))
//                 (tuple -1 2 -3 4))
//
//   ; Scenario: Multiplying a tuple by a scalar
//   (check-equal? (mul (tuple 1 -2 3 -4) 3.5)
//                 (tuple 3.5 -7.0 10.5 -14.0))
//
//   ; Scenario: Computing the magnitude of vector
//   (check-equal? (mag (vec 0 1 0))
//                 1.0)
//
//   ; Scenario: The cross product of two vectors
//   (define a (vec 1 2 3))
//   (define b (vec 2 3 4))
//   (check-equal? (cross a b)
//                 (vec -1 2 -1))
//   (check-equal? (cross b a)
//                 (vec 1 -2 1))
//
//   ; Scenario: Colors are (red, green, blue) tuples
//   (check-equal? (color-red (color -0.5 0.4 1.7))
//                 -0.5)
//   (check-equal? (color-green (color -0.5 0.4 1.7))
//                 0.4)
//
//   ; Scenario: Multiplying a color by a scalar
//   (check-equal? (mul (color 0.2 0.3 0.4) 2)
//                 (color 0.4 0.6 0.8))
//
//   ; Scenario: Multiplying colors
//   (check-equal? (product (color 1. 0.2 0.4) (color 0.9 1. 1.))  ; ?? 0.4 * 0.1 ieee bug
//                 (color 0.9 0.2 0.4))
//   )
