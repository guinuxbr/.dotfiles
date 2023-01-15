alias ls='ls --color=auto'

# Custom command to install Grub at default/fallback boot path
alias grub2-removable='sudo grub2-install --target=x86_64-efi --efi-directory=/boot/efi --removable'
