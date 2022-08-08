;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "M. Silk"
      user-mail-address "silk.michael1@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
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


;; General settings
(setq confirm-kill-emacs nil)


;; Global keybinds
(global-set-key (kbd "C-;") 'other-window)
(global-set-key (kbd "C-:") 'previous-multiframe-window)
(global-set-key (kbd "C-c t") 'transpose-frame)
(global-set-key (kbd "C-c d") 'org-time-stamp-inactive)
(global-set-key (kbd "C-c D") '(org-insert-time-stamp (current-time) t))


;; fix cursor bug
(defun enter-insert-state-hook ()
  (set-cursor-color "#ffffff"))


(after! evil
  (add-hook 'evil-insert-state-entry-hook 'enter-insert-state-hook)
  (add-hook 'evil-replace-state-entry-hook 'enter-insert-state-hook))


(map! :leader
      "X" 'doom/open-scratch-buffer
      "x" 'org-capture)


;; Disable continuing comments
(setq comment-line-break-function nil)


(put 'temporary-file-directory 'standard-value
     (list temporary-file-directory))


;; macOS HHKB fix
;; right option key is actually on the left
;; set both as "meta" rather than a symbol key
(cond ((eq system-type 'darwin)
       (setq ns-right-alternate-modifier 'meta)))


;; (when (memq window-system '(mac ns x))
;;   (exec-path-from-shell-initialize))


(after! org
  (setq electric-indent-mode nil)
  (setq org-startup-folded 'content)
  (setq org-tags-column -77)
  (setq org-agenda-files '("~/notebook/notes.org"
                           "~/notebook/fordham.org"))
  (map! :map org-mode-map
        :n "C-<tab>" #'(lambda () (interactive) (org-shifttab 3)))
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
          ("t" "Todo [Inbox]" entry (file+headline "~/notebook/notes.org" "Inbox")
           "* TODO %i%?\n")
          ("l" "Maintenance Log" entry (file+headline "~/notebook/notes.org" "Maintenance")
           "* %^{PROMPT} %^g \n%u\n\n%?\n"
           :empty-lines 1)))
  (setq org-refile-targets '(("~/notebook/notes.org" :maxlevel . 3)))
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (add-hook 'org-mode-hook
            (lambda ()
              (make-local-variable 'company-idle-delay)
              (setq company-idle-delay 999)))
  (add-to-list 'org-src-lang-modes (cons "jsx" 'rjsx-mode)))



(use-package! ox-ipynb)

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
  :init
  (setq ess-indent-with-fancy-comments nil
        ess-style 'RStudio
        ess-ask-for-ess-directory nil
        ess-history-directory "~/.cache"
        inferior-R-args "--no-save")
  (map! :map ess-mode-map
        :nv "<C-return>" #'ess-eval-line-and-step)
  :config
  (setq flycheck-lintr-linters
        (concat "with_defaults(line_length_linter(120), "
                "object_usage_linter=NULL)"))
  (defun flycheck-custom-simple-linters ()
    (interactive)
    (setq flycheck-lintr-linters
          (concat "with_defaults(line_length_linter(120), "
                  "object_usage_linter=NULL)")))
  (defun flycheck-custom-strict-linters ()
    (interactive)
    (setq flycheck-lintr-linters
          (concat "with_defaults(line_length_linter(120), "
                  "absolute_path_linter, "
                  "nonportable_path_linter, "
                  "camel_case_linter, "
                  "extraction_operator_linter, "
                  "implicit_integer_linter, "
                  "paren_brace_linter, "
                  "semicolon_terminator_linter, "
                  "todo_comment_linter, "
                  "T_and_F_symbol_linter, "
                  "undesirable_function_linter, "
                  "undesirable_operator_linter, "
                  "unneeded_concatenation_linter)"))))


;; Add path for LaTeX
(setenv "PATH" (concat (getenv "PATH") ":/Library/TeX/texbin/"))
(setq exec-path (append exec-path '("/Library/TeX/texbin/")))


(after! smartparens
  :init
  (add-to-list 'sp-ignore-modes-list 'python-mode))

(after! python
  :init
  (setq electric-pair-mode t))


(after! pyvenv
  :init
  (setenv "WORKON_HOME" "~/miniconda3/envs"))


;; (after! conda
;;   :init
;;   (setq conda-anaconda-home "/home/msilk/miniconda3")
;;   (setq conda-env-home-directory "/home/msilk/miniconda3"))
;; (setq +python-ipython-repl-args '("-i" "--simple-prompt" "--no-color-info"))

(after! tramp
  :init
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))
;;   (setq explicit-shell-file-name "/bin/bash"))

;; (after! lsp-mode
;;   :init
;;   (setq lsp-python-ms-executable "/home/msilk/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer")
;;   (lsp-register-client
;;    (make-lsp-client :new-connection (lsp-tramp-connection "mspyls")
;;                     :major-modes '(python-mode)
;;                     :remote? t
;;                     :server-id 'mspyls-remote
;;                     :notification-handlers (lsp-ht ("python/languageServerStarted" 'lsp-python-ms--language-server-started-callback)
;;                                                    ("telemetry/event" 'ignore)
;;                                                    ("python/reportProgress" 'lsp-python-ms--report-progress-callback)
;;                                                    ("python/beginProgress" 'lsp-python-ms--begin-progress-callback)
;;                                                    ("python/endProgress" 'lsp-python-ms--end-progress-callback))
;;                     :initialization-options 'lsp-python-ms--extra-init-params)))

            ;; (lambda()
            ;;   (require 'lsp-pyright)
            ;;   (lsp))))

;; (after! lsp-python-ms
;;   :init
;;   (setq lsp-python-ms-auto-install-server t)
;;   (setq lsp-python-ms-executable "/usr/local/bin/mspyls"))
  ;; (add-hook 'python-mode-hook
  ;;           (lambda()
  ;;             (require 'lsp-python-ms)
  ;;             (lsp))))

;; (exec-path-from-shell-initialize)

(after! flycheck
  :config
  (setq flycheck-flake8rc "~/.config/flake8")
  (add-hook 'python-mode-local-vars-hook
            (lambda()
              (when (flycheck-may-enable-checker 'python-flake8)
                (flycheck-select-checker 'python-flake8)))))


;; (setq fancy-splash-image (expand-file-name "splash-images/blackhole-lines-5.svg" doom-private-dir))
(setq fancy-splash-image "~/.doom.d/splash-images/blackhole-static.png")

;; ;; Black hole splash image
;; (defvar fancy-splash-image-template
;;   (expand-file-name "splash-images/blackhole-lines-template.svg" doom-private-dir)
;;   "Default template svg used for the splash image, with substitutions from ")
;; (defvar fancy-splash-image-nil
;;   (expand-file-name "splash-images/transparent-pixel.png" doom-private-dir)
;;   "An image to use at minimum size, usually a transparent pixel")

;; (setq fancy-splash-sizes
;;       `((:height 500 :min-height 50 :padding (0 . 4) :template ,(expand-file-name "splash-images/blackhole-lines-0.svg" doom-private-dir))
;;         (:height 440 :min-height 42 :padding (1 . 4) :template ,(expand-file-name "splash-images/blackhole-lines-0.svg" doom-private-dir))
;;         (:height 400 :min-height 38 :padding (1 . 4) :template ,(expand-file-name "splash-images/blackhole-lines-1.svg" doom-private-dir))
;;         (:height 350 :min-height 36 :padding (1 . 3) :template ,(expand-file-name "splash-images/blackhole-lines-2.svg" doom-private-dir))
;;         (:height 300 :min-height 34 :padding (1 . 3) :template ,(expand-file-name "splash-images/blackhole-lines-3.svg" doom-private-dir))
;;         (:height 250 :min-height 32 :padding (1 . 2) :template ,(expand-file-name "splash-images/blackhole-lines-4.svg" doom-private-dir))
;;         (:height 200 :min-height 30 :padding (1 . 2) :template ,(expand-file-name "splash-images/blackhole-lines-5.svg" doom-private-dir))
;;         (:height 100 :min-height 24 :padding (1 . 2) :template ,(expand-file-name "splash-images/emacs-e-template.svg" doom-private-dir))
;;         (:height 0   :min-height 0  :padding (0 . 0) :file ,fancy-splash-image-nil)))

;; (defvar fancy-splash-sizes
;;   `((:height 500 :min-height 50 :padding (0 . 2))
;;     (:height 440 :min-height 42 :padding (1 . 4))
;;     (:height 330 :min-height 35 :padding (1 . 3))
;;     (:height 200 :min-height 30 :padding (1 . 2))
;;     (:height 0   :min-height 0  :padding (0 . 0) :file ,fancy-splash-image-nil))
;;   "list of plists with the following properties
;;   :height the height of the image
;;   :min-height minimum `frame-height' for image
;;   :padding `+doom-dashboard-banner-padding' to apply
;;   :template non-default template file
;;   :file file to use instead of template")

;; (defvar fancy-splash-template-colours
;;   '(("$colour1" . keywords) ("$colour2" . type) ("$colour3" . base5) ("$colour4" . base8))
;;   "list of colour-replacement alists of the form (\"$placeholder\" . 'theme-colour) which applied the template")

;; (unless (file-exists-p (expand-file-name "theme-splashes" doom-cache-dir))
;;   (make-directory (expand-file-name "theme-splashes" doom-cache-dir) t))

;; (defun fancy-splash-filename (theme-name height)
;;   (expand-file-name (concat (file-name-as-directory "theme-splashes")
;;                             theme-name
;;                             "-" (number-to-string height) ".svg")
;;                     doom-cache-dir))

;; (defun fancy-splash-clear-cache ()
;;   "Delete all cached fancy splash images"
;;   (interactive)
;;   (delete-directory (expand-file-name "theme-splashes" doom-cache-dir) t)
;;   (message "Cache cleared!"))

;; (defun fancy-splash-generate-image (template height)
;;   "Read TEMPLATE and create an image if HEIGHT with colour substitutions as
;;    described by `fancy-splash-template-colours' for the current theme"
;;   (with-temp-buffer
;;     (insert-file-contents template)
;;     (re-search-forward "$height" nil t)
;;     (replace-match (number-to-string height) nil nil)
;;     (dolist (substitution fancy-splash-template-colours)
;;       (goto-char (point-min))
;;       (while (re-search-forward (car substitution) nil t)
;;         (replace-match (doom-color (cdr substitution)) nil nil)))
;;     (write-region nil nil
;;                   (fancy-splash-filename (symbol-name doom-theme) height) nil nil)))

;; (defun fancy-splash-generate-images ()
;;   "Perform `fancy-splash-generate-image' in bulk"
;;   (dolist (size fancy-splash-sizes)
;;     (unless (plist-get size :file)
;;       (fancy-splash-generate-image (or (plist-get size :file)
;;                                        (plist-get size :template)
;;                                        fancy-splash-image-template)
;;                                    (plist-get size :height)))))

;; (defun ensure-theme-splash-images-exist (&optional height)
;;   (unless (file-exists-p (fancy-splash-filename
;;                           (symbol-name doom-theme)
;;                           (or height
;;                               (plist-get (car fancy-splash-sizes) :height))))
;;     (fancy-splash-generate-images)))

;; (defun get-appropriate-splash ()
;;   (let ((height (frame-height)))
;;     (cl-some (lambda (size) (when (>= height (plist-get size :min-height)) size))
;;              fancy-splash-sizes)))

;; (setq fancy-splash-last-size nil)
;; (setq fancy-splash-last-theme nil)
;; (defun set-appropriate-splash (&rest _)
;;   (let ((appropriate-image (get-appropriate-splash)))
;;     (unless (and (equal appropriate-image fancy-splash-last-size)
;;                  (equal doom-theme fancy-splash-last-theme)))
;;     (unless (plist-get appropriate-image :file)
;;       (ensure-theme-splash-images-exist (plist-get appropriate-image :height)))
;;     (setq fancy-splash-image
;;           (or (plist-get appropriate-image :file)
;;               (fancy-splash-filename (symbol-name doom-theme) (plist-get appropriate-image :height))))
;;     (setq +doom-dashboard-banner-padding (plist-get appropriate-image :padding))
;;     (setq fancy-splash-last-size appropriate-image)
;;     (setq fancy-splash-last-theme doom-theme)
;;     (+doom-dashboard-reload)))

;; (add-hook 'window-size-change-functions #'set-appropriate-splash)
;; (add-hook 'doom-load-theme-hook #'set-appropriate-splash)
