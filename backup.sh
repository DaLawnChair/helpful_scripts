#/bin/bash

# Goal: to have a quick way to backup directories to a server instance via processes over ssh.
# Usage: This takes in 3 arguments, the input_dir (mandatory), a save_dir within the ssh server, and the server_ip address.
# Requirements: the ssh with the server requires a passwordless access, which can be done with `ssh-keygen`

# some checks exist for directory existance and server access
# This method uses pipes and process subsition, so there is no extra read-write needed. Process subsitution on the file copy allows this bitstream 
# to be copied over to what the bash treats as a file 

# access variables 
input_dir=$1 
save_dir=${2:-/mnt/sn580}
server_ip=${3:-"dietpi@10.0.0.88"}

# Check arguments are passed
if [[ -z $input_dir || $# -gt 3 ]]; then 
    echo "usage: backup.sh <input_dir> <save_dir, defaulted to /mnt/sn580> <server_ip, defaulted to dietpi@10.0.88>"
    exit 1
fi 

# test the input folder is a dir
test -d "$input_dir" || { echo "ERROR: $input_dir is not a directory" >&2 ; exit 1 ; }

# test ssh server access and directory existance
ssh_without_password(){
    ssh -o BatchMode=yes \
        -o ConnectTimeout=5 \
        -o ConnectionAttempts=1 \
        -o StrictHostKeyChecking=accept-new \
        "$server_ip" "test -d $save_dir"
}

ssh_without_password
save_dir_is_dir_test=$?

# validate that the ssh can be conncted
[[ $save_dir_is_dir_test == 225 ]] && { echo "ERROR: ssh to $server_ip failed" ; exit $save_dir_is_dir_test ; }
# validate that the ssh server has the directory
[[ $save_dir_is_dir_test == 1 ]] && { echo "ERROR: $save_dir is not a directory in $server_ip" ; exit 1 ; }


# perform the backup
# this will tar the input_dir, pipe the output to a tee that will allow the ssh server to copy and extract the .tar, as well as remove the temporary file
# data is produced as a stream (because of - in tar) that is piped to the ssh server and to /dev/null, thus no intermediate version is needed for another read-write to copy to the server
backup(){
    tar cf - $input_dir | tee  >(ssh $server_ip tar xf - --directory $save_dir) > /dev/null
}
backup 

