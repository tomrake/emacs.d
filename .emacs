
;; Setup the package manager

(setq inhibit-startup-screen t)

(setq visible-bell 1)

;;;; Roswell
;;(load (expand-file-name (convert-standard-filename "~/.roswell/helper.el")))


;;;; Download packages from MELPA

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(defvar local-packages '(flx-ido
			 auto-complete
			 epc
			 slime
			 rainbow-delimiters
			 paredit
			 ac-slime
			 cyberpunk-theme
			 dracula-theme
			 dakrone-theme
			 popup
			 jedi
			 docker-tramp
			 dockerfile-mode
			 pillar
			 cmake-mode
			 yaml-mode))


(defun uninstalled-packages (packages)
  (delq nil
	(mapcar (lambda (p)
		  (if (package-installed-p p nil) nil p))
		packages)))

(let ((need-to-install
       (uninstalled-packages local-packages)))
  (when need-to-install
    (progn
      (package-refresh-contents)
      (dolist (p need-to-install)
	(package-install p)))))


;;;; Auto Complete Setup

(require 'auto-complete-config)
(ac-config-default)


;;;; Common Lisp Setup

;;;; Slime Setup

(setq slime-lisp-implementations
    `(  
	;; Add SBCL if present
	,(when (getenv "SBCL_HOME")
	   (cond ((eq system-type 'windows-nt)

		  `(sbcl  (,(convert-standard-filename (concat (getenv "SBCL_HOME") "sbcl.exe"))
			   "--noinform")))
		 (t nil)))
	;; Add clisp on cygwin
	,(when (and (eq system-type 'cygwin) (file-exists-p (convert-standard-filename "/usr/bin/clisp")))
	   `(clisp (,(convert-standard-filename "/usr/bin/clisp" ))))
	;; Add ABCL if present
	,(when (file-exists-p  (convert-standard-filename "C:/Program Files/ABCL/abcl.jar"))
	   `(abcl  ("java" "-jar" ,(convert-standard-filename "C:/Program Files/ABCL/abcl.jar"))))

	 ))


(setq common-lisp-hyperspec-root (concat (getenv "HOME") (convert-standard-filename  "/local-code-projects/static-resources/common-lisp/HyperSpec-7.0/HyperSpec/")))

(setq slime-contribs '(slime-fancy))

(global-set-key "\C-cs" 'slime-selector)

;; Slime Autocomplete

(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))


;;;; Custom Themes

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (manoj-dark)))
 '(custom-safe-themes
   (quote
    ("e269026ce4bbd5b236e1c2e27b0ca1b37f3d8a97f8a5a66c4da0c647826a6664" "e9460a84d876da407d9e6accf9ceba453e2f86f8b86076f37c08ad155de8223c" "ff7625ad8aa2615eae96d6b4469fcc7d3d20b2e1ebc63b761a349bebbb9d23cb" "d6922c974e8a78378eacb01414183ce32bc8dbf2de78aabcc6ad8172547cb074" "38e64ea9b3a5e512ae9547063ee491c20bd717fe59d9c12219a0b1050b439cdd" "561ba4316ba42fe75bc07a907647caa55fc883749ee4f8f280a29516525fc9e8" default)))
 '(fci-rule-color "#383838")
 '(package-selected-packages
   (quote
    (dakrone-theme dockerfile-mode docker-tramp anaconda-mode popup cyberpunk-theme ac-slime paredit rainbow-delimiters slime epc auto-complete flx-ido)))
 '(w32-allow-system-shell t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:italic t :slant oblique :foreground "#9fd385"))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "dark orange"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "deep pink"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "chartreuse"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "deep sky blue"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "orchid"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "spring green"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "sienna1")))))

;; Rainbow-Delimiters Setup

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; Load the standard theme - manoj-dark

(load-theme 'manoj-dark)

(set-face-attribute 'default nil :height 120)



;;;; ido interactive file opems

(require 'ido)
(ido-mode t)

;; Paredit Mode

(add-hook 'lisp-mode-hook #'paredit-mode)
(add-hook 'lisp-mode-hook #'auto-complete-mode)


;;;; Pascal Mode setup

(add-hook 'pascal-mode-hook
	  (lambda ()
	    (set (make-local-variable 'compile-command)
		 (concat "fpc " (file-name-nondirectory (buffer-file-name)))
		 )
	    )
	  t)

(setq auto-mode-alist
      (append '((".*\\.pas\\'" . pascal-mode))
	      auto-mode-alist))

(setq auto-mode-alist
      (append '((".*\\.pp\\'" . pascal-mode))
	      auto-mode-alist))

(setq auto-mode-alist
      (append '((".*\\.asd\\'" . lisp-mode))
	      auto-mode-alist))

(setq auto-mode-alist
      (append '((".*\\.cl\\'" . lisp-mode))
	      auto-mode-alist))

(setq auto-mode-alist
      (append '((".*\\.yml\\'" . yaml-mode))
	      auto-mode-alist))

;;;; Tramp

(require 'tramp)
(setq tramp-default-method "plink")
(setq tramp-verbose 10)


;; Set standard opening directory

(cd (concat (getenv "HOME") (convert-standard-filename  "/local-code-projects/my-code/common-lisp/local-projects/")))


(setenv  "PATH" (concat
		 "C:\\devel\\msys64\\usr\\bin" ";"
		 (getenv "PATH")))


;; The MSYS-SHELL

(defun msys-shell () 
  (interactive)
  (let ((explicit-shell-file-name (convert-standard-filename "c:/devel/msys64/usr/bin/bash.exe"))
	(shell-file-name "bash")
	(explicit-bash.exe-args '("--noediting" "--login" "-i"))) 
    (setenv "SHELL" shell-file-name)
    (add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)
    (shell)))

;; The MINGW64-SHELL

(defun mingw64-shell () 
       (interactive)
       (let (( explicit-shell-file-name (convert-standard-filename  "c:/devel/msys64/mingw64/bin/bash.exe")))
	 (shell "*bash*")
	     (call-interactively 'shell))
       ;; (setq shell-file-name "bash")
       ;; (setq explicit-bash.exe-args '("--login" "-i")) 
       ;; (setenv "SHELL" shell-file-name)
       ;; (add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)
       ;; (shell)
       )

;;;; Remote printer

(setq printer-name  "\\Canon TS6000 LPR")

  
