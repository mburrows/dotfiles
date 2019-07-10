# Abbreviations
abbr -a aac 'sudo apt autoclean'
abbr -a aar 'sudo apt autoremove -V'
abbr -a adl 'apt download'
abbr -a afu 'sudo apt full-upgrade -V'
abbr -a ai 'sudo apt install'
abbr -a air 'sudo apt install --reinstall'
abbr -a ali 'apt list --installed'
abbr -a alu 'apt list --upgradable'
abbr -a ama 'sudo apt-mark auto'
abbr -a amm 'sudo apt-mark manual'
abbr -a apc 'sudo aptitude purge ~c'
abbr -a ar 'sudo apt remove -V'
abbr -a ard 'apt rdepends'
abbr -a as 'apt search'
abbr -a ash 'apt show'
abbr -a au 'sudo apt update'
abbr -a aug 'sudo apt upgrade -V'
abbr -a aulu 'sudo apt update && apt list --upgradable'
abbr -a auu 'sudo apt update && sudo apt upgrade -V'
abbr -a auufu 'sudo apt update && sudo apt upgrade -V && sudo apt full-upgrade -V'

# Load wal colors
if test -f ~/.cache/wal/sequences
  cat ~/.cache/wal/sequences
end
