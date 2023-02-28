#!/bin/bash

##################################################################
#
# About This Script:
# nd_rm: implements the BASH rm command with options for local
#           or Palantir target system;
# NOTE: requires curl, jq;
#
##################################################################
#
# NOTE: options and associated input, if any, may be passed
#          in any order;
#
# Usage:
# sh nd_rm.sh -f (-file) "local_file_path_name.extension"
# ............deletes requested file(s) from local system;
#
# sh nd_rm.sh -r (-rid) "palantir_dataset_rid"
#             -p (-path) "palantir_file_path_name.extension"
#             -u (-user_token) "user_token"
#             -d (-domain) "domain_url"
#                [default:https://nidap.nih.gov]
# ............deletes requested file(s) from Palantir system;
#
# sh nd_rm.sh -h (-help)
# ............displays function help;
#
# sh nd_rm.sh -t (-test)
# ............tests functionality (ignores file pathname provided;
#             deletes temporary test file);
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
    strFile=""
    strRID=""
    strPath=""
    strUserToken=""
    strDomain=""
    while [ $# -ne 0 ]
    do
        strArg=`echo "$1" | awk -va="$1" '{print tolower(a)}'`
        if [ "$strArg" = "-f" ] || [ "$strArg" = "-file" ]
        then
            shift
            strFile="$1"
        elif [ "$strArg" = "-r" ] || [ "$strArg" = "-rid" ]
        then
            shift
            strRID="$1"
        elif [ "$strArg" = "-p" ] || [ "$strArg" = "-path" ]
        then
            shift
            strPath="$1"
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

    # local remove
    if [ "$strFile" != "" ]
    then
        #echo "Deleting local file(s): [$strFile]...";
        if rm "$strFile"
        then
            echo "SUCCESS\n"
        else
            echo "FAILURE\n$?"
        fi
    # Palantir remove
    elif [ "$strRID" != "" ] && [ "$strPath" != "" ] && [ "$strUserToken" != "" ] && [ "$strDomain" != "" ]
    then
        #echo "Deleting Palantir dataset [$strRID] file(s): [$strPath]...";
        strPost=$(curl -X DELETE \
                    "$strDomain/foundry-catalog/api/catalog/datasets/$strRID/files/$strPath?preview=true" \
                    -H "Authorization: Bearer $strUserToken")
        if [ "$strPost" != "" ]
        then
            sh ./nd_json_parser.sh "$strPost"
        else
            echo "WARNING\nResponse is empty.\n$0"
        fi
    else
        strError="FAILURE"
        strError="$strError\nInvalid Input Set:"
        strError="$strError\nLocal File:\t$strFile"
        strError="$strError\nObject RID:\t$strRID"
        strError="$strError\nObject Path:\t$strPath"
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
    echo "# nd_rm: implements the BASH rm command with options for local"
    echo "#           or Palantir target system;"
    echo "#"
    echo "##################################################################"
    echo "#"
    echo "# NOTE: options and associated input, if any, may be passed"
    echo "#          in any order;"
    echo "#"
    echo "# Usage:"
    echo "# sh nd_rm.sh -f (-file) \"local_file_path_name.extension\""
    echo "# ............deletes requested file(s) from local system;"
    echo "#"
    echo "# sh nd_rm.sh -r (-rid) \"rid_of_dataset\""
    echo "#             -p (-path) \"palantir_file_path_name.extension\""
    echo "#             -u (-user_token) \"user_token\""
    echo "#             -d (-domain) \"domain_url\""
    echo "#                [default:https://nidap.nih.gov]"
    echo "# ............deletes requested file(s) from Palantir system;"
    echo "#"
    echo "# sh nd_rm.sh -h (-help)"
    echo "# ............displays function help;"
    echo "#"
    echo "# sh nd_rm.sh -t (-test)"
    echo "# ............tests functionality (ignores file pathname provided;"
    echo "#             deletes temporary test file);"
    echo "#"
    echo "##################################################################"
    echo "#"
    echo "# Returns:"
    echo "# nothing"
    echo "#"
    echo "##################################################################"
# test routine
elif [ "$#" -eq 1 ] && [ "$strArg" = "-t" ] || [ "$strArg" = "-test" ]
then
    touch "test.___"
    if test -f "test.___"
    then
        rm "test.___"
        if test -f "test.___"
        then
        echo "SUCCESS\n"
        else
            echo "FAILURE\n$?"
        fi
    else
        echo "FAILURE\n$?"
    fi
else
    echo "FAILURE\nUnrecognized Input\nUsage: sh nd_rm.sh -h\n$0"
fi
