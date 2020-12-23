;;;; Add project directories for quicklisp


(let* ((user (first (last (pathname-directory (user-homedir-pathname))))) ; Get the user
       (shared-code #+win32 #P"C:/Users/Public/Documents/repos/") ; The shared lisp directory; could add unix defaults
       (standard-lisp-home #+win32 (pathname (concatenate 'string "C:/Users/" user "/common-lisp/")))
       (paths))

;;;; Create path defaults based on the user
  (cond ((equalp user "zzzap")
	 (setf paths `(#P"C:/Users/zzzap/local-code-projects/my-code/common-lisp/local-attic/"
		       ,standard-lisp-home
		       ,shared-code)))
        (t (setf paths `(,standard-lisp-home ,shared-code))))
  
;;;; Add any from paths which is not present in ql:*local-project-directories*
  (dolist (p paths)
    (when (and p (probe-file p) (not (member p ql:*local-project-directories*)))
      (print (format t "Adding ~A to quicklisp local projects directory." p))
      (setf ql:*local-project-directories* (cons p ql:*local-project-directories*)))))
