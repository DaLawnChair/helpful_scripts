
make_program_name=$1 
execution_program_name={2:-"$1"}
clear

[[ -f "$2" ]] && echo "Removing old instance of $2" && rm "$2" # updates file, removes old version

make $1 || { echo "make of $1 failed. Check if it exist within the given makefile" ; exit 1 ; } 

./$2
