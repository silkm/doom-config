;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "M. Silk"
      user-mail-address "silk.michael1@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
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


;; fix cursor bug
(defun enter-insert-state-hook ()
  (set-cursor-color "#ffffff"))

(after! evil
  (add-hook 'evil-insert-state-entry-hook 'enter-insert-state-hook)
  (add-hook 'evil-replace-state-entry-hook 'enter-insert-state-hook))


(map! :leader
      "X" 'doom/open-scratch-buffer
      "x" 'org-capture)


;; macOS HHKB fix
;; right option key is actually on the left
;; set both as "meta" rather than a symbol key
(cond ((eq system-type 'darwin)
       (setq ns-right-alternate-modifier 'meta)))


(after! org
  (setq electric-indent-mode nil)
  (setq org-agenda-files '("~/notebook/notes.org"))
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
              (setq company-idle-delay 999))))


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


(after! ess
  :init
  (setq ess-indent-with-fancy-comments nil
        ess-style 'RStudio
        ess-ask-for-ess-directory nil
        inferior-R-args "--no-save")
  (map! :map ess-mode-map
        :nv "<C-return>" #'ess-eval-line-and-step)
  :config
  (setq flycheck-lintr-linters
        (concat "with_defaults(line_length_linter(120), "
                 "object_name_linter=NULL, "
                 "assignment_linter=NULL)")))

;; Add path for LaTeX
(setenv "PATH" (concat (getenv "PATH") ":/Library/TeX/texbin/"))
(setq exec-path (append exec-path '("/Library/TeX/texbin/")))


(after! smartparens
  :init
  (add-to-list 'sp-ignore-modes-list 'python-mode))

(after! python
  :init
  (setq electric-pair-mode t))


(after! conda
  :init
  (setq conda-anaconda-home "/Users/msilk/mambaforge"))


(after! flycheck
  :config
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
