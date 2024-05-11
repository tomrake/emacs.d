(message "MMIV-TESTING-user-startup")

(defvar  local-config-emacs-configs "c:/Users/zzzzap1957/Code/Emacs-Configs/"
  "Where the various emacs configs are stored on this machine")

(defvar local-config-emacs-d (concat local-config-emacs-configs chemacs-profile-name "/emacs.d") ; "c:/Users/zzzap/Documents/Code/Emacs-Configs/devel/emacs.d"
  "This is the org file Emacs.org used to generate init.el by tangle.")


(defvar local-config-slime-location "c:/Users/zzzzap1957/Code/slime"
  "The location of the slime for common lisp.")

(defvar local-config-sbcl-location "C:/Users/zzzzap1957/Code/sbcl-compiled"
  "All locally compiled and installed SBCL lisps are installed in directory,
    by release version and a compiled name..
  I also add lisp version with a compiled name of 'production' or which contain a file '.production.'")
