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


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

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


;; BASICS


;; Disable quit warning
(setq confirm-kill-emacs nil)


;; Enable breadcrumb-mode
(use-package! breadcrumb
  :config
  (breadcrumb-mode t))


;; KEYBINDS


;; Globals
(global-set-key (kbd "C-;") 'other-window)
(global-set-key (kbd "C-:") 'previous-multiframe-window)
(global-set-key (kbd "C-c t") 'transpose-frame)
(global-set-key (kbd "C-c d") 'org-time-stamp-inactive)
(global-set-key (kbd "C-c D") (lambda () (interactive) (org-insert-time-stamp (current-time) t)))
(global-set-key (kbd "s-s") 'evil-avy-goto-char-timer)
(global-set-key (kbd "s-f") 'evil-avy-goto-line)
(global-set-key (kbd "s-d") 'evil-multiedit-match-and-next)
(global-set-key (kbd "s-D") 'evil-multiedit-match-and-prev)


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

;; Rebind next-error and previous-error to use
;; Flymake
;; Bind flymake-goto-prev-error to previous error keybinds
(map!
 ;; ESC map bindings for previous error
 (:map esc-map
       "g M-p" #'flymake-goto-prev-error
       "g p"   #'flymake-goto-prev-error)

 ;; Evil motion state map for previous error
 (:map evil-motion-state-map
       "[ e" #'flymake-goto-prev-error)

 ;; Global map bindings for previous error
 "M-g M-p" #'flymake-goto-prev-error
 "M-g p"   #'flymake-goto-prev-error

 ;; Goto map bindings for previous error
 (:map goto-map
       "M-p" #'flymake-goto-prev-error
       "p"   #'flymake-goto-prev-error)

 ;; Help quick use map for previous error
 (:map help-quick-use-map
       "M-g M-p" #'flymake-goto-prev-error
       "M-g p"   #'flymake-goto-prev-error)

 ;; Next error repeat map for previous error
 (:map next-error-repeat-map
       "M-p" #'flymake-goto-prev-error
       "p"   #'flymake-goto-prev-error))

;; Bind flymake-goto-next-error to next error keybinds
(map!
 ;; Ctl-x map for next error
 (:map ctl-x-map
       "`" #'flymake-goto-next-error)

 ;; ESC map bindings for next error
 (:map esc-map
       "g M-n" #'flymake-goto-next-error
       "g n"   #'flymake-goto-next-error)

 ;; Evil motion state map for next error
 (:map evil-motion-state-map
       "] e" #'flymake-goto-next-error)

 ;; Global map bindings for next error
 "C-x `"   #'flymake-goto-next-error
 "M-g M-n" #'flymake-goto-next-error
 "M-g n"   #'flymake-goto-next-error

 ;; Goto map bindings for next error
 (:map goto-map
       "M-n" #'flymake-goto-next-error
       "n"   #'flymake-goto-next-error)

 ;; Help quick use map for next error
 (:map help-quick-use-map
       "C-x `"   #'flymake-goto-next-error
       "M-g M-n" #'flymake-goto-next-error
       "M-g n"   #'flymake-goto-next-error)

 ;; Next error repeat map for next error
 (:map next-error-repeat-map
       "M-n" #'flymake-goto-next-error
       "n"   #'flymake-goto-next-error))
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


;; Cursor colours
(setq evil-normal-state-cursor '(box "#fce9d9"))
(setq evil-replace-state-cursor '(hbar "#fce9d9"))
(setq evil-insert-state-cursor '(bar "#fce9d9"))
(setq evil-operator-state-cursor (list #'evil-half-cursor "#fce9d9"))
(setq evil-visual-state-cursor '(hollow "#fce9d9"))
(setq evil-emacs-state-cursor (list  #'+evil-emacs-cursor-fn "#f5a098"))


;; avy reduce the timer
(after! avy
  (setq avy-timeout-seconds 0.2)
  (defun avy-action-exchange (pt)
    "Exchange sexp at PT with the one at point."
    (set-mark pt)
    (transpose-sexps 0))
  (add-to-list 'avy-dispatch-alist '(?e . avy-action-exchange)))


;; Disable evil auto indent after o/O
(after! evil
  (setq evil-auto-indent nil))


(after! org
  (setq electric-indent-mode nil)
  (setq org-startup-folded 'content)
  ;; (setq org-tags-column -77)
  (setq org-agenda-files (directory-files-recursively "~/notebook/projects/" "\\.org$"))
  (setq org-image-actual-width 300)
  (map! :map org-mode-map
        :niv "C-S-<tab>" #'(lambda () (interactive) (org-shifttab 3)))
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
          ("t" "Task" entry (file "~/notebook/tasks.org")
           "* TODO %i%?\n")
          ("p" "Project File" plain
           (file (lambda ()
                   (let ((filename (read-string "Filename: ")))
                     (expand-file-name
                      (format "%s_%s.org"
                              filename
                              (format-time-string "%Y%m%d"))
                      "~/notebook/projects/"))))
           "#+TITLE: %^{Title}\n#+DATE: %U\n#+DEADLINE: %^t\n#+FILETAGS: %^G\n#+OPTIONS: \\n:t num:nil tags:nil toc:nil ^:nil\n\n* Description\n\n%?\n\n* Definition of done\n\n* Steps\n\n* Tasks")
          ("l" "Maintenance Log" entry (file+headline "~/notebook/notes.org" "Maintenance")
           "* %^{PROMPT} %^g \n%u\n\n%?\n"
           :empty-lines 1)))
  (setq org-refile-targets '(("~/notebook/notes.org" :maxlevel . 3)))
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (defun remove-ispell-completion-at-point ()
    "Disable capf completion-at-point ispell-completion-at-point."
    (setq-local
     completion-at-point-functions
     (remove 'ispell-completion-at-point completion-at-point-functions)))
  (add-hook 'org-mode-hook #'remove-ispell-completion-at-point)
  (add-hook 'org-mode-hook
            (lambda ()
              (display-line-numbers-mode -1)))
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
              (let (org-insert-heading-respect-content)
                (goto-char (line-end-position))
                (org-end-of-subtree)
                ;; Check if we're about to create a TODO heading
                (let* ((todo-keyword (org-element-property :todo-keyword context))
                       (todo-type (org-element-property :todo-type context))
                       (will-be-todo (and todo-keyword (not (eq todo-type 'done)))))
                  ;; Only ensure newline above new heading if it won't be a TODO
                  (unless (or will-be-todo
                              (looking-back "\n\n" (max (point-min) (- (point) 2))))
                    (insert "\n")))
                (insert "\n" (make-string level ?*) " ")))
             (`above
              (org-back-to-heading)
              ;; Check if we're about to create a TODO heading
              (let* ((todo-keyword (org-element-property :todo-keyword context))
                     (todo-type (org-element-property :todo-type context))
                     (will-be-todo (and todo-keyword (not (eq todo-type 'done)))))
                ;; Only ensure newline above new heading if it won't be a TODO
                (unless (or will-be-todo
                            (looking-back "\n\n" (max (point-min) (- (point) 2))))
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
  (map! :map org-mode-map
        "C-<return>" #'+org/insert-item-below-edit
        "C-RET"      #'+org/insert-item-below-edit
        "s-<return>" #'+org/insert-item-below-edit
        "C-S-<return>" #'+org/insert-item-above-edit
        "C-S-RET"      #'+org/insert-item-above-edit
        "S-s-<return>" #'+org/insert-item-above-edit)

  (map! :after evil-org
        :map evil-org-mode-map
        :i "C-<return>" #'+org/insert-item-below-edit
        :n "C-<return>" #'+org/insert-item-below-edit
        :i "C-S-<return>" #'+org/insert-item-above-edit
        :n "C-S-<return>" #'+org/insert-item-above-edit))


(after! org-download
  (setq org-download-method 'download)
  (setq org-download-heading-lvl nil)
  (setq org-download-image-dir "~/notebook/img/")
  (setq org-download-link-format "[[~/notebook/img/%s]]\n")
  (advice-add 'org-id-get-create :override #'ignore))


(after! winum
  (setq winum-auto-setup-mode-line nil)
  :config
  (winum-mode))


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


(after! ess
  (defun my-ess-insert-header ()
    "Insert header lines when opening new R files."
    (when (and (eq major-mode 'ess-r-mode)
               (= (point-max) 1)) ;; File is empty
      (insert "# " (file-name-nondirectory (buffer-file-name)))
      (newline)
      (insert "# M. Silk")
      (newline)
      (newline)
      (goto-char (point-max))))
  (add-hook 'ess-r-mode-hook 'my-ess-insert-header)
  :defer
  ;; Fix R:ESS comments going grey and unreadable
  ;; (setq-local ansi-color-for-comint-mode 'filter)
  (setq ess-indent-with-fancy-comments nil
        ess-style 'RStudio
        inferior-R-args "--no-save")
  (map! :map ess-mode-map
        :nv "<C-return>" #'ess-eval-line-and-step
        :n "C-c m" #'ess-reset-ansi-colours)
  :config
  (defun ess-reset-ansi-colours ()
    (interactive)
    (setq-local ansi-color-for-comint-mode 'filter)))


(after! python
  :config
  (map! :map python-mode-map
        :n "C-c C-w" #'(lambda () (interactive) (python-shell-send-buffer t))))


;; Apheleia set to run ruff format with no quote changing
;; and no line length splitting. These can be handled by the
;; pre-commit steps instead.
(after! apheleia
  :init
  (setf (alist-get 'ruff apheleia-formatters)
        '("ruff" "format" "--config" "format.quote-style='preserve'" "-"))
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
(after! eglot
  (setq eglot-code-action-indicator "*")
  (add-to-list 'eglot-server-programs
               ;; '(python-mode . ("ruff" "server"))))
               '(python-mode . ("pylsp"))
               '(python-ts-mode . ("pylsp")))
  (setq-default eglot-workspace-configuration
                '(:pylsp (:plugins (:jedi_completion (:include_params t :fuzzy t) ;; [X] autocompletion
                                    :rope (:enabled t)                            ;; [X] refactoring (can swap with lsp rope)
                                    :pylsp_mypy (:enabled t)                      ;; [X] type checking
                                    :pydocstyle (:enabled t)                      ;; [-] docstring style checking
                                    :ruff (:enabled t :formatEnabled :json-false) ;; [X] linting
                                    :autopep8 (:enabled :json-false)              ;; (ruff) uses pycodestyle to auto format
                                    :yapf (:enabled :json-false)                  ;; (ruff) applies formatting
                                    :pyflakes (:enabled :json-false)              ;; (ruff) error checking
                                    :mccabe (:enabled :json-false)                ;; (ruff) complexity checking
                                    :pycodestyle (:enabled :json-false)           ;; (ruff) style checking
                                    :flake8 (:enabled :json-false)                ;; (alt) error checking
                                    :pylint (:enabled :json-false)                ;; (alt) linting
                                    )))))


(after! dape
  :init
  (setq dape-buffer-window-arrangement 'right
        dape-inlay-hints nil)
  (map! :leader
        :desc "dape" "d" dape-global-map))


(after! copilot
  :init
  (map! :map copilot-mode-map
        :i "C-<tab>" #'copilot-accept-completion
        :i "C-S-<tab>" #'copilot-accept-completion-by-word))


(after! plantuml-mode
  :init
  (setq plantuml-jar-path "/Users/msilk/software/plantuml/plantuml-1.2025.2.jar"
        plantuml-executable-path "/opt/homebrew/bin/plantuml"
        plantuml-default-exec-mode 'executable))
