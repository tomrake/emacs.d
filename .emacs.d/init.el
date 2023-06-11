;; NOTE: init.el is now generated from Emacs.org.  Please edit that file
;;       in Emacs and init.el will be generated automatically!
(setq gc-cons-threshold (* 50 1000 1000))
;; You will most likely need to adjust this font size for your system!
(defvar efs/default-font-size 180)
(defvar efs/default-variable-font-size 180)

;; Make frame transparency overridable
(defvar efs/frame-transparency '(90 . 90))

(message "Debug START")

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

(message "Debug MARK")

;;;; define emacs customization file and load it.
  (setq custom-file "~/.config/emacs/.emacs-custom.el")
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

;;;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
;;;; use-package
(require 'use-package)
(setq use-package-always-ensure t)
(setq use-package-verbose t)
(setq use-package-always-defer t)

;;;; Emacs Debug On Error
   (setq debug-on-error t)

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
(setq inhibit-startup-screen t)
(setq visible-bell 1)
;;;; Turn off tool bar
(tool-bar-mode)

(setq w32-use-visible-system-caret nil)

;;;; auto revert mode
(global-auto-revert-mode 1)

;;;; dired auto revert
(setf global-auto-revert-non-file-buffers t)

(use-package  ido
    :config
  (ido-mode t))

;; Enable vertico
  (use-package vertico
;    :ensure t
    :config
    (vertico-mode)
    :custom
    ;; Different scroll margin
    ;; (setq vertico-scroll-margin 0)

    ;; Show more candidates
    ;; (setq vertico-count 20)

    ;; Grow and shrink the Vertico minibuffer
     (setq vertico-resize t)

    ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
    ;; (setq vertico-cycle t)
    )

  ;; Persist history over Emacs restarts. Vertico sorts by history position.
  ;; (use-package savehist
  ;;   :ensure t
  ;;   :init
  ;;   (savehist-mode))

  ;; ;; A few more useful configurations...
  (use-package emacs
    :init
    ;; Add prompt indicator to `completing-read-multiple'.
    ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
    (defun crm-indicator (args)
      (cons (format "[CRM%s] %s"
		    (replace-regexp-in-string
		     "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
		     crm-separator)
		    (car args))
	    (cdr args)))
    (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

    ;; Do not allow the cursor in the minibuffer prompt
    (setq minibuffer-prompt-properties
	  '(read-only t cursor-intangible t face minibuffer-prompt))
    (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

    ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
    ;; Vertico commands are hidden in normal buffers.
    ;; (setq read-extended-command-predicate
    ;;       #'command-completion-default-include-p)

    ;; Enable recursive minibuffers
    (setq enable-recursive-minibuffers t))

(use-package magit
  :defer 2
  :ensure t
  :pin melpa
  :bind
  (("C-x g" . magit-status)
   ("C-x M-d" . magit-dispatch-popup)))

;;; Specify a emacs variable from an environment variable env-string or  base,new-path-string
(defmacro default-or-environment (emacs-var base new-path-string env-string) 
  `(setq ,emacs-var (if (getenv ,env-string)
                        (getenv ,env-string)
                        (concat ,base ,new-path-string))))

(fset 'convert-windows-filename
      (if (fboundp 'cygwin-convert-file-name-from-windows)
	  'cygwin-convert-file-name-from-windows
	  'convert-standard-filename))

(defun my-put-file-name-on-clipboard ()
  "Put the current file name on the clipboard"
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (with-temp-buffer
        (insert filename)
        (clipboard-kill-region (point-min) (point-max)))
      (message filename))))

(setq ispell-program-name "c:/devel/msys64/usr/bin/aspell.exe")

(setq langtool-language-tool-jar  "c:/Users/Public/Documents/LanguageTool-5.9/languagetool-commandline.jar")
(require 'langtool)
(global-set-key "\C-x4w" 'langtool-check)
(global-set-key "\C-x4W" 'langtool-check-done)
(global-set-key "\C-x4l" 'langtool-switch-default-language)
(global-set-key "\C-x44" 'langtool-show-message-at-point)
(global-set-key "\C-x4c" 'langtool-correct-buffer)

(defun double-quote-string(s)
   (concat "\"" s "\""))

(defun single-quote-string (s)
   (concat "\'" s "\'"))

(defun double-quote-list (l)
  (mapcar 'double-quote-string l))

(defun single-quote-list (l)
  (mapcar 'single-quote-string l))

(defun join-with-spaces (args)
   (mapconcat 'identity args " "))

(setq +cygwin64-base-path+ "C:/cygwin64")

;; Paths to msys2 file root
(let ((mingw64-root-mount "C:/devel/msys64")
      (mingw64-bin-mount "C:/devel/msys64/usr/bin"))

(add-to-list 'exec-path (concat mingw64-root-mount "/mingw64/bin"))
(add-to-list 'exec-path (concat mingw64-root-mount "/usr/local/bin"))
(add-to-list 'exec-path (concat mingw64-root-mount "/usr/bin"))
(add-to-list 'exec-path mingw64-bin-mount))
(setq +msys64-base-path+ "C:/devel/msys64/")

(defun cygwin64-file-exists-p (file)
  (file-exists-p (concat +cygwin64-base-path+ file)))

(defun msys-path (path)
  (concat +msys64-base-path+ path))

(defun msys64-file-exists-p (file)
  (file-exists-p (msys-path file)))

(defun msys2-command (cmd params)
   (join-with-spaces (cons (msys2-command-string cmd) params)))


(defun msys2-command-string (cmd)
  (concat (msys-path "usr/bin") cmd ".exe"))

(use-package modus-themes
    :config
    (set-face-attribute 'default nil :height 120)
    (setq modus-themes-mode-line '(accented borderless))
    (setq modus-themes-region '(bg-only))
  (setq modus-themes-paren-match '(bold intense))
  (setq modus-themes-lang-checkers '(background intense))
  (setq modus-themes-italic-constructs t)
  (setq modus-themes-bold-contructs t)
;;; Org Mode
  (setq modus-themes-heading
      `((1 . (rainbow bold intense 1.7))
	(2 . (rainbow bold intense 1.6))
	(3 . (rainbow bold intense 1.5))
	(4 . (rainbow bold intense 1.4))
	(5 . (rainbow bold intense 1.3))
	(6 . (rainbow bold intense 1.2))
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

(use-package shx
  :ensure t)

(use-package tramp
  :config
    (when (eq  window-system 'w32)
      (setq putty-directory "C:\\Program Files\\PuTTY\\")
      (setq tramp-default-method "plink")
      (when (and (not (string-match putty-directory (getenv "PATH")))
		 (file-directory-p putty-directory))
	(setenv "PATH" (concat putty-directory ";" (getenv "PATH")))
	(add-to-list 'exec-path putty-directory))))

(use-package paredit
  :hook lisp-mode)

(defmacro add-slime-lisp (slime-tag program program-args environment)
 "The format of a standard slime entry for a lisp implenatation."
`(list ,slime-tag (cons ,program ,program-args) :env ,environment))

;;;; The standard options for SBCL
(defun invoke-standard-sbcl (slime-tag program environment)
  (add-slime-lisp slime-tag program '("--noinform") environment))

(defun msys-sbcl (slime-tag version)
  "Create a slime entry for the slime-tag if the sbcl.exe is found."
;;; The path is the path to the sbcl-version container.
;;;
;;; The standard place I store sbcl that I compile are /usr/local/sbcl-version
;;;
;;; File System Template for a sbcl implemenation
;;;
;;; sbcl-version/
;;;   bin/
;;;     sbcl.exec ; The executable
;;;   lib/
;;;     sbcl/     ; SBCL_HOME
;;;       contrib/
;;;       sbcl.core ; the core image
;;;       sbcl.mk

   (let* ((versioned-path (concat "C:/Users/zzzap/Documents/Code/sbcl/win/" version "/"))
	  (exec-path (concat versioned-path "bin/sbcl.exe"))
	  (home-path (concat versioned-path "lib/sbcl/")))
     (when (file-exists-p exec-path)
	      (invoke-standard-sbcl slime-tag exec-path (list (concat "SBCL_HOME=" home-path ))))))

(defun win64-sbcl (slime-tag version)
  (let* ((versioned-path (concat "C:/Users/zzzap/Documents/Code/sbcl/win/" version "/"))
	 (exec-path (concat versioned-path "sbcl.exe"))
	 (home-path versioned-path))
    (when (file-exists-p exec-path)
      (invoke-standard-sbcl slime-tag exec-path (list (concat "SBCL_HOME=" home-path))))))

  (defun win32-sbcl (slime-tag version)
  (let* ((versioned-path (concat "C:/Users/zzzap/Documents/Code/sbcl/win-32/" version "/"))
	 (exec-path (concat versioned-path "sbcl.exe"))
	 (home-path versioned-path))
    (when (file-exists-p exec-path)
      (invoke-standard-sbcl slime-tag exec-path (list (concat "SBCL_HOME=" home-path))))))

(defun provision-ccl (slime-tag path)
    (when (file-exists-p path)
      `(,slime-tag (,path))))

(defun provision-abcl()
  (let ((java (concat "c:/Program Files/Java/" (if t "jdk-18.0.2.1" "jdk1.8.0_333") "/bin/java.exe"))
	(abcl "c:/Program Files/ABCL/abcl-src-1.9.0/dist/abcl.jar"))
	 (when (and (file-exists-p  java) (file-exists-p abcl))
	   `(abcl  ,(list java "-jar" abcl)))))

(defun provision-clisp-msys64 ()
  (when nil
  `(clisp-msys64 ())))

(defun provision-clisp-cygwin64()
  (when nil
  `(clisp-cygwin64 ())))

;;;; Build the implemenation lisp dynamically.
;;;; Remove all nil items from the list.
  ;;;; Load slime helper
  (load (expand-file-name "~/Documents/Code/quicklisp/slime-helper.el"))

(add-to-list 'load-path "C:/devel/msys64/usr/local/slime")
;;;; Configure slime from the above provisionsing
;;;; Remove any empty items
     (require 'slime)
     (require 'slime-autoloads)
     (if nil
	 (progn
	   (setenv "SBCL_HOME" (msys-path "usr/local/sbcl/msys/2.2.6/lib/sbcl/"))
	   (setf inferior-lisp-program (msys-path "usr/local/sbcl/msys/2.2.6/bin/sbcl.exe")))
	 (progn
       (setq slime-lisp-implementations
	 (seq-filter (lambda (e) e)
	   (list
	    (msys-sbcl 'win64-sbcl-2.3.5 "2.3.5")
	    (msys-sbcl 'win64-sbcl-2.3.4 "2.3.4")
	    (msys-sbcl 'win64-sbcl-2.3.3 "2.3.3")
	    (win64-sbcl 'win64-sbcl-2.3.2 "2.3.2")
	    (win64-sbcl 'win64-sbcl-2.3.1 "2.3.1")
	    (win32-sbcl 'win32-sbcl-2.3.1 "2.3.1")
	    (win64-sbcl 'win64-sbcl-2.2.7 "2.2.7")
	    (win64-sbcl 'win64-sbcl-2.2.6 "2.2.6")
	    ;(msys-sbcl 'msys-sbcl-2.2.6 "usr/local/sbcl/msys/2.2.6/")
	    ;(msys-sbcl 'msys-sbcl-2.2.5 "usr/local/sbcl/msys/2.2.5/")
	    (provision-ccl 'ccl-64 "C:/Users/zzzap/Documents/Code/ccl/wx86cl64.exe")
	    (provision-ccl 'ccl-32 "C:/Users/zzzap/Documents/Code/ccl/wx86cl.exe")
	    (provision-clisp-msys64)
	    (provision-clisp-cygwin64)
	    (provision-abcl))))
    (setq slime-contribs '(slime-fancy))
    (global-set-key "\C-cs" 'slime-selector)))

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
  :config

(setq org-src-tab-acts-natively t)

;; org-export with no TOC, no NUM and no SUB/SUPERSCRIPTS
(setf org-export-with-toc nil)
(setf org-export-with-section-numbers nil)
(setf org-export-with-sub-superscripts nil)

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("qb" . "quote"))

;; Where org-export latex can find perl
(setenv "PATH" (concat (getenv "PATH") (concat ";" (msys-path "usr/bin/"))))

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
   (shell . t)))

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

(use-package pdf-tools
   :config
   (pdf-tools-install))


(use-package org-noter
  :config
  ;; Your org-noter config ........
  (require 'org-noter-pdftools))

(use-package org-pdftools
  :hook (org-mode . org-pdftools-setup-link))

(use-package org-noter-pdftools
  :after org-noter
  :config
  ;; Add a function to ensure precise note is inserted
  (defun org-noter-pdftools-insert-precise-note (&optional toggle-no-questions)
    (interactive "P")
    (org-noter--with-valid-session
     (let ((org-noter-insert-note-no-questions (if toggle-no-questions
						   (not org-noter-insert-note-no-questions)
						 org-noter-insert-note-no-questions))
	   (org-pdftools-use-isearch-link t)
	   (org-pdftools-use-freepointer-annot t))
       (org-noter-insert-note (org-noter--get-precise-info)))))

  ;; fix https://github.com/weirdNox/org-noter/pull/93/commits/f8349ae7575e599f375de1be6be2d0d5de4e6cbf
  (defun org-noter-set-start-location (&optional arg)
    "When opening a session with this document, go to the current location.
With a prefix ARG, remove start location."
    (interactive "P")
    (org-noter--with-valid-session
     (let ((inhibit-read-only t)
	   (ast (org-noter--parse-root))
	   (location (org-noter--doc-approx-location (when (called-interactively-p 'any) 'interactive))))
       (with-current-buffer (org-noter--session-notes-buffer session)
	 (org-with-wide-buffer
	  (goto-char (org-element-property :begin ast))
	  (if arg
	      (org-entry-delete nil org-noter-property-note-location)
	    (org-entry-put nil org-noter-property-note-location
			   (org-noter--pretty-print-location location))))))))
  (with-eval-after-load 'pdf-annot
    (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))

(setq ppl-holiday-table '(2023					;year
   (1 1)					;new years day
   (2 20)				;presidents day
   (4 7)					; Good Friday
   (5 29)				; Memorial Day
   (7 4)					; Independence Day
   (9 4)					; Labor Day
   (11 24)				; Thanksgiving
   (11 25)				; Next Day
   (12 24)				; Christmas Eve
   (12 25)))                              ; Christmas


  (defun is-holiday (dt table)
    (if table (or (and (= (nth 4 dt) (nth 0 (car table)))
		       (= (nth 3 dt) (nth 1 (car table))))
		  (is-holiday dt (cdr table)))))

  (defun is-ppl-holiday (dt)
    (if (/= (car ppl-holiday-table) (nth 5 dt)) 
	(error "Update Date table") 
	(is-holiday dt (cdr ppl-holiday-table))))

  (defun summer (dt)
    (< 5 (nth 4 dt) 12))

(defun ppl-high-rate (&optional dt)
  (unless dt (setq dt (decode-time)))
       (cond ((not (< 0 (nth 6 dt) 6))  nil)
	     ((is-ppl-holiday dt)  nil)
	     ((summer dt)  (<= 14 (nth 2 dt) 17))
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
  (when (string-equal (buffer-file-name)
		      (expand-file-name "~/Documents/Code/.emacs.d/Emacs.org"))
    (message "Begin efs/tangle")

    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))
(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

;;;; Various user settings is a local configuration.
 (local-custom-file "local-settings.org" "Final user settings")

(setq gc-cons-threshold (* 2 1000 1000))

(message "Debug END")
