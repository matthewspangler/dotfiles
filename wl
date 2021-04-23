(autoload 'wl "wl" "Wanderlust" t)
(autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
;(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

;; For non ascii-characters in folder-names
(setq elmo-imap4-use-modified-utf7 t)

;; You should set this variable if you use multiple e-mail addresses.
(setq wl-user-mail-address-list (quote ("philosopheratlarge@protonmail.com" "mattspangler@protonmail.com")))

(setq elmo-imap4-default-server "127.0.0.1"
      elmo-imap4-default-port '1143
      elmo-imap4-default-user "philosopheratlarge@protonmail.com"
      elmo-imap4-default-authenticate-type 'clear
      elmo-imap4-default-stream-type 'starttls)

;; SMTP
(setq wl-smtp-connection-type 'starttls)
(setq wl-smtp-posting-port 1025)
(setq wl-smtp-authenticate-type "plain")
(setq wl-smtp-posting-user "philosopheratlarge@protonmail.com")
(setq wl-smtp-posting-server "127.0.0.1")
(setq wl-local-domain "127.0.0.1")

(setq wl-default-folder "%inbox")
(setq wl-default-spec "%")
(setq wl-draft-folder "%Drafts")
(setq wl-trash-folder "%Trash")

(setq wl-folder-check-async t) 

(setq wl-from "philosopheratlarge@protonmail.com")

(autoload 'wl-user-agent-compose "wl-draft" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'wl-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'wl-user-agent
      'wl-user-agent-compose
      'wl-draft-send
      'wl-draft-kill
      'mail-send-hook))
