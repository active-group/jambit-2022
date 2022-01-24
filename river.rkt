;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "beginner-reader.rkt" "deinprogramm" "sdp")((modname river) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))

; Ein Fluss ist eins der folgenden:
; - Bach, kommt aus einer Quelle - ODER -
; - Zusammentreffen, fließt aus zwei Flüssen zusammen
; Fallunterscheidung; gemischte Daten
(define river
  (signature (mixed creek confluence)))

; Ein Bach hat folgende Eigenschaften:
; - Ursprungsort
(define-record creek
  make-creek
  creek?
  (creek-origin string))

(define eschach (make-creek "Heimliswald"))
(define prim (make-creek "Dreifaltigkeitsberg"))
(define schlichem (make-creek "Tieringen"))

; Ein Zusammentreffen hat folgende Eigenschaften:
; - Ort des Zusammenflusses
; - Hauptfluss
;        ^^^^^ Selbstbezug
; - Nebenfluss
(define-record confluence
  make-confluence
  confluence?
  (confluence-location string)
  (confluence-main-stem river)
  (confluence-tributary river))

(define neckar1 (make-confluence "Rottweil" eschach prim))
(define neckar2 (make-confluence "Epfendorf" neckar1 schlichem))

; Fließt Wasser aus einem Ort durch Fluß?
(: flows-from? (river string -> boolean))

(check-expect (flows-from? neckar1 "Heimliswald") #t)
(check-expect (flows-from? neckar1 "Rottweil") #t)
(check-expect (flows-from? neckar1 "Epfendorf") #f)
(check-expect (flows-from? neckar1 "Bielefeld") #f)

; Schablone
#;(define flows-from?
  (lambda (river location)
    (cond
      ((creek? river) ... (creek-origin river) ...)
      ((confluence? river)
       ...
       (confluence-location river)
       (flows-from? (confluence-main-stem river) location)
       (flows-from? (confluence-tributary river) location)
       ...))))

(define flows-from?
  (lambda (river location)
    (cond
      ((creek? river)
       (string=? location (creek-origin river)))
      ((confluence? river)
       (or
        (string=? location (confluence-location river))
        ; Fließt Wasser von location in den Hauptzweig?
        (flows-from? (confluence-main-stem river) location)
        ; Fließt Wasser von location in den Nebenzweig?
        (flows-from? (confluence-tributary river) location))))))

; strikte Auswertung:
; vor Aufruf einer Funktion werden alle Argumente ausgewertet