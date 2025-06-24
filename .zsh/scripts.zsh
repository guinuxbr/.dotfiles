# Define color escape sequences
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Matrix function
matrix() {
    local lines=$(tput lines)
    cols=$(tput cols)

    awkscript='
    {
        letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"
        lines=$1
        random_col=$3
        c=$4
        letter=substr(letters,c,1)
        cols[random_col]=0;
        for (col in cols) {
            line=cols[col];
            cols[col]=cols[col]+1;
            printf "\033[%s;%sH\033[2;32m%s", line, col, letter;
            printf "\033[%s;%sH\033[1;37m%s\033[0;0H", cols[col], col, letter;
            if (cols[col] >= lines) {
                cols[col]=0;
            }
    }
}
'

echo -e "\e[1;40m"
clear

while :; do
    echo $lines $cols $(( $RANDOM % $cols)) $(( $RANDOM % 72 ))
    sleep 0.05
done | awk "$awkscript"
}

# Shrinkpdf function
shrinkpdf() {
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$2" "$1" 

} 

# GPOS - Git Push On Steroids :)
gpos() {
    if [[ -z $1 ]]; then
        echo "A commit mesage must be passed as an argument."
    else
        # Check if the current directory is a git repository
        if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
            echo -e "${RED}Not a git repository.${RESET}"
        else
            git add .
            git commit -m $1
            git push
        fi
    fi
}

# zypper dup function
zdup() {
    if [[ $1 = "-h" ]] || [[ -z $1 ]]; then
        echo "Usage:"
        echo "zdup -r to run 'sudo zypper dup --details --recommends'"
        echo "zdup -nr to run 'sudo zypper dup --details --no-recommends'"
    elif [[ $1 = "-r" ]]; then
        echo "${GREEN}Running 'sudo zypper dup --details --recommends'...${RESET}"
        echo ""
        sudo zypper dup --details --recommends
    elif [[ $1 = "-nr" ]]; then
        echo "${GREEN}Running 'sudo zypper dup --details --no-recommends'...${RESET}"
        echo ""
        sudo zypper dup --details --no-recommends
    else
        echo "${RED}Unrecognized option.${RESET}"
        echo "Usage:"
        echo "zdup -r to run 'sudo zypper dup --details --recommends'"
        echo "zdup -nr to run 'sudo zypper dup --details --no-recommends'"
    fi
}

# zypper install function
zind() {
    if [[ $1 = "-h" ]] || [[ -z $1 ]]; then
        echo "Usage:"
        echo "zind -r to run 'sudo zypper in --details --recommends'"
        echo "zind -nr to run 'sudo zypper in --details --no-recommends'"
    elif [[ $1 = "-r" ]]; then
        echo "${GREEN}Running 'sudo zypper in --details --recommends ${@:2}'...${RESET}"
        echo ""
        sudo zypper in --details --recommends "${@:2}"
    elif [[ $1 = "-nr" ]]; then
        echo "${GREEN}Running 'sudo zypper in --details --no-recommends ${@:2}'...${RESET}"
        echo ""
        sudo zypper in --details --no-recommends "${@:2}"
    else
        echo "${RED}Unrecognized option.${RESET}"
        echo "Usage:"
        echo "zind -r to run 'sudo zypper in --details --recommends'"
        echo "zind -nr to run 'sudo zypper in --details --no-recommends'"
    fi
}

# zypper remove function
zrmd() {
    if [[ $1 = "-h" ]] || [[ -z $1 ]]; then
        echo "Usage:"
        echo "zrmd -d to run 'sudo zypper rm --details'"
        echo "zrmd -cd to run 'sudo zypper rm --details --clean-deps'"
    elif [[ $1 = "-d" ]]; then
        echo "${RED}Running 'sudo zypper rm --details ${@:2}'...${RESET}"
        echo ""
        sudo zypper rm --details "${@:2}"
    elif [[ $1 = "-cd" ]]; then
        echo "${RED}Running 'sudo zypper rm --details --clean-deps ${@:2}'...${RESET}"
        echo ""
        sudo sudo zypper rm --details --clean-deps "${@:2}"
    else
        echo "${RED}Unrecognized option.${RESET}"
        echo "Usage:"
        echo "zrmd -d to run 'sudo zypper rm --details'"
        echo "zrmd -cd to run 'sudo zypper rm --details --clean-deps'"
    fi
}

# zypper search function
zse() {
    if [[ $1 = "-h" ]]; then
        echo "Usage:"
        echo "zse to run 'sudo zypper se'"
        echo "zse -d to run 'sudo zypper se --details'"
    elif [[ $1 != "-d" ]]; then
        echo "${GREEN}Running 'sudo zypper se ${@:1}'...${RESET}"
        echo ""
        sudo zypper se "${@:1}"
    elif [[ $1 = "-d" ]]; then
        echo "${GREEN}Running 'sudo zypper se --details ${@:2}...'${RESET}"
        echo ""
        sudo zypper se --details "${@:2}"
    else
        echo "${RED}Unrecognized option, use zse -h.${RESET}"
        echo "Usage:"
        echo "zse to run 'sudo zypper se'"
        echo "zse -d to run 'sudo zypper se --details'"
    fi
}

# zypper refresh function
zref() {
    if [[ $1 = "-h" ]]; then
        echo "Usage:"
        echo "zref to run 'sudo zypper ref'"
        echo "zref -f to run 'sudo zypper ref --force'"
    elif [[ -z $1 ]]; then
        echo "${GREEN}Running 'sudo zypper ref'...${RESET}"
        echo ""
        sudo zypper ref
    elif [[ $1 = "-f" ]]; then
        echo "${GREEN}Running 'sudo zypper ref --force'...${RESET}"
        echo ""
        sudo zypper ref --force
    else
        echo "${RED}Unrecognized option.${RESET}"
        echo "Usage:"
        echo "zref to run 'sudo zypper ref'"
        echo "zref -f to run 'sudo zypper ref --force'"
    fi
}

# zypper info function
zinfo() {
    if [[ $1 = "-h" ]]; then
        echo "Usage:"
        echo "zinfo to run 'sudo zypper info'"
        echo "zinfo -c to run 'sudo zypper info --conflicts --obsoletes --provides --recommends --requires --suggests --supplements'"
    elif [[ $1 != "-c" ]]; then
        echo "${GREEN}Running 'sudo zypper info ${@:1}'...${RESET}"
        echo ""
        sudo zypper info "${@:1}"
    elif [[ $1 = "-c" ]]; then
        echo "${GREEN}Running 'sudo zypper info --conflicts --obsoletes --provides --recommends --requires --suggests --supplements ${@:2}...'${RESET}"
        echo ""
        sudo zypper info --conflicts --obsoletes --provides --recommends --requires --suggests --supplements "${@:2}"
    else
        echo "${RED}Unrecognized option, use zinfo -h.${RESET}"
        echo "Usage:"
        echo "zinfo to run 'sudo zypper info'"
        echo "zinfo -c to run 'sudo zypper info --conflicts --obsoletes --provides --recommends --requires --suggests --supplements'"
    fi
}

# Arch Linux Pacman command-not-found handler
command_not_found_handler() {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=(
        ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"}
    )
    if (( ${#entries[@]} ))
    then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}"
        do
            # (repo package version file)
            local fields=(
                ${(0)entry}
            )
            if [[ "$pkg" != "${fields[2]}" ]]
            then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}