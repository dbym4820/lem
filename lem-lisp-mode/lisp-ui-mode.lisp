(in-package :lem-lisp-mode)

(define-major-mode lisp-ui-mode nil
    (:name "lisp-ui"
     :keymap *lisp-ui-keymap*)
  (setf (buffer-read-only-p (current-buffer)) t))

(define-key *lisp-ui-keymap* "C-m" 'lisp-ui-default-action)
(define-key *lisp-ui-keymap* "C-i" 'lisp-ui-forward-button)

(define-command lisp-ui-default-action () ()
  (let ((button (button-at (current-point))))
    (when button (button-action button))))

(define-command lisp-ui-forward-button () ()
  (let ((p (current-point)))
    (or (forward-button p)
        (progn
          (buffer-start p)
          (forward-button p)))))
