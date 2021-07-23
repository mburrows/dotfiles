# vim: set ft=fish foldmethod=marker:

set -Ux GTAGSFORCECPP 1
set -Ux EDITOR "emacsclient"
set -Ux CDPATH . .. ~

# Abbreviations
abbr -a g    "git --no-pager grep -n --break -i"
abbr -a ga   "git add"
abbr -a gacm "git add -A . ; git commit --verbose"
abbr -a gau  "git add -u"
abbr -a gb   "git branch"
abbr -a gc   "git commit"
abbr -a gcm  "git commit -m"
abbr -a gco  "git checkout"
abbr -a gcob "git checkout -b"
abbr -a gcom "git checkout master"
abbr -a gd   "git diff -w"
abbr -a gdo  "git diff -w origin"
abbr -a gf   "git pull"
abbr -a gpo  "git pull origin"
abbr -a gg   "git --no-pager grep -n --break -i"
abbr -a gh   "git help"
abbr -a gl   "git log"
abbr -a gls  "git log --oneline"
abbr -a gp   "git push"
abbr -a gpm  "git push origin HEAD:master"
abbr -a gr   "git rebase"
abbr -a grm  "git pull --rebase origin master"
abbr -a gro  "git rebase origin"
abbr -a gs   "git status"
abbr -a gu   "git add -u"
abbr -a gz   "git stash"
abbr -a gme  "git log --author=mburrows"

abbr -a pk   "pkill"
abbr -a pg   "pgrep -fl"

# Aliases
alias rl="source ~/.config/fish/config.fish"
alias tmux="tmux -2"
alias e="emacsclient -n"
alias et="emacsclient -t"
alias l="ls -lrth"

# Load local configuration (it it exists)
if test -f ~/.config/fish/(hostname -s).fish
    source ~/.config/fish/(hostname -s).fish
end

# Base16 Shell
if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
    base16-tomorrow-night
end
