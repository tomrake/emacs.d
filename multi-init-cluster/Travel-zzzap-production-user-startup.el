(message "DESKER-zzzap-devel-user-startup")


(defvar local-config-sbcl-location "sbcl"
  "All locally compiled and installed SBCL lisps are installed in directory,
    by release version and a compiled name..
  I also add lisp version with a compiled name of 'production' or which contain a file '.production.'")

(defvar local-config-ccl32-location  nil
  "The location of the ccl 32 bit Lisp installation")

(defvar local-config-ccl64-location  nil
  "The location of the ccl 64 bit Lisp installation")

(defvar local-config-abcl-location nil
  "The location of the Armed Bear Common Lisp installation")

(defvar local-config-slime-location nil
  "The location of the slime for common lisp.")


(defvar multi-user-org-path "~/synced/org-documents/"

  "All org stuff that need multiuser access are located relative this path.")

(defvar config-obsidian-specify-path nil 
  "Define the location of the Obsidian Vault.")
