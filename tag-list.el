;;; roam-tag-utilities -- simple utilities for tags in orgroam

;; GNU License

;; Autor: Vinicius Camilotti <vinicamilotti@gmail.com>
;; Keywords: lisp
;; Version: 0.0.1-a

;;; Commentary:

;; In test

;;; Code:
(defun my/org-roam-filter-by-tag (tag-name)
    "Filter (NODE)s by (TAG-NAME)."
  (lambda (node)
    (member tag-name (org-roam-node-tags node))))

(defun my/org-roam-list-notes-by-tag (tag-name)
  "List notes by (TAG-NAME)."
  (mapcar #'org-roam-node-file
          (seq-filter
           (my/org-roam-filter-by-tag tag-name)
           (org-roam-node-list))))

(defun org-roam-links-by-tag(tag)
  "This function gets all the org-roam files with matching tags (TAG)."
  (setq list (my/org-roam-list-notes-by-tag tag))
  (let (value)
      (dolist (element list value)
	(setq rawTitle (org-roam-db-query [:select TITLE :from nodes :where (= FILE $s1) ] element))
	(setq rawId (org-roam-db-query [:select ID :from nodes :where (= FILE $s1)] element))
	(setq title (car rawTitle))
	(setq id (car rawId))
	(setq toWrite (format "[[id:%s][%s]]" (car id) (car title)))
	(setq value (cons toWrite value))
	)
      )
  )

(defun org-roam-tag-search(tags)
  "Search notes via list of tags (TAGS)."
  (let (value)
    (dolist (element tags value)
	    (setq search (my/org-roam-list-notes-by-tag element))
	    (setq value (cons search value))
	    ))
	)
(defun org-roam-matching-tags-search(tags)
  "Return a list of files with matching tags (TAGS)."
 (setq files (org-roam-tag-search tags))
 (let ((result (car files)))
      (dolist (lst (cdr files) result)
        (setq result (cl-intersection result lst)))))

(defun org-roam-links-by-matching-tags(tags)
  "Return a list of links based on a list of (TAGS)."
  (setq files (org-roam-matching-tags-search tags))
  (let (value)
      (dolist (element files value)
	(setq rawTitle (org-roam-db-query [:select TITLE :from nodes :where (= FILE $s1) ] element))
	(setq rawId (org-roam-db-query [:select ID :from nodes :where (= FILE $s1)] element))
	(setq title (car rawTitle))
	(setq id (car rawId))
	(setq toWrite (format "[[id:%s][%s]]" (car id) (car title)))
	(setq value (cons toWrite value))
	)
      )
  )

(mesage "%s" (org-roam-links-by-matching-tags '("Git" "Santandercoders")))

(provide 'tag-list)

;;; tag-list.el ends here
