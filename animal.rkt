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