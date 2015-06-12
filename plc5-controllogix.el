(defun plc5_word ()
  (interactive)
  
  (setq index 0)
  (set-buffer "PLC_K_EMACS_2COL.csv")  ;; File from RSLogix five containing the PLC-5 words a "," then the symbol
  (beginning-of-buffer)
  
  (while (< index 4493) ;; Number of records in above file
    
    (set-buffer "PLC_K_EMACS_2COL.csv")
    
    (setq plc5_word (buffer-substring (point) (- (search-forward ",") 1) ))
    (setq symbol_start (point))
    (end-of-line)
    (setq symbol_end (point))
    (setq plc5_symbol (buffer-substring symbol_start symbol_end))
    (next-line)
    (setq index (+ index 1)) 
    (beginning-of-line)
    
    ;; Translate & Replace O: Output files 
    (if (string-match "^O:[[:digit:]]+/[[:digit:]]+" plc5_word)
	(replace plc5_word plc5_symbol)
      )
    
    ;; Translate & Replace I: Input files 
    (if (string-match "^I:[[:digit:]]+/[[:digit:]]+" plc5_word)
	(replace plc5_word plc5_symbol)
      )
    
    ;; Translate & Replace B: Boolean files (Change B3:14/1 to B3:224 bits to word mode first)
    (if (string-match  "^B[[:digit:]]+:[[:digit:]]+/[[:digit:]]+" plc5_word)
	(progn
	  (setq file (substring plc5_word 0 (string-match ":" plc5_word)))
	  (setq word (substring plc5_word (+ 1 (string-match ":" plc5_word)) (string-match "/" plc5_word)))
	  (setq bit (substring plc5_word (+ 1 (string-match "/" plc5_word)) (string-match "\n" plc5_word)))
	  (setq word (number-to-string (+ (string-to-number  bit) (* (string-to-number word)  16))))
	  (setq file_word (concat (concat file "/") word))
	  (setq plc5_word file_word)
	  (replace plc5_word plc5_symbol)))
    
    ;; Translate & Replace Langboard N19 files for motors to the Motor.Control.0 user defined type 
    (if (string-match "^N19:[[:digit:]]+/[[:digit:]]+" plc5_word)
	(progn
	  (setq file (substring plc5_word 0 (string-match ":" plc5_word)))
      	  (setq word (substring plc5_word (+ 1 (string-match ":" plc5_word)) (string-match "/" plc5_word)))
	  (setq bit (substring plc5_word (+ 1 (string-match "/" plc5_word)) (string-match "\n" plc5_word)))
	  (setq plc5_symbol (concat (concat (substring plc5_symbol 0 (string-match "_" plc5_symbol)) ".Control.") bit))
	  (replace plc5_word plc5_symbol)))
    
    ;; Translate & Replace  T: Timer files 
    (if (string-match "^T[[:digit:]]+:[[:digit:]]+" plc5_word)
	(replace plc5_word plc5_symbol)
      )
    
    ;; Translate & Replace  C: Counter files 
    (if (string-match "^C[[:digit:]]+:[[:digit:]]+" plc5_word)
	(replace plc5_word plc5_symbol)
      )
    
    ;; Translate & Replace  C: Counter files 
    (if (string-match "^F[[:digit:]]+:[[:digit:]]+" plc5_word)
	(replace plc5_word plc5_symbol)
      )


       ;; Translate & Replace  C: Counter files 
    (if (string-match "^N[[:digit:]]+:[[:digit:]]+" plc5_word)
	(replace plc5_word plc5_symbol)
      )
    
    
    
    
    )
  
  ;; Replace slash bits bits with .DN .TT .EN .UP etc....
  (plc5-replace-slash)
  
  
  )






;;
;;
;;
;; This replaces all the "/" slashes with "."
(defun plc5-replace-slash ()
  (set-buffer "program")
  (beginning-of-buffer)
  (replace-regexp "/DN"  ".DN")
  (beginning-of-buffer)
  (replace-regexp "/TT"  ".TT")
  (beginning-of-buffer)
  (replace-regexp "/EN"  ".EN")
  (beginning-of-buffer)
  (replace-regexp "/CU"  ".CU")
  (beginning-of-buffer)
  (replace-regexp "/CD"  ".CU")
  )


;; Function for regexp replace in "program" buffer
;; This buffer is copy and paste rungs for RSLogix 5
(defun plc5-replace(word symbol)
  (set-buffer "program")
  (beginning-of-buffer)
  (message word)
  (message symbol)
  (replace-regexp (concat word "\\b")  symbol)
  )


;; Regexp builder helper
(rx bol
    "T"
    (one-or-more digit)
    ":"
    (one-or-more digit)
    )









               
