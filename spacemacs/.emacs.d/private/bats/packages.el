;;; packages.el --- bats layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Matt Burrows <mburrows@pcomblin2.uk.bats.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Code:

(defconst bats-packages '())

;; Set BATS c-style
(c-add-style "bats"
             '((indent-tabs-mode . nil)
               (c-basic-offset . 4)
               (c-offsets-alist
                (substatement-open . 0)
                (inline-open . 0)
                (statement-cont . c-lineup-assignments)
                (inextern-lang . 0)
                (innamespace . 0))))

(setq c-default-style "bats")

(setq bats-ld-library-path
      '("/opt/rh/devtoolset-7/root/usr/lib64"
        "/opt/rh/devtoolset-7/root/usr/lib"
        "/opt/rh/devtoolset-7/root/usr/lib64/dyninst"
        "/opt/rh/devtoolset-7/root/usr/lib/dyninst"
        "/opt/rh/devtoolset-8/root/usr/lib64"
        "/opt/rh/devtoolset-8/root/usr/lib"
        "/opt/rh/devtoolset-8/root/usr/lib64/dyninst"
        "/opt/rh/devtoolset-8/root/usr/lib/dyninst"
        "/opt/bats/lib64"
        "/opt/bats/lib"
        "/opt/ecn/users/mburrows/bin"))

(defun get-cpp-directory () "~/cpp/")
(defun word-empty-p (word) (string= word ""))
(defun get-ld-library-path () (string-join bats-ld-library-path ":"))

(defun run-unit-test ()
  "Run ecn unit test case with symbol under the point as the test name"
  (interactive)
  (let ((testName (thing-at-point 'symbol)))
    (unless (word-empty-p testName)
      (message (format "Running test %s..." testName))
      (shell-command (format "export LD_LIBRARY_PATH=%s; %secn_unit_test/parallel_test -t %s"
                             (get-ld-library-path)
                             (get-cpp-directory)
                             testName))
      (message "done"))))

(defun run-parallel-test ()
  "Run ecn parallet tests"
  (interactive)
  (let ((testOptions (read-string "Test Options: ")))
    (async-shell-command (format "export LD_LIBRARY_PATH=/opt/bats/lib64:/opt/ecn/bin; %secn_unit_test/parallel_test -1 %s" (get-cpp-directory) testOptions))))

(defun run-boost-unit-test ()
  "Run boost unit test case. Point should be somewhere in the body of the test case."
  (interactive) 
  (save-excursion
    (search-backward "TEST_CASE")
    (down-list)
    (run-unit-test)))

(defun bats-find-file-if-exists (base ext)
  "Find file with given BASE name and EXT, if it exists"
  (setq filename (concat base ext))
  (if (file-exists-p filename)
      (find-file filename)))

(defun bats-next-file (base exts)
  (seq-some (lambda (ext) (bats-find-file-if-exists base ext)) exts))

(defun bats-find-other-file ()
  "Switch between c++ header (.h), inline header (_inline.h) and source (.cpp)"
  (interactive)
  (let ((base (file-name-sans-extension buffer-file-name))
        (ext (downcase (file-name-extension buffer-file-name))))
    (cond
     ;; inline (special) case
     ((string-match "\\(.+\\)_inline$" base)
      (bats-next-file (match-string 1 base) '(".cpp" ".h")))
     ;; header case
     ((equal ext "h")
      (bats-next-file base '("_inline.h" ".cpp")))
     ;; source case
     ((equal ext "cpp")
      (bats-next-file base '(".inc" ".h")))
     ;; inc case
     ((equal ext "inc")
      (bats-next-file base '(".cpp" ".h"))))))

(add-hook 'c++-mode-hook
          (lambda()
            ;; (push '(?/ . ("/*" . "*/")) evil-surround-pairs-alist)
            (local-set-key (kbd "<f2>") 'bats-find-other-file)
            (local-set-key (kbd "<f6>") 'run-unit-test)
            (local-set-key (kbd "<f7>") 'run-parallel-test)
            (local-set-key (kbd "<f8>") 'run-boost-unit-test)))

(add-to-list 'auto-mode-alist '("\\.inc\\'" . c++-mode))

;; Custom sql postgres settings
(add-hook 'sql-login-hook
          (lambda ()
            (when (eq sql-product 'postgres)
              (let ((proc (get-buffer-process (current-buffer))))
                (comint-send-string proc "\set ECHO queries\n")))))

(add-to-list 'auto-mode-alist '("\\.sqli\\'" . sql-mode))

(defun bury-compile-buffer-if-successful (buffer string)
  "Bury a compilation buffer if succeeded without warnings "
  (when (and
         (buffer-live-p buffer)
         (string-match "compilation" (buffer-name buffer))
         (string-match "finished" string)
         (not
          (with-current-buffer buffer
            (goto-char (point-min))
            (search-forward "warning" nil t))))
    (run-with-timer 1 nil
                    (lambda (buf)
                      (bury-buffer buf)
                      (delete-windows-on buf))
                    buffer)))

(add-hook 'compilation-finish-functions 'bury-compile-buffer-if-successful)

;;; packages.el ends here
