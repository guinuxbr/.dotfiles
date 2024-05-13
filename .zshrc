#---------------------------------------------------------------------------------
# Define color escape sequences
#---------------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

#---------------------------------------------------------------------------------
# Check the Linux distribution name
#---------------------------------------------------------------------------------
export OSNAME=$(lsb_release -i | cut -f 2-)

#---------------------------------------------------------------------------------
# Set PATH
#---------------------------------------------------------------------------------
export PATH=$PATH:$HOME/bin:$HOME/.local/bin

#---------------------------------------------------------------------------------
# Export the local Ethernet IP
#---------------------------------------------------------------------------------
export ELAN_IP=$(ip a | grep -E "scope global.*enp" | grep -Po '(?<=inet )[\d.]+')

#---------------------------------------------------------------------------------
# Export the local Wireless IP
#---------------------------------------------------------------------------------
export WLAN_IP=$(ip a |  grep -E "scope global.*wl" | grep -Po '(?<=inet )[\d.]+')

#---------------------------------------------------------------------------------
# Enable some basic completions
#---------------------------------------------------------------------------------
autoload -Uz compinit promptinit
compinit
promptinit

#---------------------------------------------------------------------------------
# Enable the history file
#---------------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

#---------------------------------------------------------------------------------
# Enable custom scripts
#---------------------------------------------------------------------------------
source $HOME/.zsh/scripts.zsh

#---------------------------------------------------------------------------------
# Load aliases file
#---------------------------------------------------------------------------------
source $HOME/.zsh/aliases.zsh

#---------------------------------------------------------------------------------
# Configure the direcory stack
# See alias for 'dirs -v'
#---------------------------------------------------------------------------------
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

#---------------------------------------------------------------------------------
# Enable arrow selection
#---------------------------------------------------------------------------------
zstyle ':completion:*' menu select

#---------------------------------------------------------------------------------
# Enable autocompletion of command line switches for aliases
#---------------------------------------------------------------------------------
setopt COMPLETE_ALIASES

#---------------------------------------------------------------------------------
# Enable autocompletion of privileged environments in privileged commands.
#---------------------------------------------------------------------------------
zstyle ':completion::complete:*' gain-privileges 1

#---------------------------------------------------------------------------------
# Set up key bindings
#---------------------------------------------------------------------------------
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
        autoload -Uz add-zle-hook-widget
        function zle_application_mode_start { echoti smkx }
        function zle_application_mode_stop { echoti rmkx }
        add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
        add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# Enable Shift, Alt, Ctrl and Meta modifiers
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

#---------------------------------------------------------------------------------
# Enable history search
#---------------------------------------------------------------------------------
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

#---------------------------------------------------------------------------------
# Enable Pacman "command-not-found". "pkgfile" should be installed
# For Arch Linux only
#---------------------------------------------------------------------------------
if [[ $OSNAME == "Arch" ]]
then
    COMMAND_NOT_FOUND="/usr/share/doc/pkgfile/command-not-found.zsh"
    if ! [[ -f $COMMAND_NOT_FOUND ]]
    then
        echo "${RED}pkgfile${RESET} is not installed"
    else
        source $COMMAND_NOT_FOUND
    fi
fi

#---------------------------------------------------------------------------------
# Start the SSH agent automatically
# Ensure only one ssh-agent process is running
# For Arch Linux only
#---------------------------------------------------------------------------------
if [[ $OSNAME == "Arch" ]]
then
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
    fi
    if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
        source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
    fi
fi

#---------------------------------------------------------------------------------
# Check if Starship is installed and load it, if not, load a native Zsh theme 
#---------------------------------------------------------------------------------
if ! [ -x "$(command -v starship)" ]
then
    prompt fade green
else
    eval "$(starship init zsh)"
fi

#---------------------------------------------------------------------------------
# Enable ZSH syntax-highlighting plugin
#---------------------------------------------------------------------------------

if [[ $OSNAME == "openSUSE" ]] || [[ $OSNAME == "Fedora" ]]
then
    ZSH_SYNTAX_HIGHLIGHTING="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    if ! [[ -f $ZSH_SYNTAX_HIGHLIGHTING ]]
    then
        echo "${RED}zsh-syntax-highlighting${RESET} is not installed"
    else
        source $ZSH_SYNTAX_HIGHLIGHTING
    fi
elif [[ $OSNAME == "Arch" ]]
then
    ZSH_SYNTAX_HIGHLIGHTING="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    if ! [[ -f $ZSH_SYNTAX_HIGHLIGHTING ]]
    then
        echo "${RED}zsh-syntax-highlighting${RESET} is not installed"
    else
        source $ZSH_SYNTAX_HIGHLIGHTING
    fi
fi

#---------------------------------------------------------------------------------
# Enable ZSH autosuggestions plugin
#---------------------------------------------------------------------------------
if [[ $OSNAME == "openSUSE" ]] || [[ $OSNAME == "Fedora" ]]
then
    ZSH_AUTOSUGGESTIONS="/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    if ! [[ -f $ZSH_AUTOSUGGESTIONS ]]
    then
        echo "${RED}zsh-autosuggestions${RESET} is not installed"
    else
        source $ZSH_AUTOSUGGESTIONS
    fi
elif [[ $OSNAME == "Arch" ]]
then
    ZSH_AUTOSUGGESTIONS="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    if ! [[ -f $ZSH_AUTOSUGGESTIONS ]]
    then
        echo "${RED}zsh-autosuggestions${RESET} is not installed"
    else
        source $ZSH_AUTOSUGGESTIONS
    fi
fi

#---------------------------------------------------------------------------------
# Enable "keychain" if running in a headless server
#---------------------------------------------------------------------------------
if [ -z "$DISPLAY" ]; then
    # The DISPLAY environment variable isn't set, so we're likely on a headless server
    /usr/bin/keychain $HOME/.ssh/github $HOME/.ssh/guinuxbr_ed25519
    source $HOME/.keychain/$HOSTNAME-sh
fi

