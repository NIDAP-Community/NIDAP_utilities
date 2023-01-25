#!/bin/bash

##################################################################
#
# About This Script:
# nd_ls: implements the BASH ls command
#
##################################################################
#
# Usage:
# sh nd_ls.sh "folder_path_name_to_list"
#
# sh nd_ls.sh -h
#             -h flag; displays function help;
#
# sh nd_ls.sh -t
#             -t flag; test function;
#
##################################################################
#
# Returns:
# nothing
#
##################################################################

# execute request
if [ "$#" -eq 1 ] && [ "$1" != "-h" ] && [ "$1" != "-t" ]
then
    echo "Listing folder(s): [$1]...";
    ls -C -al | awk '{ print $6 "/" $7 "/" $8 "\t" $5 "\t" $9}'
# display help
elif [ "$#" -eq 1 ] && [ "$1" = "-h" ]
then
    echo "##################################################################"
    echo "#"
    echo "# About This Script:"
    echo "# nd_ls: implements the BASH ls command"
    echo "#"
    echo "##################################################################"
    echo "#"
    echo "# Usage:"
    echo "# sh nd_ls.sh ""folder_path_name_to_list"""
    echo "#"
    echo "# sh nd_ls.sh -h"
    echo "#             -h flag; displays function help;"
    echo "#"
    echo "# sh nd_ls.sh -t"
    echo "#             -t flag; test function;"
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
    getTest=$(ls ".")
    #echo "$getTest"
    if ! test -z "$getTest"
    then
        echo "nd_ls: SUCCESS."
    else
        echo "nd_ls: ERROR: failed to list folder contents; verify folder pathname and/or permissions."
    fi
else
    echo "nd_ls: ERROR: unrecognized input; syntax is: sh nd_ls.sh -h"
fi
