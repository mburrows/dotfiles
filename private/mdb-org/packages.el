;;; packages.el --- mdb-org layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Matt Burrows & Contributors
;;
;; Author: Matt Burrows <m@ttburro.ws>
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Code:

(defconst mdb-org-packages
  '(org)
  "The list of Lisp packages required by the mdb-org layer.")

(defun mdb-org/post-init-org ()
  (with-eval-after-load 'org
    (setq org-enforce-todo-dependencies t
          org-enforce-todo-checkbox-dependencies t
          org-agenda-dim-blocked-tasks 'invisible
          org-directory "~/org"
          org-default-notes-file "~/org/inbox.org"
          ;;org-agenda-files '(file-expand-wildcards "~/org/*.org")
          org-agenda-files '("~/org/todo.org" "~/org/inbox.org" "~/org/interesting.org"))

    ;; To-Do states and transitions
    (setq org-todo-keywords
          (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
                  (sequence "WAITING(w@/!)"))))

    ;; Tags
    (setq org-tag-alist '((:startgroup)
                          ("@errand" . ?e)
                          ("@office" . ?o)
                          ("@home"   . ?h)
                          (:endgroup)
                          ("PROJECT"  . ?P)
                          ("HOME"     . ?H)
                          ("PERSONAL" . ?M)
                          ("WORK"     . ?W)
                          ("ONLINE"   . ?O)
                          ("PHONE"    . ?P)))

    ;; Capture templates
    (setq org-capture-templates
          (quote (("t" "todo" entry (file "")
                   "* TODO %?\n%U\n")
                  ("l" "todo (with link)" entry (file "")
                   "* TODO %?\n%U\n%a\n")
                  ("j" "journal" entry (file+datetree "journal.org")
                   "* %?\nEntered on %U\n  %i\n")
                  ("r" "respond" entry (file "")
                   "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n"))))

    ;; Setup refile targets
    (setq org-refile-targets (quote ((nil :maxlevel . 9) (org-agenda-files :maxlevel . 9)))
          org-refile-use-outline-path t
          org-outline-path-complete-in-steps nil
          org-refile-allow-creating-parent-nodes 'confirm)

    ;; Custom agenda views
    (setq org-agenda-tags-todo-honor-ignore-options t)
    (setq org-agenda-custom-commands
          '(("b" "Block Agenda"
             ((agenda "" ((org-agenda-ndays 3)))
              (tags "REFILE"
                    ((org-agenda-overriding-header "Tasks to Refile")
                     (org-tags-match-list-sublevels t)))
              (stuck "")
              (tags-todo "/!NEXT"
                         ((org-agenda-overriding-header "Next Actions")
                          (org-tags-match-list-sublevels t)
                          (org-agenda-todo-ignore-scheduled 'all)
                          (org-agenda-todo-ignore-deadlines 'all)
                          (org-agenda-todo-ignore-with-date 'all)
                          (org-agenda-sorting-strategy '(todo-state-down category-keep))))
              (tags-todo "-REFILE/!-WAITING-NEXT"
                         ((org-agenda-overriding-header "Tasks")
                          (org-agenda-todo-ignore-scheduled 'all)
                          (org-agenda-todo-ignore-deadlines 'all)
                          (org-agenda-todo-ignore-with-date 'all)
                          (org-agenda-sorting-strategy '(todo-state-down category-keep))))
              (tags "PROJECT"
                    ((org-agenda-overriding-header "Projects")
                     (org-tags-match-list-sublevels nil)))
              (todo "WAITING"
                    ((org-agenda-overriding-header "Waiting For")
                     (org-agenda-todo-ignore-scheduled 'future)
                     (org-agenda-todo-ignore-deadlines 'future)))))
            ("r" "Weekly Review"
             ((agenda "" ((org-agenda-ndays 14))) ; review upcoming deadlines and appointments
              (stuck "")                          ; review stuck projects as designated by org-stuck-projects
              (tags "PROJECT")                    ; review all projects (assuming you use todo keywords to designate projects)
              (todo "WAITING")))                  ; review waiting items
            ))

    (defun fc/org-inherit-deadline ()
      "Inherit a DEADLINE."
      (interactive)
      (let* ((deadline (org-entry-get-with-inheritance "DEADLINE")))
        (if (and (org-not-nil deadline)
                 (y-or-n-p (format "Inherit DEADLINE: <%s>? " deadline)))
            (org-deadline nil (org-time-string-to-time deadline)))))

    (add-hook 'org-mode-hook
              (lambda ()
                (define-key org-mode-map (kbd "C-c C-x d") 'fc/org-inherit-deadline)))
    )
  )
;;; packages.el ends here
