;;; package -- Sumary
;;; Commentary:
;;;; In test
;;; Code:
(defun my/org-roam-filter-by-tag (tag-name)
  (lambda (node)
    (member tag-name (org-roam-node-tags node))))


(defun my/org-roam-list-notes-by-tag (tag-name)
  (mapcar #'org-roam-node-file
          (seq-filter
           (my/org-roam-filter-by-tag tag-name)
           (org-roam-node-list))))

(defun linksByTag(tag)
  "This function gets all the org-roam files with matching tags (TAG)."
  (defvar roam/allnotes (my/org-roam-list-notes-by-tag tag))
  (lambda (list)
      (let (value)
      (dolist (element list value)
	(message "%s" element)
	(defvar rawTitle (org-roam-db-query [:select TITLE :from nodes :where (= FILE $s1) ] element))
	(defvar rawId (org-roam-db-query [:select ID :from nodes :where (= FILE $s1)] element))
	(defvar title (car rawTitle))
	(defvar id (car rawId))
	(defvar toWrite (format "[[id:%s][%s]]" (car id) (car title)))
	(message "%s" toWrite)
	(setq value (cons toWrite value))
	)
      ))
)
(provide 'tag-list)
;;; tag-list.el ends here

