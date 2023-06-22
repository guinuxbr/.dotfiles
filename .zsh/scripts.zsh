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
    git add .
    git commit -m $1
    git push
}

# zypper dup function
zdup() {
    if [[ $1 = "-h" ]] || [[ -z $1 ]]; then
        echo "Usage:"
        echo "zdup -r to run 'sudo zypper dup --details --recommends'"
        echo "zdup -nr to run 'sudo zypper dup --details --no-recommends'"
    elif [[ $1 = "-r" ]]; then
        echo "'${RED}sudo zypper dup --details --recommends${RESET}' will be executed!"
        echo ""
        sudo zypper dup --details --recommends
    elif [[ $1 = "-nr" ]]; then
        echo "'${RED}sudo zypper dup --details --no-recommends${RESET}' will be executed!"
        echo ""
        sudo zypper dup --details --no-recommends
    else
        echo "${RED}Unrecognized option, use zdup -h.${RESET}"
    fi
}

# zypper install function
zind() {
    if [[ $1 = "-h" ]] || [[ -z $1 ]]; then
        echo "Usage:"
        echo ""
        echo "zind -r to run 'sudo zypper in --details --recommends'"
        echo ""
        echo "zind -nr to run 'sudo zypper in --details --no-recommends'"
    elif [[ $1 = "-r" ]]; then
        echo "'${RED}sudo zypper in --details --recommends${RESET} "${@:2}"' will be executed!"
        echo ""
        sudo zypper in --details --recommends "${@:2}"
    elif [[ $1 = "-nr" ]]; then
        echo "'${RED}sudo zypper in --details --no-recommends${RESET} "${@:2}"' will be executed!"
        echo ""
        sudo zypper in --details --no-recommends "${@:2}"
    else
        echo "${RED}Unrecognized option, use zind -h.${RESET}"
    fi
}

# zypper remove function
zrmd() {
    if [[ $1 = "-h" ]] || [[ -z $1 ]]; then
        echo "Usage:"
        echo ""
        echo "zrmd -d to run 'sudo zypper rm --details'"
        echo ""
        echo "zrmd -cd to run 'sudo zypper rm --details --clean-deps'"
    elif [[ $1 = "-d" ]]; then
        echo "'${RED}sudo zypper rm --details${RESET} "${@:2}"' will be executed!"
        echo ""
        sudo zypper rm --details "${@:2}"
    elif [[ $1 = "-cd" ]]; then
        echo "'${RED}sudo zypper rm --details --clean-deps${RESET} "${@:2}"' will be executed!"
        echo ""
        sudo sudo zypper rm --details --clean-deps "${@:2}"
    else
        echo "${RED}Unrecognized option, use zrmd -h.${RESET}"
    fi
}
