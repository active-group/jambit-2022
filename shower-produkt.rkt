;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "beginner-reader.rkt" "deinprogramm" "sdp")((modname shower-produkt) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))
; Führe eine Datenanalyse durch für Duschprodukte!
; Es gibt Seife, Shampoo und Duschgel.
; bei Seife: pH-Wert
; bei Shampoo: Farbe und Haartyp
; Duschgel besteht zu gleichen Teilen aus Shampoo und Seife

; 4. Duschprodukt:
; Mixtur aus zwei Duschprodukten, mit prozentualen Anteilen


; Schreibe eine Funktion, die den Seifenanteil eines Duschprodukts
; ermittelt!

(define product
  (signature (mixed soap shampoo shower-gel mixture)))

; Seife hat folgende Eigenschaften:
; - pH-Wert
(define-record soap
  make-soap
  soap?
  (soap-ph rational))

(define soap1 (make-soap 5.7))
(define soap2 (make-soap 6.2))

; Shampoo hat folgende Eigenschaften:
; - Farbe
; - Haartyp
(define-record shampoo
  make-shampoo
  shampoo?
  (shampoo-color string)
  (shampoo-type string))

(define shampoo1 (make-shampoo "brown" "dry"))
(define shampoo2 (make-shampoo "blonde" "dandruff"))

; Duschgel besteht aus:
; - Seife
; - Shampoo
(define-record shower-gel
  make-shower-gel
  shower-gel?
  (shower-gel-soap soap)
  (shower-gel-shampoo shampoo))

(define gel1 (make-shower-gel soap1 shampoo1))
(define gel2 (make-shower-gel soap2 shampoo2))

; Eine Mixtur hat folgende Eigenschaften:
; - Duschprodukt #1
; - Anteil Duschprodukt #1
; - Duschprodukt #2
(define-record mixture
  make-mixture
  mixture?
  (mixture-product-1 product)
  (mixture-ratio-1 rational)
  (mixture-product-2 product))

(define mix1 (make-mixture gel1 0.4 shampoo1))
(define mix2 (make-mixture mix1 0.2 gel2))

; Anteil von Duschprodukt 2 berechnen
(: mixture-ratio-2 (mixture -> rational))

(check-expect (mixture-ratio-2 mix1) 0.6)
(check-expect (mixture-ratio-2 mix2) 0.8)

(define mixture-ratio-2
  (lambda (mix)
    (- 1 (mixture-ratio-1 mix))))

; Seifenanteil eines Produkts berechnen
(: product-soap-ratio (product -> rational))

(check-expect (product-soap-ratio mix1) 0.2)

; Schablone

#;(define product-soap-ratio
  (lambda (product)
    (cond
      ((soap? product) ...)
      ((shampoo? product) ...)
      ((shower-gel? product) ...)
      ((mixture? product)
       ...
       (mixture-ratio-1 product)
       (product-soap-ratio (mixture-product-1 product))
       (product-soap-ratio (mixture-product-2 product))
       ...))))


(define product-soap-ratio
  (lambda (product)
    (cond
      ((soap? product) 1)
      ((shampoo? product) 0)
      ((shower-gel? product) 0.5)
      ((mixture? product)
       (+ (* (mixture-ratio-1 product)
             (product-soap-ratio (mixture-product-1 product)))
          (* (mixture-ratio-2 product)
             (product-soap-ratio (mixture-product-2 product))))))))

