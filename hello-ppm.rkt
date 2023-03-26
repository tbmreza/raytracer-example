#lang racket

; (define WIDTH 256)
; (define HEIGHT 256)
;
; (define (denormalize n)
; 	(exact-floor (* 255.999 n)))
;
; (define image
;   (lambda ()
;     (displayln "P3")
;     (printf "~a ~a\n" WIDTH HEIGHT)
; 		(displayln "255")
;
; 		(for ([j (in-range HEIGHT 0 -1)])
; 			; std::cerr << "\rScanlines remaining: " << j << ' ' << std::flush;
; 			(for ([i WIDTH])
; 				(define r (/ i (- WIDTH 1.0)))
; 				(define g (/ j (- HEIGHT 1.0)))
; 				(define b 0.85)
;
; 				(printf "~a ~a ~a\n" (denormalize r)(denormalize g)(denormalize b))))))
;
; (image)

; vec3 struct of 3 fields
; methods (maybe operator overloading later):
; - [x] equal?
; - [ ] add -> vec3::new(u.e[0] + v.e[0], u.e[1] + v.e[1], u.e[2] + v.e[2])
; - [ ] ...
; - [ ] unit_vector -> v / v.length()

(struct trio (e1 e2 e3)
  #:methods
	; impl equal?
  gen:equal+hash
  [(define (equal-proc a b equal?-recur)
     (and (equal?-recur (trio-e1 a) (trio-e1 b))
          (equal?-recur (trio-e2 a) (trio-e2 b))
          (equal?-recur (trio-e3 a) (trio-e3 b))))
   (define (hash-proc a hash-recur)
     (+ (* 10000 (hash-recur (trio-e1 a)))
        (* 100 (hash-recur (trio-e2 a)))
        (* 1 (hash-recur (trio-e3 a)))))
   (define (hash2-proc a hash2-recur)
     (+ (hash2-recur (trio-e1 a))
        (hash2-recur (trio-e2 a))
        (hash2-recur (trio-e3 a))))])

(equal? (trio 12 11 14)(trio 12 14 11))
