;;; init.el --- Where all the magic begins
;; This is the first thing to get loaded.

;; Relaxed garbage collector to speed up startup
;; https://www.emacswiki.org/emacs/OptimizingEmacsStartup
(setq gc-cons-threshold most-positive-fixnum)

;; Lower threshold back to 8 MiB (default is 800kB)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (expt 2 23))))


;; Enter debugger if an error is signaled during Emacs startup.
;;
;; This works the same as you boot emacs with "--debug-init" every time, except
;; for errors in "init.el" itself, which means, if there's an error in
;; "init.el", "emacs --debug-init" will entering the debugger, while "emacs"
;; will not; however, if there's an error in other files loaded by init.el,
;; both "emacs" and "emacs --debug-init" will entering the debugger. I don't
;; know why.
(setq debug-on-error t)

;(add-to-list 'load-path (concat user-emacs-directory "elisp"))

(setq vc-follow-symlinks t)

;; Turn off mouse interface early in startup to avoid momentary display
(when window-system
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1))

;(setq inhibit-startup-screen t)

;;; My configuation using org-babel
(org-babel-load-file "~/.emacs.d/babel/config.org")
