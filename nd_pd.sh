#!/bin/bash

##################################################################
#
# About This Script:
# nd_pd: Palantir download; copies file from Palantir to local
#           system;
#
##################################################################
#
# NOTE: options and associated input, if any, may be passed
#          in any order;
#
# Usage:
# sh nd_pd.sh -tf (-to_file) "to_local_file_name.extension"
#             -fr (-from_rid) "from_palantir_object_rid"
#             -fp (-from_path) "from_palantir_object_path"
#             -u (-user_token) "user_token"
#             -d (-domain) "domain_url"
#                [default:https://nidap.nih.gov]
# ............downloads Palantir from_path as local to_file;
#
# sh nd_pd.sh -h (-help)
# ............displays function help;
#
# sh nd_pd.sh -t (-test)
# ............test function;
#
##################################################################
#
# Returns:
# string: SUCCESS or FAILURE
#
##################################################################

# temp code to fetch ttest objects/parameters
strTestToFile="/mnt/c/Users/stephendh.ctr/Documents/GitHub/NIDAP_utilities/NIDAP_utilities/download_test.txt"
strTestFromRID="ri.foundry.main.dataset.385838db-254c-4cf9-aafd-32c0f41cf90c"
strTestFromPath="palantir_test.txt"
strTestUserToken=`cat /mnt/c/Users/stephendh.ctr/Documents/GitHub/NIDAP_utilities/NIDAP_utilities/sdh.txt`
strTestDomain="https://nidap.nih.gov"

strDefaultDomain="https://nidap.nih.gov"

# execute request
strArg=`echo "$1" | awk -va="$1" '{print tolower(a)}'`
if [ "$#" -gt 1 ] && [ "$strArg" != "-h" ] && [ "$strArg" != "-help" ] && [ "$strArg" != "-t" ] && [ "$strArg" != "-test" ]
then
    strToFile=""
    strFromRID=""
    strFromPath=""
    strUserToken=""
    strDomain=""    
    while [ $# -ne 0 ]
    do
        strArg=`echo "$1" | awk -va="$1" '{print tolower(a)}'`
        if [ "$strArg" = "-tf" ] || [ "$strArg" = "-to_file" ]
        then
            shift
            strToFile="$1"
        elif [ "$strArg" = "-fr" ] || [ "$strArg" = "-from_rid" ]
        then
            shift
            strFromRID="$1"
        elif [ "$strArg" = "-fp" ] || [ "$strArg" = "-from_path" ]
        then
            shift
            strFromPath="$1"
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
    
    if [ "$strToFile" != "" ] && [ "$strFromRID" != "" ] && [ "$strFromPath" != "" ] && [ "$strUserToken" != "" ] && [ "$strDomain" != "" ]
    then
        #echo "Downloading file: [$strToRID]:[$strToPath] to [$strToFile]...";
        echo ""
        strPost=$(curl \
            -H "Authorization: Bearer $strUserToken" \
            "$strDomain/api/v1/datasets/$strFromRID/files/$strFromPath/content?preview=true")
        if [ "$strPost" != "" ]
        then
            #echo "\n[$strPost]\n"
            echo "$strPost">"$strToFile"
        else
            echo "WARNING\nDownload file is empty.\n$0"
        fi
        echo ""
    else
        strError="FAILURE"
        strError="$strError\nInvalid Input Set:"
        strError="$strError\nLocal To File:\t$strToFile"
        strError="$strError\nPalantir From RID:\t$strFromRID"
        strError="$strError\nPalantir From Path:\t$strFromPath"
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
    echo "# nd_pd: Palantir download; copies file from Palantir to local"
    echo "#           system;"
    echo "#"
    echo "##################################################################"
    echo "#"
    echo "# NOTE: options and associated input, if any, may be passed"
    echo "#          in any order;"
    echo "#"
    echo "# Usage:"
    echo "# sh nd_pd.sh -tf (-to_file) \"to_local_file_name.extension\""
    echo "#             -fr (-from_rid) \"from_palantir_object_rid\""
    echo "#             -fp (-from_path) \"from_palantir_object_path\""
    echo "#             -u (-user_token) \"user_token\""
    echo "#             -d (-domain) \"domain_url\""
    echo "#                [default:https://nidap.nih.gov]"
    echo "# ............downloads Palantir from_path as local to_file;"
    echo "#"
    echo "# sh nd_pd.sh -h (-help)"
    echo "# ............displays function help;"
    echo "#"
    echo "# sh nd_pd.sh -t (-test)"
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
    strToFile="$strTestToFile"
    strFromRID="$strTestFromRID"
    strFromPath="$strTestFromPath"
    strUserToken="$strTestUserToken"
    strDomain="$strTestDomain"
    #echo "Downloading file: [$strToRID]:[$strToPath] to [$strToFile]...";
    strPost=$(curl \
	    -H "Authorization: Bearer $strUserToken" \
	    "$strDomain/api/v1/datasets/$strFromRID/files/$strFromPath/content?preview=true")
    if [ "$strPost" != "" ]
    then
        echo "\n[$strPost]\n"
        echo "$strPost">"$strToFile"
    else
        echo "WARNING\nDownload file is empty.\n$0"
    fi
else
    echo "FAILURE\nUnrecognized Input\nUsage: sh nd_ls.sh -h\n$0"
fi
