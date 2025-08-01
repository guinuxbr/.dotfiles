#---------------------------------------------------------------------------------
# Define color escape sequences
#---------------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

#---------------------------------------------------------------------------------
# Export Environment Variables
#---------------------------------------------------------------------------------
export OSNAME=$(hostnamectl | grep "Operating System" | cut -d" " -f3)  # Check the Linux distribution name
export PATH=$PATH:$HOME/bin:$HOME/.local/bin  # Set PATH
export ELAN_IP=$(ip a | grep -E "scope global.*enp" | grep -Po '(?<=inet )[\d.]+') # Export the local Ethernet IP
export WLAN_IP=$(ip a | grep -E "scope global.*wl" | grep -Po '(?<=inet )[\d.]+') # Export the local Wireless IP

#---------------------------------------------------------------------------------
# Enable some basic completions
#---------------------------------------------------------------------------------
autoload -Uz compinit promptinit
compinit
promptinit

#---------------------------------------------------------------------------------
# Enable the history file
#---------------------------------------------------------------------------------
HISTFILE=~/.zsh_history  # The path to the history file
HISTSIZE=10000  # The maximum number of events to save in the history file
SAVEHIST=$HISTSIZE  # The maximum number of events in the history file
HISTDUP=erase  # Erase duplicates in the history file
setopt appendhistory  # Append history to the history file (no overwriting)
setopt sharehistory  # Share history across terminals
setopt hist_ignore_space  # Don't record an entry starting with a space
setopt hist_ignore_all_dups  # Delete old recorded entry if new entry is a duplicate
setopt hist_save_no_dups  # Don't write duplicate entries in the history file
setopt hist_ignore_dups  # Don't record an entry that was just recorded again
setopt hist_find_no_dups  # Don't display a line previously found
setopt AUTO_PUSHD   # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS  # Do not store duplicates in the stack.
setopt PUSHD_SILENT   # Do not print the directory stack after pushd or popd.
setopt COMPLETE_ALIASES  # Enable autocompletion of command line switches for aliases
#---------------------------------------------------------------------------------
# zstyle options
#---------------------------------------------------------------------------------
zstyle ':completion:*' menu select  # Enable arrow selection in autocompletion
zstyle ':completion::complete:*' gain-privileges 1  # Enable autocompletion of privileged environments in privileged commands
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Enable case-insensitive autocompletion

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
# Load external functionalities
#---------------------------------------------------------------------------------
source $HOME/.zsh/scripts.zsh  # Load custom scripts
source $HOME/.zsh/aliases.zsh  # Load aliases

#---------------------------------------------------------------------------------
# Check if the ssh-agent is running. If not, start it
#---------------------------------------------------------------------------------
[ -n "$SSH_AGENT_PID" ] || eval "$(ssh-agent -s)" > /dev/null

#---------------------------------------------------------------------------------
# Enable a command_not_found_handler for openSUSE
#---------------------------------------------------------------------------------
if [[ $OSNAME == "openSUSE" ]]
then   
    command_not_found_handler() {
        echo "Either '$1' is not installed or can only be executed by root."
        cnf "$1"
    }
fi

#---------------------------------------------------------------------------------
# Enable Pacman "command-not-found". "pkgfile" should be installed (Arch Linux only)
#---------------------------------------------------------------------------------
# if [[ $OSNAME == "Arch" ]]
# then
#     COMMAND_NOT_FOUND="/usr/share/doc/pkgfile/command-not-found.zsh"
#     if ! [[ -f $COMMAND_NOT_FOUND ]]
#     then
#         echo "${RED}pkgfile${RESET} is not installed"
#     else
#         source $COMMAND_NOT_FOUND
#     fi
# fi

#---------------------------------------------------------------------------------
# Check if Starship is installed and load it, if not, load a native Zsh theme
#---------------------------------------------------------------------------------
if ! [[ -x "$(command -v starship)" ]]
then
    prompt fade green
else
    eval "$(starship init zsh)"
fi

#---------------------------------------------------------------------------------
# Check if Atuin is installed and load it, if not, do nothing
#---------------------------------------------------------------------------------
if ! [[ -x "$(command -v atuin)" ]]
then
    :
else
    eval "$(atuin init zsh)"
fi

#---------------------------------------------------------------------------------
# Check if Pyenv is installed and load it, if not, do nothing
#---------------------------------------------------------------------------------
if ! [[ -x "$(command -v pyenv)" ]]
then
    :
else
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - zsh)"
fi

#---------------------------------------------------------------------------------
# Enable ZSH syntax-highlighting plugin
#---------------------------------------------------------------------------------

if [[ $OSNAME == "openSUSE" ]] || [[ $OSNAME == "Fedora" ]] || [[ $OSNAME == "Ubuntu" ]]
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
if [[ $OSNAME == "openSUSE" ]] || [[ $OSNAME == "Fedora" ]] || [[ $OSNAME == "Ubuntu" ]]
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
