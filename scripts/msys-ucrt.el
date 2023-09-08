(message "...msys-ucrt")
(setq my-msys2-base "c:\devel\msys64")
  (setq msystem (getenv "MSYSTEM"))
  (setq old-msystem msystem)
  (setq old-msystem-prefix (getenv "MSYSTEM_PREFIX"))

;; Paths to msys2 file root

(let ((msys64-root-mount "C:/devel/msys64")
      (msys64-bin-mount "C:/devel/msys64/usr/bin"))
      (add-to-list 'exec-path (concat msys64-root-mount (getenv "MSYSTEM_PREFIX") "/bin"))
      (add-to-list 'exec-path (concat msys64-root-mount "/usr/local/bin"))
      (add-to-list 'exec-path (concat msys64-root-mount "/usr/bin"))
      (add-to-list 'exec-path msys64-bin-mount)
 

      (defun msys-path (path)
	(concat my-msys2-base path))

      (defun msys64-file-exists-p (file)
	(file-exists-p (msys-path file)))

      (defun msys2-command (cmd params)
	(join-with-spaces (cons (msys2-command-string cmd) params)))

      (defun msys2-command-string (cmd)
	(concat (msys-path "usr/bin") cmd ".exe")))

(provide 'msys-ucrt)
