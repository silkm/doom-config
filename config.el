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


;; General settings
(setq confirm-kill-emacs nil)


;; Edit faces for tree-sitter; remove bold from the following
(custom-set-faces!  `(tree-sitter-hl-face:method.call :foreground ,(doom-color 'blue)))
(custom-set-faces!  `(tree-sitter-hl-face:label :foreground ,(doom-color 'blue)))
(custom-set-faces!  `(tree-sitter-hl-face:function.call :foreground ,(doom-color 'blue)))
(custom-set-faces!  `(tree-sitter-hl-face:function.macro :foreground ,(doom-color 'blue)))
(custom-set-faces!  `(tree-sitter-hl-face:function.special :foreground ,(doom-color 'blue)))


;; Global keybinds
(global-set-key (kbd "C-;") 'other-window)
(global-set-key (kbd "C-:") 'previous-multiframe-window)
(global-set-key (kbd "C-c t") 'transpose-frame)
(global-set-key (kbd "C-c d") 'org-time-stamp-inactive)
(global-set-key (kbd "C-c D") (lambda () (interactive) (org-insert-time-stamp (current-time) t)))
(global-set-key (kbd "C-S-s") 'evil-avy-goto-char-timer)
(global-set-key (kbd "s-s") 'evil-avy-goto-char-timer)
(global-set-key (kbd "s-f") 'evil-avy-goto-line)
(global-set-key (kbd "s-d") 'evil-multiedit-match-and-next)
(global-set-key (kbd "s-D") 'evil-multiedit-match-and-prev)

;; ;; Disable arrow keys from the normal and insert maps
;; (map! :ni "<left>"  #'ignore
;;       :ni "<right>" #'ignore
;;       :ni "<up>"    #'ignore
;;       :ni "<down>"  #'ignore)

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

;; Breadcrumbs globally
(use-package! breadcrumb
  :config
  (breadcrumb-mode t))


;; Set normal mode cursor colour
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


(after! org
  (setq electric-indent-mode nil)
  (setq org-startup-folded 'content)
  (setq org-tags-column -77)
  (setq org-agenda-files '("~/notebook/notes.org"
                           "~/notebook/fordham.org"
                           "~/notebook/baby.org"))
  (setq org-image-actual-width 300)
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
          ("t" "Task" entry (file "~/notebook/tasks.org")
           "* TODO %i%?\n")
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
              (display-line-numbers-mode -1))))


(after! org-download
  (setq org-download-method 'download)
  (setq org-download-heading-lvl nil)
  (setq org-download-image-dir "~/notebook/img/")
  (setq org-download-link-format "[[~/notebook/img/%s]]\n"))


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


;; Doom splash screen
(setq fancy-splash-image (expand-file-name "splash-images/blackhole-lines-small.svg" doom-user-dir))
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-loaded)
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-footer)
