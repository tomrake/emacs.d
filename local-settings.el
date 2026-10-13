;; -*- lexical-binding: nil -*-
;;;; Change to my work directory
(if (getenv "CODE-REPO")
     (cd (getenv "CODE-REPO")))
