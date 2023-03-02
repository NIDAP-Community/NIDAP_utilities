#!/bin/bash

##################################################################
#
# About This Script:
# nd_br: nidap branch: creates a branch on a dataset if it does not exist;
#
##################################################################
#
# NOTE: options and associated input, if any, may be passed
#          in any order;
#
# Usage:
# sh nd_br.sh -r (-rid) "palantir_dataset_rid"
#             -b (-branch_name) "myNewBranch"
#             -u (-user_token) "user_token
#             -d (-domain) "domain_url"
#                [default:https://nidap.nih.gov]
# ............Creates branch o
#
# sh nd_br.sh -h (-help)
# ............displays function help;
#
##################################################################
#
# Returns:
# string: SUCCESS or FAILURE
#
##################################################################

strDefaultDomain="https://nidap.nih.gov"

# execute request
strArg=`echo "$1" | awk -va="$1" '{print tolower(a)}'`
if [ "$#" -gt 1 ] && [ "$strArg" != "-h" ] && [ "$strArg" != "-help" ] && [ "$strArg" != "-t" ] && [ "$strArg" != "-test" ]
then
    strRID=""
    strUserToken=""
    strDomain=""    
    strBranchName=""
    while [ $# -ne 0 ]
    do
        strArg=`echo "$1" | awk -va="$1" '{print tolower(a)}'`
        if [ "$strArg" = "-r" ] || [ "$strArg" = "-rid" ]
        then
            shift
            strRID="$1"
        elif [ "$strArg" = "-b" ] || [ "$strArg" = "-branch_name" ]
        then
            shift
            strBranchName="$1"
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

    if [ "$strRID" != "" ] && [ "$strUserToken" != "" ] && [ "$strBranchName" != "" ]
    then
        create_branch_response=$(curl --request POST $strDomain/foundry-catalog/api/catalog/datasets/$strRID/branchesUnrestricted2/$strBranchName \
                                    -H "Authorization: Bearer $strUserToken" \
                                    -H "Content-Type: application/json" \
                                    -d '{}')
        if [[ "$create_branch_response" == *"errorCode"* ]]
        then
            if [[ "$create_branch_response" == *"BranchesAlreadyExist"* ]]
            then
                echo "branch $strBranchName already exists"
                echo "SUCCESS\n"
            else
                echo "ERROR in creating branch $create_branch_response"
                echo "FAILURE"
            fi 
        else
            echo "SUCCESS"
        fi

    else
        strError="FAILURE"
        strError="$strError\nInvalid Input Set:"
        strError="$strError\nPalantir RID:\t$strRID"
        strError="$strError\nUser Token:\t$strUserToken"
        strError="$strError\nBranch Name:\t$strBranchName"
        strError="$strError\n$0\n"
        echo "$strError"
    fi 
   
    

elif [ "$#" -eq 1 ] && [ "$strArg" = "-h" ] || [ "$strArg" = "-help" ]
then
echo '
#################################################################
About This Script:
nd_br: nidap branch: creates a branch on a dataset if it does not exist;

#################################################################

NOTE: options and associated input, if any, may be passed
         in any order;

Usage:
sh nd_br.sh -r (-rid) "palantir_dataset_rid"
            -b (-branch_name) "myNewBranch"
            -u (-user_token) "user_token
            -d (-domain) "domain_url"
               [default:https://nidap.nih.gov]
............Creates branch o

sh nd_br.sh -h (-help)
............displays function help;

#################################################################

Returns:
string: SUCCESS or FAILURE
'

else
    echo "FAILURE\nUnrecognized Input\nUsage: sh nd_br.sh -h\n$0"
fi