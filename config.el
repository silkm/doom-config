;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "M. Silk"
      user-mail-address "silk.michael1@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
(setq doom-font (font-spec :family "Inconsolata" :size 13 :weight 'Light))
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-nord)
;; (setq doom-theme 'doom-vibrant)
;; (setq doom-theme 'apropospriate-dark)
;; (setq doom-theme 'doom-monokai-pro)
;; (setq doom-theme 'doom-opera)
;; (setq doom-theme 'catppuccin)
;; (setq catppuccin-flavor 'frappe)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/notebook/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; =============
;; Custom config
;; M. Silk
;; =============


;; LOADS
(load! "secrets.el")
(load! "jira.el")


;; BASICS


;; Disable quit warning
(setq confirm-kill-emacs nil)


;; Start emacsclient server
(require 'server)
(unless (server-running-p)
  (server-start))

;; Fix modeline being truncated by adding some padding
(setq all-the-icons-scale-factor 0.9)
(after! doom-modeline
  (doom-modeline-def-modeline 'main
    '(bar matches buffer-info remote-host buffer-position parrot selection-info)
    '(misc-info minor-modes check input-method buffer-encoding major-mode process vcs "  ")))


;; Add transparency
(set-frame-parameter (selected-frame) 'alpha '(100 . 100))
(add-to-list 'default-frame-alist '(alpha . (100 . 100)))


;; Disable constant git querying over tramp
(setq vc-ignore-dir-regexp
      (format "\\(%s\\)\\|\\(%s\\)"
              vc-ignore-dir-regexp
              tramp-file-name-regexp))

;; Function to adjust transparency
(defun my-set-frame-transparency ()
  "Prompt for alpha value and set frame transparency."
  (interactive)
  (let ((alpha (read-number "Enter alpha value (0-100): " 95)))
    (when (and (>= alpha 0) (<= alpha 100))
      (set-frame-parameter (selected-frame) 'alpha `(,alpha . ,alpha))
      (add-to-list 'default-frame-alist `(alpha . (,alpha . ,alpha)))
      (message "Frame transparency set to %d" alpha))))


;; ;; Enable breadcrumb-mode
;; (use-package! breadcrumb
;;   :config
;;   (breadcrumb-mode t))


;; Add evil motions
;; vih / vah visual around highlight
;; vil / val visual around line
;; hmm but the l keys aren't working in treesitter mode
;; will need to set the keybind there
(use-package! evil-textobj-line)
(use-package! evil-textobj-syntax)


;; Disable ESC menu fully in evil-emacs-mode
(define-key evil-emacs-state-map (kbd "<escape>") #'ignore)


;; Add a function to drop the current line down one
(defun my/insert-newline-above-and-goto ()
  "Insert a blank line above current line and move cursor to it."
  (interactive)
  (beginning-of-line)
  (newline)
  (forward-line -1))

(map! :n "<S-return>" #'my/insert-newline-above-and-goto)


;; Globals
(global-set-key (kbd "C-g") 'keyboard-quit)
(global-set-key (kbd "C-;") 'other-window)
(global-set-key (kbd "C-:") 'previous-multiframe-window)
(global-set-key (kbd "C-c t") 'transpose-frame)
(global-set-key (kbd "C-c d") 'org-time-stamp-inactive)
(global-set-key (kbd "C-c D") (lambda () (interactive) (org-insert-time-stamp (current-time) t t)))
(global-set-key (kbd "s-s") 'evil-avy-goto-char-timer)
(global-set-key (kbd "s-S") 'evil-avy-goto-char)
(global-set-key (kbd "s-f") 'evil-avy-goto-line)
(global-set-key (kbd "s-d") 'evil-multiedit-match-and-next)
(global-set-key (kbd "s-r") 'evil-multiedit-match-and-prev)
(global-set-key (kbd "s-D") 'evil-multiedit-match-all)
(global-set-key (kbd "s-o") 'occur)
(global-set-key (kbd " ") (lambda () (interactive) (insert " ")))
(global-unset-key (kbd "<C-wheel-up>"))
(global-unset-key (kbd "<C-wheel-down>"))


;; Swap doom capture and scratch bindings
(map! :leader
      "X" 'doom/open-scratch-buffer
      "x" 'org-capture)

;; Enable backtab to cycle outline collapse, akin to Org
(map! :map help-mode-map
      :n "<backtab>" #'outline-cycle-buffer)

;; Add toggle to maximise frame to screen
(map! :leader
      :prefix "t"
      "M" #'toggle-frame-maximized)

;; Set Ctrl+K to kill to end of line in insert mode
(map! :i "C-k" #'kill-line)


;; Map custom function calls to SPC-l
(map! :leader
      :prefix "l"
      "t" #'my-set-frame-transparency
      "s" #'my-update-silk-ssh-config)

;; Bind flymake-goto-prev-error to previous error keybinds
(map! :map esc-map
      "g M-p" #'flymake-goto-prev-error)

(map! :map esc-map
      "g M-p" #'flymake-goto-prev-error
      "g p"   #'flymake-goto-prev-error)

(map! :map evil-motion-state-map
      "[ e" #'flymake-goto-prev-error
      "C-e" #'doom/forward-to-last-non-comment-or-eol)

(map!
 "M-g M-p" #'flymake-goto-prev-error
 "M-g p"   #'flymake-goto-prev-error)

(map! :map goto-map
      "M-p" #'flymake-goto-prev-error
      "p"   #'flymake-goto-prev-error)

(map! :map help-quick-use-map
      "M-g M-p" #'flymake-goto-prev-error
      "M-g p"   #'flymake-goto-prev-error)

(map! :map next-error-repeat-map
      "M-p" #'flymake-goto-prev-error
      "p"   #'flymake-goto-prev-error)


;; Bind flymake-goto-next-error to next error keybinds
(map! :map ctl-x-map
      "`" #'flymake-goto-next-error)

(map! :map esc-map
      "g M-n" #'flymake-goto-next-error
      "g n"   #'flymake-goto-next-error)

(map! :map evil-motion-state-map
      "] e" #'flymake-goto-next-error)

(map!
 "C-x `"   #'flymake-goto-next-error
 "M-g M-n" #'flymake-goto-next-error
 "M-g n"   #'flymake-goto-next-error)

(map! :map goto-map
      "M-n" #'flymake-goto-next-error
      "n"   #'flymake-goto-next-error)

(map! :map help-quick-use-map
      "C-x `"   #'flymake-goto-next-error
      "M-g M-n" #'flymake-goto-next-error
      "M-g n"   #'flymake-goto-next-error)

(map! :map next-error-repeat-map
      "M-n" #'flymake-goto-next-error
      "n"   #'flymake-goto-next-error)


;; APPEARANCE


;; Doom splash screen
(setq fancy-splash-image (expand-file-name "splash-images/blackhole-lines-small.svg" doom-user-dir))
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-loaded)
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-footer)


;; Edit faces for tree-sitter; remove bold from the following
(custom-set-faces!  `(tree-sitter-hl-face:method.call :foreground ,(doom-color 'blue)))
(custom-set-faces!  `(tree-sitter-hl-face:label :foreground ,(doom-color 'blue)))
(custom-set-faces!  `(tree-sitter-hl-face:function.call :foreground ,(doom-color 'blue)))
(custom-set-faces!  `(tree-sitter-hl-face:function.macro :foreground ,(doom-color 'blue)))
(custom-set-faces!  `(tree-sitter-hl-face:function.special :foreground ,(doom-color 'blue)))
(custom-set-faces!  `(font-lock-function-name-face :foreground ,(doom-color 'blue)))
;; (custom-set-faces!  `(font-lock-variable-use-face :foreground ,(doom-color 'white))) ;; alleviates the purple in python
;; (custom-set-faces!  `(font-lock-function-call-face :foreground ,(doom-color 'blue) :slant italic)) ;; option to italicise functions

;; Cursor colours
(setq evil-normal-state-cursor '(box "#fce9d9"))
(setq evil-replace-state-cursor '(hbar "#fce9d9"))
(setq evil-insert-state-cursor '(bar "#fce9d9"))
(setq evil-operator-state-cursor (list #'evil-half-cursor "#fce9d9"))
(setq evil-visual-state-cursor '(hollow "#fce9d9"))
(setq evil-emacs-state-cursor (list  #'+evil-emacs-cursor-fn "#f5a098"))


;; Open multiple projects in the one workspace
(setq +workspaces-on-switch-project-behavior nil)



;; avy reduce the timer
(after! avy
  (setq avy-timeout-seconds 0.3)
  (setq avy-all-windows t)
  (defun my/avy-action-exchange (pt)
    "Exchange sexp at PT with the one at point."
    (set-mark pt)
    (transpose-sexps 0))
  (add-to-list 'avy-dispatch-alist '(?e . my/avy-action-exchange)))


;; Disable evil auto indent after o/O
(after! evil
  (setq evil-auto-indent nil))


(after! tramp
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))


(after! vterm
  (evil-set-initial-state 'vterm-mode 'emacs)
  (add-hook 'vterm-mode-hook
            (lambda ()
              (setq-local ring-bell-function 'ignore))))


;; To be avoided, exceptionally slow.
;; (use-package! exec-path-from-shell
;;   :config
;;   (when (memq window-system '(mac ns x))
;;     (exec-path-from-shell-initialize)))


(after! magit
  (setq magit-process-popup-time 0))


(after! org
  (setq electric-indent-mode nil)
  (setq org-startup-folded 'content)
  (setq org-image-actual-width 300)
  (setq org-export-initial-scope 'subtree)
  (remove-hook 'org-tab-first-hook #'+org-cycle-only-current-subtree-h) ;; Cycle headlines classic
  (add-hook 'org-mode-hook (lambda () (hl-line-mode -1))) ;; Disable hl-line-mode to restore @open @closed highlight

  ;; AGENDA

  (setq org-agenda-files
        (append
         (directory-files-recursively "~/notebook/projects/" "\\.org$")
         (directory-files-recursively "~/notebook/docs/" "\\.org$")
         (directory-files-recursively "~/notebook/home/" "\\.org$")
         (list "~/notebook/notes.org" "~/notebook/tasks.org")))
  (setq org-agenda-remove-tags t)

  ;; Agenda - colourise lines by parent epic, status tag badges via org-tag-faces

  (defvar my/epic-color-cache nil)

  (defun my/get-entry-epic (marker)
    "Return the epic heading text for the entry at MARKER, or nil."
    (when (and marker (marker-buffer marker))
      (with-current-buffer (marker-buffer marker)
        (save-excursion
          (goto-char (marker-position marker))
          (let ((epic nil))
            (while (and (not epic) (org-up-heading-safe))
              (when (member "epic" (org-get-tags))
                (setq epic (org-get-heading t t t t))))
            epic)))))

  (defun my/generate-color-palette (n)
    "Generate N distinct colors using HSL golden-ratio spacing."
    (let ((colors '())
          (golden-ratio 0.618033988749895))
      (dotimes (i n)
        (let* ((hue (mod (* i golden-ratio) 1.0))
               (color (color-hsl-to-rgb hue 0.6 0.65)))
          (push (apply #'color-rgb-to-hex color) colors)))
      (nreverse colors)))

  (defun my/get-epic-colors ()
    "Return cached epic-to-color alist, regenerating if epics have changed."
    (let ((epics '()))
      (org-map-entries
       (lambda ()
         (when (member "epic" (org-get-tags))
           (push (org-get-heading t t t t) epics)))
       nil 'agenda)
      (let ((sorted (sort epics #'string<)))
        (unless (equal (mapcar #'car my/epic-color-cache) sorted)
          (setq my/epic-color-cache
                (cl-mapcar #'cons sorted (my/generate-color-palette (length sorted)))))
        my/epic-color-cache)))

  (defun my/colorize-by-epic ()
    "Colorize agenda lines by their parent epic."
    (let ((epic-colors (my/get-epic-colors)))
      (save-excursion
        (goto-char (point-min))
        (while (not (eobp))
          (let* ((marker (or (org-get-at-bol 'org-hd-marker)
                             (org-get-at-bol 'org-marker)))
                 (epic (my/get-entry-epic marker))
                 (color (when epic (cdr (assoc epic epic-colors)))))
            (when color
              (add-text-properties
               (line-beginning-position)
               (line-end-position)
               `(face (:foreground ,color)))))
          (forward-line 1)))))

  (add-hook 'org-agenda-finalize-hook #'my/colorize-by-epic)

  ;; Agenda - Project view formatting

  (defun my/agenda-story-points ()
    "Return story points. Uses [ ] if synced to Jira, - - if unsynced."
    (let ((points (org-entry-get (point) "STORY_POINTS"))
          (key (org-entry-get (point) "JIRA_KEY")))
      (if (and points (not (string-blank-p points)))
          (if (and key (not (string-blank-p key)))
              (format "[%s]" points)
            (format "-%s-" points))
        "   "))) ;; Spacer if no points set

  (defun my/agenda-deadline ()
    "Return relative deadline, e.g. In 3d or Late 2d"
    (let ((d-str (org-entry-get (point) "DEADLINE")))
      (if d-str
          (let* ((d-time (org-time-string-to-time d-str))
                 (days (- (time-to-days d-time)
                          (time-to-days (current-time)))))
            (cond ((< days 0) (format "Late %dd" (abs days)))
                  ((= days 0) "Due Today")
                  (t (format "In %dd" days))))
        "")))

  ;; Agenda - display settings and shortcut

  (setq org-agenda-prefix-format
        '((agenda . " %i %-12:c%?-12t% s")
          (todo . " %i %-25:c")
          (tags . " %i %-25:c %-5(my/agenda-story-points) %-11(my/agenda-deadline) ")
          (search . " %i %-12:c")))

  (setq org-agenda-sorting-strategy
        '((agenda habit-down time-up priority-down category-keep)
          (todo   priority-down category-keep)
          (tags   category-keep priority-down)
          (search category-keep priority-down)))

  (setq org-agenda-custom-commands
        '(("o" "Project Dashboard"
           (
            ;; --- Active: in flight ---
            (tags "@in_progress|@in_review|@blocked"
                  ((org-agenda-overriding-header "Active")))

            ;; --- Queued: not yet started ---
            (tags "@todo|@approved|@backlog"
                  ((org-agenda-overriding-header "Queued")))

            ;; --- TODOs: non-Jira tasks, coloured by parent epic ---
            (alltodo ""
                     ((org-agenda-overriding-header "TODOs")
                      (org-agenda-skip-function
                       '(org-agenda-skip-entry-if
                         'regexp
                         ":@in_progress:\\|:@in_review:\\|:@blocked:\\|:@todo:\\|:@approved:\\|:@backlog:\\|:@done:\\|:@wont_do:"))
                      (org-agenda-prefix-format '((todo . " %i %-25:c ")))
                      (org-agenda-sorting-strategy '(priority-down category-keep))))
            ))))

  (map! :leader
        :prefix "o a"
        :desc "View active tickets"
        "o" (lambda () (interactive) (org-agenda nil "o")))

  (setq org-refile-targets '((org-agenda-files :maxlevel . 2)))
  (setq org-refile-allow-creating-parent-nodes 'confirm)

  (setq org-tags-exclude-from-inheritance
        '("@backlog" "@todo" "@approved" "@in_progress" "@in_review"
          "@blocked" "@done" "@wont_do" "epic"))

  (setq org-tag-faces
        '(("@backlog"     . (:foreground "#737994" :background "#414559" :weight bold))
          ("@todo"        . (:foreground "#c6d0f5" :background "#51576d" :weight bold))
          ("@approved"    . (:foreground "#85c1dc" :background "#2d4555" :weight bold))
          ("@in_progress" . (:foreground "#8caaee" :background "#2a3459" :weight bold))
          ("@in_review"   . (:foreground "#e5c890" :background "#403d28" :weight bold))
          ("@blocked"     . (:foreground "#e78284" :background "#402828" :weight bold))
          ("@done"        . (:foreground "#a6d189" :background "#2a3d28" :weight bold))
          ("@wont_do"     . (:foreground "#838ba7" :background "#414559" :weight bold))
          ("epic"         . (:foreground "#ca9ee6" :background "#3a2d50" :weight bold))))

  (defun my/set-jira-status ()
    "Prompt for a Jira status and set it on the current headline."
    (interactive)
    (let ((selected (completing-read "Status: " my/jira-status-tags nil t)))
      (save-excursion
        (org-back-to-heading t)
        (dolist (s my/jira-status-tags)
          (org-toggle-tag s 'off))
        (org-toggle-tag selected 'on))))

  (defun my/jira-set-done ()
    "Set current ticket status to Done."
    (interactive)
    (save-excursion
      (org-back-to-heading t)
      (dolist (s my/jira-status-tags)
        (org-toggle-tag s 'off))
      (org-toggle-tag "@done" 'on)))

  ;; Jira ticket exports

  (defun my/jira-create-ticket-from-headline ()
    "Create Jira URL and open rendered HTML description in browser."
    (interactive)
    (require 'ox-html)

    (let* ((base-url "https://cpg-populationanalysis.atlassian.net/secure/CreateIssueDetails!init.jspa")

           (title (org-get-heading t t t t))
           (points (org-entry-get (point) "STORY_POINTS"))

           (deadline-time (org-get-deadline-time (point)))
           (deadline-str (when deadline-time
                           (format-time-string "%d/%b/%y" deadline-time)))

           (program-option-id (or (org-entry-get (point) "PROGRAM_ID")
                                  my-jira-default-program-id))

           (filename (concat (make-temp-file "jira-export-") ".html")))

      ;; Export the specific subtree to the temp file
      (org-export-to-file 'html filename nil t nil t)

      ;; Create URL
      (let ((url-params
             (concat
              "?pid=" my-jira-project-id
              "&issuetype=" my-jira-issuetype-id
              "&assignee=" my-jira-account-id
              "&summary=" (url-hexify-string title)
              "&" my-jira-points-field-id "=" (or points "3")
              "&" my-jira-program-field-id "=" program-option-id
              (if deadline-str (concat "&duedate=" deadline-str) ""))))

        ;; Open the local HTML file
        (browse-url-of-file filename)

        ;; Open the Jira Link
        (browse-url (concat base-url url-params))

        (message "Opened Jira ticket creation."))))

  (defun my/jira-render-headline-html ()
    "Export ticket to HTML and open existing ticket."
    (interactive)
    (require 'ox-html)

    (let ((filename (concat (make-temp-file "jira-update-") ".html"))
          (url (org-entry-get (point) "JIRA_URL")))

      ;; Export settings:
      ;; async=nil, subtreep=t (only current headline), visible-only=nil, body-only=t
      (org-export-to-file 'html filename nil t nil t)

      ;; Open HTML render
      (browse-url-of-file filename)

      ;; Open Jira URL if present
      (if (and url (not (string-blank-p url)))
          (progn
            (browse-url url)
            (message "Opened Jira ticket update."))
        (message "Opened Jira ticket update (no Jira URL found)."))))


  (setq org-capture-templates
        '(("j" "Journal" entry (file+olp+datetree "~/notebook/notes.org" "Journal")
           "* %^{PROMPT}  :note:\n%u\n\n%?\n"
           :empty-lines 1)

          ("m" "Meeting" entry (file+olp+datetree "~/notebook/notes.org" "Journal")
           "* Meeting: %^{PROMPT}  :meeting:\n%u\n\n%?\n"
           :empty-lines 1)

          ("s" "Seminar" entry (file+olp+datetree "~/notebook/notes.org" "Journal")
           "* Seminar: %^{PROMPT}  :seminar:\n%u\n\n%?\n"
           :empty-lines 1)

          ("t" "Task" entry
           (file+function
            "~/notebook/projects/popgen.org"
            (lambda ()
              (let ((epics-alist '()))
                (org-map-entries
                 (lambda ()
                   (when (member "epic" (org-get-tags))
                     (push (cons (org-get-heading t t t t) (point)) epics-alist)))
                 nil 'file)
                (let* ((choices (append (mapcar #'car (nreverse epics-alist)) '("Void")))
                       (selected (completing-read "File under epic: " choices nil t nil nil "Void")))
                  (if (string= selected "Void")
                      (progn
                        (goto-char (point-min))
                        (re-search-forward "^\\* Void" nil t)
                        (let ((end (save-excursion (org-end-of-subtree t t) (point))))
                          (re-search-forward "^\\*\\* Tasks" end t)))
                    (let ((epic-pos (cdr (assoc selected epics-alist))))
                      (goto-char epic-pos)
                      (let ((end (save-excursion (org-end-of-subtree t t) (point))))
                        (re-search-forward "^\\*\\* Tasks" end t))))))))
           "* TODO [#B] %i%?\n")

          ("p" "Project Ticket" plain
           (file+function
            "~/notebook/projects/popgen.org"
            (lambda ()
              (let ((epics-alist '()))
                (org-map-entries
                 (lambda ()
                   (when (member "epic" (org-get-tags))
                     (push (cons (org-get-heading t t t t) (point)) epics-alist)))
                 nil 'file)
                (let* ((choices (append (mapcar #'car (nreverse epics-alist)) '("Void")))
                       (selected (completing-read "Epic: " choices nil t)))
                  (if (string= selected "Void")
                      (progn
                        (goto-char (point-min))
                        (re-search-forward "^\\* Void" nil t))
                    (goto-char (cdr (assoc selected epics-alist))))
                  (let ((epic-end (save-excursion (org-end-of-subtree t t) (point))))
                    (if (re-search-forward "^\\*\\* Tasks" epic-end t)
                        (beginning-of-line)
                      (goto-char epic-end)))))))
           "** [#%^{Priority|B|A|B|C}] %^{Task name} :@todo:\n:PROPERTIES:\n:CREATED: %U\n:JIRA_KEY:\n:JIRA_TITLE:\n:STORY_POINTS: %^{Story Points|3}\n:SPRINT:\n:JIRA_URL:\n:END:\n\n*Description*\n%?\n\n*Definition of Done*\n\n\n")

          ("l" "Maintenance Log" entry (file+headline "~/notebook/notes.org" "Maintenance")
           "* %^{PROMPT} %^g \n%u\n\n%?\n"
           :empty-lines 1)))

  (defun my/org-set-jira-url ()
    "Prompt for a Jira URL and save it to the current headline's JIRA_URL property."
    (interactive)
    (save-excursion
      (org-back-to-heading t)
      (let ((url (string-trim (read-string "Paste Jira URL: "))))
        (if (string-blank-p url)
            (message "Cancelled.")
          (org-entry-put (point) "JIRA_URL" url)
          (message "Linked ticket to: %s" url)))))

  (defun my/refile-to-project-tasks ()
    "Refile current heading to a selected project file under * Tasks heading."
    (interactive)
    (let* ((project-dir "~/notebook/projects/")
           (files (directory-files project-dir t ".*\\.org$"))
           (file-names (mapcar #'file-name-nondirectory files))
           (selected-name (completing-read "Select project file: " file-names nil t))
           (selected-file (expand-file-name selected-name project-dir)))
      ;; Set up refile targets temporarily
      (let ((pos (save-excursion
                   (find-file selected-file)
                   (org-find-exact-headline-in-buffer "Tasks")))
            (orig-buffer (current-buffer)))
        ;; Refile to the selected file under Tasks
        (org-refile nil nil (list "Tasks" selected-file nil pos))
        (org-save-all-org-buffers)
        (switch-to-buffer orig-buffer))))

  (defun remove-ispell-completion-at-point ()
    "Disable capf completion-at-point ispell-completion-at-point."
    (setq-local
     completion-at-point-functions
     (remove 'ispell-completion-at-point completion-at-point-functions)))
  (add-hook 'org-mode-hook #'remove-ispell-completion-at-point)

  ;; Redefine org--insert item to add newlines
  (defun +org--insert-item-edit (direction)
    (let ((context (org-element-lineage
                    (org-element-context)
                    '(table table-row headline inlinetask item plain-list)
                    t)))
      (pcase (org-element-type context)
        ;; Add a new list item (carrying over checkboxes if necessary)
        ((or `item `plain-list)
         (let ((orig-point (point)))
           ;; Position determines where org-insert-todo-heading and `org-insert-item'
           ;; insert the new list item.
           (if (eq direction 'above)
               (org-beginning-of-item)
             (end-of-line))
           (let* ((ctx-item? (eq 'item (org-element-type context)))
                  (ctx-cb (org-element-property :contents-begin context))
                  ;; Hack to handle edge case where the point is at the
                  ;; beginning of the first item
                  (beginning-of-list? (and (not ctx-item?)
                                           (= ctx-cb orig-point)))
                  (item-context (if beginning-of-list?
                                    (org-element-context)
                                  context))
                  ;; Horrible hack to handle edge case where the
                  ;; line of the bullet is empty
                  (ictx-cb (org-element-property :contents-begin item-context))
                  (empty? (and (eq direction 'below)
                               ;; in case contents-begin is nil, or contents-begin
                               ;; equals the position end of the line, the item is
                               ;; empty
                               (or (not ictx-cb)
                                   (= ictx-cb
                                      (1+ (point))))))
                  (pre-insert-point (point)))
             ;; Insert dummy content, so that `org-insert-item'
             ;; inserts content below this item
             (when empty?
               (insert " "))
             (org-insert-item (org-element-property :checkbox context))
             ;; Remove dummy content
             (when empty?
               (delete-region pre-insert-point (1+ pre-insert-point))))))
        ;; Add a new table row
        ((or `table `table-row)
         (pcase direction
           ('below (save-excursion (org-table-insert-row t))
                   (org-table-next-row))
           ('above (save-excursion (org-shiftmetadown))
                   (+org/table-previous-row))))
        ;; Otherwise, add a new heading, carrying over any todo state, if
        ;; necessary.
        (_
         (let ((level (or (org-current-level) 1)))
           ;; I intentionally avoid `org-insert-heading' and the like because they
           ;; impose unpredictable whitespace rules depending on the cursor
           ;; position. It's simpler to express this command's responsibility at a
           ;; lower level than work around all the quirks in org's API.
           (pcase direction
             (`below
              (goto-char (line-end-position))
              (org-end-of-subtree)
              ;; Check if we're about to create a TODO heading
              (let* ((todo-keyword (org-element-property :todo-keyword context))
                     (todo-type (org-element-property :todo-type context))
                     (will-be-todo (and todo-keyword (not (eq todo-type 'done)))))
                ;; Only ensure newline above new heading if it won't be a TODO
                (unless (or will-be-todo
                            (looking-back "\n[ \t]*\n" (max (point-min) (- (point) 4))))
                  (insert "\n")))
              (insert "\n" (make-string level ?*) " "))
             (`above
              (org-back-to-heading)
              ;; Check if we're about to create a TODO heading
              (let* ((todo-keyword (org-element-property :todo-keyword context))
                     (todo-type (org-element-property :todo-type context))
                     (will-be-todo (and todo-keyword (not (eq todo-type 'done)))))
                ;; Only ensure newline above new heading if it won't be a TODO
                (unless (or will-be-todo
                            (looking-back "\n[ \t]*\n" (max (point-min) (- (point) 4))))
                  (insert "\n")))
              (insert (make-string level ?*) " ")
              (save-excursion (insert "\n"))))
           (run-hooks 'org-insert-heading-hook)
           (when-let* ((todo-keyword (org-element-property :todo-keyword context))
                       (todo-type    (org-element-property :todo-type context)))
             (org-todo
              (cond ((eq todo-type 'done)
                     ;; Doesn't make sense to create more "DONE" headings
                     (car (+org-get-todo-keywords-for todo-keyword)))
                    (todo-keyword)
                    ('todo)))))))
      (when (org-invisible-p)
        (org-show-hidden-entry))
      (when (and (bound-and-true-p evil-local-mode)
                 (not (evil-emacs-state-p)))
        (evil-insert 1))))

  (defun +org/insert-item-below-edit (count)
    "Inserts a new heading, table cell or item below the current one."
    (interactive "p")
    (dotimes (_ count) (+org--insert-item-edit 'below)))

  (defun +org/insert-item-above-edit (count)
    "Inserts a new heading, table cell or item below the current one."
    (interactive "p")
    (dotimes (_ count) (+org--insert-item-edit 'above)))

  (defun my/org-insert-checkbox ()
    "Insert a checkbox - [ ] and enter insert mode."
    (interactive)
    (insert "- [ ] ")
    (evil-insert-state))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (jupyter . t)))

  (map! :map org-mode-map
        "C-<return>" #'+org/insert-item-below-edit
        "C-RET"      #'+org/insert-item-below-edit
        "s-<return>" #'+org/insert-item-below-edit
        "C-S-<return>" #'+org/insert-item-above-edit
        "C-S-RET"      #'+org/insert-item-above-edit
        "S-s-<return>" #'+org/insert-item-above-edit
        "C-c l" #'my/org-insert-checkbox
        "C-c C-;" #'my/set-jira-status
        "C-c j" #'my/jira-create-ticket-from-headline)

  (map! :map org-mode-map
        :leader
        :prefix "j"
        :desc "Create ticket in Jira"  "o" #'my/jira-api-create-ticket
        :desc "Render HTML"            "u" #'my/jira-render-headline-html
        :desc "Set status"             "t" #'my/set-jira-status
        :desc "Mark as done"           "d" #'my/jira-set-done
        :desc "Set Jira URL"           "l" #'my/org-set-jira-url
        :desc "Pull epics + tickets"   "p" #'my/jira-pull-all
        :desc "Pull epics only"        "e" #'my/jira-pull-epics
        :desc "Push body to Jira"      "b" #'my/jira-push-body
        :desc "Sync current ticket"    "s" #'my/jira-sync-ticket)

  (map! :map org-mode-map
        :localleader
        "r p" #'my/refile-to-project-tasks)

  (map! :after evil-org
        :map evil-org-mode-map
        :i "C-<return>" #'+org/insert-item-below-edit
        :n "C-<return>" #'+org/insert-item-below-edit
        :i "C-S-<return>" #'+org/insert-item-above-edit
        :n "C-S-<return>" #'+org/insert-item-above-edit))

(map! :map org-mode-map
      :niv "C-S-<tab>" #'(lambda () (interactive) (org-shifttab 2)))


(after! evil-org
  (remove-hook 'org-tab-first-hook #'+org-cycle-only-current-subtree-h))


(after! org-download
  (setq org-download-method 'download)
  (setq org-download-heading-lvl nil)
  (setq org-download-image-dir "~/notebook/img/")
  (setq org-download-link-format "[[~/notebook/img/%s]]\n")
  (advice-add 'org-id-get-create :override #'ignore))


(defun my/corfu-kill-ghost-frame ()
  "Directly locate and destroy the orphaned Corfu child frame."
  (interactive)
  (when (and (boundp 'corfu--frame)
             (frame-live-p corfu--frame))
    (delete-frame corfu--frame)
    ;; Clear the variable so Corfu knows it needs to build a new one next time
    (setq corfu--frame nil)))
(advice-add 'toggle-frame-fullscreen :after #'my/corfu-kill-ghost-frame)


(after! winum
  (setq winum-auto-setup-mode-line nil)
  :config
  (winum-mode))


(after! smartparens
  ;; Prevent pair insertion in the minibuffer (ex commands, M-x, etc.).
  ;; Mode-level disabling doesn't survive smartparens-global-mode re-enabling it,
  ;; so advise the post-self-insert handler directly to no-op in minibuffer buffers.
  (advice-add 'sp--post-self-insert-hook-handler :before-while
              (lambda (&rest _) (not (minibufferp))))
  (add-hook 'evil-command-window-mode-hook #'turn-off-smartparens-mode)

  ;; Backspace: only use smartparens pair-deletion for empty pairs (e.g. () → delete both).
  ;; Falls back to plain delete-backward-char for non-empty pairs, avoiding the strict-mode
  ;; "skip over delimiter" behaviour where backspace moves the cursor without deleting.
  (defun my/smart-backspace ()
    "Delete backward; if inside an empty pair, delete both delimiters."
    (interactive)
    (let ((enc (sp-get-enclosing-sexp)))
      (if (and enc
               (= (point) (sp-get enc :beg-in))
               (= (sp-get enc :beg-in) (sp-get enc :end-in)))
          (sp-backward-delete-char)
        (delete-char -1))))

  (map! :map smartparens-mode-map
        :i [backspace] #'my/smart-backspace
        :i "DEL"       #'my/smart-backspace))


;; Window swapping meh commands
(map! "C-M-S-o" #'evil-window-up)
(map! "C-M-S-h" #'evil-window-left)
(map! "C-M-S-a" #'evil-window-down)
(map! "C-M-S-e" #'evil-window-right)

(map! "C-M-S-p" #'split-window-right)
(map! "C-M-S-f" #'split-window-below)

(map! "C-M-S-w" #'evil-window-delete)

(map! "C-M-S-n" #'shrink-window-horizontally)
(map! "C-M-S-r" #'shrink-window)
(map! "C-M-S-t" #'enlarge-window)
(map! "C-M-S-s" #'enlarge-window-horizontally)
(map! "C-M-S-k" #'balance-windows)

(cond ((eq system-type 'darwin)
       (map! "s-0" #'winum-select-window-0-or-10)
       (map! "s-1" #'winum-select-window-1)
       (map! "s-2" #'winum-select-window-2)
       (map! "s-3" #'winum-select-window-3)
       (map! "s-4" #'winum-select-window-4)
       (map! "s-5" #'winum-select-window-5)
       (map! "s-6" #'winum-select-window-6)
       (map! "s-7" #'winum-select-window-7)
       (map! "s-8" #'winum-select-window-8)
       (map! :after evil
             :map evil-normal-state-map
             "s-0" nil
             "s-1" nil
             "s-2" nil
             "s-3" nil
             "s-4" nil
             "s-5" nil
             "s-6" nil
             "s-7" nil
             "s-8" nil))
      ((eq system-type 'gnu/linux)
       (map! "M-0" #'winum-select-window-0-or-10)
       (map! "M-1" #'winum-select-window-1)
       (map! "M-2" #'winum-select-window-2)
       (map! "M-3" #'winum-select-window-3)
       (map! "M-4" #'winum-select-window-4)
       (map! "M-5" #'winum-select-window-5)
       (map! "M-6" #'winum-select-window-6)
       (map! "M-7" #'winum-select-window-7)
       (map! "M-8" #'winum-select-window-8)
       (map! :after evil
             :map evil-normal-state-map
             "M-0" nil
             "M-1" nil
             "M-2" nil
             "M-3" nil
             "M-4" nil
             "M-5" nil
             "M-6" nil
             "M-7" nil
             "M-8" nil)))

(when (not (display-graphic-p))
  (map! :leader
        "0" 'winum-select-window-0-or-10
        "1" #'winum-select-window-1
        "2" #'winum-select-window-2
        "3" #'winum-select-window-3
        "4" #'winum-select-window-4
        "5" #'winum-select-window-5
        "6" #'winum-select-window-6
        "7" #'winum-select-window-7
        "8" #'winum-select-window-8)
  (load-theme 'doom-opera t))


;; workspace switching with SPC-num
(map! :leader
      :desc "Switch to workspace 1" "1" #'(lambda () (interactive) (+workspace/switch-to 0))
      :desc "Switch to workspace 2" "2" #'(lambda () (interactive) (+workspace/switch-to 1))
      :desc "Switch to workspace 3" "3" #'(lambda () (interactive) (+workspace/switch-to 2))
      :desc "Switch to workspace 4" "4" #'(lambda () (interactive) (+workspace/switch-to 3))
      :desc "Switch to workspace 5" "5" #'(lambda () (interactive) (+workspace/switch-to 4))
      :desc "Switch to workspace 6" "6" #'(lambda () (interactive) (+workspace/switch-to 5))
      :desc "Switch to workspace 7" "7" #'(lambda () (interactive) (+workspace/switch-to 6))
      :desc "Switch to workspace 8" "8" #'(lambda () (interactive) (+workspace/switch-to 7))
      :desc "Switch to workspace 9" "9" #'(lambda () (interactive) (+workspace/switch-to 8))
      :desc "Switch to last workspace" "0" #'+workspace/switch-to-final)

(after! ess

  (evil-set-initial-state 'ess-r-mode 'emacs)
  (evil-set-initial-state 'inferior-ess-r-mode 'emacs)

  (defun ess-insert-header ()
    "Insert R header lines and standard libs."
    (interactive)
    (insert "# "
            (file-name-nondirectory (buffer-file-name))
            "\n# M. Silk\n"
            "# " (format-time-string "%Y%m%d")
            "\n\n\n\nlibrary(data.table)\nlibrary(magrittr)\nlibrary(purrr)\n")
    (goto-char (point-min))
    (forward-line 4))
  (setq ess-indent-with-fancy-comments nil
        ess-style 'RStudio
        inferior-R-args "--no-save")
  (map! :map ess-mode-map
        :nv "<C-return>" #'ess-eval-line-and-step
        :n "C-c m" #'ess-reset-ansi-colours
        "C-c l" #'ess-insert-header)
  :config
  (defun ess-reset-ansi-colours ()
    (interactive)
    (setq-local ansi-color-for-comint-mode 'filter)))


(after! python
  :config
  (add-hook 'python-mode-hook
            (lambda ()
              (setq python-indent-def-block-scale 1)))
  (map! :map python-mode-map
        :n "C-c C-w" #'(lambda () (interactive) (python-shell-send-buffer t)))
  (add-hook 'python-mode-hook #'eglot-ensure)
  (add-hook 'python-ts-mode-hook #'eglot-ensure))


(after! treesit
  (setq treesit-language-source-alist
        '((python "https://github.com/tree-sitter/tree-sitter-python")
          (elisp "https://github.com/Wilfred/tree-sitter-elisp")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src" nil nil)
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src" nil nil))))


;; note that diagnostics at end of line will show everything
;; and gets noisy with our repos.
;; Popon mode disabling also cuts out some of the noise
(after! flymake
  (set-face-attribute 'flymake-error nil
                      :underline '(:style dots :color "red"))
  (set-face-attribute 'flymake-warning nil
                      :underline '(:style dots :color "#FBBF77"))
  (set-face-attribute 'flymake-note nil
                      :underline '(:style dots :color "blue"))
  (setq flymake-show-diagnostics-at-end-of-line 'short)
  (remove-hook 'flymake-mode-hook #'flymake-popon-mode))


(after! eldoc
  (setq eldoc-display-functions '(eldoc-display-in-echo-area)))


(after! flymake-eslint
  (add-hook 'typescript-mode-hook #'flymake-eslint-enable)
  (add-hook 'typescript-tsx-mode-hook #'flymake-eslint-enable)
  (add-hook 'js-mode-hook #'flymake-eslint-enable)
  (add-hook 'jsx-mode-hook #'flymake-eslint-enable))


;; Apheleia set to run ruff format with no quote changing
;; and no line length splitting. These can be handled by the
;; pre-commit steps instead.
;; Edit: disabled specifying arguments for apheleia so it would properly
;; pick up the pyproject.toml settings, particularly for pre-commit.
(after! apheleia
  :init
  ;; (setf (alist-get 'ruff apheleia-formatters)
  ;; '("ruff" "format" "--config" "format.quote-style='preserve'" "-"))
  ;; '("ruff" "format" "--config" "format.quote-style='single'" "-"))
  (setf (alist-get 'python-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist)
        '(ruff-isort ruff)))


;; EGLOT + PYLSP + RUFF
;; this gives the speed boosts of ruff, which replaces
;; autopep8, flake8, pyflakes, pylint, mccabe, at the cost
;; of using flymake instead of flycheck (as flymake uses ruff).
;; Aside from the ugly error popups flymake gives, it's really
;; good!
;; [X] enabled; [-] disabled; for those that can be used
;; (alt) == disabled by default, alternate tool python-lsp-server can use
;; (ruff) == replaced by ruff
;; Note that black and isort are handled by aphelia
;; EDIT [2026-02-15 Sun]
;; Swapped to basedpyright to give that a go.
(after! eglot
  (require 'flymake-ruff)
  (setq eglot-code-action-indicator "*")
  (add-to-list 'eglot-server-programs
               '(python-mode . ("basedpyright-langserver" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(python-ts-mode . ("basedpyright-langserver" "--stdio")))
  (add-to-list 'eglot-server-programs
               '((tsx-mode typescript-tsx-mode) . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(haskell-mode . ("haskell-language-server-wrapper" "--lsp")))
  (add-to-list 'eglot-server-programs
               '(haskell-ts-mode . ("haskell-language-server-wrapper" "--lsp")))
  (setq-default eglot-workspace-configuration
                '(:basedpyright.analysis ( :typeCheckingMode "standard"
                                                             :autoImportCompletions t
                                                             :diagnosticMode "openFilesOnly"
                                                             :diagnosticSeverityOverrides (:reportUnusedImport "none"
                                                                                           :reportUnusedVariable "none")
                                                             :inlayHints (:variableTypes :json-false
                                                                          :functionReturnTypes :json-false
                                                                          :callArgumentNames :json-false
                                                                          :genericTypes :json-false))))
  (add-hook 'eglot-managed-mode-hook #'flymake-ruff-load))
;; (setq-default eglot-workspace-configuration
;;               '(:pylsp (:plugins (:jedi_completion (:include_params t :fuzzy t) ;; [X] autocompletion
;;                                   :rope (:enabled t)                            ;; [X] refactoring (can swap with lsp rope)
;;                                   :pylsp_mypy (:enabled t)                      ;; [X] type checking
;;                                   :pydocstyle (:enabled t)                      ;; [X] docstring style checking
;;                                   :ruff (:enabled t :formatEnabled :json-false) ;; [X] linting
;;                                   :autopep8 (:enabled :json-false)              ;; (ruff) uses pycodestyle to auto format
;;                                   :yapf (:enabled :json-false)                  ;; (ruff) applies formatting
;;                                   :pyflakes (:enabled :json-false)              ;; (ruff) error checking
;;                                   :mccabe (:enabled :json-false)                ;; (ruff) complexity checking
;;                                   :pycodestyle (:enabled :json-false)           ;; (ruff) style checking
;;                                   :flake8 (:enabled :json-false)                ;; (alt) error checking
;;                                   :pylint (:enabled :json-false)                ;; (alt) linting
;;                                   ))))
;;



(after! dape
  :config
  (setq dape-buffer-window-arrangement 'right
        dape-inlay-hints nil)
  (map! :leader
        :desc "dape" "d" dape-global-map))


(after! copilot
  :config
  (setq copilot-indent-offset-warning-disable t)
  (map! :map copilot-mode-map
        :i "C-<tab>" #'copilot-accept-completion
        :i "C-S-<tab>" #'copilot-accept-completion-by-word
        :i "C-n" #'copilot-next-completion
        :i "C-p" #'copilot-previous-completion))


(after! gptel
  :config
  (setq gptel-backend (gptel-make-anthropic "Claude"
                        :stream t
                        :key gptel-api-key))
  (setq gptel-model 'claude-sonnet-4-20250514)
  (setq gptel-default-mode 'org-mode))


(after! plantuml-mode
  :init
  (setq plantuml-jar-path (expand-file-name "~/software/plantuml/plantuml-1.2025.2.jar")
        plantuml-executable-path (executable-find "plantuml")
        plantuml-default-exec-mode 'executable))


(defun my/dired-colab ()
  (interactive)
  (find-file "/ssh:msilk-colab.australia-southeast1-b.notebooks-314505|docker:colab-kernel:/"))


(defun my-update-silk-ssh-config ()
  "Update SSH config entries for hosts starting with silk- in ~/.ssh/config.
   Removes duplicate entries, keeping the simpler one from Google."
  (interactive)
  (let ((config-file (expand-file-name "~/.ssh/config")))
    (unless (file-exists-p config-file)
      (error "SSH config file not found: %s" config-file))
    (with-current-buffer (find-file-noselect config-file)
      ;; First pass: collect all silk- entries and identify duplicates to delete
      (let ((entries '())
            (to-delete '()))
        (save-excursion
          (goto-char (point-min))
          (while (re-search-forward "^Host \\(.*silk-[^ \t\n]+.*\\)$" nil t)
            (let* ((host-line (match-string 1))
                   (line-pos (match-beginning 0))
                   (entry-end (save-excursion
                                (if (re-search-forward "^Host " nil t)
                                    (match-beginning 0)
                                  (point-max)))))
              ;; Extract the full silk- hostname
              (when (string-match "\\(silk-[^ \t\n]+\\)" host-line)
                (let ((long-hostname (match-string 1 host-line)))
                  (push (list long-hostname host-line line-pos entry-end) entries))))))

        ;; Group entries by long hostname to find duplicates
        (let ((hostname-map (make-hash-table :test 'equal)))
          (dolist (entry entries)
            (let* ((long-hostname (car entry))
                   (existing (gethash long-hostname hostname-map)))
              (puthash long-hostname (cons entry existing) hostname-map)))

          ;; For duplicates, mark the edited entries (with aliases) for deletion
          (maphash
           (lambda (long-hostname entry-list)
             (when (> (length entry-list) 1)
               ;; Multiple entries with same long hostname - delete the ones with aliases
               (dolist (entry entry-list)
                 (let ((host-line (nth 1 entry))
                       (line-pos (nth 2 entry))
                       (entry-end (nth 3 entry)))
                   ;; Delete if Host line has space after hostname (i.e., has aliases)
                   (when (string-match (concat "^" (regexp-quote long-hostname) "[ \t]+") host-line)
                     (push (cons line-pos entry-end) to-delete))))))
           hostname-map))

        ;; Delete marked entries in reverse order to preserve positions
        (dolist (region (sort to-delete (lambda (a b) (> (car a) (car b)))))
          (delete-region (car region) (cdr region))))

      ;; Second pass: update remaining entries with aliases and User jupyter
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward "^Host \\(.*silk-[^ \t\n]+.*\\)$" nil t)
          (let ((original-line (match-string 1))
                (line-start (match-beginning 0)))
            ;; Extract the silk- hostname
            (when (string-match "\\(silk-[^ \t\n]+\\)" original-line)
              (let* ((full-host (match-string 1 original-line))
                     (short-alias (car (split-string full-host "\\."))))
                ;; Check if short alias is already in the line
                (unless (or (string-match-p (concat "^" (regexp-quote short-alias) "\\([ \t]\\|$\\)") original-line)
                            (string-match-p (concat "[ \t]" (regexp-quote short-alias) "\\([ \t]\\|$\\)") original-line))
                  ;; Replace the line with updated version
                  (goto-char line-start)
                  (delete-region (point) (line-end-position))
                  (insert (format "Host %s %s" original-line short-alias)))
                ;; Now handle User jupyter
                (forward-line 1)
                (let ((entry-start (point))
                      (next-host-pos (save-excursion
                                       (if (re-search-forward "^Host " nil t)
                                           (match-beginning 0)
                                         (point-max)))))
                  ;; Check for User jupyter in this entry
                  (save-excursion
                    (goto-char entry-start)
                    (unless (re-search-forward "^[ \t]*User jupyter" next-host-pos t)
                      ;; Add User jupyter at the beginning of the entry
                      (goto-char entry-start)
                      (insert "    User jupyter\n")))
                  ;; Continue search from end of this entry
                  (goto-char next-host-pos)
                  (forward-line -1)))))))
      (save-buffer)
      (message "Updated ~/.ssh/config"))))
