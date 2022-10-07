;;;;          -*-  mode: lisp;  -*-
;;; The following lines added by ql:add-to-init-file:
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

#+quicklisp
(let ((quicklisp-per-user (merge-pathnames ".quicklisp-user.lisp"
					   (user-homedir-pathname))))
  (when (and quicklisp-per-user (probe-file quicklisp-per-user))
    (load quicklisp-per-user)))



