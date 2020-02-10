;;; packages.el --- mdb-org layer packages file for Spacemacs.
;;
;; Author: Matt Burrows <maburrow@googlemail.com>
;;
;;; License: GPLv3

;;; Commentary:
;;;
;;; My custom configuration for org mode

;;; Code:

(defconst mdb-org-packages
  '()
  "The list of Lisp packages required by the mdb-org layer")

(with-eval-after-load 'org

  (setq org-directory "~/org")
  (setq org-default-notes-file "~/org/inbox.org")
  (setq org-agenda-files '("~/org/inbox.org" "~/org/work.org" "~/org/home.org"))
  (setq org-enforce-todo-dependencies t)
  (setq org-cycle-separator-lines 0)

  ;; Skip normal processing when changing states with S-<left> and S-<right>
  (setq org-treat-S-cursor-todo-selection-as-state-change nil)

  ;; Set refile targets to be this file + any agenda file - up to 5 levels deep
  (setq org-refile-targets
        '((nil :maxlevel . 5)
          (org-agenda-files :maxlevel . 5)))

  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
          (sequence "WAITING(w@/!)" "MAYBE(m)")))

  (setq org-todo-keyword-faces
        '(("TODO" . (:foreground "orange" :weight bold))
          ("NEXT" . (:foreground "IndianRed1" :weight bold))
          ("WAITING" . (:foreground "yellow" :weight bold))
          ("MAYBE" . (:foreground "purple" :weight bold))
          ("DONE" . (:foreground "limegreen" :weight bold))))

  (setq org-capture-templates
        '(("t" "todo" entry (file org-default-notes-file)
           "* TODO %?\n%U\n%a\n")
          ("j" "Journal" entry (file+datetree "~/org/journal.org")
           "* %?\n%U\n")
          ("i" "Idea" entry (file org-default-notes-file)
           "* %? :IDEA: \n%u")))

  (setq org-agenda-compact-blocks t)

  (setq org-stuck-projects
        '("+PROJECT+LEVEL=2-NOTSTUCK" ("NEXT") nil ""))

  (setq org-agenda-custom-commands
        '(("l" "Later"
           ((tags "+LEVEL=2+READ|+LEVEL=2+WATCH")))
          ("o" "Agenda"
           ((agenda "" ((org-agenda-span 3)))
            (tags "REFILE" ((org-agenda-overriding-header "\nTasks to Refile:")))
            (stuck "" ((org-agenda-overriding-header "Stuck Projects:")))
            (todo "NEXT" ((org-agenda-overriding-header "Next Actions:")))
            (todo "TODO" ((org-agenda-overriding-header "Tasks:")))
            (todo "WAITING" ((org-agenda-overriding-header "Waiting For:")))
            (tags "+PROJECT+LEVEL=2" ((org-agenda-overriding-header "Projects:")))
            (tags "+CLOSED<=\"<-7d>\"" ((org-agenda-overriding-header "To Archive:"))))
           ((org-tags-match-list-sublevels nil)
            (org-agenda-todo-ignore-scheduled 'future)))))
  )

