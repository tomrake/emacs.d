;; NOTE: init.el is now generated from Emacs.org.  Please edit that file
;;       in Emacs and init.el will be generated automatically!

;;;; Emacs and init debuging flags
(setq debug-on-error nil)
(setq init-file-debug nil)

 ;;;; Control debugging during init
 (when init-file-debug
     (setq use-package-verbose t
           use-package-expand-minimally nil
           use-package-compute-statistics t
           debug-on-error t))

;;;; Wider emacs applications may need to locate custom resources.
;;;; The various custom configuratiions are collected for the group.
;;;; the files at <user-emacs-directory>/multi-init-cluster/<system-name>-<user-login-name>-<chemacs-profile-name>-user-startup.el
;;;; Represent all member of the cluster.
;;;; the user-emacs-directory and chemacs-profile-names are defined in ~/.emacs-profiles.el
(message "chemacs-profile-name   : %s" chemacs-profile-name)
(message "system-name            : %s" system-name)
(message "user-login-name        : %s" user-login-name)
(if chemacs-profile-name
    (progn
	(defvar local-config-name (concat system-name "-" user-login-name "-" chemacs-profile-name "-user-startup")
	  "The name of local-config file.")
	(defvar local-config-pathname (concat user-emacs-directory "multi-init-cluster/" local-config-name)
	  "The filename to load the local-config.")
	(message "local-config-pathname  : %s" local-config-pathname)
	(load local-config-pathname))
  (progn
    (message "This config should be executed by chemacs2 and chemacs-profile-name is not defined ")
    (error "Bad chemacs config.")))
(message "---------- Done with multi-init-cluster startup -------")

(defmacro checksym-defined (name &rest body)
  "Anaphoric - it macro, where the body can uss *it* when symbol name is defined."
  (let ((_sym (gensym)))
    `(let ((,_sym (intern-soft ,name)))
	 (when ,_sym
	   (let ((it (symbol-value ,_sym)))
	     ,@body)))))

(defmacro checksym-not-nil (name &rest body)
  "Anaphoric - it macro, where the body can uss *it* when symbol name is defined."
  "Execute the body when the symbol is not nil"
  (let ((_sym (gensym)))
    `(let ((,_sym (intern-soft ,name)))
	 (when (,_sym (symbol-value ,_sym))
	   (let ((it (symbol-value ,_sym)))
	     ,@body)))))

(defmacro checksym-not-empty-string (name &rest body)
  "Anaphoric - it macro, where the body can uss *it* when symbol name is a string that is not empty."
  (let ((_sym (gensym)))
    `(let ((,_sym (intern-soft ,name)))
	 (when ,_sym
	   (let ((it (symbol-value ,_sym)))
	     (when (and (stringp it) (< 0 (length it)))
	       ,@body))))))


(defmacro checksym-existing-file (name &rest body)
  "Anaphoric - it macro, where the body can uss *it* when symbol name is a the name of an existing file."
  (let ((_sym (gensym)))
    `(let ((,_sym (intern-soft ,name)))
	 (when ,_sym
	   (let ((it (symbol-value ,_sym)))
	     (when (and (stringp it) (file-exists-p it))
		 ,@body))))))


(defmacro checksym-existing-directory (name &rest body)
	"Anaphoric - it macro, where the body can us *it* when symbol name is a the name of an existing directory."
  (let ((_sym (gensym)))
    `(let ((,_sym (intern-soft ,name)))
	 (when ,_sym
	   (let ((it (symbol-value ,_sym)))
	     (when (and (stringp it) (file-directory-p it))
		 ,@body))))))

(setq twr/init-loading-flag "default")
(defun twr/check-init-load ()
  (when twr/init-loading-flag
    (message (concat "INIT DID NOT FINISH!!!!!! " twr/init-loading-flag))))
(add-hook 'after-init-hook 'twr/check-init-load)

;; Autommatically tangle our Emacs.org config file when we save it.
(defun efs/org-babel-tangle-config ()
  "Test if the buffer should be auto-tangled after save"
  ; (message "string-equal: %s %s" (buffer-file-name) (expand-file-name (concat user-emacs-directory "Emacs.org")))
  (when (string-equal (buffer-file-name)
			(expand-file-name "Emacs.org" user-emacs-directory))
    (message "tangle-Emacs.org")

    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
	(org-babel-tangle))))
(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(add-to-list 'load-path (expand-file-name "scripts/" user-emacs-directory))

(setq gc-cons-threshold (* 50 1000 1000))

(defun find-first-existing-file (files)
  (if (listp files)
	(if (null files)
	  nil
	  (let ((file (car files)))
	    (if (and file (file-exists-p file))
	      file
	      (find-first-existing-file (cdr files)))))
    (error "files should be a list but is %s" files)))
  (setq initial-buffer-choice
	  (find-first-existing-file (list "~/startup-buffer.org"
					   (concat user-emacs-directory "startup-buffer.org"))))

;; UTF-8 as default encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8-unix)

;; do this especially on Windows, else python output problem
(set-terminal-coding-system 'utf-8-unix)

;;;; Reporting Startup Time
(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
	     (format "%.2f seconds"
		     (float-time
		      (time-subtract after-init-time before-init-time)))
	     gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;;;; straight boilerplate startup code.
  (defvar bootstrap-version)
    (let ((bootstrap-file
           (expand-file-name
            "straight/repos/straight.el/bootstrap.el"
            (or (bound-and-true-p straight-base-dir)
                user-emacs-directory)))
          (bootstrap-version 7))
      (unless (file-exists-p bootstrap-file)
        (with-current-buffer
            (url-retrieve-synchronously
             "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
             'silent 'inhibit-cookies)
          (goto-char (point-max))
          (eval-print-last-sexp)))
      (load bootstrap-file nil 'nomessage))

;;;; Various straight customizations.
    (straight-use-package 'use-package)
    (straight-use-package '(org :type built-in))
    (straight-use-package 'htmlize)

;;;; use-package
(require 'use-package)
(setq straight-use-package-by-default t)
(setq use-package-verbose t)
(setq use-package-always-defer t)

;;;; Macro to load user customizations from .emacs.d
(defmacro local-custom-file (file description)
  `(progn
     ;(require 'org)
     ;;(message (concat "Looking for " ,description " file: " ,file ))
     (let ((file-and-path (expand-file-name ,file user-emacs-directory)))
	 (if (file-exists-p file-and-path)
	     (progn ;;(message (concat "org-babel-load of " file-and-path))
	            (require 'org)
		    (org-babel-load-file file-and-path))
	   (message (concat "Custom file is missing " file-and-path))))))

;;;; Magic File modes
(setq magic-mode-alist '(("*.org" . org)))

;;;; Have a clean statup screen
(setq inhibit-startup-screen t)
(setq visible-bell 1)
 ;;;; Turn off tool bar
(tool-bar-mode 0)
(setq use-file-dialog nil)

(when (equal system-type 'windows-nt)
  (setq w32-use-visible-system-caret nil))

;;;; auto revert mode
(global-auto-revert-mode 1)

;;;; dired auto revert
(setf global-auto-revert-non-file-buffers t)

(use-package  ido
    :config
  (ido-mode t))

(use-package which-key
  :straight t)

;;;; Enable vertico
(use-package vertico
  :straight t
  :init
  (vertico-mode))

(use-package savehist
  :init
  (savehist-mode))

(setq ispell-program-name "aspell")

;; The java interface assumption is you can execute the program "java"
;; There is no jdk to be considered.
(defvar java-executable (executable-find "java")
  "The java-executable to use for java.")

(defvar ltex-ls-plus-base   (concat user-emacs-directory "ltex-plus/ltex-ls-plus-18.6.1/"))
(defvar ltex-ls-plus-bin   (concat ltex-ls-plus-base "bin/ltex-ls-plus"))
(when t (when (equal system-type 'windows-nt)
  (setenv "JAVA_HOME")
  (setenv "JDK_HOME")
  (setq ltex-ls-plus-bin (concat ltex-ls-plus-bin ".bat"))
  (message (concat "ltex server: " ltex-ls-plus-bin))))
(use-package lsp-ltex-plus
  :if (file-exists-p ltex-ls-plus-bin)
  ;; For Emacs 29+, use the built-in :vc fetcher:
  ;; :vc (:url "https://github.com/alberti42/emacs-ltex-plus")

  ;; If you prefer straight.el, replace the :vc line above with this:
  :straight (lsp-ltex-plus :type git :host github :repo "alberti42/emacs-ltex-plus")

  :defer t

  :custom
  (lsp-ltex-plus-ltex-ls-path ltex-ls-plus-base)
  (lsp-ltex-plus-language "en-US")
  (lsp-ltex-plus-ls-plus-executable ltex-ls-plus-bin)
  (flymake-show-diagnostics-at-end-of-line t)
  ;; To use the online service, set the URI.
  ;; If you prefer the remote server (slower, but more precise), uncomment the next line (it defaults to nil).
  ;; (lsp-ltex-plus-lt-server-uri "https://api.languagetoolplus.com")
  ;; Uncomment the next line to also check grammar in the comments of programming
  ;; languages (Python, C, Rust, …) in addition to markup formats (LaTeX, Markdown, Org, …).

  ;; [2026-04-26] BUGFIX:  This is set to nil because there is a slime/ltex-ls-plus conflict 
  (lsp-ltex-plus-check-programming-languages nil)
  
  ;; Uncomment to apply the "Kind-First" protocol patch to lsp-mode.
  ;; Strongly recommended, especially if you use a remote LanguageTool server;
  ;; the network latency makes JSON-RPC ID collisions between client and server
  ;; requests almost inevitable, which can permanently stall the connection.
  ;; The patch is a general lsp-mode fix and benefits every LSP client, not
  ;; only ltex-ls-plus. Details: https://github.com/alberti42/emacs-ltex-plus#lsp-mode-protocol-patch
  (lsp-ltex-plus-apply-kind-first-patch t)

  :init
  (lsp-ltex-plus-enable-for-modes))

(use-package yasnippet
	    :straight t)

(require 'quoting-tools)

(when (equal system-type "windows-nt")
  (require 'gnu-tools))

;;;; Magit 
(use-package magit
  ;:defer 2
  :straight t
  ;:pin melpa
  :bind
   (("C-x g" . magit-status)
    ("C-x M-d" . magit-dispatch-popup)))

;;;; SSH Agency
(use-package ssh-agency
:straight t
:init
(setenv "GIT_ASKPASS" "git-gui--askpass")
(setenv "SSH_ASKPASS" "git-gui--askpass")
:after (magit))

(use-package modus-themes
  :ensure t
  :init
  (set-face-attribute 'default nil :height 150)
	;; Subtle red background, red foreground, invisible border

  (setq modus-themes-region '(bg-only))
  (setq modus-themes-paren-match '(bold intense))
  (setq modus-themes-lang-checkers '(background intense))
  (setq modus-themes-italic-constructs t)
  (setq modus-themes-bold-contructs t)
  (setq modus-themes-prompts  '(bold italic))
  ;; Subtle blue background, neutral foreground, intense blue border
  (setq modus-themes-common-palette-overrides
    '((bg-mode-line-active bg-blue-subtle)
	(fg-mode-line-active fg-main)
	(border-mode-line-active blue-intense)))
  (setq modus-themes-mode-line '(accented borderless))
  ;;; Org Mode
  (setq modus-themes-heading
	  `((1 . (rainbow bold intense 2.3))
	    (2 . (rainbow bold intense 1.9))
	    (3 . (rainbow bold intense 1.7))
	    (4 . (rainbow bold intense 1.5))
	    (5 . (rainbow bold intense 1.3))
	    (6 . (rainbow bold intense 1.1))
	    (t . (rainbow bold background 1.0))))
  (setq modus-themes-org-agenda
	  '((header-block . (variable-pitch 1.5))
	    (header-date . (grayscale workaholic bold-today 1.2))
	    (event . (accented italic varied))
	    (scheduled . uniform)
	    (habit . traffic-light)))
  (setf custom-safe-themes "e410458d3e769c33e0865971deb6e8422457fad02bf51f7862fa180ccc42c032")
  (load-theme 'modus-vivendi t))

;;;; rainbow-delimiter
(use-package rainbow-delimiters)

;;;; powershell
(defun powershell()
  (interactive)
  (let ((explicit-shell-file-name "powershell.exe")
	  (explicit-powershell.exe-args '()))
    (shell (generate-new-buffer-name "*powershell*"))))

;;;; Set the explicit shell name to msys2 version.
(when (or (equal system-type "windows-nt"))
  (setq explicit-shell-file-name "c:/devel/msys64/usr/bin/bash"))

;;;; eshell this really  msys2 path stuff.
(when (or (equal system-type "windows-nt"))
  (setenv  "PATH" (concat
		   (list
		    "C:/devel/msys64/ucrt64/bin" ";"
		    "C:/devel/msys64/bin" ";")
		   (getenv "PATH"))))

(use-package shx
  :straight t)

(use-package tramp
  :config
    (when (equal  system-type "windows-nt")
	(setq putty-directory "c:/Program Files/PuTTY/")
	(setq tramp-default-method "plink")
	(when (and (not (string-match putty-directory (getenv "PATH")))
		   (file-directory-p putty-directory))
	  (setenv "PATH" (concat putty-directory ";" (getenv "PATH")))
	  (add-to-list 'exec-path putty-directory)))
    (when (equal system-type "gnu/linux")
      (message "Tramp GNU/Linux Config")))

(use-package paredit
  :straight t
  :hook (lisp-mode . enable-paredit-mode))

(use-package easy-hugo
:straight t
:custom
(easy-hugo-basedir "C:/Users/zzzap/Documents/Code/source-projects/ACTIVE/tomrake.github.io/")
(easy-hugo-postdir "content/blog/")
)

(message "Debug <<<<<<<<< START COMMONLISP STUFF")

(defvar common-lisp-mode-tool :slime "This can be :slime or :sly.")

(defvar my-lisp-implementations nil
	"For various implemenations there are lisp invokers for slime and sly.")

  (defmacro assemble-invoker (my-tag program program-args environment)
     "The format of a standard slime entry for a lisp implenatation."
     `(list ,my-tag (cons ,program ,program-args) :env ,environment))

;;;; [TBD] Replace the assemble invokers with an optional program-args and enviroment 
  (defun make-lisp-invoker (tag program &optional program-args environment)
    `(,tag ,(cons ,program  ,program-args) ,(if environment (list :env environment))))

  (defmacro assemble-invoker-no-env (my-tag program program-args environment)
    "The format of a standard slime entry for a lisp implenatation."
    `(list ,my-tag (cons ,program ,program-args)))


  (defun collect-this-lisp (lisp-invoker)
	"Add an specific lisp invoker to slime list"
	(add-to-list 'my-lisp-implementations lisp-invoker))

;;;; The standard options for SBCL
(setq sbcl-program-arguments '("--dynamic-space-size" "4000" "--noinform"))

(defun assemble-sbcl-enviroment-invoker (my-tag program environment)
  (assemble-invoker my-tag program sbcl-program-arguments environment))

(defun get-sbcl-versions (base-address)
    "Get all the directories under the base-address"
    (remove "." (remove ".." (directory-files  base-address ))))

  (defun get-sbcl-configs (version-address)
    (remove "." (remove ".." (directory-files version-address))))

  (defun assemble-named-sbcl-version (prefix base-address version config)
    "Create a SBCL invoker for specific compiled version."
    (assemble-sbcl-enviroment-invoker
     (intern (concat prefix version "-" config))
     (concat base-address "/" version "/" config (sbcl-exe))
     (list (concat "SBCL_HOME=" base-address "/" version "/" config "/lib/sbcl/"))))

(defun augment-versions (vers)
  "Add the numeric version  pieces to each element."
  (let ((aug-vers 
	   (mapcar (lambda (v)
	      (cons v (mapcar
		       (lambda (s) (string-to-number s)) (split-string v "\\." ))))
		   vers)))
    aug-vers))

 (defun sort-by-nth (n aug-vers)
   "sort the aug-vers by the nth item"
   (sort aug-vers (lambda (a b) ( < (nth n a) (nth n b)))))

  (defun filter-non-versions (l)
    "Remove any string from the list that container other that 0-9 or ."
    (seq-filter (lambda (a) (not (string-match "[^0-9.]" a))) l))

  (defun sort-version (vers)

    (mapcar (lambda (av)  (car av))
	      (sort-by-nth 1 (sort-by-nth 2 (sort-by-nth 3 (augment-versions (filter-non-versions vers)))))))


  (defun sbcl-exe ()
    (if (string-equal system-type "windows-nt")
	  "/bin/sbcl.exe"
	  (if (string-equal system-type "gnu/linux")
	      "/bin/sbcl"
	      (error "Unknown system type"))))


  (defun add-win64-sbcl (base-address)
    "Add a SBCL invoker for all versions under the base-address"
    (let ((versions (sort-version (get-sbcl-versions base-address))))
	(message "versions: %s"versions)
	(dolist (version versions)
	  (let ((configs (get-sbcl-configs (concat base-address "/" version))))
	    (dolist (config configs)
	      (when (and (file-exists-p (concat base-address "/" version "/" config  (sbcl-exe)))
			 (or (string= config "production") (file-exists-p (concat base-address "/" version "/" config "/.production"))))
		(collect-this-lisp (assemble-named-sbcl-version "sbcl64-" base-address version config))))))))

  (defun collect-sbcl ()
    "Add all the slime invokers for SBCL 64bit compiled versions."
    (checksym-existing-directory "local-config-sbcl-location"
		(add-win64-sbcl it)))

(defun ccl-invoker (my-tag path)
  "Return a lisp invoker; nil if path does not exist"
    (when (file-exists-p path)
	`(,my-tag (,path))))

(defun add-ccl ()
  "Collect any CCL Lisp versions"
  (checksym-existing-file "local-config-ccl32-location" (collect-this-lisp (ccl-invoker 'ccl-32 it)))
  (checksym-existing-file "local-config-ccl64-location" (collect-this-lisp (ccl-invoker 'ccl-64 it))))

(defun invoke-abcl()
  "Return a lisp invoker; nil if abcl is not found,"
  (let ((abcl local-config-abcl-location))
    (when (file-exists-p abcl)
	`(abcl  ,(list java-executable "-jar" abcl)))))

(defun add-abcl ()
  "Check of abcl implmentations"
  (let ((has-java (checksym-existing-file "java-executable" it)))
    (when has-java
	(checksym-existing-file "local-config-abcl-location"
				(collect-this-lisp `(abcl ,(list has-java "-jar" it)))))))

(message "Debug  START GATHERING INVOKERS")

(defun collect-lisp-invokers ()
    "collect all lisp-invokers to my-lisp-implementations."
  (setf my-lisp-implementations nil)
  (add-abcl)
  (add-ccl)
  (collect-sbcl)
  my-lisp-implementations)

(message "Debug SLIME MARK")

(use-package slime-repl-ansi-color
:straight t
:defer t)

(use-package slime
  :if (eq common-lisp-mode-tool :slime)
  :straight t
  :config
  (when (equal system-type 'gnu/linux)
    (message "Linux Slime")
    (defvar slime-lisp-location nil)
    (when (file-exists-p local-config-sbcl-location)
	(setq slime-lisp-location local-config-sbcl-location))
    (unless slime-lisp-location
      (setq slime-lisp-location "sbcl"))
    (setq inferior-lisp-program slime-lisp-location)

   
    (require 'slime-repl-ansi-color)
    (add-hook 'slime-repl-mode-hook
	      #'(lambda () (setf slime-repl-ansi-color-mode 1))))
  (when (equal system-type 'windows-nt)
    (message "Windows Slime.")
    (setf slime-lisp-implementations (collect-lisp-invokers))
    (require 'slime-repl-ansi-color)
    (add-hook 'slime-repl-mode-hook
    	      #'(lambda () (setf slime-repl-ansi-color-mode 1)))))

(message "Debug SLIME END MARK")

(setq auto-mode-alist
	(append '((".*\\.asd\\'" . lisp-mode))
		auto-mode-alist))

(setq auto-mode-alist
	(append '((".*\\.cl\\'" . lisp-mode))
		auto-mode-alist))

(setq auto-mode-alist
      (append '((".*\\.rkt\\'" . racket-mode))
	      auto-mode-alist))

(when (getenv "HyperSpec")
 (setq common-lisp-hyperspec-root (convert-standard-filename (getenv "HyperSpec"))))

(straight-use-package 'dap-mode)

(use-package dap-mode
 :straight t
 :config
 (dap-auto-configure-mode))

(use-package treesit-auto
  :straight t
  :config
    (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package racket-mode
  :straight t
  ;:config
  ;(setf racket-program "C:/Program Files/Racket/Racket.exe" )
)

(use-package deferred
  :straight t)
(use-package request
  :straight t)
(use-package zotxt
:straight t
:after (request deferred))

(add-hook 'pascal-mode-hook
	  (lambda ()
	    (set (make-local-variable 'compile-command)
		 (concat "fpc " (file-name-nondirectory (buffer-file-name)))))
	  t)

(setq auto-mode-alist
      (append '((".*\\.pas\\'" . pascal-mode))
	      auto-mode-alist))

(setq auto-mode-alist
      (append '((".*\\.pp\\'" . pascal-mode))
	      auto-mode-alist))

(setq auto-mode-alist
      (append '((".*\\.yml\\'" . yaml-mode))
	      auto-mode-alist))

(use-package simple-httpd
  :straight t)

;;;; PS Print with GHOSTSCRIPT
(when (eq system-type 'windows-nt)
	    (setq ps-lpr-command "C:/Program Files/gs/gs9.56.1/bin/gswin64c.exe")
	    (setq ps-lpr-switches '("-q" "-dNOPAUSE" "-dBATCH" "-sDEVICE=mswinpr2" "-sOutputFile=\"%printer%Canon\ TS6000\ series\""))
	    (setq ps-printer-name t))
(setf ps-font-family 'Courier)
(setf ps-font-size 10.0)
(setf ps-line-number t)
(setf ps-line-number-font-size 10)

(defun ps-portrait-one-column()
  (interactive)
  (setq ps-landscape-mode nil)
  (setq ps-number-of-columns 1))

(defun ps-landscape-one-column()
  (interactive)
  (setq ps-landscape-mode t)
  (setq ps-number-of-columns 1))

(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))

(defun efs/configure-eshell ()
	   ;; Save command history when commands are entered
	   (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

	   ;; Truncate buffer for performance
	   (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

	   (setq eshell-history-size         10000
		 eshell-buffer-maximum-lines 10000
		 eshell-hist-ignoredups t
		 eshell-scroll-to-bottom-on-input t))

(use-package eshell
	   :hook (eshell-first-time-mode . efs/configure-eshell))

(use-package eshell-git-prompt
  :straight t
  :config
    (eshell-git-prompt-use-theme 'powerline))

(message "Debug START")

(use-package dired
  :straight nil
  :after all-the-icons-dired)

(use-package all-the-icons-dired
  :straight t
  :after all-the-icons)

 (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

(use-package dired-single
  :straight nil
  :after
    dired
  :config
    (defun twr/dired-init ()
	(define-key dired-mode-map [remap dired-find-file]
	  'dired-single-buffer)
	(define-key dired-mode-map [remap dired-mouse-find-file-other-window]
	  'dired-single-buffer-mouse)
	(define-key dired-mode-map [remap dired-up-directory]
	  'dired-single-up-directory))
    (twr/dired-init)
    (setq dired-single-use-magic-buffer t)
    ;; F5 is my special key
    (global-set-key [(f5)] 'dired-single-magic-buffer)
    (global-set-key [(control f5)] (function
	(lambda nil (interactive)
	  (dired-single-magic-buffer default-directory))))
    (global-set-key [(shift f5)] (function
	(lambda nil (interactive)
	  (message "Current directory is: %s" default-directory))))
    (global-set-key [(meta f5)] 'dired-single-toggle-buffer-name))

(defun mydired-sort ()
	  "Sort dired listings with directories first."
	  (save-excursion
	    (let (buffer-read-only)
	      (forward-line 2) ;; beyond dir. header 
	      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
	    (set-buffer-modified-p nil)))

(defadvice dired-readin
	  (after dired-after-updating-hook first () activate)
	  "Sort dired listings with directories first before adding marks."
	  (mydired-sort))

(message "Debug TEST - YES!!!")

;;;; mastodon
  (use-package mastodon
    :straight t)
  (setq mastodon-active-user "tomrake")
  (setq mastodon-instance-url "https://mastodon.social")

(when (require 'openwith nil 'noerror)

     (setq openwith-associatsions
	 (list (list (openwith-make-extension-regexp '("mpg" "mpeg" "mp3" "mp4"
					      "avi" "wmv" "wav" "mov" "flv"
					      "ogm" "ogg" "mkv")) "vlc.exe")
	       (list (openwith-make-extension-regexp '("JPEG" "JPG"))
		     "c:/Program Files (x86)/JPEGView/JPEGView.exe" '(file))))
;;    (message "OPENWITH CONFIG")
;;    (message openwith-associatsions)
    (openwith-mode 1))

(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(use-package yaml-mode)

(defun json-to-single-line (beg end)
  "Collapse prettified json in region between BEG and END to a single line"
  (interactive "r")
  (if (use-region-p)
      (save-excursion
        (save-restriction
          (narrow-to-region beg end)
          (goto-char (point-min))
          (while (re-search-forward "[[:space:]\n]+" nil t)
            (replace-match " "))))
    (print "This function operates on a region")))

;;;; Various user settings is a local configuration.
(local-custom-file "local-settings.org" "Final user settings")

(require 'filename2clipboard)

(use-package erc
    :straight t
    :config
    (setq erc-fill-column 120
	erc-fill-function 'erc-fill-static
	erc-fill-static-center 20))

(use-package erc-hl-nicks
  :straight t
  :after erc
  :config
  (add-to-list 'erc-modules 'hl-nicks))

(use-package erc-hl-nicks
  :straight t
  :after erc
  :config
  (add-to-list 'erc-modules 'hl-nicks))

(use-package emojify
  :straight t
  :hook (erc-mode . emojify-mode)
  :commands emojify-mode)

(use-package emms
  :straight t
  :if (eq system-type 'gnu/linux)
  :config
  (emms-all)
  (setq emms-player-list '(emms-player-vlc)
	emms-info-functions '(emms-info-native)))

(use-package vterm
  :straight t
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
  ;;(setq vterm-shell "zsh")
  (setq vterm-max-scrollback 10000))

(load "pico-emacs")

(message "Debug Before ORG")

(load (expand-file-name "org-init" user-emacs-directory))

(setq gc-cons-threshold (* 2 1000 1000))

(message "Debug END")

(setq twr/init-loading-flag nil)
(message "<<<<  !!!     INIT.EL FINISHED   !!!   >>>>> ")

(load "~/.emacs-local")
