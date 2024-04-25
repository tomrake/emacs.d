;; NOTE: init.el is now generated from Emacs.org.  Please edit that file
;;       in Emacs and init.el will be generated automatically!

;;;; Emacs Debug On Error
   (setq debug-on-error t )

;;;; load the user-custom-startup file.
(when chemacs-profile-name
(message (concat "chemacs-profile-name: " chemacs-profile-name)))
(let ((uc (getenv "USERINITCUSTOM")))
  (if uc
      (load uc)
    (message "USERINITCUSTOM is NIL.")))

(setq twr/init-loading-flag "default")
(defun twr/check-init-load ()
  (when twr/init-loading-flag
    (message (concat "INIT DID NOT FINISH!!!!!! " twr/init-loading-flag))))
(add-hook 'after-init-hook 'twr/check-init-load)

(message "Debug START")

;; Allow chezmoi_config.el to define things:
;;   msys2 paths and enviroments
;;   java locations
(condition-case err
    (load "chezmoi_config")
  (file-missing
   (message "%s" (error-message-string err))))

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

;; Enable vertico
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  )
(use-package savehist
  :init
  (savehist-mode))

;;; Specify a emacs variable from an environment variable env-string or  base,new-path-string
(defun ensure-string (s)
  (if s s ""))
(defmacro default-or-environment (emacs-var base new-path-string env-string)
  ;;`(concat ,base ,new-pathe-string))
   `(setq ,emacs-var (if (getenv ,env-string)
		      (getenv ,env-string)
		      (concat (ensure-string ,base) (ensure-string ,new-path-string)))))

(setq ispell-program-name "aspell")

;; The java interface assumption is you can execute the program "java"
;; There is no jdk to be considered.
  (if (executable-find "java")
      (setq my-java "java")
      (message "******** java not found *******"))

(use-package langtool
  :ensure t
  :config
    (setq langtool-java-bin my-java)
    (setq langtool-language-tool-jar  "c:/Users/Public/Documents/LanguageTool-5.9/languagetool-commandline.jar")
  :bind
    (( "\C-x4w" . langtool-check)
     ("\C-x4W" . langtool-check-done)
     ("\C-x4l" . langtool-switch-default-language)
     ("\C-x44" . langtool-show-message-at-point)
     ("\C-x4c" . langtool-correct-buffer)))

(require 'quoting-tools)

(require 'gnu-tools)

(use-package magit
  :defer 2
  :ensure t
  :pin melpa
  :config
  ;; (if (getenv "MSYSTEM")
  ;; (setq magit-git-executable "C:/devel/msys64/usr/bin/git.exe"
  ;; 	with-editor-emacsclient-executable "C:/devel/msys64/ucrt64/bin/emacsclientw.exe")

  ;; (setq magit-git-executable "C:/Program Files/Git/git-bash.exe"
  ;; 	with-editor-emacsclient-executable "C:/Program Files/Emacs/emacs-28.2/bin/emacsclient.exe")
  ;; )
   :bind
   (
   ("C-x g" . magit-status)
   ("C-x M-d" . magit-dispatch-popup)))

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

(use-package rainbow-delimiters)

(defun powershell()
  (interactive)
  (let ((explicit-shell-file-name "powershell.exe")
	(explicit-powershell.exe-args '()))
    (shell (generate-new-buffer-name "*powershell*"))))

(setq explicit-shell-file-name "c:/devel/msys64/usr/bin/bash")

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

(defvar local-config-sbcl-location "C:/Users/Public/Lispers/sbcl/installed"
    "All locally compiled and installed SBCL lisps are installed in directory,
  by release version and a compiled name..
I also add lisp version with a compiled name of 'production' or which contain a file '.production.'")

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
  (when (and (boundp 'local-config-sbcl-location) local-config-sbcl-location)
    (add-win64-sbcl local-config-sbcl-location)))

(defun ccl-invoker (my-tag path)
  "Return a lisp invoker; nil if path does not exist"
    (when (file-exists-p path)
      `(,my-tag (,path))))

(defun add-ccl ()
  "Collect any CCL Lisp versions"
  (let ((ccl32 (ccl-invoker 'ccl-32 local-config-ccl32-location))
	(ccl64 (ccl-invoker 'ccl-64 local-config-ccl64-location)))
    (when ccl32 (collect-this-lisp ccl32))
    (when ccl64 (collect-this-lisp ccl64))))

(defun invoke-abcl()
  "Return a lisp invoker; nil if abcl is not found,"
  (let ((abcl local-config-abcl-location))
    (when (file-exists-p abcl)
      `(abcl  ,(list my-java "-jar" abcl)))))
(defun add-abcl ()
  "Check of abcl implmentations"
  (let ((abcl (invoke-abcl)))
    (when abcl (collect-this-lisp abcl))))

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

(setq org-src-tab-acts-natively t)

;; org-export with no TOC, no NUM and no SUB/SUPERSCRIPTS
(setf org-export-with-toc nil)
(setf org-export-with-section-numbers nil)
(setf org-export-with-sub-superscripts nil)

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("qb" . "quote"))

(setf org-global-properties
    '(("Effort_ALL" . "0:05 0:10 0:15 0:30 1:00 2:00 4:00 6:00 8:00")))

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

(setf org-mode-base-dir "~/org/")

(setf org-gtd-dir (concat org-mode-base-dir "gtd/"))

;;;; Org Mode key bindings.
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c b") 'org-switchb)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((lisp . t)
   (emacs-lisp . t)
   (shell . t)
   (dot . t)
   ))

(setq org-modules '(org-habit))

(setq org-habit-graph-column 50)

(setq org-link-abbrev-alist
      '(("bugzilla" . "http://192.168.1.50/bugzilla/show_bug.cgi?id=")
	("bugzilla-comp" . "http://192.168.1.50/bugzilla/describecomponents.cgi?product=")
	("code" . "file:///C:/Users/zzzap/Documents/Code/quicklisp/local-projects/%s")
	("common-docs" . "file:///C:/Users/zzzap/Documents/Common-Document-Store/%s")))

;; Create stadard org directories if not already present.
;; The standard user directory is ~/org in the HOME directory.
;; Override with the var ORG-USER-DIR.
;; The org-public-dir is a legacy model for shared tasks across all users.
;; The public shared model is to be deprecated in the light of the task-agenda model.
(default-or-environment org-user-dir (getenv "HOME") "/org" "ORG-USER-DIR")
   (unless (file-directory-p org-user-dir)
     (make-directory  org-user-dir))
;; Define a global org directory
(default-or-environment org-public-dir "c:/Users/Public/Documents" "/org" "ORG-PUBLIC-DIR")

;; The Standard org note file is ~/org/notes/notes.
;; This can be set by the environment variable ORG-NOTES-FILE
(default-or-environment org-notes-file org-user-dir "/nodes/notes.org" "ORG-NOTES-FILE")
(setq org-default-notes-file org-notes-file)

(setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)")))

(setq org-todo-keyword-faces '(("TODO" . "red")
			       ("NEXT" . "magenta")
			       ("WAITING" ."yellow1")
			       ("CANCELLED"."green")
			       ("DONE" . "green")));

;;;; Customize the agenda locally
(local-custom-file "local-custom-agenda.org" "Customize org-agenda")

;;;; Customize the agenda locally
(let ((base (file-name-directory (or load-file-name (buffer-file-name)))))
  (default-or-environment gtd-template-dir base  "" "ORG-TEMPLATE-DIR")
  (local-custom-file "local-capture.org" "Customize org-capture"))

(require 'ob-shell)
(defadvice org-babel-sh-evaluate (around set-shell activate)
  "Add header argument :shcmd that determines the shell to be called."
  (defvar org-babel-sh-command)
  (let* ((org-babel-sh-command (or (cdr (assoc :shcmd params)) org-babel-sh-command)))
    ad-do-it))

;;;; org-publishing is a local configuration.
(local-custom-file "local-publishing.org" "Configuration of org-publishing")

(use-package org-present
  :ensure t
  :config
    (use-package visual-fill-column
      :ensure t
      :config
      (setq visual-fill-column-width 110
	    visual-fill-column-center-text t)))

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

)

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

;; Autommatically tangle our Emacs.org config file when we save it.
(defun efs/org-babel-tangle-config ()
  "Test if the buffer should be auto-tangled after save"
  (when (string-equal (buffer-file-name)
		      "c:/Users/Public/Lispers/standard-emacs.d/Emacs.org")
    (message "Begin efs/tangle")

    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))
(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

;;;; Various user settings is a local configuration.
 (local-custom-file "local-settings.org" "Final user settings")

(require 'filename2clipboard)

(setq gc-cons-threshold (* 2 1000 1000))

(message "Debug END")

(setq twr/init-loading-flag nil)
(message "NO INIT HANGS, IT DID FINISH!!!!!! ")
