(defun double-quote-string(s)
  "Double quote a string."
     (concat "\"" s "\""))

(defun single-quote-string (s)
  "Single quote a string."
     (concat "\'" s "\'"))

(defun double-quote-list (l)
  "Return the list l with each item double quoted."
    (mapcar 'double-quote-string l))

(defun single-quote-list (l)
  "Return the list l with each item single quoted."
    (mapcar 'single-quote-string l))

(defun join-with-spaces (args)
  "Join all the args with spaces."
     (mapconcat 'identity args " "))

(provide 'quoting-tools)
