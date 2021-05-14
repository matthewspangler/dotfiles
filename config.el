(use-package centaur-tabs
  :demand
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward))

(centaur-tabs-mode t)
(setq centaur-tabs-set-icons t)
(setq centaur-tabs-style "bar")
(setq centaur-tabs-set-bar 'under)
(setq x-underline-at-descent-line t)
(setq centaur-tabs-cycle-scope 'tabs)

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(setq dashboard-items '((recents  . 5)
			(bookmarks . 5)
			(projects . 5)
			(agenda . 5)
			(registers . 5)))
(setq dashboard-set-navigator t)
(setq dashboard-week-agenda t)

					; Set banner - I sneakily set the official logo to a random xkcd comic later! Change 'logo to 'official to see it.
(setq dashboard-startup-banner 'logo)

(use-package zoom
  :ensure t)

(custom-set-variables '(zoom-mode t))
;(custom-set-variables
; '(zoom-size '(0.618 . 0.618)))
(defun size-callback ()
  (cond ((> (frame-pixel-width) 1280) '(90 . 0.75))
	(t                            '(0.5 . 0.5))))

(custom-set-variables
 '(zoom-size 'size-callback))

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
	  treemacs-deferred-git-apply-delay      0.5
	  treemacs-directory-name-transformer    #'identity
	  treemacs-display-in-side-window        t
	  treemacs-eldoc-display                 t
	  treemacs-file-event-delay              5000
	  treemacs-file-extension-regex          treemacs-last-period-regex-value
	  treemacs-file-follow-delay             0.2
	  treemacs-file-name-transformer         #'identity
	  treemacs-follow-after-init             t
	  treemacs-git-command-pipe              ""
	  treemacs-goto-tag-strategy             'refetch-index
	  treemacs-indentation                   2
	  treemacs-indentation-string            " "
	  treemacs-is-never-other-window         nil
	  treemacs-max-git-entries               5000
	  treemacs-missing-project-action        'ask
	  treemacs-move-forward-on-expand        nil
	  treemacs-no-png-images                 nil
	  treemacs-no-delete-other-windows       t
	  treemacs-project-follow-cleanup        nil
	  treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
	  treemacs-position                      'left
	  treemacs-read-string-input             'from-child-frame
	  treemacs-recenter-distance             0.1
	  treemacs-recenter-after-file-follow    nil
	  treemacs-recenter-after-tag-follow     nil
	  treemacs-recenter-after-project-jump   'always
	  treemacs-recenter-after-project-expand 'on-distance
	  treemacs-show-cursor                   nil
	  treemacs-show-hidden-files             t
	  treemacs-silent-filewatch              nil
	  treemacs-silent-refresh                nil
	  treemacs-sorting                       'alphabetic-asc
	  treemacs-space-between-root-nodes      t
	  treemacs-tag-follow-cleanup            t
	  treemacs-tag-follow-delay              1.5
	  treemacs-user-mode-line-format         nil
	  treemacs-user-header-line-format       nil
	  treemacs-width                         35
	  treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (pcase (cons (not (null (executable-find "git")))
		 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
	("M-0"       . treemacs-select-window)
	("C-x t 1"   . treemacs-delete-other-windows)
	("C-x t t"   . treemacs)
	("C-x t B"   . treemacs-bookmark)
	("C-x t C-t" . treemacs-find-file)
	("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :after (treemacs dired)
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; Or use this
;; Use `window-setup-hook' if the right segment is displayed incorrectly
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(use-package dash
  :ensure t)
(use-package helm-dash
  :ensure t)

(with-eval-after-load 'org
  (setq org-directory "~/Documents"))

; Do not truncate lines and enable word wrap
(set-default 'truncate-lines nil)
(set-default 'word-wrap t)
(setq helm-buffers-truncate-lines nil)
(setq org-startup-truncated nil)

; Set bullets for heading levels
(setq org-bullets-bullet-list (quote ("♚" "♛" "♜" "♝" "♞" "♟")))

; Fold content on startup
(setq org-startup-folded t)

(setq org-agenda-files '("~/Documents"))

(use-package org-super-agenda :ensure t)

(let ((org-super-agenda-groups
       '(;; Each group has an implicit boolean OR operator between its selectors.
	 (:name "Today"  ; Optionally specify section name
		:time-grid t  ; Items that appear on the time grid
		:todo "TODAY")  ; Items that have this TODO keyword
	 (:name "Important"
		;; Single arguments given alone
		:tag "bills"
		:priority "A")
	 ;; Set order of multiple groups at once
	 (:order-multi (2 (:name "Shopping in town"
				 ;; Boolean AND group matches items that match all subgroups
				 :and (:tag "shopping" :tag "@town"))
			  (:name "Food-related"
				 ;; Multiple args given in list with implicit OR
				 :tag ("food" "dinner"))
			  (:name "Personal"
				 :habit t
				 :tag "personal")
			  (:name "Space-related (non-moon-or-planet-related)"
				 ;; Regexps match case-insensitively on the entire entry
				 :and (:regexp ("space" "NASA")
					       ;; Boolean NOT also has implicit OR between selectors
					       :not (:regexp "moon" :tag "planet")))))
	 ;; Groups supply their own section names when none are given
	 (:todo "WAITING" :order 8)  ; Set order of this section
	 (:todo ("SOMEDAY" "TO-READ" "CHECK" "TO-WATCH" "WATCHING")
		;; Show this group at the end of the agenda (since it has the
		;; highest number). If you specified this group last, items
		;; with these todo keywords that e.g. have priority A would be
		;; displayed in that group instead, because items are grouped
		;; out in the order the groups are listed.
		:order 9)
	 (:priority<= "B"
		      ;; Show this section after "Today" and "Important", because
		      ;; their order is unspecified, defaulting to 0. Sections
		      ;; are displayed lowest-number-first.
		      :order 1)
	 ;; After the last group, the agenda will display items that didn't
	 ;; match any of these groups, with the default order position of 99
	 )))
  (org-agenda nil "a"))

(use-package ledger-mode
  :ensure t)

(use-package projectile
  :ensure t)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(use-package org-roam
      :ensure t
      :hook
      (after-init . org-roam-mode)
      :custom
      (org-roam-directory "~/Documents")
      :bind (:map org-roam-mode-map
	      (("C-c n l" . org-roam)
	       ("C-c n f" . org-roam-find-file)
	       ("C-c n g" . org-roam-graph))
	      :map org-mode-map
	      (("C-c n i" . org-roam-insert))
	      (("C-c n I" . org-roam-insert-immediate))))

(use-package org-download
  :ensure t)
;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

(use-package helm-org-rifle
  :ensure t)

(use-package ox-hugo
  :ensure t            ;Auto-install the package from Melpa (optional)
  :after ox)

(require 'use-package)

(use-package sx
  :config
  (bind-keys :prefix "C-c s"
             :prefix-map my-sx-map
             :prefix-docstring "Global keymap for SX."
             ("q" . sx-tab-all-questions)
             ("i" . sx-inbox)
             ("o" . sx-open-link)
             ("u" . sx-tab-unanswered-my-tags)
             ("a" . sx-ask)
             ("s" . sx-search)))

(use-package color-identifiers-mode
  :ensure t)
(add-hook 'after-init-hook 'global-color-identifiers-mode)

(use-package fill-column-indicator
  :ensure t)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

(use-package gdscript-mode
    :straight (gdscript-mode
	       :type git
	       :host github
	       :repo "godotengine/emacs-gdscript-mode"))

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
	 (gdscript-mode . lsp)
	 ;; if you want which-key integration
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
    :config
    (which-key-mode))

(use-package elfeed
  :ensure t)

(use-package elfeed-org
  :ensure t)

;; Initialize elfeed-org
;; This hooks up elfeed-org to read the configuration when elfeed
;; is started with =M-x elfeed=
(elfeed-org)

;; Optionally specify a number of files containing elfeed
;; configuration. If not set then the location below is used.
;; Note: The customize interface is also supported.
(setq rmh-elfeed-org-files (list "~/Documents/rss.org"))

(use-package wl
  :ensure wanderlust
  :init
  (autoload 'wl "wl" "Wanderlust" t))
(add-hook 'mime-view-mode-hook #'(lambda () (setq show-trailing-whitespace nil)))

;;; My IRC configuration using org-babel
(org-babel-load-file "~/.emacs.d/babel/irc.org")

(use-package xkcd
    :ensure t)

;;  ;; to get a rand comic and to set dashboard image (png)
;;  (let ((rand-id-xkcd nil))
;;    (with-temp-buffer
;;      (setq rand-id-xkcd (string-to-number (xkcd-rand)))
;;      (xkcd-kill-buffer))
;;    (let ((last-xkcd-png (concat xkcd-cache-dir (number-to-string rand-id-xkcd) ".png")))
;;      (if (file-exists-p last-xkcd-png)
;;      (setq dashboard-banner-official-png last-xkcd-png))))

(use-package restart-emacs
  :ensure t)

(use-package f
  :ensure t)

(use-package s
  :ensure t)

(use-package ido
  :ensure t)

; I don't like the scratch buffer in my face :(
(setq initial-scratch-message nil)
(kill-buffer "*scratch*")

; restore previous buffers
(desktop-save-mode 1)

					; so I can use C-x b to cycle buffers
(ido-mode 1)
