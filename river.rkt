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
