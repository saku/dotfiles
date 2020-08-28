;; language setting（UTF-8）
(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)

;; window alpha setting
(if window-system (progn
   (set-background-color "Black")
   (set-foreground-color "LightGray")
   (set-cursor-color "Gray")
   (set-frame-parameter nil 'alpha 80)
   ))

;; base setting
(global-font-lock-mode t)  ;; coloring
(display-time)             ;; show watch
(setq column-number-mode t);; show column number
(setq line-number-mode t)  ;; show line number
(auto-compression-mode t)  ;; prevent Japanese info display bug
(setq inhibit-startup-message t) ;; do not display startup message
(tool-bar-mode 0) ;; do not display toolbar
(setq-default tab-width 4) ;; tab = 4 spaces
(setq visible-bell t) ;; do not beep
(setq completion-ignore-case t) ;; ignore case when searching file path
(setq transient-mark-mode t)

;; use electrical buffer
(define-key global-map "\C-x\C-b" 'electric-buffer-list)

;; use Control + h = BackSpace
(define-key global-map "\C-h" 'delete-backward-char)

;; Command-Key and Option-Key
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;; when exited, delete auto save file
(setq delete-auto-save-files t)

;; do not maek *.~ file
(setq make-backup-files nil)

;; show paren
(show-paren-mode 1)

;; display one line
(setq truncate-lines t)
(setq truncate-partial-width-windows t)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; open recent
(recentf-mode t)
(setq recentf-max-menu-items 30)
(setq recentf-max-saved-items 100)

;; cocoa emacs font
(when (>= emacs-major-version 23)
 (set-face-attribute 'default nil
                     :family "monaco"
                     :height 140)
 (set-fontset-font
  (frame-parameter nil 'font)
  'japanese-jisx0208
  '("Hiragino Kaku Gothic ProN" . "iso10646-1"))
 (set-fontset-font
  (frame-parameter nil 'font)
  'japanese-jisx0212
  '("Hiragino Kaku Gothic ProN" . "iso10646-1"))
 (set-fontset-font
  (frame-parameter nil 'font)
  'mule-unicode-0100-24ff
  '("monaco" . "iso10646-1"))
 (setq face-font-rescale-alist
      '(("^-apple-hiragino.*" . 1.2)
        (".*osaka-bold.*" . 1.2)
        (".*osaka-medium.*" . 1.2)
        (".*courier-bold-.*-mac-roman" . 1.0)
        (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
        (".*monaco-bold-.*-mac-roman" . 0.9)
        ("-cdac$" . 1.3))))

;; set empty to initial scratch text
(setq initial-scratch-message "")

;; change find-file path to ~/
(cd "~/")

;; uniq functions.
(defun uniq-region (beg end)
  "Remove duplicate lines, a` la Unix uniq.
   If tempted, you can just do <<C-x h C-u M-| uniq RET>> on Unix."
  (interactive "r")
  (let ((ref-line nil))
      (uniq beg end
            (lambda (line) (string= line ref-line))
            (lambda (line) (setq ref-line line)))))
(defun uniq-remove-dup-lines (beg end)
  "Remove all duplicate lines wherever found in a file, rather than
   just contiguous lines."
  (interactive "r")
  (let ((lines '()))
    (uniq beg end
          (lambda (line) (assoc line lines))
          (lambda (line) (add-to-list 'lines (cons line t))))))
(defun uniq (beg end test-line add-line)
  (save-restriction
    (save-excursion
      (narrow-to-region beg end)
      (goto-char (point-min))
      (while (not (eobp))
     (if (funcall test-line (thing-at-point 'line))
         (kill-line 1)
       (progn
         (funcall add-line (thing-at-point 'line))
         (forward-line))))
      (widen))))

;; force single window mode.
(setq ns-pop-up-frames nil)

;; package install setting
(require 'package)
;;; add MELPA
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;;; add Marmalade
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))

;; init
(package-initialize)

;; IME
(when (eq window-system 'ns)
  (when (assoc "MacOSX" input-method-alist)
    ;; ime inline patch
    (setq default-input-method "MacOSX")
    (mapc
     (lambda (param)
       (let ((name (car param)))
         (cond
          ((string-match "Japanese\\(\\.base\\)?\\'" name) ;; hiragana
           (mac-set-input-method-parameter name 'cursor-color "blue"))
          ((string-match "Japanese" name) ;; katakana
           (mac-set-input-method-parameter name 'cursor-color "red"))
          ((string-match "Roman" name) ;; alphabet
           (mac-set-input-method-parameter name 'cursor-color "black"))
          (t ;; others
           (mac-set-input-method-parameter name 'cursor-color "yellow"))
          )
         ))
     mac-input-method-parameters)
    (mac-set-input-method-parameter "com.apple.keylayout.US" 'cursor-color "black")
    )
)

;; helm
;;; keybindings
(define-key global-map (kbd "M-x") 'helm-M-x)
;(define-key global-map (kbd "\C-x\C-f") 'helm-find-files)
(define-key global-map (kbd "\C-x\C-r") 'helm-recentf)
(define-key global-map (kbd "\C-x\C-b") 'helm-buffers-list)
(helm-recentf)

;; Advansed window separate setting
(defun other-window-or-split (val)
  (interactive)
  (when (one-window-p)
;    (split-window-horizontally) ;split horizontally
    (split-window-vertically) ;split vertically
  )
  (other-window val))
(global-set-key (kbd "<C-tab>") (lambda () (interactive) (other-window-or-split 1)))
(global-set-key (kbd "<C-S-tab>") (lambda () (interactive) (other-window-or-split -1)))

;; initialize path env at last
(exec-path-from-shell-initialize)

;; for jq format
(defun jq-format (beg end)
  (interactive "r")
  (shell-command-on-region beg end "jq ." nil t))

;; disable menu bar
(menu-bar-mode -1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (kotlin-mode exec-path-from-shell ag helm))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; keep big/small character when replace.
(setq case-replace nil)

;; for ag
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
