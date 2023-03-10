# tramp-interactive
tramp-interactive: An easier find-file for TRAMP

This module provides a comfortable means to build the file name for `find-file` when accessing remote servers using ssh and TRAMP.

Once installed in the Emacs configuration directory tree, I add it using `use-package`:

```
(use-package tramp-interactive
  :ensure nil
  :load-path "lisp/tramp-interactive"
  :pin manual
  :init
  (require 'tramp)
  ;; Just in case, make sure that the LSP is there
  (add-to-list 'tramp-remote-path "~/.local/bin")
  :config
  (message "Configuring tramp-interactive...")
  (setq tramp-user-default (getenv "USER"))
  (setq tramp-user-list `(,tramp-user-default "student"))
  (setq tramp-host-list `("localhost" "osm12.local")))
```

Variables to customise your environment:

`tramp-user-default` will normally be your user in the system.
If you don't set it, the package will use the value of `tramp-default-user`
or  `(getenv "USER")` as a last resort if `tramp-default-user` is `nil`.
When you access a remote server with this user, `tramp-interactive` will suppress the `user@` part in the file spec

`tramp-user-list` is a list of frequently used user names that will be used to auto-complete the user prompt.

`tramp-host-list` is a list of frequently used hosts

Key bindings:

`C-x T f` to access an (eventually) port translated remote server.

`C-x T l` to access a port translated virtual machine in the current host.
