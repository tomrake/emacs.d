
;;;; Add MikTex executables to path
;(add-to-list 'exec-path "/c/Users/zzzap/AppData/Local/Programs/MiKTeX/miktex/bin/x64")

;;;; Change to my work directory
(cd "~/local-code-projects/my-code/common-lisp/local-projects/")

(setq org-agenda-files `(,user/org-agenda-files))

(find-file (concat user/org-agenda-files "gtd.org"))


;;; See: http://cachestocaches.com/2016/9/my-workflow-org-agenda/
(setq org-capture-templates
      `(("t" "todo" entry (file ,(concat user/org-agenda-files "gtd.org"))
	 "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
	("n" "note" entry (file ,(concat user/org-agenda-files  "gtd.org"))
	 "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
	("m" "Meeting" entry (file  ,(concat user/org-agenda-files "gtd.org"))
	 "* MEETING with %? :MEETING:\n%t" :clock-in t :clock-resume t)
	("i" "Idea" entry (file ,(concat user/org-agenda-files "gtd.org"))
	 "* %? :IDEA: \n%t" :clock-in t :clock-resume t)
	("d" "Journal" entry (file+datetree ,(concat user/org-files "diary.org"))
	 "* %U %^{Title}\n%?" :clock-in t :clock-resume t)
	("n" "Next Task" entry (file+headline  ,(concat user/org-agenda-files "tasks"))
	 "** NEXT %? \nDEADLINE: %t")))

;;;; Allow access to org agenda files

(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))
