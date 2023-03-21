#!/bin/bash

##################################################################
#
# About This Script:
# nd_pd: Palantir upload; copies file from local to Palantir
#           system;
#
##################################################################
#
# NOTE: options and associated input, if any, may be passed
#          in any order;
#
# Usage:
# sh nd_pu.sh -ff (-from_file) "from_local_file_name.extension"
#             -tr (-to_rid) "to_palantir_object_rid"
#             -tp (-to_path) "to_palantir_object_path"
#             -u (-user_token) "user_token"
#             -d (-domain) "domain_url"
#                [default:https://nidap.nih.gov]
#             -b (-branch_name) "myBranch"
                # [default: master]
# ............uploads local from_file as Palantir to_path;
#
# sh nd_pu.sh -h (-help)
# ............displays function help;
#
# sh nd_pu.sh -t (-test)
# ............test function;
#
##################################################################
#
# Returns:
# string: SUCCESS or FAILURE
#
##################################################################

# temp code to fetch ttest objects/parameters
strTestFromFile="palantir_test.txt"
strTestToRID="ri.foundry.main.dataset.385838db-254c-4cf9-aafd-32c0f41cf90c"
strTestToPath="palantir_test.txt"
strTestUserToken=`cat /mnt/c/Users/stephendh.ctr/Documents/GitHub/NIDAP_utilities/NIDAP_utilities/sdh.txt`
strTestDomain="https://nidap.nih.gov"

# default domain
strDefaultDomain="https://nidap.nih.gov"

# execute request
strArg=`echo "$1" | awk -va="$1" '{print tolower(a)}'`
if [ "$#" -gt 1 ] && [ "$strArg" != "-h" ] && [ "$strArg" != "-help" ] && [ "$strArg" != "-t" ] && [ "$strArg" != "-test" ]
then
    strFromFile=""
    strToRID=""
    strToPath="/"
    strUserToken=""
    strDomain=""
    strBranchName=""
    while [ $# -ne 0 ]
    do
        strArg=`echo "$1" | awk -va="$1" '{print tolower(a)}'`
        if [ "$strArg" = "-ff" ] || [ "$strArg" = "-from_file" ]
        then
            shift
            strFromFile="$1"
        elif [ "$strArg" = "-tr" ] || [ "$strArg" = "-to_rid" ]
        then
            shift
            strToRID="$1"
        elif [ "$strArg" = "-tp" ] || [ "$strArg" = "-to_path" ]
        then
            shift
            strToPath="$1"
        elif [ "$strArg" = "-u" ] || [ "$strArg" = "-user_token" ]
        then
            shift
            strUserToken="$1"
        elif [ "$strArg" = "-d" ] || [ "$strArg" = "-domain" ]
        then
            shift
            strDomain="$1"
        elif [ "$strArg" = "-b" ] || [ "$strArg" = "-branch_name" ]
        then
            shift
            strBranchName="$1"
        fi
        shift
    done

    if [ "$strDomain" = "" ]
    then
        strDomain="$strDefaultDomain"
    fi

    if [ "$strFromFile" != "" ] && [ "$strToRID" != "" ] && [ "$strToPath" != "" ] && [ "$strUserToken" != "" ] && [ "$strDomain" != "" ]
    then
        echo ""
        #echo "Uploading file: [$strFromFile] to [$strToRID]:[$strToPath]...";
        if [ "$strBranchName" == "" ] 
        then
            strPost=$(curl -X POST \
                -H "Content-type: application/octet-stream" \
                -H "Authorization: Bearer $strUserToken" \
                "$strDomain/api/v1/datasets/$strToRID/files:upload?filePath=$strToPath" \
                --data-binary '@'$strFromFile)
        else
            strPost=$(curl -X POST \
                -H "Content-type: application/octet-stream" \
                -H "Authorization: Bearer $strUserToken" \
                "$strDomain/api/v1/datasets/$strToRID/files:upload?filePath=$strToPath&branchId=$strBranchName" \
                --data-binary '@'$strFromFile)
        fi
        echo "$strPost"
        # TODO: determine error conditions: first line begins "errorCode"
        # if ...
        # then
        #   parse json result
        # else
        #   echo "FAILURE\n..."
        # fi
        echo ""
    else
        strError="FAILURE"
        strError="$strError\nInvalid Input Set:"
        strError="$strError\nLocal From File:\t$strFromFile"
        strError="$strError\nPalantir To RID:\t$strToRID"
        strError="$strError\nPalantir To Path:\t$strToPath"
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
    echo "# nd_pu: Palantir upload; copies file from local to Palantir"
    echo "#           system;"
    echo "#"
    echo "##################################################################"
    echo "#"
    echo "# NOTE: options and associated input, if any, may be passed"
    echo "#          in any order;"
    echo "#"
    echo "# Usage:"
    echo "# sh nd_pu.sh -ff (-from_file) \"from_local_file_name.extension\""
    echo "#             -tr (-to_rid) \"to_palantir_object_rid\""
    echo "#             -tp (-to_path) \"to_palantir_object_path\""
    echo "#             -u (-user_token) \"user_token\""
    echo "#             -d (-domain) \"domain_url\""
    echo "#                [default:https://nidap.nih.gov]"
    echo "# ............uploads local from_file as Palantir to_path;"
    echo "#"
    echo "# sh nd_pu.sh -h (-help)"
    echo "# ............displays function help;"
    echo "#"
    echo "# sh nd_pu.sh -t (-test)"
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
    strFromFile="$strTestFromFile"
    strToRID="$strTestToRID"
    strToPath="$strTestToPath"
    strUserToken="$strTestUserToken"
    strDomain="$strTestDomain"
    strTimeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
    echo "$strTimeStamp">"$strFromFile"
    strPost=$(curl -X POST \
	    -H "Content-type: application/octet-stream" \
	    -H "Authorization: Bearer $strUserToken" \
	    "$strDomain/api/v1/datasets/$strToRID/files:upload?filePath=$strToPath&preview=true" \
	    --data-binary '@'$strTestFromFile)
    echo "\n$strPost\n"
    # TODO: determine error conditions
    # if ...
    # then
    #   parse json result
    # else
    #   echo "FAILURE\n..."
    # fi
else
    echo "FAILURE\nUnrecognized Input\nUsage: sh nd_ls.sh -h\n$0"
fi
