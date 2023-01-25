#!/bin/bash

##################################################################
#
# About This Script:
# nd_rm: implements the BASH rm command
#
##################################################################
#
# Usage:
# sh nd_rm.sh "file_path_name_to_delete.extension" [-i]
#             -i is optional, forces interactive confirmation
#                prompt;
#
# sh nd_rm.sh -h
#             -h flag; displays function help;
#
# sh nd_rm.sh -t
#             -t flg; tests functionality (ignores file
#                pathname provided; deletes temporary test file);
#
##################################################################
#
# Returns:
# nothing
#
##################################################################

# execute request
if [ "$#" -eq 1 ] || [ "$#" -eq 2 ] && [ "$1" != "-h" ] && [ "$1" != "-t" ]
then
    echo "Deleting file(s): [$1]...";
    if [ "$#" -eq 2 ] && [ "$2" = "-i" ]
    then
        echo "Using Switch(es): [$2]...";
        rm -i "$1"
    else
        rm "$1"
    fi
# display help
elif [ "$#" -eq 1 ] && [ "$1" = "-h" ]
then
    echo "##################################################################"
    echo "#"
    echo "# About This Script:"
    echo "# nd_rm: implements the BASH rm command"
    echo "#"
    echo "##################################################################"
    echo "#"
    echo "# Usage:"
    echo "# sh nd_rm.sh ""file_path_name_to_delete.extension"" [-i]"
    echo "#             -i is optional, forces interactive confirmation"
    echo "#                prompt;"
    echo "#"
    echo "# sh nd_rm.sh -h"
    echo "#             -h flag; displays function help;"
    echo "#"
    echo "# sh nd_rm.sh -t"
    echo "#             -t flg; tests functionality (ignores file"
    echo "#                pathname provided; deletes temporary test file);"
    echo "#"
    echo "##################################################################"
    echo "#"
    echo "# Returns:"
    echo "# nothing"
    echo "#"
    echo "##################################################################"
# test routine
elif [ "$#" -eq 1 ] && [ "$1" = "-t" ]
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
else
    echo "nd_ls: ERROR: unrecognized input; syntax is: sh nd_rm.sh -h"
fi
