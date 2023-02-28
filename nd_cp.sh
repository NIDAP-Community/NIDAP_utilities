#!/bin/bash

##################################################################
#
# About This Script:
# nd_cp: implements the BA/bin/bash cp command with options for local
#           and/or Palantir target system;
# NOTE: requires curl, jq;
#
##################################################################
#
# NOTE: options and associated input, if any, may be passed
#          in any order;
#
# Usage:
# /bin/bash nd_cp./bin/bash -ff (-from_file) "from_local_file_name.extension"
#             -tf (-to_file) "to_local_file_name.extension"
#             -fr (-from_rid) "from_palantir_object_rid"
#             -fp (-from_path) "from_palantir_object_path"
#             -tr (-to_rid) "to_palantir_object_rid"
#             -tp (-to_path) "to_palantir_object_path"
#             -bp (-base_path)
#             -u (-user_token) "user_token"
#             -d (-domain) "domain_url"
#                [default:https://nidap.nih.gov]
# ............copies from_file/_path as to_file/_path; direction
#             determined by input; e.g., providing -ff and -tf
#             results in local copy, providing -fr,-fp, -tr, -tp,
#             and -u results in Palantir copy, providing combin-
#             ations produce intuitive results; i.e., providing
#             -tf with -fr, -fp and -u copies from Palantir to
#             local system, while -ff with -tr, -tp and -u copies
#             from local system to Palantir;
#
# /bin/bash nd_cp./bin/bash -h (-help)
# ............displays function help;
#
# /bin/bash nd_cp./bin/bash -t (-test)
# ............test function;
#
##################################################################
#
# Returns:
# string: SUCCESS or FAILURE
#
##################################################################

# execute request
strCheck=`echo "$1" | awk -va="$1" '{print tolower(a)}'`
if [ "$#" -gt 1 ] && [ "$strCheck" != "-h" ] && [ "$strCheck" != "-help" ] && [ "$strCheck" != "-t" ] && [ "$strCheck" != "-test" ]
then
    strFromFile=""
    strToFile=""
    strFromRID=""
    strFromPath=""
    strToRID=""
    strToPath=""
    strUserToken=""
    strDomain=""
    while [ $# -ne 0 ]
    do
        strArg=`echo "$1" | awk -va="$1" '{print tolower(a)}'`
        if [ "$strArg" = "-ff" ] || [ "$strArg" = "-from_file" ]
        then
            shift
            strFromFile="$1"
        elif [ "$strArg" = "-tf" ] || [ "$strArg" = "-to_file" ]
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
        fi
        shift
    done

    strTimeStamp=$(date '+%Y-%m-%d %H:%M:%S')
    strWorkingDirectory=$(pwd)
    strTempFile="$strWorkingDirectory/temp/$strTimeStamp.___"

    # local copy
    if [ "$strFromFile" != "" ] && [ "$strToFile" != "" ]
    then
        #echo "Copying local file: [$strFromFile] to [$strToFile]...";
        if cp "$strFromFile" "$strToFile"
        then
            echo "SUCCESS\n"
        else
            echo "FAILURE\n$?"
        fi
    # palatir copy 
    elif [ "$strFromRID" != "" ] && [ "$strFromPath" != "" ] && [ "$strToRID" != "" ] && [ "$strToPath" != "" ] && [ "$strUserToken" != "" ] && [ "$strDomain" != "" ]
    then
        #echo "Copying file: [$strFromRID]:[$strFromPath] to [$strToRID]:[$strToPath]...";        
        strDownloadResult=/bin/bash ./nd_pd.sh -tf "$strTempFile" -fr "$strFromRID" -fp "$strFromPath" -u "$strUserToken" -d "$strDomain"
        if touch "$strTempFile"
        then
            strUploadResult=/bin/bash ./nd_pu.sh -ff "$strTempFile" -tr "$strToRID" -tp "$strToPath" -u "$strUserToken" -d "$strDomain"
            /bin/bash ./nd_json_parser.sh "$strDownloadResult"
            /bin/bash ./nd_json_parser.sh "$strUploadResult"
            rm "$strTempFile"
        else
            echo "FAILURE\n$?"
        fi
    # local to palatir copy (upload without local delete)
    elif [ "$strFromFile" != "" ] && [ "$strToRID" != "" ] && [ "$strToPath" != "" ] && [ "$strUserToken" != "" ] && [ "$strDomain" != "" ]
    then
        #echo "Copying file: [$strFromRID]:[$strFromPath] to [$strToRID]:[$strToPath]...";        
        strUploadResult=/bin/bash ./nd_pu.sh -ff "$strFromFile" -tr "$strToRID" -tp "$strToPath" -u "$strUserToken" -d "$strDomain"
        /bin/bash ./nd_json_parser.sh "$strUploadResult"
    # palatir to local copy (download without Palantir delete)
    elif [ "$strToFile" != "" ] && [ "$strFromRID" != "" ] && [ "$strFromPath" != "" ] && [ "$strUserToken" != "" ] && [ "$strDomain" != "" ]
    then
        #echo "Copying file: [$strFromRID]:[$strFromPath] to [$strToRID]:[$strToPath]...";        
        strDownloadResult=/bin/bash ./nd_pd.sh -tf "$strToFile" -fr "$strFromRID" -fp "$strFromPath" -u "$strUserToken" -d "$strDomain"
            /bin/bash ./nd_json_parser.sh "$strDownloadResult"
    else
        strError="FAILURE"
        strError="$strError\nInvalid Input Set:"
        strError="$strError\nLocal From File:\t$strFromFile"
        strError="$strError\nLocal To File:\t$strToFile"
        strError="$strError\nPalantir From RID:\t$strFromRID"
        strError="$strError\nPalantir From RID:\t$strFromRID"
        strError="$strError\nPalantir To RID:\t$strToRID"
        strError="$strError\nPalantir To Path:\t$strToPath"
        strError="$strError\nUser Token:\t$strUserToken"
        strError="$strError\nDomain:\t$strDomain"
        strError="$strError\n$0\n"
        echo "$strError"
    fi
# display help
elif [ "$#" -eq 1 ] && [ "$strCheck" = "-h" ] || [ "$strCheck" = "-help" ]
then
    echo "##################################################################"
    echo "#"
    echo "# About This Script:"
    echo "# nd_cp: implements the BA/bin/bash cp command with options for local"
    echo "#           and/or Palantir target system;"
    echo "#"
    echo "##################################################################"
    echo "#"
    echo "# NOTE: options and associated input, if any, may be passed"
    echo "#          in any order;"
    echo "#"
    echo "# Usage:"
    echo "# /bin/bash nd_cp./bin/bash -ff (-from_file) \"from_local_file_name.extension\""
    echo "#             -tf (-to_file) \"to_local_file_name.extension\""
    echo "#             -fr (-from_rid) \"from_palantir_object_rid\""
    echo "#             -fp (-from_path) \"from_palantir_object_path\""
    echo "#             -tr (-to_rid) \"to_palantir_object_rid\""
    echo "#             -tp (-to_path) \"to_palantir_object_path\""
    echo "#             -u (-user_token) \"user_token\""
    echo "#             -d (-domain) \"domain_url\""
    echo "#                [default:https://nidap.nih.gov]"
    echo "# ............copies from_file/_path as to_file/_path; direction"
    echo "#             determined by input; e.g., providing -ff and -tf"
    echo "#             results in local copy, providing -fr,-fp, -tr, -tp,"
    echo "#             and -u results in Palantir copy, providing combin-"
    echo "#             ations produce intuitive results; i.e., providing"
    echo "#             -tf with -fr, -fp and -u copies from Palantir to"
    echo "#             local system, while -ff with -tr, -tp and -u copies"
    echo "#             from local system to Palantir;"
    echo "#"
    echo "# /bin/bash nd_cp./bin/bash -h (-help)"
    echo "# ............displays function help;"
    echo "#"
    echo "# /bin/bash nd_cp./bin/bash -t (-test)"
    echo "# ............test function;"
    echo "#"
    echo "##################################################################"
    echo "#"
    echo "# Returns:"
    echo "# Contents of requested folder/dataset(s)"
    echo "#"
    echo "##################################################################"
# test routine
elif [ "$#" -eq 1 ] && [ "$strCheck" = "-t" ] || [ "$strCheck" = "-test" ]
then
    touch "test_original.___"
    if test -f "test_original.___"
    then
        cp -i "test_original.___" "test_new.___"
        if test -f "test_new.___"
        then
            echo "SUCCESS\n"
            rm "test_original.___"
            rm "test_new.___"
        else
            #echo "nd_cp: ERROR: failed to copy test file; verify file pathname and/or permissions."
            echo "FAILURE\n$?"
            rm "test_original.___"
        fi
    else
        echo "FAILURE\n$?"
    fi
else
    echo "FAILURE\nUnrecognized Input\nUsage: /bin/bash nd_cp./bin/bash -h\n$0"
fi
