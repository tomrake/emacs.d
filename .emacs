;;;; File: ~/.emacs
;; load time metrics
(setq  *emacs-load-start* (current-time))


;;
(fset 'convert-windows-filename
      (if (fboundp 'cygwin-convert-file-name-from-windows)
	  'cygwin-convert-file-name-from-windows
	  'convert-standard-filename))



(load (convert-windows-filename "C:/Users/Public/Documents/emacs/.emacs"))

;; ;;;; Allow system wide customoization from Public user
;; (cond ((file-exists-p (convert-standard-filename "C:/Users/Public/Documents/emacs/.emacs"))
;;        (load (convert-standard-filename "C:/Users/Public/Documents/emacs/.emacs")))
;;       ((file-exists-p (convert-standard-filename "/c/Users/Public/Documents/emacs/.emacs"))
;;        (load (convert-standard-filename "/c/Users/Public/Documents/emacs/.emacs")))
;;       (t (error "Can't load public .emacs file")))

;;;; Below is changed by Emacs Customization options
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
 '(safe-local-variable-values (quote ((org-use-property-inheritance . t)))))
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

;; Load time metrics
(setq *emacs-load-end* (current-time))
(message "My .emacs loaded in %s " (float-time (time-subtract *emacs-load-end* *emacs-load-start*)))
