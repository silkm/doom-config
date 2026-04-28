;;; ~/.doom.d/jira.el -*- lexical-binding: t; -*-

(require 'url)
(require 'json)
(require 'org)

;; ============================================================
;; Constants & status tags
;; ============================================================

(defconst my/jira-base-url "https://cpg-populationanalysis.atlassian.net")

(defconst my/jira-popgen-file
  (expand-file-name "~/notebook/projects/popgen.org"))

(defvar my/jira-status-tags
  '("@backlog" "@todo" "@approved" "@in_progress" "@in_review" "@blocked" "@done" "@wont_do")
  "All Jira status tags.")

(defvar my/jira-status-colors
  '(("@backlog"     . "#737994")
    ("@todo"        . "#c6d0f5")
    ("@approved"    . "#85c1dc")
    ("@in_progress" . "#8caaee")
    ("@in_review"   . "#e5c890")
    ("@blocked"     . "#e78284")
    ("@done"        . "#a6d189")
    ("@wont_do"     . "#838ba7"))
  "Foreground colours for Jira status tags in agenda.")

;; ============================================================
;; Auth + HTTP
;; ============================================================

(defun my/jira--auth-header ()
  (concat "Basic "
          (base64-encode-string
           (concat my-jira-email ":" my-jira-api-token) t)))

(defun my/jira--request (method endpoint &optional payload)
  "Synchronous Jira API request. Returns parsed JSON alist or nil on error."
  (condition-case err
      (let* ((url-request-method method)
             (url-request-extra-headers
              `(("Authorization" . ,(my/jira--auth-header))
                ("Content-Type"  . "application/json")
                ("Accept"        . "application/json")))
             (url-request-data
              (when payload
                (encode-coding-string
                 (let ((json-encoding-pretty-print nil))
                   (json-encode payload))
                 'utf-8)))
             (buf (url-retrieve-synchronously
                   (concat my/jira-base-url endpoint)
                   t t 30)))
        (when buf
          (with-current-buffer buf
            (set-buffer-multibyte t)
            (goto-char (point-min))
            (when (re-search-forward "^$" nil t)
              (forward-char 1)
              (let ((json-object-type 'alist)
                    (json-array-type  'list)
                    (json-false        nil)
                    (json-null         nil))
                (condition-case nil
                    (json-read)
                  (error nil)))))))
    (error
     (message "Jira request error: %s" err)
     nil)))

;; ============================================================
;; Org helpers
;; ============================================================

(defun my/jira--status-to-tag (status-name)
  "Convert Jira status name to org tag string."
  (pcase status-name
    ("To Do"       "@todo")
    ("Backlog"     "@backlog")
    ("Approved"    "@approved")
    ("In Progress" "@in_progress")
    ("In Review"   "@in_review")
    ("Blocked"     "@blocked")
    ("Done"        "@done")
    ("Won't Do"    "@wont_do")
    (_             "@todo")))

(defun my/jira--set-status-tag (status-name)
  "Replace current status tag with one matching STATUS-NAME."
  (let ((new-tag (my/jira--status-to-tag status-name)))
    (dolist (tag my/jira-status-tags)
      (org-toggle-tag tag 'off))
    (org-toggle-tag new-tag 'on)))

(defun my/jira--get-parent-epic-key ()
  "Walk up headings to find the nearest :epic: and return its JIRA_KEY."
  (save-excursion
    (let ((key nil))
      (while (and (not key) (org-up-heading-safe))
        (when (member "epic" (org-get-tags))
          (setq key (org-entry-get (point) "JIRA_KEY"))))
      key)))

(defun my/jira--find-heading-by-key (jira-key)
  "Return a marker for the heading with JIRA_KEY=JIRA-KEY in popgen.org, or nil."
  (let ((found nil))
    (with-current-buffer (find-file-noselect my/jira-popgen-file)
      (org-map-entries
       (lambda ()
         (when (equal (org-entry-get (point) "JIRA_KEY") jira-key)
           (setq found (point-marker))))
       nil 'file))
    found))

(defun my/jira--find-epic-pos (jira-key)
  "Return point of the :epic: heading with JIRA_KEY in popgen.org, or nil."
  (let ((found nil))
    (with-current-buffer (find-file-noselect my/jira-popgen-file)
      (org-map-entries
       (lambda ()
         (when (and (member "epic" (org-get-tags))
                    (equal (org-entry-get (point) "JIRA_KEY") jira-key))
           (setq found (point))))
       nil 'file))
    found))

(defun my/jira--get-sprint-name (fields)
  "Extract the active sprint name from issue FIELDS alist."
  (let ((sprints (cdr (assq 'customfield_10020 fields))))
    (when (and sprints (listp sprints) (car sprints))
      (cdr (assq 'name (car sprints))))))

(defun my/jira--get-epic-key-from-fields (fields)
  "Extract epic key from FIELDS, handling both classic and next-gen projects."
  (or (cdr (assq 'customfield_10014 fields))
      (let ((parent (cdr (assq 'parent fields))))
        (when parent (cdr (assq 'key parent))))))

;; ============================================================
;; ADF → org
;; ============================================================

(defun my/adf--node-to-org (node)
  "Recursively convert an ADF node alist to org markup."
  (let ((type    (cdr (assq 'type node)))
        (content (cdr (assq 'content node)))
        (text    (cdr (assq 'text node)))
        (attrs   (cdr (assq 'attrs node))))
    (pcase type
      ("doc"
       (mapconcat #'my/adf--node-to-org (or content '()) ""))
      ("paragraph"
       (let ((inner (mapconcat #'my/adf--node-to-org (or content '()) "")))
         (if (string-blank-p inner) "" (concat inner "\n\n"))))
      ("text"
       (let ((raw (or text ""))
             (marks (cdr (assq 'marks node))))
         (dolist (mark (or marks '()))
           (let ((mtype (cdr (assq 'type mark))))
             (setq raw
                   (pcase mtype
                     ("strong" (concat "*" raw "*"))
                     ("em"     (concat "/" raw "/"))
                     ("code"   (concat "=" raw "="))
                     ("link"
                      (let ((href (cdr (assq 'href (cdr (assq 'attrs mark))))))
                        (if href (concat "[[" href "][" raw "]]") raw)))
                     (_ raw)))))
         raw))
      ("heading"
       (let ((level (or (cdr (assq 'level attrs)) 1)))
         (concat (make-string (+ 2 level) ?*) " "
                 (mapconcat #'my/adf--node-to-org (or content '()) "")
                 "\n\n")))
      ("codeBlock"
       (let ((lang (or (cdr (assq 'language attrs)) "")))
         (concat "#+begin_src " lang "\n"
                 (mapconcat #'my/adf--node-to-org (or content '()) "")
                 "\n#+end_src\n\n")))
      ("bulletList"
       (concat (mapconcat
                (lambda (item)
                  (concat "- " (string-trim
                                (mapconcat #'my/adf--node-to-org
                                           (or (cdr (assq 'content item)) '()) ""))
                          "\n"))
                (or content '()) "")
               "\n"))
      ("taskList"
       (concat (mapconcat #'my/adf--node-to-org (or content '()) "") "\n"))
      ("taskItem"
       (let ((state (cdr (assq 'state attrs)))
             (inner (mapconcat #'my/adf--node-to-org (or content '()) "")))
         (concat "- [" (if (equal state "DONE") "X" " ") "] "
                 (string-trim inner) "\n")))
      ("hardBreak" "\n")
      ("rule"      "\n-----\n\n")
      (_
       (when content
         (mapconcat #'my/adf--node-to-org content ""))))))

(defun my/adf-to-org (adf)
  "Convert an ADF alist to org markup string."
  (if adf (string-trim (my/adf--node-to-org adf)) ""))

;; ============================================================
;; org → ADF
;; ============================================================

(defun my/org--text-to-adf-nodes (text)
  "Parse inline org markup in TEXT into a list of ADF text node alists."
  (let ((nodes '())
        (remaining text))
    (while (> (length remaining) 0)
      (cond
       ((string-match "\\*\\([^*\n]+\\)\\*" remaining)
        (let ((pre (substring remaining 0 (match-beginning 0))))
          (when (> (length pre) 0)
            (push `(("type" . "text") ("text" . ,pre)) nodes))
          (push `(("type" . "text") ("text" . ,(match-string 1 remaining))
                  ("marks" . [( ("type" . "strong") )])) nodes)
          (setq remaining (substring remaining (match-end 0)))))
       ((string-match "/\\([^/\n]+\\)/" remaining)
        (let ((pre (substring remaining 0 (match-beginning 0))))
          (when (> (length pre) 0)
            (push `(("type" . "text") ("text" . ,pre)) nodes))
          (push `(("type" . "text") ("text" . ,(match-string 1 remaining))
                  ("marks" . [( ("type" . "em") )])) nodes)
          (setq remaining (substring remaining (match-end 0)))))
       ((string-match "=\\([^=\n]+\\)=" remaining)
        (let ((pre (substring remaining 0 (match-beginning 0))))
          (when (> (length pre) 0)
            (push `(("type" . "text") ("text" . ,pre)) nodes))
          (push `(("type" . "text") ("text" . ,(match-string 1 remaining))
                  ("marks" . [( ("type" . "code") )])) nodes)
          (setq remaining (substring remaining (match-end 0)))))
       ((string-match "\\[\\[\\([^]]+\\)\\]\\[\\([^]]+\\)\\]\\]" remaining)
        (let ((pre (substring remaining 0 (match-beginning 0)))
              (url (match-string 1 remaining))
              (lbl (match-string 2 remaining)))
          (when (> (length pre) 0)
            (push `(("type" . "text") ("text" . ,pre)) nodes))
          (push `(("type" . "text") ("text" . ,lbl)
                  ("marks" . [( ("type" . "link") ("attrs" . (("href" . ,url))) )])) nodes)
          (setq remaining (substring remaining (match-end 0)))))
       ((string-match "\\[\\[\\([^]]+\\)\\]\\]" remaining)
        (let ((pre (substring remaining 0 (match-beginning 0)))
              (url (match-string 1 remaining)))
          (when (> (length pre) 0)
            (push `(("type" . "text") ("text" . ,pre)) nodes))
          (push `(("type" . "text") ("text" . ,url)
                  ("marks" . [( ("type" . "link") ("attrs" . (("href" . ,url))) )])) nodes)
          (setq remaining (substring remaining (match-end 0)))))
       (t
        (push `(("type" . "text") ("text" . ,remaining)) nodes)
        (setq remaining ""))))
    (nreverse nodes)))

(defun my/org-body-to-adf ()
  "Convert the current org subtree body (below heading+drawer) to ADF."
  (let* ((beg (save-excursion (org-end-of-meta-data t) (point)))
         (end (save-excursion (org-end-of-subtree t t) (point)))
         (body (string-trim (buffer-substring-no-properties beg end)))
         (lines (split-string body "\n"))
         (nodes '())
         (i 0))
    (while (< i (length lines))
      (let ((line (nth i lines)))
        (cond
         ;; src block
         ((string-match "^#\\+begin_src\\(?:[[:space:]]+\\(\\w+\\)\\)?" line)
          (let ((lang (or (match-string 1 line) ""))
                (src '()))
            (setq i (1+ i))
            (while (and (< i (length lines))
                        (not (string-match "^#\\+end_src" (nth i lines))))
              (push (nth i lines) src)
              (setq i (1+ i)))
            (push `(("type" . "codeBlock")
                    ("attrs" . (("language" . ,lang)))
                    ("content" . [( ("type" . "text")
                                    ("text"  . ,(mapconcat #'identity (nreverse src) "\n")) )]))
                  nodes)))
         ;; org heading
         ((string-match "^\\(\\*+\\)[[:space:]]+\\(.*\\)" line)
          (let ((level (max 1 (- (length (match-string 1 line)) 2)))
                (txt   (match-string 2 line)))
            (push `(("type"    . "heading")
                    ("attrs"   . (("level" . ,level)))
                    ("content" . ,(vconcat (my/org--text-to-adf-nodes txt))))
                  nodes)))
         ;; checkbox list — collect consecutive items
         ((string-match "^- \\[\\([ X]\\)\\] \\(.*\\)" line)
          (let ((items '()))
            (while (and (< i (length lines))
                        (string-match "^- \\[\\([ X]\\)\\] \\(.*\\)" (nth i lines)))
              (push (cons (if (string= (match-string 1 (nth i lines)) "X") "DONE" "TODO")
                          (match-string 2 (nth i lines)))
                    items)
              (setq i (1+ i)))
            (setq i (1- i))
            (push `(("type"    . "taskList")
                    ("attrs"   . (("localId" . ,(number-to-string (abs (random))))))
                    ("content" . ,(vconcat
                                   (mapcar
                                    (lambda (item)
                                      `(("type"    . "taskItem")
                                        ("attrs"   . (("localId" . ,(number-to-string (abs (random))))
                                                      ("state"   . ,(car item))))
                                        ("content" . ,(vconcat (my/org--text-to-adf-nodes (cdr item))))))
                                    (nreverse items)))))
                  nodes)))
         ;; bullet list — collect consecutive items
         ((string-match "^- \\(.*\\)" line)
          (let ((items '()))
            (while (and (< i (length lines))
                        (string-match "^- \\(.*\\)" (nth i lines))
                        (not (string-match "^- \\[" (nth i lines))))
              (push (match-string 1 (nth i lines)) items)
              (setq i (1+ i)))
            (setq i (1- i))
            (push `(("type"    . "bulletList")
                    ("content" . ,(vconcat
                                   (mapcar
                                    (lambda (txt)
                                      `(("type"    . "listItem")
                                        ("content" . [( ("type"    . "paragraph")
                                                         ("content" . ,(vconcat (my/org--text-to-adf-nodes txt))) )])))
                                    (nreverse items)))))
                  nodes)))
         ;; non-empty line → paragraph (collect until blank/heading/block)
         ((> (length (string-trim line)) 0)
          (let ((para (list line)))
            (setq i (1+ i))
            (while (and (< i (length lines))
                        (> (length (string-trim (nth i lines))) 0)
                        (not (string-match "^\\*\\+\\|^- \\|^#\\+" (nth i lines))))
              (push (nth i lines) para)
              (setq i (1+ i)))
            (setq i (1- i))
            (push `(("type"    . "paragraph")
                    ("content" . ,(vconcat
                                   (my/org--text-to-adf-nodes
                                    (mapconcat #'identity (nreverse para) " ")))))
                  nodes)))))
      (setq i (1+ i)))
    `(("version" . 1)
      ("type"    . "doc")
      ("content" . ,(vconcat (nreverse nodes))))))

;; ============================================================
;; Pull epics
;; ============================================================

(defun my/jira-pull-epics ()
  "Fetch POPGEN epics from Jira and add any new ones to popgen.org."
  (interactive)
  (let* ((response (my/jira--request
                    "POST"
                    "/rest/api/3/search/jql"
                    `(("jql"        . "project=POPGEN AND issuetype=Epic AND statusCategory != Done ORDER BY created DESC")
                      ("maxResults" . 50)
                      ("fields"     . ["summary" "status"]))))
         (issues (cdr (assq 'issues response)))
         (added 0))
    (dolist (issue issues)
      (let* ((key     (cdr (assq 'key issue)))
             (fields  (cdr (assq 'fields issue)))
             (summary (cdr (assq 'summary fields)))
             (status  (cdr (assq 'name (cdr (assq 'status fields))))))
        (unless (my/jira--find-heading-by-key key)
          (with-current-buffer (find-file-noselect my/jira-popgen-file)
            (goto-char (point-min))
            (if (re-search-forward "^\\* Void" nil t)
                (beginning-of-line)
              (goto-char (point-max)))
            (insert (format "* %s :epic:\n" summary))
            (insert ":PROPERTIES:\n")
            (insert (format ":JIRA_KEY:   %s\n" key))
            (insert (format ":JIRA_URL:   %s/browse/%s\n" my/jira-base-url key))
            (insert (format ":JIRA_TITLE: %s\n" summary))
            (insert ":END:\n\n")
            (insert "** Tasks\n\n")
            (save-buffer))
          (setq added (1+ added)))))
    (message "Epics: %d new" added)))

;; ============================================================
;; Create ticket in Jira
;; ============================================================

(defun my/jira-api-create-ticket ()
  "Create a Jira ticket from the current heading and stamp back properties."
  (interactive)
  (let* ((title    (org-get-heading t t t t))
         (points   (org-entry-get (point) "STORY_POINTS"))
         (epic-key (my/jira--get-parent-epic-key))
         (payload
          `(("fields" .
             (("project"               . (("key" . "POPGEN")))
              ("summary"               . ,title)
              ("issuetype"             . (("id" . ,my-jira-issuetype-id)))
              (,my-jira-points-field-id . ,(string-to-number (or points "3")))
              ,@(when epic-key
                  `(("customfield_10014" . ,epic-key)))))))
         (response (my/jira--request "POST" "/rest/api/3/issue" payload))
         (key      (cdr (assq 'key response))))
    (if key
        (progn
          (org-entry-put (point) "JIRA_KEY"   key)
          (org-entry-put (point) "JIRA_URL"   (format "%s/browse/%s" my/jira-base-url key))
          (org-entry-put (point) "JIRA_TITLE" title)
          (message "Created: %s" key))
      (error "Failed to create ticket. Response: %s"
             (json-encode response)))))

;; ============================================================
;; Sync current ticket (pull fields from Jira)
;; ============================================================

(defun my/jira-sync-ticket ()
  "Pull status, points, sprint and title from Jira for the current heading."
  (interactive)
  (let ((key (org-entry-get (point) "JIRA_KEY")))
    (unless (and key (not (string-blank-p key)))
      (user-error "No JIRA_KEY on this heading"))
    (let* ((response (my/jira--request "GET"
                                       (format "/rest/api/3/issue/%s" key)))
           (fields   (cdr (assq 'fields response)))
           (status   (cdr (assq 'name (cdr (assq 'status fields)))))
           (summary  (cdr (assq 'summary fields)))
           (points   (cdr (assq (intern my-jira-points-field-id) fields)))
           (sprint   (my/jira--get-sprint-name fields)))
      (when status  (my/jira--set-status-tag status))
      (when summary (org-entry-put (point) "JIRA_TITLE" summary))
      (when points  (org-entry-put (point) "STORY_POINTS"
                                   (if (numberp points)
                                       (number-to-string points)
                                     (format "%s" points))))
      (when sprint  (org-entry-put (point) "SPRINT" sprint))
      (message "Synced %s → %s" key (or status "?")))))

;; ============================================================
;; Pull assigned tickets
;; ============================================================

(defun my/jira--insert-new-ticket (key fields epic-pos)
  "Insert a new ticket heading in popgen.org under the correct epic or Void."
  (let* ((summary  (cdr (assq 'summary fields)))
         (status   (cdr (assq 'name (cdr (assq 'status fields)))))
         (points   (cdr (assq (intern my-jira-points-field-id) fields)))
         (sprint   (my/jira--get-sprint-name fields))
         (desc-adf (cdr (assq 'description fields)))
         (body     (my/adf-to-org desc-adf)))
    (with-current-buffer (find-file-noselect my/jira-popgen-file)
      (if epic-pos
          (progn
            (goto-char epic-pos)
            (let ((epic-end (save-excursion (org-end-of-subtree t t) (point))))
              (if (re-search-forward "^\\*\\* Tasks" epic-end t)
                  (beginning-of-line)
                (goto-char epic-end))))
        (goto-char (point-min))
        (re-search-forward "^\\* Void" nil t)
        (let ((void-end (save-excursion (org-end-of-subtree t t) (point))))
          (if (re-search-forward "^\\*\\* Tasks" void-end t)
              (beginning-of-line)
            (goto-char void-end))))
      (insert (format "** [#B] %s :%s:\n" summary
                      (my/jira--status-to-tag status)))
      (insert ":PROPERTIES:\n")
      (insert (format ":CREATED:      %s\n"
                      (format-time-string "[%Y-%m-%d %a %H:%M]")))
      (insert (format ":JIRA_KEY:     %s\n" key))
      (insert (format ":JIRA_URL:     %s/browse/%s\n" my/jira-base-url key))
      (insert (format ":JIRA_TITLE:   %s\n" summary))
      (insert (format ":STORY_POINTS: %s\n"
                      (if points (format "%s" points) "")))
      (insert (format ":SPRINT:       %s\n" (or sprint "")))
      (insert ":END:\n\n")
      (when (> (length body) 0)
        (insert body "\n\n"))
      (save-buffer))))

(defun my/jira-pull-assigned ()
  "Fetch assigned POPGEN tickets. Update existing ones, insert new ones."
  (interactive)
  (let* ((response (my/jira--request
                    "POST"
                    "/rest/api/3/search/jql"
                    `(("jql"        . "assignee=currentUser() AND project=POPGEN AND statusCategory != Done ORDER BY updated DESC")
                      ("maxResults" . 100)
                      ("fields"     . ,(vector "summary" "status" "description"
                                               "parent" "customfield_10014"
                                               "customfield_10020"
                                               my-jira-points-field-id)))))
         (issues       (cdr (assq 'issues response)))
         (new-count     0)
         (updated-count 0))
    (dolist (issue issues)
      (let* ((key      (cdr (assq 'key issue)))
             (fields   (cdr (assq 'fields issue)))
             (existing (my/jira--find-heading-by-key key)))
        (if existing
            (progn
              (with-current-buffer (marker-buffer existing)
                (goto-char (marker-position existing))
                (let ((status  (cdr (assq 'name (cdr (assq 'status fields)))))
                      (summary (cdr (assq 'summary fields)))
                      (points  (cdr (assq (intern my-jira-points-field-id) fields)))
                      (sprint  (my/jira--get-sprint-name fields)))
                  (when status  (my/jira--set-status-tag status))
                  (when summary (org-entry-put (point) "JIRA_TITLE" summary))
                  (when points  (org-entry-put (point) "STORY_POINTS"
                                               (if (numberp points)
                                                   (number-to-string points)
                                                 (format "%s" points))))
                  (when sprint  (org-entry-put (point) "SPRINT" sprint)))
                (save-buffer))
              (setq updated-count (1+ updated-count)))
          (let* ((epic-key (my/jira--get-epic-key-from-fields fields))
                 (epic-pos (when epic-key (my/jira--find-epic-pos epic-key))))
            (my/jira--insert-new-ticket key fields epic-pos)
            (setq new-count (1+ new-count))))))
    (message "Pull complete: %d new, %d updated" new-count updated-count)))

(defun my/jira-pull-all ()
  "Pull epics then assigned tickets from Jira."
  (interactive)
  (my/jira-pull-epics)
  (my/jira-pull-assigned))

;; ============================================================
;; Push body to Jira (org → ADF)
;; ============================================================

(defun my/jira-push-body ()
  "Convert the current heading's body to ADF and PUT it to Jira."
  (interactive)
  (let ((key (org-entry-get (point) "JIRA_KEY")))
    (unless (and key (not (string-blank-p key)))
      (user-error "No JIRA_KEY on this heading"))
    (let* ((adf      (my/org-body-to-adf))
           (payload  `(("fields" . (("description" . ,adf)))))
           (response (my/jira--request
                      "PUT"
                      (format "/rest/api/3/issue/%s" key)
                      payload)))
      ;; PUT returns 204 No Content on success → response is nil
      (if (null response)
          (message "Pushed body to %s" key)
        (message "Pushed body to %s" key)))))

;; ============================================================
;; Status transition (used by j t / j d to push to Jira)
;; ============================================================

(defun my/jira--get-transition-id (key target-status)
  "Return the transition ID for TARGET-STATUS on issue KEY, or nil."
  (let* ((response    (my/jira--request "GET"
                                        (format "/rest/api/3/issue/%s/transitions" key)))
         (transitions (cdr (assq 'transitions response))))
    (cl-some (lambda (tr)
               (when (equal (cdr (assq 'name tr)) target-status)
                 (cdr (assq 'id tr))))
             (or transitions '()))))

(defun my/jira--push-transition (key target-status)
  "Transition Jira issue KEY to TARGET-STATUS via the transitions API."
  (let ((tid (my/jira--get-transition-id key target-status)))
    (if tid
        (progn
          (my/jira--request "POST"
                            (format "/rest/api/3/issue/%s/transitions" key)
                            `(("transition" . (("id" . ,tid)))))
          (message "Transitioned %s → %s" key target-status))
      (message "No available transition to '%s' for %s" target-status key))))
