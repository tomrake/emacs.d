;; NOTE: init.el is now generated from Emacs.org.  Please edit that file
;;       in Emacs and init.el will be generated automatically!

;;;; Emacs Debug On Error
   (setq debug-on-error nil )

;;;; This code will error for any non-multi-init-cluster profiles.
;;;; load the user-custom-startup file.
;;;; The local-config is
;;;; loaded from the file <user-emacs-directory>/multi-init-cluster/<system-name>-<user-login-name>-<chemacs-profile-name>-user-startup.el
;;;; That file must exist.
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
  ;; (message "string-equal: %s %s" (buffer-file-name) (expand-file-name (concat user-emacs-directory "Emacs.org")))
  (when (string-equal (buffer-file-name)
		      (expand-file-name (concat user-emacs-directory "Emacs.org")))
    (message "Begin efs/tangle")

    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))
(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(message "Debug START")

(add-to-list 'load-path (expand-file-name "scripts/" user-emacs-directory))

(defvar use-slime t "Set true to use slime for superior lisp")
(defvar use-sly nil "Set true to use sly for superior lisp")

(setq gc-cons-threshold (* 50 1000 1000))

;; You will most likely need to adjust this font size for your system!
(defvar efs/default-font-size 180)
(defvar efs/default-variable-font-size 180)

;; Make frame transparency overridable
(defvar efs/frame-transparency '(90 . 90))

(setq initial-buffer-choice (concat user-emacs-directory "startup-buffer.org"))

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

;;;; define emacs customization file and load it.
(setq custom-file (expand-file-name "emacs-custom.el" user-emacs-directory))
(load custom-file)

;;;; Initialize package sources
(require 'package)
;(setq package-check-signature nil)
(setq package-gnupghome-dir "~/.gnupg/")
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(package-install 'htmlize)
;;;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
;;;; use-package
(require 'use-package)
(setq use-package-always-ensure t)
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

(add-hook 'emacs-startup-hook 'toggle-frame-maximized)

;;;; Have a clean statup screen
; (setq inhibit-startup-screen t)
(setq visible-bell 1)
 ;;;; Turn off tool bar
(tool-bar-mode 0)
(setq use-file-dialog nil)

(setq w32-use-visible-system-caret nil)

;;;; auto revert mode
(global-auto-revert-mode 1)

;;;; dired auto revert
(setf global-auto-revert-non-file-buffers t)

(use-package  ido
    :config
  (ido-mode t))

(use-package which-key
  :ensure t)

;;;; Enable vertico
(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package savehist
  :init
  (savehist-mode))

(checksym-not-empty-string config-obsidian-specify-path 
  (use-package obsidian
    :ensure t
    :demand t
    :config
    (obsidian-specify-path config-obsidian-specify-path)
    (global-obsidian-mode t)
    :custom
    ;; This directory will be used for `obsidian-capture' if set.
    (obsidian-inbox-directory "Inbox")
    ;; Create missing files in inbox? - when clicking on a wiki link
    ;; t: in inbox, nil: next to the file with the link
    ;; default: t
					;(obsidian-wiki-link-create-file-in-inbox nil)
    ;; The directory for daily notes (file name is YYYY-MM-DD.md)
    (obsidian-daily-notes-directory "Daily Notes")
    ;; Directory of note templates, unset (nil) by default
					;(obsidian-templates-directory "Templates")
    ;; Daily Note template name - requires a template directory. Default: Daily Note Template.md
					;(obsidian-daily-note-template "Daily Note Template.md")
    :bind (:map obsidian-mode-map
		;; Replace C-c C-o with Obsidian.el's implementation. It's ok to use another key binding.
		("C-c C-o" . obsidian-follow-link-at-point)
		;; Jump to backlinks
		("C-c C-b" . obsidian-backlink-jump)
		;; If you prefer you can use `obsidian-insert-link'
		("C-c C-l" . obsidian-insert-wikilink))))

(setq ispell-program-name "aspell")

;; The java interface assumption is you can execute the program "java"
;; There is no jdk to be considered.
(defvar java-executable (executable-find "java")
  "The java-executable to use for java.")

(use-package langtool
  :ensure t
  :config
    (setq langtool-java-bin java-executable)
    (setq langtool-language-tool-jar  "c:/Users/Public/Documents/LanguageTool-5.9/languagetool-commandline.jar")
  :bind
    (( "\C-x4w" . langtool-check)
     ("\C-x4W" . langtool-check-done)
     ("\C-x4l" . langtool-switch-default-language)
     ("\C-x44" . langtool-show-message-at-point)
     ("\C-x4c" . langtool-correct-buffer)))

(require 'quoting-tools)

(require 'gnu-tools)

;;;; Magit 
(use-package magit
  :defer 2
  :ensure t
  :pin melpa
  :bind
   (("C-x g" . magit-status)
    ("C-x M-d" . magit-dispatch-popup)))

;;;; SSH Agency
(use-package ssh-agency
:ensure t
:init
(setenv "GIT_ASKPASS" "git-gui--askpass")
(setenv "SSH_ASKPASS" "git-gui--askpass")
:after (magit))

(if (getenv "MSYSTEM")
  (when (file-exists-p (expand-file-name "~/.roswell/helper.el"))
    (load (expand-file-name "~/.roswell/helper.el"))))

(use-package modus-themes
  :ensure t
  :config
  (set-face-attribute 'default nil :height 150)
      ;; Subtle red background, red foreground, invisible border

  (setq modus-themes-region '(bg-only))
  (setq modus-themes-paren-match '(bold intense))
  (setq modus-themes-lang-checkers '(background intense))
  (setq modus-themes-italic-constructs t)
  (setq modus-themes-bold-contructs t)
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
  (setq explicit-shell-file-name "c:/devel/msys64/usr/bin/bash")

;;;; eshell
(setenv  "PATH" (concat
		 "C:/devel/msys64/ucrt64/bin" ";"
		 "C:/devel/msys64/bin" ";"
		 (getenv "PATH")))

(use-package shx
  :ensure t)

(use-package tramp
  :config
    (when (eq  window-system 'w32)
      (setq putty-directory "c:/Program Files/PuTTY/")
      (setq tramp-default-method "plink")
      (when (and (not (string-match putty-directory (getenv "PATH")))
		 (file-directory-p putty-directory))
	(setenv "PATH" (concat putty-directory ";" (getenv "PATH")))
	(add-to-list 'exec-path putty-directory))))

(use-package paredit
  :ensure t
  :hook (lisp-mode . enable-paredit-mode))

(message "Debug <<<<<<<<< START COMMONLISP STUFF")

(defvar my-lisp-implementations nil
  "For various implemenations there are lisp invokers for slime and sly.")

(defmacro assemble-invoker (my-tag program program-args environment)
 "The format of a standard slime entry for a lisp implenatation."
`(list ,my-tag (cons ,program ,program-args) :env ,environment))

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
   (concat base-address "/" version "/" config "/bin/sbcl.exe")
   (list (concat "SBCL_HOME=" base-address "/" version "/" config "/lib/sbcl/")
	 "CC=c:/devel/msys64/ucrt64/bin/gcc")))

(defun add-win64-sbcl (base-address)
  "Add a SBCL invoker for all versions under the base-address"
  (let ((versions (get-sbcl-versions base-address)))
    (dolist (version versions)
      (let ((configs (get-sbcl-configs (concat base-address "/" version))))
	(dolist (config configs)
	  (when (and (file-exists-p (concat base-address "/" version "/" config  "/bin/sbcl.exe"))
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
  (collect-sbcl))
;;;; Collect all right now
(collect-lisp-invokers)

(message "Debug SLIME MARK")

(when (and use-slime (boundp 'local-config-slime-location) local-config-slime-location (file-directory-p local-config-slime-location))
  (add-to-list 'load-path local-config-slime-location)
  (collect-lisp-invokers)
  (setq slime-lisp-implementations my-lisp-implementations)
  ;; (when (file-exists-p "c:/Users/Public/Lispers/quicklisp/slime-helper.el")
  ;;   (load "c:/Users/Public/Lispers/quicklisp/slime-helper.el"))
  (require 'slime)
  (require 'slime-autoloads)

  (setq slime-contribs '(slime-fancy slime-repl-ansi-color))

  (setq slime-repl-ansi-color-mode 1)
  (global-set-key "\C-cs" 'slime-selector))

(use-package sly
  :disabled use-slime
  :init
    (collect-lisp-invokers)
    (setq sly-lisp-implementations my-lisp-implementations))

(message "Debug SLIME END MARK")

(setq auto-mode-alist
      (append '((".*\\.asd\\'" . lisp-mode))
	      auto-mode-alist))

(setq auto-mode-alist
      (append '((".*\\.cl\\'" . lisp-mode))
	      auto-mode-alist))

(when (getenv "HyperSpec")
 (setq common-lisp-hyperspec-root (convert-standard-filename (getenv "HyperSpec"))))

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

(use-package org
  :pin elpa
  :catch
  (lambda (keyword err)
         (message (error-message-string err)))
  :config

(message "Debug ORG START")

;; Create stadard org directories if not already present.
;; The standard user directory is ~/Documents/org .
(message "!!!! DO NOT CREATE org directories!!!")
;; (checksym-defined "local-config-org-user-dir"
;; 		  (defvar org-user-dir it "The base of org user files.")
;; 		  (unless (file-directory-p org-user-dir)
;; 		    (make-directory  org-user-dir)))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Replace list hyphen with dot
(font-lock-add-keywords 'org-mode
			'(("^ *\\([-]\\) "
			  (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(dolist (face '((org-level-1 . 1.2)
		(org-level-2 . 1.1)
		(org-level-3 . 1.05)
		(org-level-4 . 1.0)
		(org-level-5 . 1.1)
		(org-level-6 . 1.1)
		(org-level-7 . 1.1)
		(org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

;; Make sure org-indent face is available
(require 'org-indent)

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

;;;; Org Mode key bindings.
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c b") 'org-switchb)

(setq org-src-tab-acts-natively t)

;; org-export with no TOC, no NUM and no SUB/SUPERSCRIPTS
(setf org-export-with-toc nil)
(setf org-export-with-section-numbers nil)
(setf org-export-with-sub-superscripts nil)

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("qb" . "quote"))

;; Kill the frame if one was created for the capture
(defvar kk/delete-frame-after-capture 0 "Whether to delete the last frame after the current capture")

(defun kk/delete-frame-if-neccessary (&rest r)
  (cond
   ((= kk/delete-frame-after-capture 0) nil)
   ((> kk/delete-frame-after-capture 1)
    (setq kk/delete-frame-after-capture (- kk/delete-frame-after-capture 1)))
   (t
    (setq kk/delete-frame-after-capture 0)
    (delete-frame))))

(advice-add 'org-capture-finalize :after 'kk/delete-frame-if-neccessary)
(advice-add 'org-capture-kill :after 'kk/delete-frame-if-neccessary)
(advice-add 'org-capture-refile :after 'kk/delete-frame-if-neccessary)

(use-package org-present
  :ensure t
  :config
    (use-package visual-fill-column
      :ensure t
      :config
      (setq visual-fill-column-width 110
	    visual-fill-column-center-text t)))

;;;; Add Windows cmdproxy  
  (require 'ob-shell)
  (defadvice org-babel-sh-evaluate (around set-shell activate)
    "Add header argument :shcmd that determines the shell to be called."
    (defvar org-babel-sh-command)
    (let* ((org-babel-sh-command (or (cdr (assoc :shcmd params)) org-babel-sh-command)))
      ad-do-it))

;;;; Add image link type to org.
  (org-add-link-type
   "image-url"
   (lambda (path)
     (let ((img (expand-file-name
	     (concat (md5 path) "." (file-name-extension path))
	     temporary-file-directory)))
       (if (file-exists-p img)
       (find-file img)
	 (url-copy-file path img)
	 (find-file img)))))

;;;; Configure Babel Languages
   (org-babel-do-load-languages
    'org-babel-load-languages
    '((lisp . t)
      (emacs-lisp . t)
      (shell . t)
      (dot . t)))

(setq org-modules '(org-habit))

;;;; Add Magic F5 key to copy ID link in an org file.
(defun my/copy-idlink-to-clipboard() "Copy an ID link with the
headline to killring, if no ID is there then create a new unique
ID.  This function works only in org-mode or org-agenda buffers. 
 
The purpose of this function is to easily construct id:-links to 
org-mode items. If its assigned to a key it saves you marking the
text and copying to the killring."
       (interactive)
       (when (eq major-mode 'org-agenda-mode) ;switch to orgmode
     (org-agenda-show)
     (org-agenda-goto))       
       (when (eq major-mode 'org-mode) ; do this only in org-mode buffers
     (setq mytmphead (nth 4 (org-heading-components)))
         (setq mytmpid (funcall 'org-id-get-create))
     (setq mytmplink (format "[[id:%s][%s]]" mytmpid mytmphead))
     (kill-new mytmplink)
     (message "Copied %s to killring (clipboard)" mytmplink)))
  
(global-set-key (kbd "<f5>") 'my/copy-idlink-to-clipboard)

(setq org-habit-graph-column 50)

(setq gtd-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)")))

(setq gtd-todo-keyword-faces '(("TODO" . "red")
			       ("NEXT" . "magenta")
			       ("WAITING" ."yellow1")
			       ("CANCELLED"."green")
			       ("DONE" . "green")));

(when multi-user-org-path
  (defun multi-user-org-file-path (r-path)
    "Locate multi-user-org-file-paths."
    (format "%s%s" multi-user-org-path r-path)))

(defun gtd-file (name)
  "Where to find a gtd file."
  (multi-user-org-file-path (concat "gtd/" name)))

(defun med-file (name)
  "Where to find a medical file."
  (multi-user-org-file-path (concat "medical/" name)))

(defun car-file (name)
  "Where to find a car data file."
   (multi-user-org-file-path (concat "car/" name)))

(setq gtd-refile-targets `((,(gtd-file "gtd.org") :maxlevel . 3)
			   (,(gtd-file "Someday.org") :maxlevel . 3)
			   (,(gtd-file "Tickler.org") :maxlevel . 3)
			   (,(gtd-file "Appointments.org") :maxlevel . 1)))

;;;; Set the Capture Templates
   (defun transform-square-brackets-to-round-ones(string-to-transform)
     "Transforms [ into ( and ] into ), other chars left unchanged."
     (concat 
      (mapcar #'(lambda (c) (if (equal c ?\[) ?\( (if (equal c ?\]) ?\) c))) string-to-transform)))


 ;;;; See: http://cachestocaches.com/2016/9/my-workflow-org-agenda/
   (setq gtd-capture-templates
	 `(
       ;; Logs for Projects
	   ("l" "Project Logging")
	   ("ls" "sbcl-compile project"
	   entry (file+datetree "c:/Users/zzzap/Documents/Code/source-projects/ACTIVE/sbcl-compile/project-log.org" "Project Log")
	   "** %U - %^{Activity} :NOTE:")
       ;; Todo
	  ("t" "Inbox Entry" entry (file+headline ,(gtd-file "Inbox.org") "Tasks")
	   "* TODO %^{Brief Description} %^g\n  OPENED: %U")
       ;; Tickler
	  ("T" "Tickler Entry" entry (file+headline ,(gtd-file "Tickler.org") "TICKLERS")
	   "* TODO %^{Brief Description} %^g\n  OPENED: %U")
       ;; Journal Capture
	  ("j" "Journal" entry (file+datetree ,(gtd-file "Journal.org") )
	     "* %?\nEntered on %U\n  %i\n  %a")
       ;; Medical Appointments  (m) Medical template
	  ("m" "Medical Appointments")
	  ("mo" "(o) Office Appointent" entry (file+headline ,(gtd-file "Appointments.org") "APPOINTMENTS")
	   (file ,(concat user-emacs-directory "Office-Appointment.txt")) :empty-lines 1 :time-prompt t)
	  ("mt" "(t) Testing Appointent" entry (file+headline ,(gtd-file "Appointments.org") "APPOINTMENTS")
	   (file ,(concat user-emacs-directory "Testing-Appointment.txt")) :empty-lines 1 :time-prompt t)
       ;; Health Data Capture
	  ("h" "Health Data Capture (h)")

	  ("hb" "Blood Pressure (b)" table-line (file+headline ,(med-file "Medical-Data.org") "Blood Pressure")
	    "|%^{Person|TOM|JOANNE}|%U|%^{Systtolic}|%^{Diastolic}|%^{Pulse}|")

	  ("ht" "Temperature (t)" table-line (file+headline ,(med-file "Medical-Data.org") "Temperature")
	   "|%^{Person|TOM|JOANNE}|%U|%^{Temperature}|")

	  ("hw" "Weight (w)" table-line (file+headline ,(med-file "Medical-Data.org") "Weight")
	   "|%^{Person|TOM|JOANNE}|%U|%^{Weight}|")
       ;; Car Related
	  ("a" "Automotive (a)")

	  ("ag" "Gas Receipt (g}" table-line (file+headline ,(car-file "Auto-Receipt.org") "Gas Receipts")
	  "|%^u|%^{mileage}|%^{gallons}|%^{total}|")
       ;; org-protocol 
	  ("p" "Protocol" entry (file+headline ,(gtd-file "notes.org") "Inbox")
     "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")

	  ("L" "Protocol Link" entry (file+headline ,(gtd-file  "notes.org") "Inbox")
   "* %? [[%:link][%:description]] %(progn (setq kk/delete-frame-after-capture 2) \"\")\nCaptured On: %U"
   :empty-lines 1)))

(setq org-agenda-start-with-log-mode t)
(setq org-log-done 'time)
(setq org-log-into-drawer "LOGBOOK")

(defmacro twr-todo-overview (file-list)
  `(list '(todo "WAITING" ((org-agenda-files ,file-list)))
    '(todo "NEXT" ((org-agenda-files ,file-list)))
    '(todo "CANCELLED" ((org-agenda-files ,file-list)))
    '(todo "TODO" ((org-agenda-files ,file-list)))
    '(todo "DONE" ((org-agenda-files ,file-list)))))

(message "[TBD] %s" "Fix GTD Agenda file calculation. ")
 ;; There are current available tasks and Annual Events
(setq gtd-tasks-and-events
	 (mapcar #'gtd-file ' ("gtd.org" "Tickler.org" "Annual-Days.org" "Appointments.org" "Inbox.org")))

       ;;   (list (gtd-file "gtd.org")
   ;; 	    (gtd-file "Tickler.org")
   ;; 	    (gtd-file "Annual-Days.org")
   ;; 	    (gtd-file "Appointments.org")
   ;; 	    (gtd-file "Inbox.org"))

   ;; These are current available tasks	 
   (setq gtd-tasks
	 (mapcar #'gtd-file '("gtd.org" "Inbox.org" "Appointments.org" "Tickler.org")))

   ;;   (list (gtd-file "gtd.org")
   ;; 	    (gtd-file "Inbox.org")
   ;; 	    (gtd-file "Appointments.org")
   ;; 	    (gtd-file "Tickler.org")))


   ;;; All items except for appointments
   (setq gtd-no-appointments
	 (mapcar #'gtd-file '("gtd.org" "Tickler.org" "Annual-Days.org" "Inbox.org")))
;;	 (list (gtd-file "gtd.org")
;;	       (gtd-file "Tickler.org")
;;	       (gtd-file "Annual-Days.org")
;;	       (gtd-file "Inbox.org")))

   ;; Full Events include Someday tasks which are long term and not scheduled.
   (setq full-agenda-files (cons (gtd-file "Someday.org") gtd-tasks-and-events))
   (setq org-agenda-skip-scheduled-if-done t)
   (setq org-agenda-todo-list-sublevels t)
   (setf org-agenda-files gtd-tasks-and-events)

   (defun org-current-is-todo ()
     (string= "TODO" (org-get-todo-state)))

;;;; Define Custom Agenda views
     (setq gtd-custom-agenda-commands
	   `(
	     ("x" . "Experimental")
	     ("xx" "xx" agenda)
	     ("xy" "xy" agenda*)
	     ("xn" "xn" todo "NEXT")
	     ("xN" "xN" todo-tree "NEXT")
	     ("xa" "Daily Overview"
	      ;; The first part is an agenda calendar view
	      ((agenda* "" ((org-agenda-files gtd-tasks-and-events)
			   (org-agenda-ndays 1)
			   (org-agenda-sorting-strategy
			    `((agenda time-up priority-down tag-up)))
			   (org-deadline-warning-days 0)))
				       ; exclude ticker files from todo list because they are covered in agenda
	       (todo "WAITING" ((org-agenda-files gtd-no-appointments)))
	       (todo "NEXT" ((org-agenda-files gtd-no-appointments)))

  (todo "TODO" ((org-agenda-files gtd-no-appointments)))))
	     ("xA" "All Appointments" tags "+APPOINTMENT")
	     ("xc" "Weekly schedule" agenda ""
	       ((org-agenda-span 7) ;; agenda will start in week view
		(org-agenda-repeating-timestamp-show-all t)))
	     ("xf" "Evaluate all Tasks" agenda ""
	       ((org-agenda-files gtd-tasks-and-events)))

	     ("H" 
	      "All Contexts"
	      ((agenda)
	       (tags-todo "CAR")
	       (tags-todo "JAMES")
	       (tags-todo "TOM")
	       (tags-todo "JOANNE")
	       (tags-todo "ATTIC")
	       (tags-todo "HOME")
	       (tags-todo "COMPUTER")
	       (tags-todo "OUTDOOR")))
	     ("D" . "Daily Tasks")
	     ("Dt" "Any Project Task"
	      ((agenda ""
		       ((org-deadline-warning-days 7)))
	       (todo)))
	     ("Da" "A Scheduled Project task"
	      ((agenda "" ((org-agenda-files gtd-tasks-and-events)
			   (org-agenda-ndays 1)
			   (org-agenda-sorting-strategy
			    `((agenda time-up priority-down tag-up)))
			   (org-deadline-warning-days 0)))
				       ; exclude ticker files from todo list because they are covered in agenda
	       (todo "NEXT" ((org-agenda-files gtd-tasks)))))
	     ("Do" "Daily Overview"
	      ;; The first part is an agenda calendar view
	      ((agenda "" ((org-agenda-files gtd-tasks-and-events)
			   (org-agenda-ndays 1)
			   (org-agenda-sorting-strategy
			    `((agenda time-up priority-down tag-up)))
			   (org-deadline-warning-days 0)))
	       ,@(twr-todo-overview gtd-no-appointments)))
	     ("W" . "Weekly Tasks")
	     ("Wo" "Weekly Overview"
	       ;; The first part is an agenda calendar view
	       ((agenda "" ((org-agenda-files full-agenda-files)
			(org-agenda-ndays 1)
			(org-agenda-sorting-strategy
			 `((agenda time-up priority-down tag-up)))
			(org-deadline-warning-days 0)))
		,@(twr-todo-overview full-agenda-files)))
	     ("g" . "GTD contexts")
	     ("ga" "Attic" tags-todo "ATTIC")
	     ("gh" "Home" tags-todo "HOME")
	     ("gc" "Computer" tags-todo "COMPUTER")
	     ("go" "Outdoor" tag-toto "OUTDOOR")
	     ("gp" "Projects" tags-todo "PROJECTS")
	     ("gf" "Financial" tags-todo "FINANCIAL")

	     ("p" . "Priorities")
	     ("pa" "A items" tags-todo "+PRIORITY=\"A\"")
	     ("pb" "B items" tags-todo "+PRIORITY=\"B\"")
	     ("pc" "C items" tags-todo "+PRIORITY=\"C\"")
	     ("y" agenda*)
	     ("c" "Weekly schedule" agenda ""
	      ((org-agenda-span 7) ;; agenda will start in week view
	       (org-agenda-repeating-timestamp-show-all t))))) ;; ensures that repeating events appear on all relevant dates

(defun clear-gtd-switch()
  "Remove the gtd customizations." 
       (setf org-agenda-custom-commands nil
	org-capture-templates nil
	org-refile-targets nil
	org-todo-keywords  nil
	org-todo-keyword-faces nil))

(defun make-gtd-switch()
  "Add the gtd customizations."
  (setf org-agenda-custom-commands gtd-custom-agenda-commands
	org-capture-templates gtd-capture-templates
	org-refile-targets gtd-refile-targets
	org-todo-keywords  gtd-todo-keywords
	org-todo-keyword-faces gtd-todo-keyword-faces))
;; And throw the switch
(make-gtd-switch)

) ;; This is close of a huge :config of (use-package org

(require 'ox-publish)

(defun dual-org-data (name org-part data-part common-part)
  "Creates a name publishing project with org files and data files in the same directory."
  `((,(concat name "-text")  ,@common-part ,@org-part)
    (,(concat name "-data")  ,@common-part ,@data-part)
    (,name :components (,(concat name "-text") ,(concat name "-data")))))


(setq org-publish-project-alist
      `(
	,@(dual-org-data      "org-web" '(
	 :base-extension "org"
	 :publishing-function org-html-publish-to-html
	 :headline-levels 4             ; Just the default for this project.
	 :auto-preamble t
	 :auto-sitemap t
	 :section-numbers nil
	 :makeindex t)
	 '(
	 :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
	 :auto-sitemap nil
	 :publishing-function org-publish-attachment)
	 '(:base-directory "~/Documents/Code/org-web/content"
			    :publishing-directory "c:/Users/Public/org-web"
			   :recursive t
			   :exclude ".*/\.git/.*|.*/.*~"
			   ))
	("blog-src"
	 ;; Path to org files.
	 :base-directory "~/Documents/Code/blog/org-source"
	 :base-extension "org"

	 ;; Path to Jekyll Posts
	 :publishing-directory "~/Documents/Code/blog/tomrake.github.io/_drafts/"
	 :recursive t
	 :publishing-function org-html-publish-to-html
	 :headline-levels 4
	 :html-extension "html"
	 :body-only t)
	("blog" :components ("blog-src"))))

(use-package simple-httpd
  :ensure t)

;;;; PS Print with GHOSTSCRIPT
  (setq ps-lpr-command "C:/Program Files/gs/gs9.56.1/bin/gswin64c.exe")
  (setq ps-lpr-switches '("-q" "-dNOPAUSE" "-dBATCH" "-sDEVICE=mswinpr2" "-sOutputFile=\"%printer%Canon\ TS6000\ series\""))
  (setq ps-printer-name t)
  (setf ps-font-family 'Courier)
  (setf ps-font-size 10.0)
  (setf ps-line-number t)
  (setf ps-line-number-font-size 10)

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
  :ensure t
  :config
    (eshell-git-prompt-use-theme 'powerline))

(use-package dired
  :ensure nil
  :config
    (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

(use-package dired-single
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

(use-package all-the-icons-dired
      :ensure t
      :pin melpa
      :config
      (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

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

;;;; mastodon
  (use-package mastodon
    :ensure t)
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

(setq ppl-holiday-table ;; '(2023					;year
 ;;   (1 1)					;new years day
 ;;   (2 20)				;presidents day
 ;;   (4 7)					; Good Friday
 ;;   (5 29)				; Memorial Day
 ;;   (7 4)					; Independence Day
 ;;   (9 4)					; Labor Day
 ;;   (11 24)				; Thanksgiving
 ;;   (11 25)				; Next Day
 ;;   (12 24)				; Christmas Eve
 ;;   (12 25))
 '(2024					;year
  (1 1)					;new years day
 (2 19)				;presidents day
 (3 29)					; Good Friday
 (5 27)				; Memorial Day
 (7 4)					; Independence Day
 (9 2)					; Labor Day
 (11 28)				; Thanksgiving
 (11 29)				; Next Day
 (12 24)				; Christmas Eve
 (12 25)))                              ; Christmas


  (defun is-holiday (dt table)
    "Check if a date is a holiday"
    (if table (or (and (= (nth 4 dt) (nth 0 (car table)))
		       (= (nth 3 dt) (nth 1 (car table))))
		  (is-holiday dt (cdr table)))))

  (defun is-ppl-holiday (dt)
    "Check if a date is a PPL holiday"
    (if (/= (car ppl-holiday-table) (nth 5 dt)) 
	(error "Update Date table") 
	(is-holiday dt (cdr ppl-holiday-table))))

  (defun ppl-summer (dt)
    "Check if a date is PPL summer rate"
    (< 5 (nth 4 dt) 12))

(defun ppl-high-rate (&optional dt)
  "Check if a date and time are at PPL high rate"
  (unless dt (setq dt (decode-time)))
       (cond ((not (< 0 (nth 6 dt) 6))  nil)
	     ((is-ppl-holiday dt)  nil)
	     ((ppl-summer dt)  (<= 14 (nth 2 dt) 17))
	      (t  ( <= 16 (nth 2 dt) 19))))

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

(setq gc-cons-threshold (* 2 1000 1000))

(message "Debug END")

(setq twr/init-loading-flag nil)
(message "<<<<  !!!     INIT.EL FINISHED   !!!   >>>>> ")
