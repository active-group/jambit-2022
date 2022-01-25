;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "vanilla-reader.rkt" "deinprogramm" "sdp")((modname rev) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))
(: rev ((list-of %a) -> (list-of %a)))

#;(check-expect (rev (list 1 2 3))
              (list 3 2 1))

(define rev
  (lambda (list)
    (cond
      ((empty? list) empty)
      ((cons? list)
       (add-to-end
        (rev (rest list))
        (first list))))))

; Rechnen mit Zwischenergebnis / Akkumulator

(define rev*
   ; Idee: acc enthält die umgekehrte Liste der schon gesehenen Elemente
  (lambda (list acc)
    (cond
      ((empty? list) acc)
      ((cons? list)
       (rev* (rest list) (cons (first list) acc))))))

(rev* (list 1 2 3) empty)

; Element an Ende der Liste hängen
(: add-to-end ((list-of %a) %a -> (list-of %a)))

(check-expect (add-to-end (list 1 2 3) 4)
              (list 1 2 3 4))

(define add-to-end
  (lambda (list el)
    (cond
      ((empty? list) (cons el empty))
      ((cons? list)
       (cons
        (first list)
        (add-to-end (rest list) el))))))

; n + (n - 1) + ... + 2 + 1 = n (n + 1) / 2 = n^2 + ...
