#lang racket

; begin module
(require racket/generic)

(define (denor n)
  (exact-floor (* 255.999 n)))

(define-generics Trio
    [write-color Trio]
    [add Trio t]
    [subtract Trio t]
    [mult Trio t]
    [multc Trio C]
    [divc Trio C]
    [unit-vector Trio])

(struct trio (e1 e2 e3)
  #:methods gen:Trio [
    (define (write-color t)
      (printf "~a ~a ~a\n"
        (denor (trio-e1 t))
        (denor (trio-e2 t))
        (denor (trio-e3 t))))
    (define (add a b)
      (trio (+ (trio-e1 a)
               (trio-e1 b))
            (+ (trio-e2 a)
               (trio-e2 b))
            (+ (trio-e3 a)
               (trio-e3 b))))
    (define (subtract a b)
      (trio (- (trio-e1 a)
               (trio-e1 b))
            (- (trio-e2 a)
               (trio-e2 b))
            (- (trio-e3 a)
               (trio-e3 b))))
    (define (mult a b)
      (trio (* (trio-e1 a)
               (trio-e1 b))
            (* (trio-e2 a)
               (trio-e2 b))
            (* (trio-e3 a)
               (trio-e3 b))))
    (define (multc t C)
      (trio (* (trio-e1 t) C)
            (* (trio-e2 t) C)
            (* (trio-e3 t) C)))
    (define (divc t C)
      (trio (* (trio-e1 t) (/ 1 C))
            (* (trio-e1 t) (/ 1 C))
            (* (trio-e1 t) (/ 1 C))))
    (define (unit-vector t) (divc t 1))]

  #:methods gen:equal+hash [
    (define (equal-proc a b equal?-recur)
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

(define color trio)

(module+ test
  (require rackunit)
  (check-equal? (trio 12 14 11) (trio 12 14 11))
  (check-not-equal? (trio 2 14 11) (trio 12 14 11)))

(unit-vector (trio 12 11 14))
; (trio-e1 (add (trio 12 11 14)(trio 12 14 11)))
; (trio-e1 (subtract (trio 10 10 10)(trio 2 4 1)))
; (trio-e1 (mult (trio 10 10 10)(trio 2 4 1)))
; (trio-e1 (multc (trio 2 4 1) 100))
; (trio-e1 (divc (trio 2 4 1) 2))
; (unit-vector (trio 2 4 1))
(write-color (trio 2 4 1))
; end module

(define WIDTH 256)
(define HEIGHT 256)

(define image
  (lambda ()
    (displayln "P3")
    (printf "~a ~a\n" WIDTH HEIGHT)
    (displayln "255")

    (for ([j (in-range HEIGHT 0 -1)])
      ; std::cerr << "\rScanlines remaining: " << j << ' ' << std::flush;
      (for ([i WIDTH])
        (define r (/ i (- WIDTH 1.0)))
        (define g (/ j (- HEIGHT 1.0)))
        (define b 0.25)

        (write-color (color r g b))))))

; (image)
