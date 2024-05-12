(message "DESKER-TESTING-user-startup")



(defvar  local-config-emacs-configs "c:/Users/zzzap/Documents/Code/Emacs-Configs/"
  "Where the various emacs configs are stored on this machine")

(defvar local-config-emacs-d (concat local-config-emacs-configs chemacs-profile-name "/emacs.d") ; "c:/Users/zzzap/Documents/Code/Emacs-Configs/devel/emacs.d"
  "This is the org file Emacs.org used to generate init.el by tangle.")

(defvar local-config-sbcl-location "C:/Users/Public/Lispers/sbcl/installed"
  "All locally compiled and installed SBCL lisps are installed in directory,
    by release version and a compiled name..
  I also add lisp version with a compiled name of 'production' or which contain a file '.production.'")

(defvar local-config-ccl32-location  "C:/Users/Public/Lispers/ccl/wx86cl.exe"
  "The location of the ccl 32 bit Lisp installation")

(defvar local-config-ccl64-location  "C:/Users/Public/Lispers/ccl/wx86cl64.exe"
  "The location of the ccl 64 bit Lisp installation")

(defvar local-config-abcl-location "c:/program Files/ABCL/abcl-src-1.9.0/dist/abcl.jar"
  "The location of the Armed Bear Common Lisp installation")

(defvar local-config-slime-location "c:/Users/zzzap/Documents/Code/source-projects/ACTIVE/slime"
  "The location of the slime for common lisp.")

(defvar local-config-org-user-dir "~/Documents/Code/org"
  "The local org directory")


(defvar local-config-gtd-template-dir (concat local-config-emacs-configs chemacs-profile-name "/emacs.d/");; "~/Documents/Code/Emacs-Config/testing/emacs.d/"
  "Where the GTD temples are located.")

(defvar local-config-src-base-path "~/Documents/Code/org-web/"
  "Where the published source is located.")

(defvar local-config-publish-base-path "c:/Users/Public/org-web/"
  "Where the publish html files are located here.")
