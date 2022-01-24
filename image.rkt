;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "beginner-reader.rkt" "deinprogramm" "sdp")((modname image) (read-case-sensitive #f) (teachpacks ((lib "image.rkt" "teachpack" "deinprogramm" "sdp"))) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ((lib "image.rkt" "teachpack" "deinprogramm" "sdp")))))
(define x
  (+ 12
     (* 23 42)))

(define circle1 (circle 50 "solid" "red"))
(define square1 (square 100 "outline" "blue"))
(define star1 (star 50 "solid" "gold"))

(define overlay1 (overlay star1 circle1))

#;(above
 (beside circle1 star1)
 (beside star1 circle1))

#;(above
 (beside square1 circle1)
 (beside circle1 square1))

; Abstraktion

; Konstruktionsanleitung

; Kurzbeschreibung:
; Quadratisches Musters aus 2 Kacheln zusammensetzen

; Signatur(deklaration):
(: tile (image image -> image))

; Testfälle
(check-expect (tile star1 circle1)
              (above
               (beside star1 circle1)
               (beside circle1 star1)))

; Gerüst (ohne Nachdenken!)
#;(define tile
  (lambda (image1 image2)
    ...))

; Funktionsdefinition
(define tile
  (lambda (image1 image2)
    (above
     (beside image1 image2)
     (beside image2 image1))))

;(tile star1 circle1)

#|
class C {
  // Wert einer Variable ist eine Speicherzelle
  static int m(int x) {
     ...
     x
     ...
     // Inhalt der Speicherzelle wird ausgetauscht
     x = x + 1;
     ...
     x
     ...
  }

  ... C.m(23) ...
|#

; Datenanalyse
; "Sind Haustiere niedlich?"

; Datendefinition
; Ein Haustier ist eins der folgenden:
; - Hund - ODER -
; - Katze - ODER -
; - Schlange
; Fallunterscheidung
; hier Spezialfall: Aufzählung

; -> Code mit Signatur
(define pet
  (signature (enum "dog" "cat" "snake")))

; Ist Haustier niedlich?
(: cute? (pet -> boolean))

(check-expect (cute? "dog") #t)
(check-expect (cute? "cat") #t)
(check-expect (cute? "snake") #f)

; Gerüst
#;(define cute?
  (lambda (pet)
    ...))

; Schablone
#;(define cute?
  (lambda (pet)
    (cond
      ; (<Bedingung> <Ergebnis>)
      ((string=? pet "dog") ...)
      ((string=? pet "cat") ...)
      ((string=? pet "snake") ...))))
  
#;(define cute?
  (lambda (pet)
    (cond
      ; (<Bedingung> <Ergebnis>)
      ((string=? pet "dog") #t)
      ((string=? pet "cat") #t)
      ((string=? pet "snake") #f))))

(define cute?
  (lambda (pet)
    (match pet
      ("dog" #t)
      ("cat" #t)
      ("snake" #f))))

; Schreibe eine Funktion, die das Format eines
; Bildes bestimmt
  
; Eine Uhrzeit besteht aus / hat folgende Eigenschaften:
; - Stunde
; - Minute
; zusammengesetzten Daten
(define-record time ; Signatur
  make-time ; Konstruktor
  (time-hour natural) ; Selektor
  (time-minute natural))

; 12:24 Uhr
(define time1 (make-time 12 24))
; 14:12 Uhr
(define time2 (make-time 14 12))

(: make-time (natural natural -> time))
(: time-hour (time -> natural))
(: time-minute (time -> natural))

; Minuten seit Mitternacht
(: msm (time -> natural))

(check-expect (msm time1) (+ (* 12 60) 24))
(check-expect (msm time2) (+ (* 14 60) 12))

; Schablone:
#;(define msm
  (lambda (time)
    ...
    (time-hour time)
    (time-minute time)
    ...))

(define msm
  (lambda (time)
    (+ (* 60 (time-hour time))
       (time-minute time))))

