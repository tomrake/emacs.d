
;;;; Add MikTex executables to path
;(add-to-list 'exec-path "/c/Users/zzzap/AppData/Local/Programs/MiKTeX/miktex/bin/x64")

;;;; Change to my work directory
(cd "~/local-code-projects/my-code/common-lisp/local-projects/")

;; My org files
(setq user/org-files "~/org/")
(setq user/org-agenda-files "~/org/agenda/")

(setq org-agenda-files `(,user/org-agenda-files))

(find-file (concat user/org-agenda-files "gtd.org"))

(defun morning-checklist-writer()
  (format "* Morning Checklist
  - [ ] Morning Tray for Mom [/]
    - [ ] Morning Medications
    - [ ] Breakfast
      - [ ] Cereal 4oz milk
    - [ ] 4oz water 1/2 TSP metamucil
    - [ ] Spoon
  - [ ] Feed Cat
  - [ ] Eat YOUR Breakfast
" nil))

(defun monthly-tasks-for-james-seese ()
  (format "* Monthly Tasks: James Seese
  - [ ] Process all inbound mail.
  - [ ] Separate mail by entity
  - [ ] list all oustanding bills
  - [ ] list all oustanding deposits
  - [ ] Make deposit list
    - [ ] vendor
    - [ ] amount
  - [ ] Make check list
    - [ ] Vendor
    - [ ] Amount
  - [ ] Write and mail checks" nil))

;;; See: http://cachestocaches.com/2016/9/my-workflow-org-agenda/
(setq org-capture-templates
      `(("t" "todo" entry (file ,(concat user/org-agenda-files "gtd.org"))
	 "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
	("n" "note" entry (file ,(concat user/org-agenda-files  "gtd.org"))
	 "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
;; Medical Appointments
;; Medical Appointment  (m) Medical template
   ("m" "MEDICAL   (m) Medical" entry (file ,(concat user/org-agenda-files "gtd.org"))
    "* Medical %^{Who} %?
  CLOSED: %^U
  :PROPERTIES:
  :Attend:   Tom Rake
  :Location:
  :Via:
  :Note:
  :END:
  :LOGBOOK:
  - State \"MEETING\"    from \"\"           %U
  :END:
  %^T--%^T" :empty-lines 1)
;; Historic Meeting Template
;; ("m" "Meeting" entry (file  ,(concat user/org-agenda-files "gtd.org"))
;;  "* MEETING with %^{Meeting with:} %?" :clock-in t :clock-resume t)

;; Shoppping Items
   ("s" "Shopping List - Needed (s)" entry (file ,(concat user/org-agenda-files "gtd.org"))
    "* Shopping Item %^{Needed Item} %?
  CLOSED: %U
  :PROPERTIES:
  :URGENCY: %^{Urgency?|Regular Trip|ASAP|Next Day}
  :END:
")
	("i" "Idea" entry (file ,(concat user/org-agenda-files "gtd.org"))
	 "* %? :IDEA: \n%t" :clock-in t :clock-resume t)
	("j" "Journal" entry (file+datetree ,(concat user/org-files "diary.org"))
	 "* %U %^{Title}\n  -%?" :clock-in t :clock-resume t)
	("n" "Next Task" entry (file+headline  ,(concat user/org-agenda-files "tasks"))
	 "** NEXT %? \nDEADLINE: %t")))

;;;; Allow access to org agenda files

(setq org-refile-targets '((org-agenda-files :maxlevel . 9)))
