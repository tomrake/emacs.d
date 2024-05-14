(defun gtd-file (name)
  (concat local-config-gtd-dir name))

(setq org-refile-targets `((,(gtd-file "gtd.org") :maxlevel . 3)
			   (,(gtd-file "Someday.org") :maxlevel . 3)
			   (,(gtd-file "Tickler.org") :maxlevel . 3)
			   (,(gtd-file "Appointments.org") :maxlevel . 1)))

(setq org-agenda-start-with-log-mode t)
(setq org-log-done 'time)
(setq org-log-into-drawer "LOGBOOK")

(defmacro twr-todo-overview (file-list)
  `(list '(todo "WAITING" ((org-agenda-files ,file-list)))
    '(todo "NEXT" ((org-agenda-files ,file-list)))
    '(todo "CANCELLED" ((org-agenda-files ,file-list)))
    '(todo "TODO" ((org-agenda-files ,file-list)))
    '(todo "DONE" ((org-agenda-files ,file-list)))))

(setq org-agenda-files-1
      (list (gtd-file "gtd.org")
	    (gtd-file "Tickler.org")
	    (gtd-file "Annual-Days.org")
	    (gtd-file "Appointments.org")
	    (gtd-file "Inbox.org")))
(setq current-agenda-files
      (list (gtd-file "gtd.org")
	    (gtd-file "Inbox.org")
	    (gtd-file "Appointments.org")
	    (gtd-file "Tickler.org")))
;;; All items except for appointments
(setq org-non-appoinment-files
      (list (gtd-file "gtd.org")
	    (gtd-file "Tickler.org")
	    (gtd-file "Annual-Days.org")
	    (gtd-file "Inbox.org")))
(setq full-agenda-files (cons (gtd-file "Someday.org") org-agenda-files-1))
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-todo-list-sublevels t)
(setf org-agenda-files org-agenda-files-1)

(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))

;;;; Define Custom Agenda views
     (setq org-agenda-custom-commands
	   `(
	     ("x" . "Experimental")
	     ("xx" "xx" agenda)
	     ("xy" "xy" agenda*)
	     ("xn" "xn" todo "NEXT")
	     ("xN" "xN" todo-tree "NEXT")
	     ("xa" "Daily Overview"
	      ;; The first part is an agenda calendar view
	      ((agenda* "" ((org-agenda-files org-agenda-files-1)
			   (org-agenda-ndays 1)
			   (org-agenda-sorting-strategy
			    `((agenda time-up priority-down tag-up)))
			   (org-deadline-warning-days 0)))
				       ; exclude ticker files from todo list because they are covered in agenda
	       (todo "WAITING" ((org-agenda-files org-non-appoinment-files)))
	       (todo "NEXT" ((org-agenda-files org-non-appoinment-files)))

  (todo "TODO" ((org-agenda-files org-non-appoinment-files)))))
	     ("xA" "All Appointments" tags "+APPOINTMENT")
	     ("xj" "James Appointments" tags "+JAMES+APPOINTMENT")
	     ("xJ" "James" tags "+JAMES")
	     ("xc" "Weekly schedule" agenda ""
	       ((org-agenda-span 7) ;; agenda will start in week view
		(org-agenda-repeating-timestamp-show-all t)))
	     ("xf" "Evaluate all Tasks" agenda ""
	       ((org-agenda-files current-agenda-files-1)))

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
	      ((agenda "" ((org-agenda-files org-agenda-files-1)
			   (org-agenda-ndays 1)
			   (org-agenda-sorting-strategy
			    `((agenda time-up priority-down tag-up)))
			   (org-deadline-warning-days 0)))
				       ; exclude ticker files from todo list because they are covered in agenda
	       (todo "NEXT" ((org-agenda-files current-agenda-files)))))
	     ("Do" "Daily Overview"
	      ;; The first part is an agenda calendar view
	      ((agenda "" ((org-agenda-files org-agenda-files-1)
			   (org-agenda-ndays 1)
			   (org-agenda-sorting-strategy
			    `((agenda time-up priority-down tag-up)))
			   (org-deadline-warning-days 0)))
	       ,@(twr-todo-overview org-non-appoinment-files)))
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
