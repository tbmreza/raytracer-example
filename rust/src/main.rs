use std::ops::{Add, Sub, Mul};

#[derive(Default, Debug, PartialEq, Clone)]
struct Tuple(f64, f64, f64, f64);

impl Tuple {
    fn vector(x: f64, y: f64, z: f64) -> Self {
    // ?? fn vector(x: Into<f64>, y: f64, z: f64) -> Self {
        Tuple(x, y, z, 0.0)
    }
    fn dot(&self, rhs: &Tuple) -> f64 {
        self.0 * rhs.0 + self.1 * rhs.1 + self.2 * rhs.2
    }
}

trait Point {
    fn is_point(&self) -> bool;
}

trait Vector {
    fn is_vector(&self) -> bool;
    fn mag(&self) -> f64;
    // fn reflect(&self, rhs: Box<dyn Vector>) -> Self;
    // fn reflect(&self, rhs: impl Vector) -> Self;
    fn reflect(&self, rhs: Tuple) -> Self;
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
    fn mag(&self) -> f64 {
        let sum = self.0 + self.1 + self.2 + self.3;
        sum.sqrt()
    }

    // fn reflect(&self, normal: Tuple + Vector) -> Self {  // ??
    fn reflect(&self, normal: Tuple) -> Self {
        self.clone() - normal.clone() * 2.0 * self.dot(&normal)
    }

}

// fn reflect(incoming: Vector, rhs: Vector) -> Vector {
//     unimplemented!()
// }

impl Add for Tuple {
    type Output = Self;
    fn add(self, rhs: Self) -> Self::Output {
        Tuple(self.0 + rhs.0, self.1 + rhs.1, self.2 + rhs.2, self.3 + rhs.3)
    }
}

impl Sub for Tuple {
    type Output = Self;
    fn sub(self, rhs: Self) -> Self::Output {
        Tuple(self.0 - rhs.0, self.1 - rhs.1, self.2 - rhs.2, self.3 - rhs.3)
    }
}

impl Mul<f64> for Tuple {
    type Output = Self;
    fn mul(self, rhs: f64) -> Self::Output {
        Tuple(self.0 * rhs, self.1 * rhs, self.2 * rhs, self.3 * rhs)
    }
}

#[cfg(test)]
mod tests {
    use crate::*;

    #[test]
    fn point_tuple() {
        let w1 = Tuple(4.3, -4.2, 3.1, 1.0);
        assert!(w1.is_point());
        assert!(!w1.is_vector());
    }

    #[test]
    fn point_vector() {
        let w0 = Tuple(4.3, -4.2, 3.1, 0.0);
        assert!(w0.is_vector());
        assert!(!w0.is_point());
    }

    #[test]
    fn ops_mul() {
        let t = Tuple(1.0, -2.0, 3.0, -4.0) * 3.5;
        let r = Tuple(3.5, -7.0, 10.5, -14.0);
        assert_eq!(t, r);
    }

    #[test]
    fn reflect_45() {
        let v = Tuple::vector(1.0, -1.0, 0.0);
        let n = Tuple::vector(0.0, 1.0, 0.0);
        let r = Tuple::vector(1.0, 1.0, 0.0);
        assert_eq!(v.reflect(n), r)
    }

    #[test]
    fn reflect() {
        let v = Tuple::vector(0.0, -1.0, 0.0);
        // let n = Tuple::vector(); PICKUP  Reflecting a vector off a slanted surface
        // let r = Tuple::vector(1.0, 1.0, 0.0);
        // assert_eq!(v.reflect(n), r)
    }

}

fn main() {
    let _res = Tuple::default() + Tuple::default();
}
