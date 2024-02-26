;;;; With lisp-impl-tools each inferior lisp candidate can be defined as per the slime manual.
;;;; lisp-impl-tools maintains a list of all the specifications along with metadata.

;;;; SLIME can be configured to use multiple lisps.
;;;; A typical use would be define an slime entry for SBCL and CCL. You add a 'slime-entry' for
;;;; each both lisps to the 'slime-lisp-implementations'.
;;;; Startup either lisp my doing M-0 M-slime <TAB> and select from the completion list.
;;;;
;;;; When abused this approach leads to long completion lists with programatically created ids.
;;;; But sometimes you want these messy cases when debugging.
;;;;
;;;; With a three phase strategy you can switch between both options.
;;;;
;;;; Phase 1, define all configurations with a meta tag strategy.
;;;; At some point in you init.el you are going to iterate over all the lisp implemenations and
;;;; There various startup options. You at metadata to each case based on how you want those cases selected.
;;;; Phase 2, define selection strategy based on the metadata.
;;;; Phase 3, use a strategy to create the lisp-implentations.
;;;; Basically production cases for real work and testing case for the trivial stuff.
;;;; Next you define filters based on your marking strategy.

;;;;
;;;; SLIME, “Superior Lisp Interaction Mode for Emacs,” and i't fork SLY both accept a list of elements.
;;;; to specify which Common Lisp implemenation will be the inferior to emacs.
;;;; I first used a simple approach and hand coded this list, for say SBCL, ABCL, CCL and CLISP.
;;;; SBCL leads to a number of startup cases with monthly releases combined with various startup options.
;;;;
;;;; When testing SBCL, I may have various configurations where some represent various Startup Options and
;;;; other represent various compilation and configuration options. Sometimes I just want reliable items
;;;; on my slime startup list from SBCL and CCL. Other times I am testing and tweeking a specific version of SBCL. 
;;;;
;;;; By dividing the creation of the various lisps and options in the creationg and tagging of the master lisp.
;;;; And next designing extraction filters  based on specific tags various purposes could be accomplished.


;;;; Slime and Sly each take similar lists of information to decribe inferior lisp processes.
;;;; I use the term *invoker* to describe each element of those lists.
;;;; For Slime See:  https://slime.common-lisp.dev/doc/html/Multiple-Lisps.html#Multiple-Lisps
;;;; For Sly See: https://joaotavora.github.io/sly/#Multiple-Lisps

;;;; The functional design.
;;;; 1) meta tag various lisp implmentations creating a master-list
;;;;  Because there are various lisp implmentations and there could be various start up options for those implemenations.
;;;;  You create an inferior lisp invoker for each all with metadata about the variations. This could be a very long list.
;;;; 2) filter the list by metadata
;;;;  You create various filters by metadata, such as 'production', 'testing' or 'custom'.
;;;; 3) you set 'slime-lisp-implementations' or 'sly-lisp-implemenatations' to the selected output of the filters to the master-list.

(defvar lisp-impl-master-list nil "This is a list of all lisp implmentations candidates. If set this to nil the list is made empty")

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

(defmacro _tag (id val)
  (let ((_val (gensym))
	(_id (gensym)))
    `(let ((,_val ,val)
	   (,_id ,id))
	(if ,_val (list ,_id ,_val)))))

(defun render-lisp-impl()
  "Return an sexp for the lisp-impl"
  `(,lisp-impl-meta
    (,lisp-impl-name
     ((,lisp-impl-program ,@lisp-impl-program-args)
      ,@(_tag :CODING-SYSTEM lisp-impl-coding-system)
      ,@(_tag :INIT lisp-impl-init)
      ,@(_tag :INIT-FUNCTION lisp-impl-init-function)
      ,@(_tag :ENV lisp-impl-env)))))

(defun render-to-list ()
  "Render am implmenatons and add it to the master list."
  (setf lisp-impl-master-list (cons (render-lisp-impl) lisp-impl-master-list)))

(defun test-render-lisp-impl()
  (reset-lisp-impl)
  (setq lisp-impl-name 'imagino-test-lisp)
  (setq lisp-impl-program "sbcl.exe")
  (setq lisp-impl-program-args '("hello" "there"))
  (setq lisp-impl-coding-system :utf8)
  (setq lisp-impl-init '(the-initer))
  (setq lisp-impl-init-function "(defun swanko-starto() (do-init))  (swanko-starto)")
  (setq lisp-impl-env "((SBCL_HOME=\"/home/zzzap/sbcl/\"))")
  (setq lisp-impl-meta '(("use-slime" t)("production" t)))
  (render-lisp-impl))
