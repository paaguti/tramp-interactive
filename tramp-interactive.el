;;; tramp-interactive.el --- Find files with tramp easier

;; Copyright (C) 2022 Pedro A. Aranda Gutiérrez

;; Author: Pedro A. Aranda Gutiérrez
;; Version: 1.0
;; Package-Requires: https://github.com/paaguti/tramp-interactive/
;; Keywords: tramp, find-file
;; URL:

;;; Commentary:
;;
;; This package provides two interactive functions to make
;; find-file easier when files are accessed with TRAMP.
;; It asks for user, host and port and then
;; creates the initial value to delegate to `find-file'
;;
;; Keybindings
;;
;; C-x T f : find file in remote server
;; C-x T l : find file in local server

(provide 'tramp-interactive)
(require 'tramp)

;;;###autoload
(defvar tramp-user-default
  (if tramp-default-user tramp-default-user (getenv "USER"))
  "The default user for TRAMP.
Take tramp-default-user from the general tramp configuration
or set it to the current user name if nil.")

;;;###autoload
(defvar tramp-user-list (list (getenv "USER"))
  "The list of users you use frequently when accessing remote files.
By default only the current user")

;;;###autoload
(defvar tramp-host-list (list "localhost")
  "The list of users you use frequently when accessing remote files.
By default only localhost")

(defun tramp-initial-spec (user host port)
  "Create the initial spec from the `user', `host' and `port'"
  (let ((initial (if (string= user tramp-user-default)
                  (format "/ssh:%s" host)
                  (format "/ssh:%s@%s" user host))))
    (setq initial (concat initial (if (= port 22) ":"
				    (format "#%d:" port))))
    initial))

;;;###autoload
(defun tramp-open-local (filename)
  "Open a file in a port-xlated VM
default user is student"
  (interactive
   (let*
       ((prompt-user (format "user (%s): " tramp-user-default))
	(user (completing-read prompt-user tramp-user-list nil nil nil nil tramp-user-default))
	(port (read-number "port: ")))
     (list (read-file-name "Remote file:" (tramp-initial-spec user "localhost" port) nil 'confirm ))))
  (find-file filename))

;;;###autoload
(defun tramp-open-remote (filename)
  "Open a file in a potentially port-traslated remote host
default user is student"
  (interactive
   (let*
       ((default-host (car tramp-host-list))
	      (prompt-host (format "host (%s): " default-host))
	      (prompt-user (format "user (%s): " tramp-user-default))
	      (host ;; (read-string "host: "))
	       (completing-read prompt-host tramp-host-list nil nil nil nil default-host ))
	      (user (completing-read prompt-user tramp-user-list nil nil nil nil tramp-user-default))
	      (port (read-number "port: " 22)))
     (list (read-file-name "Remote file:" (tramp-initial-spec user host port) nil 'confirm ))))
  (find-file filename))

(keymap-global-set "C-x T l" 'tramp-open-local)
(keymap-global-set "C-x T f" 'tramp-open-remote)
;;; tramp-interactive.el ends here
