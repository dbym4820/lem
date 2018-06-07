(in-package :lem-capi)

(defvar *non-focus-interface*)
(defvar *menu-items*)

(defmethod lem-if:display-popup-menu ((implementation capi-impl) items
                                      &key action-callback print-function focus-attribute non-focus-attribute)
  (declare (ignore focus-attribute non-focus-attribute))
  (setf *menu-items* items)
  (multiple-value-bind (char-width char-height)
      (lem-pane-char-size *lem-pane*)
    (multiple-value-bind (x y)
        (lem.popup-window::compute-popup-window-position (lem:current-window))
      (setf *non-focus-interface*
            (capi:prompt-with-list-non-focus
             items
             :owner *lem-pane*
             :x (* x char-width)
             :y (* y char-height)
             :print-function (or print-function #'princ-to-string)
             :action-callback (lambda (item interface)
                                (declare (ignore interface))
                                (mp:process-interrupt *lem-process* action-callback item))
             :list-updater (lambda () *menu-items*))))))

(defmethod lem-if:popup-menu-update ((implementation capi-impl) items)
  (setf *menu-items* items)
  (capi:non-focus-update *non-focus-interface*))

(defmethod lem-if:popup-menu-quit ((implementation capi-impl))
  (capi:non-focus-terminate *non-focus-interface*))

(defmethod lem-if:popup-menu-down ((implementation capi-impl))
  (capi:non-focus-maybe-capture-gesture *non-focus-interface* (sys:coerce-to-gesture-spec :down)))

(defmethod lem-if:popup-menu-up ((implementation capi-impl))
  (capi:non-focus-maybe-capture-gesture *non-focus-interface* (sys:coerce-to-gesture-spec :up)))

(defmethod lem-if:popup-menu-first ((implementation capi-impl))
  (capi:non-focus-maybe-capture-gesture *non-focus-interface* (sys:coerce-to-gesture-spec :prior)))

(defmethod lem-if:popup-menu-last ((implementation capi-impl))
  (capi:non-focus-maybe-capture-gesture *non-focus-interface* (sys:coerce-to-gesture-spec :next)))

(defmethod lem-if:popup-menu-select ((implementation capi-impl))
  (capi:non-focus-maybe-capture-gesture *non-focus-interface* (sys:coerce-to-gesture-spec #\return)))

(defmethod lem-if:display-popup-message ((implementation capi-impl) text timeout)
  (multiple-value-bind (char-width char-height)
      (lem-pane-char-size *lem-pane*)
    (multiple-value-bind (x y)
        (lem.popup-window::compute-popup-window-position (lem:current-window))
      (capi:display-non-focus-message text
                                      :timeout timeout
                                      :owner *lem-pane*
                                      :x (* x char-width)
                                      :y (* y char-height)))))