; [
;   "in"
;   "on"
;   "at"
; ] @boolean

;; Write queries here (see $VIMRUNTIME/queries/ for examples).
;; Move cursor to a capture ("@foo") to highlight matches in the source buffer.
;; Completion for grammar nodes is available (:help compl-omni)

; (function_definition
  ; "func" @debug
  ; (identifier) @function
  ; (parameter_list) @markup.heading
  ; (block))

(types) @type

