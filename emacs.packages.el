;;; Usage
;;; 1. Open this file via emacs
;;; 2. Input M-x, and exec 'eval-buffer' command
;;; 3. All favorite packages will be installed.

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(package-refresh-contents)

(defvar favorite-packages
  '(
    ;;;; helm
    helm

    ;;;; ag
    ag exec-path-from-shell
    ))

(dolist (package favorite-packages)
  (unless (package-installed-p package)
    (package-install package)))
