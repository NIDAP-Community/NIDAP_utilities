#!/bin/bash

##################################################################
#
# About This Script:
# nd_rm: implements the BASH rm command
#
##################################################################
#
# Usage:
# sh nd_rm.sh "file_path_name_to_delete.extension" ["-i"] ["-t"]
#
#             -i is optional, forces interactive confirmation
#                prompt;
#             -t is optional, tests functionality (ignores file
#                pathname provided; deletes temporary test file);
#
##################################################################
#
# Returns:
# nothing
#
##################################################################
#!/bin/bash

# test routine
if [ "$#" -ge 3 ] && [ "$3" = "-t" ]
then
    touch "test.___"
    if test -f "test.___"
    then
        rm -i "test.___"
        if test -f "test.___"
        then
            echo "nd_rm: ERROR: failed to delete test file; verify file pathname and/or permissions."
        else
            echo "nd_rm: SUCCESS."
        fi
    else
        echo "nd_rm: ERROR: failed to create test file; verify permissions."
    fi
elif [ "$#" -ge 3 ] && [ "$3" != "-t" ]
then
    echo "nd_ls: FAIL: unrecognized flag; test syntax is: sh nd_rm.sh ""filepathname.extension"" [""-i""] [""-t""]"
else
    # execute request
    if "$#" -ge 1
    then
        echo "Deleting file(s): [$1]...";
        if [ "$#" -ge 2 ] && [ "$2" = "-i" ]
        then
            echo "Using Switch(es): [$2]...";
            rm -i "$1"
        else
            echo "Deleting file(s): [$1]...";
            rm "$1"
        fi
    else
        echo "nd_rm: ERROR: file pathname is missing; syntax is: sh nd_rm.sh ""filepathname.extension"" [""-i""]"
    fi
fi
