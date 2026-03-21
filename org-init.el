;; Autommatically tangle our Emacs.org config file when we save it.
(defun efs/org-babel-tangle-org-config ()
  "Test if the buffer should be auto-tangled after save"
  ; (message "string-equal: %s %s" (buffer-file-name) (expand-file-name (concat user-emacs-directory "Emacs.org")))
  (when (string-equal (buffer-file-name)
			(expand-file-name "Org-Config.org" user-emacs-directory))
    (message "Tangle-Org-Config.org")

    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
	(org-babel-tangle))))
(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-org-config)))

(setq twr/org-loading-flag "default")
(defun twr/check-org-load ()
  (when twr/org-loading-flag
    (message (concat "ORG DID NOT FINISH LOADING!!!!!! " twr/org-loading-flag))))
(add-hook 'after-init-hook 'twr/check-org-load)

(use-package org
  :straight t
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
  :straight t
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
  :straight t
  :config
    (use-package visual-fill-column
	:straight t
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
	`(list '(todo "WAITING" ((org-agenda-overriding-header "Waiting Tasks")(org-agenda-files ,file-list)
				 ))
	  '(todo "NEXT" ((org-agenda-overriding-header "Next Tasks")(org-agenda-files ,file-list)))
	  '(todo "CANCELLED" ((org-agenda-overriding-header "Cancelled Tasks")(org-agenda-files ,file-list)))
	  '(todo "TODO" ((org-agenda-overriding-header "Todo Tasks")(org-agenda-files ,file-list)))
	  '(todo "DONE" ((org-agenda-overriding-header "Completed Tasks")(org-agenda-files ,file-list)))))

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

(setq twr/org-loading-flag nil)
(message "<<<<  !!!    org-init.el  FINISHED   !!!   >>>>> ")
