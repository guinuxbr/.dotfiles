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

shrinkpdf() {
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$2" "$1" 

} 

gpos() {
    git add .
    git commit -m $1
    git push
}

zdup() {
    if [[ $1 = "-h" ]] || [[ -z $1 ]]; then
        echo "Usage:"
        echo "zdup -r to run 'sudo zypper dup --details --recommends'"
        echo "zdup -nr to run 'sudo zypper dup --details --no-recommends'"
    elif [[ $1 = "-r" ]]; then
        echo "'sudo zypper dup --details --recommends' will be executed!"
        sudo zypper dup --details --recommends
    elif [[ $1 = "-nr" ]]; then
        echo "'sudo zypper dup --details --no-recommends' will be executed!"
        sudo zypper dup --details --no-recommends
    else
        echo "Unrecognized option, use zdup -h."
    fi
}

zind() {
    if [[ $1 = "-h" ]] || [[ -z $1 ]]; then
        echo "Usage:"
        echo "zind -r to run 'sudo zypper in --details --recommends'"
        echo "zind -nr to run 'sudo zypper in --details --no-recommends'"
    elif [[ $1 = "-r" ]]; then
        echo "'sudo zypper in --details --recommends "${@:2}"' will be executed!"
        sudo zypper in --details --recommends "${@:2}"
    elif [[ $1 = "-nr" ]]; then
        echo "'sudo zypper in --details --no-recommends "${@:2}"' will be executed!"
        sudo zypper in --details --no-recommends "${@:2}"
    else
        echo "Unrecognized option, use zind -h."
    fi
}