
make_program_name=$1 


[[ -f "$1" ]] && echo "Removing old instance of $1" && rm "$1" # updates file, removes old version

make $1 || { echo "make of $1 failed. Check if it exist within the given makefile" ; exit 1 ; } 

./$1
