;;;; With lisp-impl-tools each lisp can be defined as per the slime manual.
;;;; lisp-impl-tools maintains a list of all the  specifications along with


;;;; The following are elements decribed in slime manual on how to configure a lisp
(defvar lisp-impl-name nil "See slime manual 2.5.2 Multiple Lisps, is a symbol and is used to identify the program.")
(defvar lisp-impl-program nil "See slime manual 2.5.2 Multiple Lisps, the filename of the program. Note that the filename can contain spaces.")
(defvar lisp-impl-program-args nil "See slime manual 2.5.2 Multiple Lisps, a list of command line arguments.")
(defvar lisp-impl-coding-system nil "See slime manual 2.5.2 Multiple Lisps, the coding system for the connection. (see slime-net-coding-system)")
(defvar lisp-impl-init nil "See slime manual 2.5.2 Multiple Lisps, should be a function which takes two arguments: a filename and a character encoding. The function should return a Lisp expression as a string which instructs Lisp to start the Swank server and to write the port number to the file. At startup, SLIME starts the Lisp process and sends the result of this function to Lisp’s standard input. As default, slime-init-command is used. An example is shown in Loading Swank faster.")
(defvar lisp-impl-init-function nil "See slime manual 2.5.2 Multiple Lisps, should be a function which takes no arguments. It is called after the connection is established. (See also slime-connected-hook.)")
(defvar lisp-impl-env nil "See slime manual 2.5.2 Multiple Lisps, specifies a list of environment variables for the subprocess. ")
(defvar lisp-impl-meta nil "The metadate for a the specific lisp implmentation.")

(defun reset-lisp-impl()
  "Create an empty and blank lisp implementation."
  (setq lisp-impl-name nil)
  (setq lisp-impl-program nil)
  (setq lisp-impl-program-args nil)
  (setq lisp-impl-coding-system nil)
  (setq lisp-impl-init nil)
  (setq lisp-impl-init-function nil)
  (setq lisp-impl-env nil)
  (setq lisp-impl-meta nil))

(defun tag (id val)
  (when val `(id val)))

(defun render-lisp-impl()
  "Return an sexp for the lisp-impl"
  `(,lisp-impl-meta
    (,lisp-impl-name
     ((,lisp-impl-program ,@lisp-impl-program-args)
      ,@(tag :CODING-SYSTEM lisp-impl-coding-system)
      ,@(tag :INIT lisp-impl-init)
      ,@(tag :INIT-FUNCTION lisp-impl-init-function)
      ,@(tag :ENV lisp-impl-env)))))

(defun test-render-lisp-impl()
  (reset-lisp-impl)
  (setq lisp-impl-name 'tester)
  (setq lisp-impl-program "sbcl.exe")
  (setq lisp-impl-program-args '("hello" "there"))
  (setq lisp-impl-coding-system :utf8)
  (setq lisp-impl-meta '((:use-slime t)))
  (render-lisp-impl))
