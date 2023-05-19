;;; roam-tag-utilities -- simple utilities for tags in orgroam

;; GNU License

;; Autor: Vinicius Camilotti <vinicamilotti@gmail.com>
;; Keywords: lisp
;; Version: 0.0.1-a

;;; Commentary:

;; In test

;;; Code:

(defun linksByTag(tag)
  "This function gets all the org-roam files with matching tags (TAG)."
  (setq-local list (my/org-roam-list-notes-by-tag tag))
  (sort (let (value)
      (dolist (element list value)
	(message "%s" element)
	(setq-local rawTitle (org-roam-db-query [:select TITLE :from nodes :where (= FILE $s1) ] element))
	(setq-local rawId (org-roam-db-query [:select ID :from nodes :where (= FILE $s1)] element))
	(setq-local title (car rawTitle))
	(setq-local id (car rawId))
	(setq-local toWrite (format "[[id:%s][%s]]" (car id) (car title)))
	(message "%s" toWrite)
	(setq value (cons toWrite value))
	)
      ) 'a)
  )
(message "%s" (linksByTag "Git"))
(provide 'tag-list)
;;; tag-list.el ends here
