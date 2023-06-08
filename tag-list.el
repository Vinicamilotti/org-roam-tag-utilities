;;; roam-tag-utilities -- simple utilities for tags in orgroam

;; GNU License

;; Autor: Vinicius Camilotti <vinicamilotti@gmail.com>
;; Keywords: lisp
;; Version: 0.0.1-a

;;; Commentary:

;; In test

;;; Code:

(defvar org-roam-tags-default-sort "Date")

(defun sort-list-of-lists (list)
  "Sort a (LIST) of lists by its car."
  (cl-sort list '< :key 'car)
  )

(defun org-roam-date-get-timestamp (file)
  "Return the date of a given (FILE)."
  (setq raw-path
	(split-string file "**/" t))
  (setq filename (car(last raw-path)))
  (car(split-string filename "**-" t))
  )
(defun org-roam-date-trasnform-date(file)
  "Return a org formated date for a given (FILE) - default format YYYY-mm-DD HH:MM."
  (setq raw-timestamp (org-roam-date-get-timestamp file))
  (setq year (substring raw-timestamp 0 4))
  (setq month (substring raw-timestamp 4 6))
  (setq day (substring raw-timestamp 6 8))
  (setq hour (substring raw-timestamp 8 10))
  (setq minutes (substring raw-timestamp 10 12))
  (format "<%s-%s-%s %s:%s>" year month day hour minutes)
 )

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
"Return a sorted list of org-roam links with matching tags (TAG)."
  (setq list (my/org-roam-list-notes-by-tag tag))
  (setq links (let (value)
    (dolist (element list value)
      (setq datestring (string-to-number (org-roam-date-get-timestamp element)))
      (setq rawTitle (org-roam-db-query [:select TITLE :from nodes :where (= FILE $s1) ] element))
      (setq rawId (org-roam-db-query [:select ID :from nodes :where (= FILE $s1)] element))
      (setq title (car rawTitle))
      (setq id (car rawId))
      (setq link (format "[[id:%s][%s]]" (car id) (car title)))
      (setq toReturn (list datestring link))
      (setq value (cons toReturn value))
      
    )))
	
  (cl-sort links '< :key 'car)
  (setq sorted '())
    (dolist (element links sorted)
      (setq only-link (car(cdr element)))
      (add-to-list 'sorted only-link t)

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
  (setq links (sort-list-of-lists (let (value)
    (dolist (element files value)
      (setq datestring (string-to-number (org-roam-date-get-timestamp element)))
      (setq rawTitle (org-roam-db-query [:select TITLE :from nodes :where (= FILE $s1) ] element))
      (setq rawId (org-roam-db-query [:select ID :from nodes :where (= FILE $s1)] element))
      (setq title (car rawTitle))
      (setq id (car rawId))
      (setq link (format "[[id:%s][%s]]" (car id) (car title)))
      (setq toReturn (list datestring link))
      (setq value (cons toReturn value))
      )
    )
   ))

  (let (only-link)
    (dolist (element links only-link)
      (setq outro (car(cdr element)))
      (add-to-list 'only-link outro t))
    )
  )

(defun get-all-roam-tags ()
  "Return all available tags."
  (seq-uniq (org-roam-db-query [:select tag :from tags]))
  )
(defun org-roam-insert-by-tag ()
  "Insert all tagged notes at pointer (TAGS)."
  (interactive)
  (setq continue 1)
  (setq tags '())
  (setq all-tags (get-all-roam-tags))
  (while (= continue 1)
    (setq user-input (let ((choices all-tags))
      (message "%s" (completing-read "Tags:" choices))
      ))
   (setq tags (cons user-input tags))
    
    (if (y-or-n-p "Contiue filtering?")
      (progn
	;; code to do something here
	(setq continue 1)
      )
      (progn
	;; code if user answered no.
	(setq continue 0)
      )
     )
   )
  (setq links (org-roam-links-by-matching-tags tags))
  (dolist (element links)
    (setq formated-links (format "** %s\n" element))
    (insert formated-links)
    )
  )

(defun org-roam-open-dashboard ()
"Opens the file with the tag Dashboard.IMPORTANT: Maked sure to have only one file marked with the Dashboard tag."
(interactive)
(setq file-raw (my/org-roam-list-notes-by-tag "Dashboard"))
(setq file (car file-raw))
(find-file file)
  )

(provide 'tag-list)

;;; tag-list.el ends here
