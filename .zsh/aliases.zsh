# Base aliases
alias ls='ls --color=auto'
alias eza='eza --icons --long --header --all --group'

# Custom command to install Grub at default/fallback boot path
alias grub2-removable='sudo grub2-install --target=x86_64-efi --efi-directory=/boot/efi --removable'

# Custom Git command to work with git@github.com:guinuxbr/.dotfiles.git
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Arch Linux aliases
alias alup='paru && flatpak update && fwupdmgr update'
