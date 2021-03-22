set -gx EDITOR nvim
set -gx BAT_THEME Nord

abbr -a c clear

#important configuration files
alias vlightdm "sudo nvim /etc/lightdm/lightdm.conf"
alias vpacman "sudo nvim /etc/pacman.conf"
alias vgrub "sudo nvim /etc/default/grub"
alias vconfgrub "sudo nvim /boot/grub/grub.cfg"
alias vmkinitcpio "sudo nvim /etc/mkinitcpio.conf"
alias vmirrorlist "sudo nvim /etc/pacman.d/mirrorlist"

#list
alias ls "exa --git"
alias la "ls -a"
alias ll "ls -la"
alias l "ls -la"
abbr -a tree exa --tree

abbr -a open "xdg-open"
abbr -a pbcopy "xclip -i -selection clipboard"
abbr -a pbpaste "xclip -o -selection clipboard"

function v
  if test -z "$argv"
    nvim .
  else
    nvim $argv
  end
end

alias lconf-reload "source ~/.config/fish/config.fish"
abbr -a todo "nvim ~/.github/README.md"
abbr -a vconf "nvim ~/.config/nvim/init.vim"
abbr -a lconf "nvim ~/.config/fish/config.fish; and lconf-reload"
abbr -a aconf "nvim ~/.config/alacritty/alacritty.yml"
abbr -a xmconf "nvim ~/.xmonad/xmonad.hs"
abbr -a kconf "nvim ~/.xmonad/README.md"
abbr -a asconf "nvim ~/.xmonad/scripts/autostart.sh"
abbr -a pbconf "nvim ~/.config/polybar/config"
abbr -a pblaunch "~/.config/polybar/launch.sh"
abbr -a xmerr "bat ~/.xmonad/xmonad.errors"

#git & yadm
function g
  if test -z "$argv"
    git status -sb
  else
    git $argv
  end
end

abbr -a ga "git add --all"

function gc
  if test -z "$argv"
    git commit -v
  else
    git commit -m "$argv"
  end
end

abbr -a gl "git log --show-signature"

function y
  if test -z "$argv"
    yadm status -sb
  else
    yadm $argv
  end
end

abbr -a ya "yadm add -u"

function yc
  if test -z "$argv"
    yadm commit -v
  else
    yadm commit -m "$argv"
  end
end

#other
alias yay "echo do you mean paru?"

# Load asdf
source $HOME/.asdf/asdf.fish

# Load prompt
starship init fish | source
