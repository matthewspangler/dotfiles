;;; package --- Main init file
;;; Commentary:
;;; 	The first version of this init file was generated by emacs-bootstrap,
;;;	and then I added my own elisp using org-babel (config.org).
;;;     https://github.com/editor-bootstrap/emacs-bootstrap

;;; Code:

(add-to-list 'load-path (concat user-emacs-directory "elisp"))

(require 'base)
(require 'base-theme)
(require 'base-extensions)
(require 'base-functions)
(require 'base-global-keys)

(require 'lang-python)

(require 'lang-go)

(require 'lang-web)

(require 'lang-haskell)

(require 'lang-rust)

(require 'lang-c)

(require 'lang-ios)

;;; org-babel setup
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (haskell . nil)
   (ledger . t)
   (python . t)
   (ruby . t)))

;;; My configuation using org-babel
(org-babel-load-file "~/.emacs.d/babel/config.org")
