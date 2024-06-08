#![allow(unused)]
use std::sync::atomic::{AtomicUsize, Ordering};
fn new_id() -> usize {
    static COUNTER: AtomicUsize = AtomicUsize::new(1);
    COUNTER.fetch_add(1, Ordering::Relaxed)
}


use std::ops::{Add, Sub, Mul};

#[derive(Default, Debug, PartialEq, Clone, Copy)]
struct Tuple(f64, f64, f64, f64);

impl Tuple {
    fn vector(x: f64, y: f64, z: f64) -> Self {
    // ?? fn vector(x: Into<f64>, y: f64, z: f64) -> Self {
        Tuple(x, y, z, 0.0)
    }
    fn color(r: f64, g: f64, b: f64) -> Self {
        Tuple(r, g, b, 0.0)
    }
    fn point(x: f64, y: f64, z: f64) -> Self {
        Tuple(x, y, z, 1.0)
    }
    fn dot(&self, rhs: &Tuple) -> f64 {
        self.0 * rhs.0 + self.1 * rhs.1 + self.2 * rhs.2
    }
    fn round(&self) -> Self {
        // ?? fn closure
        let x = (self.0 * 1000.0).round() / 1000.0;
        let y = (self.1 * 1000.0).round() / 1000.0;
        let z = (self.2 * 1000.0).round() / 1000.0;
        let w = (self.3 * 1000.0).round() / 1000.0;
        Tuple(x, y, z, w)
    }
    fn normalize(&self) -> Self {
        Tuple(self.0 / self.mag(), self.1 / self.mag(), self.2 / self.mag(), self.3 / self.mag())
    }
}

type Color = Tuple;

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

struct Ray {
    origin: Tuple, // ?? + Point
    direction: Tuple, // + Vector
}
impl Ray {
    fn new(origin: Tuple, direction: Tuple) -> Self {
        Ray { origin, direction }
    }
}

struct Sphere;
impl Sphere {
    fn new() -> Self {
        // ?? new_id
        Sphere
    }
    // PICKUP in relation with hit
    fn intersect(&self, ray: Ray) -> Vec<f64> {
        let sphere_to_ray = ray.origin - Tuple::point(0.0,0.0,0.0);
        let a = ray.direction.dot(&ray.direction);
        let b = 2.0 * ray.direction.dot(&sphere_to_ray);
        let c = sphere_to_ray.dot(&sphere_to_ray) - 1.0;
        let discriminant = b.powi(2) - 4.0 * a * c;
        if discriminant < 0.0 {
            return Vec::new();
        }
        let t1 = (- b - discriminant.sqrt()) / 2.0 * a;
        let t2 = (- b + discriminant.sqrt()) / 2.0 * a;
        // vec![-6.0, -4.0]
        vec![t1, t2]
    }
}

struct Material {
    color: Color,
    ambient: f64,
    diffuse: f64,
    specular: f64,
    shininess: f64,
}

use std::default::Default;
impl Default for Material {
    fn default() -> Self {
        Material {
            color: Tuple::color(1.0, 1.0, 1.0),
            ambient: 0.1,
            diffuse: 0.9,
            specular: 0.9,
            shininess: 200.1,
        }
    }
}

// fn lighting(material, light, point, eyev, normalv) -> Color {
fn lighting(material: Material, light: Light, point: Tuple, eyev: Tuple, normalv: Tuple) -> Color {
    let effective_color = material.color * light.intensity;
    let lightv = (light.position - point).normalize();
    let ambient = effective_color * material.ambient;
    let light_dot_normal = lightv.dot(&normalv);


    let black = Tuple::color(0.0, 0.0, 0.0);
    black.clone() + black
}

// fn shade_hit(world, comps) -> Color {
fn shade_hit() -> Color {
    // lighting(comps.object.material)
    unimplemented!()
}

struct Light {
    position: Tuple,  // ?? impl Point
    intensity: Color
}
impl Light {
    fn point_light(position: Tuple, intensity: Color) -> Self {
        Light { position, intensity }
    }
}

// ?? impl Add for &Tuple {
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

impl Mul for Tuple {
    type Output = Self;
    fn mul(self, rhs: Self) -> Self::Output {
        Tuple(self.0 * rhs.0, self.1 * rhs.1, self.2 * rhs.2, self.3 * rhs.3)
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
        let n = Tuple::vector(2.0_f64.sqrt() / 2.0, 2.0_f64.sqrt() / 2.0, 0.0);
        let r = Tuple::vector(1.0, 0.0, 0.0);
        assert_eq!(v.reflect(n).round(), r)
    }

    #[test]
    fn sphere_behind_ray() {
        let r = Ray::new(Tuple::point(0.0, 0.0, 5.0), Tuple::vector(0.0, 0.0, 1.0));
        let s = Sphere::new();
        let xs = s.intersect(r);
        assert_eq!(xs.len(), 2);
        assert_eq!(xs, &[-6.0, -4.0]);
    }


}

struct Canvas(Vec<Vec<Color>>);
impl Canvas {
    fn new(w: usize, h: usize) -> Self {
        let grid = vec![vec![Tuple::color(0.0, 0.0, 0.0); w]; h];
        Canvas(grid)
    }
    fn write_pixel(&mut self, w: usize, h: usize, color: Color) {
        // ?? -> Result
        self.0[w][h] = color;
    }
    fn pixel_at(&self, w: usize, h: usize) -> Color {
        self.0[w][h].clone()
    }
}

// hit  lowest non negative intersection
fn hit() -> Option<bool> {
    None
}

fn main() {
    let canvas_pixels = 100;
    let mut canvas = Canvas::new(canvas_pixels, canvas_pixels);
    // let p0 = canvas.pixel_at(2, 3);
    // println!("p0: {:?}", p0);
    // canvas.write_pixel(2, 3, Tuple::color(200.1, 2.0, 0.0));
    // let p1 = canvas.pixel_at(2, 3);
    // println!("p1: {:?}", p1);
    let color = Tuple::color(1.0, 0.0, 0.0);
    let shape = Sphere::new();

    let ray_origin = Tuple::point(0.0, 0.0, -5.0);
    let wall_z = 10.0;
    let wall_size = 7.0;
    let pixel_size = wall_size / canvas_pixels as f64;
    let half = wall_size / 2.0;
    for y in 0..canvas_pixels {
        let world_y = half - pixel_size * y as f64;
            for x in 0..canvas_pixels {
                let world_x = -half + pixel_size * x as f64;
                let position = Tuple::point(world_x, world_y, wall_z);
                let r = Ray::new(ray_origin, (position - ray_origin).normalize());
                let xs = shape.intersect(r);
                canvas.write_pixel(x, y, color);
            }

    }
}
