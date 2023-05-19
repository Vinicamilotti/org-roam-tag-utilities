;;; package -- Sumary
;;; Commentary:
;;;; In test
;;; Code:
(require 'org-roam-mode)
(defun my/org-roam-filter-by-tag (tag-name)
  (lambda (node)
    (member tag-name (org-roam-node-tags node))))


(defun my/org-roam-list-notes-by-tag (tag-name)
  (mapcar #'org-roam-node-file
          (seq-filter
           (my/org-roam-filter-by-tag tag-name)
           (org-roam-node-list))))

(defun getAllByTag(tag)
  "This function gets all the org-roam files with matching tags (TAG)."
  (defvar roam/allnotes (my/org-roam-list-notes-by-tag tag))
  (lambda (list)
      (let (value)
      (dolist (element list value)
	(message "%s" element)
	(setq rawTitle (org-roam-db-query [:select TITLE :from nodes :where (= FILE $s1) ] element))
	(setq rawId (org-roam-db-query [:select ID :from nodes :where (= FILE $s1)] element))
	(setq title (car rawTitle))
	(setq id (car rawId))
	(setq toWrite (format "[[id:%s][%s]]" (car id) (car title))) 
	(message "%s" toWrite)
	(setq value (cons toWrite value))
	)
      ))
)
(provide 'tag-list)
;;; tag-list.el ends here

