# Base aliases
alias ls='ls --color=auto'

# Custom command to install Grub at default/fallback boot path
alias grub2-removable='sudo grub2-install --target=x86_64-efi --efi-directory=/boot/efi --removable'

# Custom Git command to work with git@github.com:guinuxbr/.dotfiles.git
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Eza aliases
alias eza='eza --icons --long --header --all --group'
