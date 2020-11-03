;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "M. Silk"
      user-mail-address "silkshake@gmail.com")

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

(after! evil-escape
  (setq evil-escape-key-sequence "jh"))

;; Swiper
;; (use-package! swiper)

;; Org-publish
;; (use-package! ox-publish)


;; Winum
(after! winum
  ;; :init
  ;; (map! "M-2" 'winum-select-window-2)
  ;; (setq winum-keymap
  ;;     (let ((map (make-sparse-keymap)))
  ;;     (define-key map (kbd "M-0") 'winum-select-window-0-or-10)
  ;;     (define-key map (kbd "M-1") 'winum-select-window-1)
  ;;     (define-key map (kbd "M-2") 'winum-select-window-2)
  ;;     (define-key map (kbd "M-3") 'winum-select-window-3)
  ;;     (define-key map (kbd "M-4") 'winum-select-window-4)
  ;;     (define-key map (kbd "M-5") 'winum-select-window-5)
  ;;     (define-key map (kbd "M-6") 'winum-select-window-6)
  ;;     (define-key map (kbd "M-7") 'winum-select-window-7)
  ;;     (define-key map (kbd "M-8") 'winum-select-window-8)
  ;;     map))
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

;; (map! "s-0" #'winum-select-window-0-or-10)
;; (map! "s-1" #'winum-select-window-1)
;; (map! "s-2" #'winum-select-window-2)
;; (map! "s-3" #'winum-select-window-3)
;; (map! "s-4" #'winum-select-window-4)
;; (map! "s-5" #'winum-select-window-5)
;; (map! "s-6" #'winum-select-window-6)
;; (map! "s-7" #'winum-select-window-7)
;; (map! "s-8" #'winum-select-window-8)

;; (map! :after evil
;;       :map evil-normal-state-map
;;       "s-0" nil
;;       "s-1" nil
;;       "s-2" nil
;;       "s-3" nil
;;       "s-4" nil
;;       "s-5" nil
;;       "s-6" nil
;;       "s-7" nil
;;       "s-8" nil)
