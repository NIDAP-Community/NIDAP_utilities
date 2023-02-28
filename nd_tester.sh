#!/bin/bash

strFolder="."
strRID="ri.foundry.main.dataset.385838db-254c-4cf9-aafd-32c0f41cf90c"
strPath="palantir_test_from.txt"
strFile="palantir_test.txt"
strFromFile="palantir_test_from.txt"
strToFile="palantir_test_to.txt"
strFromRID="ri.foundry.main.dataset.385838db-254c-4cf9-aafd-32c0f41cf90c"
strFromPath="palantir_test_from.txt"
strToRID="ri.foundry.main.dataset.385838db-254c-4cf9-aafd-32c0f41cf90c"
strToPath="palantir_test_to.txt"
strUserToken=`cat /mnt/c/Users/stephendh.ctr/Documents/GitHub/NIDAP_utilities/NIDAP_utilities/sdh.txt`
strDomain="https://nidap.nih.gov"

echo "This is a test of the system.">"$strFile"
echo "This is a test of the system.">"$strFromFile"
echo "This is a test of the system.">"$strToFile"

# list tests
echo "\n========================================================================================\nPerforming List Tests:\n"
# local test
echo "\n++++++++++++++++++++++++++++++++++++++++\nLocal Test\n++++++++++++++++++++++++++++++++++++++++\n"
sh ./nd_ls.sh -f "$strFolder"
echo "\n++++++++++++++++++++++++++++++++++++++++\nPalantir Test\n++++++++++++++++++++++++++++++++++++++++\n"
# palantir test
sh ./nd_ls.sh -r "$strRID" -u "$strUserToken" -d "$strDomain"

# copy tests
echo "\n========================================================================================\nPerforming Copy Tests:\n"
# local test
echo "\n++++++++++++++++++++++++++++++++++++++++\nLocal Test\n++++++++++++++++++++++++++++++++++++++++\n"
sh ./nd_cp.sh -ff "$strFromFile" -tf "$strToFile"
# palantir test
echo "\n++++++++++++++++++++++++++++++++++++++++\nPalantir Test\n++++++++++++++++++++++++++++++++++++++++\n"
sh ./nd_cp.sh -fr "$strFromRID" -fp "$strFromPath" -tr "$strToRID" -tp "$strToPath" -u "$strUserToken" -d "$strDomain"
# local to palantir test
echo "\n++++++++++++++++++++++++++++++++++++++++\nLocal to Palantir Test\n++++++++++++++++++++++++++++++++++++++++\n"
sh ./nd_cp.sh -ff "$strFromFile" -tr "$strToRID" -tp "$strToPath" -u "$strUserToken" -d "$strDomain"
# palantir to local test
echo "\n++++++++++++++++++++++++++++++++++++++++\nPalantir to Local Test\n++++++++++++++++++++++++++++++++++++++++\n"
sh ./nd_cp.sh -fr "$strFromRID" -fp "$strFromPath" -tf "$strToFile" -u "$strUserToken" -d "$strDomain"

echo "This is a test of the system.">"$strFile"
echo "This is a test of the system.">"$strFromFile"
echo "This is a test of the system.">"$strToFile"

# move tests
echo "\n========================================================================================\nPerforming Move Tests:\n"
# local test
echo "\n++++++++++++++++++++++++++++++++++++++++\nLocal Test\n++++++++++++++++++++++++++++++++++++++++\n"
sh ./nd_mv.sh -ff "$strFromFile" -tf "$strToFile"
# palantir test
echo "\n++++++++++++++++++++++++++++++++++++++++\nPalantir Test\n++++++++++++++++++++++++++++++++++++++++\n"
sh ./nd_mv.sh -fr "$strFromRID" -fp "$strFromPath" -tr "$strToRID" -tp "$strToPath" -u "$strUserToken" -d "$strDomain"
# local to palantir test
echo "\n++++++++++++++++++++++++++++++++++++++++\nLocal to Palantir Test\n++++++++++++++++++++++++++++++++++++++++\n"
echo "This is a test of the system.">"$strFromFile"
sh ./nd_mv.sh -ff "$strFromFile" -tr "$strToRID" -tp "$strToPath" -u "$strUserToken" -d "$strDomain"
# palantir to local test
echo "\n++++++++++++++++++++++++++++++++++++++++\nPalantir to Local Test\n++++++++++++++++++++++++++++++++++++++++\n"
sh ./nd_mv.sh -fr "$strFromRID" -fp "$strFromPath" -tf "$strToFile" -u "$strUserToken" -d "$strDomain"

echo "This is a test of the system.">"$strFile"
echo "This is a test of the system.">"$strFromFile"
echo "This is a test of the system.">"$strToFile"

# remove tests
echo "\n========================================================================================\nPerforming Remove Tests:\n"
# local test
echo "\n++++++++++++++++++++++++++++++++++++++++\nLocal Test\n++++++++++++++++++++++++++++++++++++++++\n"
sh ./nd_rm.sh -f "$strFromFile"
# palantir test
echo "\n++++++++++++++++++++++++++++++++++++++++\nPalantir Test\n++++++++++++++++++++++++++++++++++++++++\n"
sh ./nd_rm.sh -r "$strRID" -p "$strPath" -u "$strUserToken" -d "$strDomain"

echo "This is a test of the system.">"$strFile"
echo "This is a test of the system.">"$strFromFile"
echo "This is a test of the system.">"$strToFile"

rm "$strFile"
rm "$strFromFile"
rm "$strToFile"
