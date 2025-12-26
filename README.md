# Helpful Scripts


These are a few helpful bash scripts that I found helpful for both usage and learning advanced bash topics.

## backup.sh 
A simple script that takes in a folder and saves a backup into a server.
This uses ssh for connectivity, tar for compression, and process subsitition to avoid temporary files that would lead to another read-write.
```bash
. backup.sh <input_dir> <output_dir> <server_ip>
```
where server_ip and output_dir are defaulted for my configuration.



## run.sh 
A simple script that makes debugging into 1 line. Given a program name, tt will remove of the compiled program if it exists, and run make in accordance to the `makefile`, and then run the program.

This is designed to run within the folder itself.

``` 
. run.sh <program_name>
```
where `program_name` represents the name for compilation within the `makefile` as well as the outputted name of the program.
