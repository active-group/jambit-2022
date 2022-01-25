;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "beginner-reader.rkt" "deinprogramm" "sdp")((modname animal) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))
; Ein Tier auf dem texanischen Highway ist eins der folgenden:
; - Gürteltier - ODER -
; - Papagei
; Fallunterscheidung
; jeder einzelne Fall hat eigene Datendefinition
; gemischte Daten
(define animal
  (signature (mixed dillo parrot)))

; Ein Gürteltier hat folgende Eigenschaft:
; - lebendig oder tot?
; - Gewicht
; zusammengesetzte Daten
(define-record dillo
  make-dillo
  dillo? ; Prädikat
  (dillo-alive? boolean)
  (dillo-weight number))

(: make-dillo (boolean number -> dillo))
(: dillo-alive? (dillo -> boolean))
(: dillo-weight (dillo -> number))
(: dillo? (any -> boolean))
               
; lebendiges Gürteltier, 10kg
(define dillo1 (make-dillo #t 10))
; totes Gürteltier, 8kg
(define dillo2 (make-dillo #f 8))

#|
class Dillo {
  bool isAlive;
  double weight;

  void runOver() {
    this.isAlive = false;
  }
}
|#

; Gürteltier überfahren
(: run-over-dillo (dillo -> dillo))

(check-expect (run-over-dillo dillo1)
              (make-dillo #f 10))
(check-expect (run-over-dillo dillo2)
              dillo2)

; Schablone:
#;(define run-over-dillo
  (lambda (dillo)
    (make-dillo ... ...)
    (dillo-alive? dillo)
    (dillo-weight dillo)
    
    ...))

(define run-over-dillo
  (lambda (dillo)
    (make-dillo #f (dillo-weight dillo))))

; (cond ... (else ...))
; (and ...)
; (or ...)
; 2 Booleans vergleichen: boolean=?

; (boolean=? x #t) == x
; (boolean=? x #f) == (not x)

; Gürteltier füttern
(: feed-dillo (dillo number -> dillo))

(check-expect (feed-dillo dillo1 5)
              (make-dillo #t 15))
(check-expect (feed-dillo dillo2 5)
              dillo2)

(define feed-dillo
  (lambda (dillo amount)
    (define alive? (dillo-alive? dillo))
    (define weight (dillo-weight dillo))
    (make-dillo alive?
                (if alive?
                    (+ weight amount)
                    weight)
                #;(cond
                  ((dillo-alive? dillo) (+ (dillo-weight dillo)
                                           amount))
                  (else (dillo-weight dillo))))))

; lexikalische Bindung:
; vom Vorkommen einer Variablen von innen nach außen suchen nach:
; - define (wenn innerhalb von Klammern: "lokal")
; - lambda
; wenn das nicht klappt:
; - Suche nach define "ganz außen" ("global")
; wenn das nicht klappt:
; - muß es eine importierte Bindung

; Ein Papagei hat folgende Eigenschaften:
; - Satz
; - Gewicht
(define-record parrot
  make-parrot
  parrot?
  (parrot-sentence string)
  (parrot-weight number))

; Begrüßungspapagei, 1kg
(define parrot1 (make-parrot "Hello!" 1))
; Verabschiedungspapagei, 2kg
(define parrot2 (make-parrot "Goodbye!" 2))

; Papagei überfahren
(: run-over-parrot (parrot -> parrot))

(check-expect (run-over-parrot parrot1)
              (make-parrot "" 1))
(check-expect (run-over-parrot parrot2)
              (make-parrot "" 2))

(define run-over-parrot
  (lambda (parrot)
    (make-parrot "" (parrot-weight parrot))))


; Tier überfahren
(: run-over-animal (animal -> animal))

(check-expect (run-over-animal dillo1)
              (run-over-dillo dillo1))
(check-expect (run-over-animal parrot1)
              (run-over-parrot parrot1))


(define run-over-animal
  (lambda (animal)
    (cond
      ((dillo? animal) (run-over-dillo animal))
      ((parrot? animal) (run-over-parrot animal)))))

; animal: Gemischte Daten, jeder Fall zusammengesetzte Daten


#|
interface Animal {
  Animal runOver();
}
class Dillo implements Animal {
  Animal runOver() { ... }
}
class Parrot implements Animal {
  Animal runOver() { ... }
}

interface Animal<R> {
  R runOver();
}
class Dillo implements Animal<Dillo> {
  Dillo runOver() { ... }
}
class Parrot implements Animal<Parrot> {
  Parrot runOver() { ... }
}


abstract class Animal { ... }
class Dillo extends Animal { ... }
class Parrot extends { ... }
|#

; Eine Liste ist eins der folgenden:
; - die leere Liste
; - eine Cons-Liste bestehend aus erstem Element und Rest-Liste
;                                                         ^^^^^ Selbstbezug
(define list-of
  (lambda (element)
    (signature
     (mixed empty-list
            (cons-list-of element)))))

; zunächst: Listen von Zahlen
(define-record empty-list
  make-empty
  empty?)

(define empty (make-empty))

; Eine Cons-Liste besteht aus:
; - erstes Element
; - Rest-Liste
(define-record (cons-list-of element)
  cons
  cons?
  (first element)
  (rest list-of-numbers))

; (cons-list-of number)
; (cons-list-of animal)

; 1elementige Liste: 7
(define list1 (cons 7 empty))
; 2elementige Liste: 7 5
(define list2 (cons 7 (cons 5 empty)))
; 3elementige Liste: 3 7 5
(define list3 (cons 3 (cons 7 (cons 5 empty))))
; 4elementige Liste: 2 3 7 5
(define list4 (cons 2 list3))

; Elemente einer Liste addieren
(: list-sum (list-of-numbers -> number))

(check-expect (list-sum list4) 17)

; Schablone
#;(define list-sum
  (lambda (list)
    (cond
      ((empty? list) ...)
      ((cons? list)
       ...
       (first list)
       (list-sum (rest list))
       ...
       ))))
    

(define list-sum
  (lambda (list)
    (cond
      ((empty? list) 0)
      ((cons? list)
       (+
        (first list)
        (list-sum (rest list)))))))
    

; Zahlen einer Liste multiplizieren
(: list-product (list-of-numbers -> number))

(check-expect (list-product list4) 210)

(define list-product
  (lambda (list)
    (cond
      ((empty? list) 1)
      ((cons? list)
       (* 
        (first list)
        (list-product (rest list)))))))

; Alle Elemente einer Liste inkrementieren
(: inc-list (list-of-numbers -> list-of-numbers))

(check-expect (inc-list list4)
              (cons 3 (cons 4 (cons 8 (cons 6 empty)))))

(define inc-list
  (lambda (list)
    (cond
      ((empty? list) empty)
      ((cons? list)
       (cons
        (inc (first list))
        (inc-list (rest list)))))))

(define inc (lambda (x) (+ 1 x)))

; Alle Elemente einer Liste verdoppeln
(: double-list (list-of-numbers -> list-of-numbers))

(check-expect (double-list list4)
              (cons 4 (cons 6 (cons 14 (cons 10 empty)))))

(define double-list
  (lambda (list)
    (cond
      ((empty? list) empty)
      ((cons? list)
       (cons
        (double (first list))
        (double-list (rest list)))))))

(define double (lambda (x) (* 2 x)))

; Funktion auf alle Elemente einer Liste an
(: map-list ((number -> number) list-of-numbers -> list-of-numbers))
; mehr als ein Pfeil in der Signatur:
; Higher-Order-Funktion
; Funktion höherer Ordnung

(check-expect (map-list inc list4)
              (cons 3 (cons 4 (cons 8 (cons 6 empty)))))
(check-expect (map-list double list4)
              (double-list list4))

(define map-list
  (lambda (f list)
    (cond
      ((empty? list) empty)
      ((cons? list)
       (cons
        (f (first list))
        (map-list f (rest list)))))))

(define highway (cons dillo1
                      (cons dillo2
                            (cons parrot1
                                  (cons parrot2 empty)))))