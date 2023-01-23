#!/bin/bash

##################################################################
#
# About This Script:
# nd_ls: implements the BASH ls command
#
##################################################################
#
# Usage:
# sh nd_ls.sh "folder_path_name_to_list" ["-t"]
#
#             -t is optional, tests functionality;
#
##################################################################
#
# Returns:
# nothing
#
##################################################################
#!/bin/bash

# test routine
if [ "$#" -ge 2 ] && [ "$2" = "-t" ]
then
    getTest=$(ls "$1")
    #echo "$getTest"
    if ! test -z "$getTest"
    then
        echo "nd_ls: SUCCESS."
    else
        echo "nd_ls: ERROR: failed to list folder contents; verify folder pathname and/or permissions."
    fi
elif [ "$#" -ge 2 ] && [ "$2" != "-t" ]
then
    echo "nd_ls: FAIL: unrecognized flag; test syntax is: sh nd_ls.sh ""folder_path_name_to_list"" [""-t""]."
else
    # execute request
    if [ "$#" -ge 1 ]
    then
        echo "Listing folder(s): [$1]...";
        ls -C -al | awk '{ print $6 "/" $7 "/" $8 "\t" $5 "\t" $9}'
    else
        echo "nd_ls: ERROR: folder pathname is missing; syntax is: sh nd_ls.sh ""folder_path_name_to_list"""
    fi
fi
