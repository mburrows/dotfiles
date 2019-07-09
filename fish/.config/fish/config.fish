# vim: set ft=fish foldmethod=marker:

set -Ux GTAGSFORCECPP 1
set -Ux EDITOR "emacsclient"
set -Ux CDPATH . .. ~

# Abbreviations
abbr -a ga   "git add"
abbr -a gacm "git add -A . ; git commit --verbose"
abbr -a gc   "git commit"
abbr -a gd   "git diff -w"
abbr -a gdo  "git diff -w origin"
abbr -a gf   "git pull"
abbr -a gg   "git --no-pager grep -n --break -i"
abbr -a gl   "git log"
abbr -a gls  "git log --oneline"
abbr -a go   "git checkout"
abbr -a gp   "git push"
abbr -a gpum "git pull upstream master"
abbr -a gr   "git rebase"
abbr -a grm  "git rebase master"
abbr -a gs   "git status"
abbr -a gu   "git add -u"
abbr -a gv   "git svnup"
abbr -a gvp  "git svn dcommit"
abbr -a gz   "git stash"

abbr -a pk   "pkill"
abbr -a pg   "pgrep -fl"

# Aliases
alias g="git --no-pager grep -n --break -i"
alias rl="source ~/.config/fish/config.fish"
alias tmux="tmux -2"
alias e="emacsclient -n"
alias et="emacsclient -t"
alias l="ls -lrth"

# Load local configuration (it it exists)
if test -f ~/.config/fish/(hostname -s).fish
    source ~/.config/fish/(hostname -s).fish
end


