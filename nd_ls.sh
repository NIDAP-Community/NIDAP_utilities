#!/bin/bash

##################################################################
#
# About This Script:
# nd_ls: implements the BASH ls command with options for local
#           and/or Palantir target system;
# NOTE: requires curl, jq;
#
##################################################################
#
# NOTE: options and associated input, if any, may be passed
#          in any order;
#
# Usage:
# sh nd_ls.sh -f (-folder) "folder_path_name_to_list"
# ............displays contents of local folder(s);
#
# sh nd_ls.sh -r (-rid) "palantir_object_rid"
#             -u (-user_token) "user_token"
#             -d (-domain) "domain_url"
#                [default:https://nidap.nih.gov]
# ............displays contents of Palantir folder/dataset(s);
#
# sh nd_ls.sh -h (-help)
# ............displays function help;
#
# sh nd_ls.sh -t (-test)
# ............test function;
#
##################################################################
#
# Returns:
# SUCCESS or FAILURE; Contents of requested folder/dataset(s);
#
##################################################################

# temp code to fetch ttest objects/parameters
strTestFolder="."
strTestRID="ri.foundry.main.dataset.385838db-254c-4cf9-aafd-32c0f41cf90c"
strTestUserToken=`cat /mnt/c/Users/stephendh.ctr/Documents/GitHub/NIDAP_utilities/NIDAP_utilities/sdh.txt`
strTestDomain="https://nidap.nih.gov"

strDefaultDomain="https://nidap.nih.gov"

# execute request
strArg=`echo "$1" | awk -va="$1" '{print tolower(a)}'`
if [ "$#" -gt 1 ] && [ "$strArg" != "-h" ] && [ "$strArg" != "-help" ] && [ "$strArg" != "-t" ] && [ "$strArg" != "-test" ]
then
    strFolder=""
    strRID=""
    strUserToken=""
    strDomain=""
    while [ $# -ne 0 ]
    do
        strArg=`echo "$1" | awk -va="$1" '{print tolower(a)}'`
        if [ "$strArg" = "-f" ] || [ "$strArg" = "-folder" ]
        then
            shift
            strFolder="$1"
        elif [ "$strArg" = "-r" ] || [ "$strArg" = "-rid" ]
        then
            shift
            strRID="$1"
        elif [ "$strArg" = "-u" ] || [ "$strArg" = "-user_token" ]
        then
            shift
            strUserToken="$1"
        elif [ "$strArg" = "-d" ] || [ "$strArg" = "-domain" ]
        then
            shift
            strDomain="$1"
        fi
        shift
    done

    if [ "$strDomain" = "" ]
    then
        strDomain="$strDefaultDomain"
    fi
    
    # local list
    if [ "$strFolder" != "" ]
    then
        # echo "\nListing local folder(s): [$strFolder]:\n"
        if ls "$strFolder" -C -al | grep "^d" && ls -la | grep -v "^d" | awk '{ print $6 "/" $7 "/" $8 "\t" $5 "\t" $9}'
        then
            echo "SUCCESS\n"
        else
            echo "FAILURE\n$?"
        fi
    # Palantir list
    elif [ "$strRID" != "" ] && [ "$strUserToken" != "" ] && [ "$strDomain" != "" ]
    then
        # echo "Listing Palantir folder/dataset(s), RID: [$strRID]:"
        strPost=$(curl \
            -H "Authorization: Bearer $strUserToken" \
            "$strDomain/api/v1/datasets/$strRID/files?preview=true")
        if [ "$strPost" != "" ]
        then
            strPost=sh ./nd_json_parser.sh "$strPost"
            strResult=`echo "$strPost" | head -1`
            if [ strResult == "errorCode"]
            then
                strError="$strPost"
                strError="$strError\nLocal Folder:\t$strFolder"
                strError="$strError\nObject RID:\t$strRID"
                strError="$strError\nUser Token:\t$strUserToken"
                strError="$strError\nDomain:\t$strDomain"
                strError="$strError\n$0\n"
                echo "$strError"
            fi
        else
            echo "WARNING\nResponse is empty.\n$0"
        fi
    else
        strError="FAILURE"
        strError="$strError\nInvalid Input Set:"
        strError="$strError\nLocal Folder:\t$strFolder"
        strError="$strError\nObject RID:\t$strRID"
        strError="$strError\nUser Token:\t$strUserToken"
        strError="$strError\nDomain:\t$strDomain"
        strError="$strError\n$0\n"
        echo "$strError"
    fi
# display help
elif [ "$#" -eq 1 ] && [ "$strArg" = "-h" ] || [ "$strArg" = "-help" ]
then
    echo "##################################################################"
    echo "#"
    echo "# About This Script:"
    echo "# nd_ls: implements the BASH ls command with options for local"
    echo "#           and/or Palantir target system;"
    echo "#"
    echo "##################################################################"
    echo "#"
    echo "# NOTE: options and associated input, if any, may be passed"
    echo "#          in any order;"
    echo "#"
    echo "# Usage:"
    echo "# sh nd_ls.sh -f (-folder) \"folder_path_name_to_list\""
    echo "# ............displays contents of local folder(s);"
    echo "#"
    echo "# sh nd_ls.sh -r (-rid) \"palantir_object_rid\""
    echo "#             -u (-user_token) \"user_token\""
    echo "#             -d (-domain) \"domain_url\""
    echo "#                [default:https://nidap.nih.gov]"
    echo "# ............displays contents of Palantir folder/dataset(s);"
    echo "#"
    echo "# sh nd_ls.sh -h (-help)"
    echo "# ............displays function help;"
    echo "#"
    echo "# sh nd_ls.sh -t (-test)"
    echo "# ............test function;"
    echo "#"
    echo "##################################################################"
    echo "#"
    echo "# Returns:"
    echo "# Contents of requested folder/dataset(s)"
    echo "#"
    echo "##################################################################"
# test routine
elif [ "$#" -eq 1 ] && [ "$strArg" = "-t" ] || [ "$strArg" = "-test" ]
then
    # TODO: test routine
    # temp code, testing
    strFolder="$strTestFolder"
    strRID="$strTestRID"
    strUserToken="$strTestUserToken" 
    strDomain="$strTestDomain"

    echo "$strDomain/api/v1/datasets/$strRID/files?preview=true"
    
    strTest=$(ls "$strFolder" -C -al | grep "^d" && ls -la | grep -v "^d" | awk '{ print $6 "/" $7 "/" $8 "\t" $5 "\t" $9}')
    #echo "$strTest"
    if ! test -z "$strTest"
    then
        echo "SUCCESS\n"
        echo "$strTest"
    else
        echo "FAILURE\n$?\n"
    fi
    # echo "Listing Palantir folder/dataset(s), RID: [$strRID]:"
    strPost=$(curl \
        -H "Authorization: Bearer $strUserToken" \
        "$strDomain/api/v1/datasets/$strRID/files?preview=true")
    echo sh ./nd_json_parser.sh "$strPost"
else
    echo "FAIsLURE\nUnrecognized Input\nUsage: sh nd_ls.sh -h\n$0"
fi
