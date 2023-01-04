#!/bin/bash

# Version 0.1 Use to upload single template pipeline result to NIDAP

set -e

key=$1

# Input arguements
folder_path=$2

# output_dataset_rid=$2

files_to_be_uploaded_list=$4
echo "File list: $files_to_be_uploaded_list"

names_to_be_uploaded_list=$5
echo "Name list: $names_to_be_uploaded_list"

# V 0.1 version does not allow new dataset to be created to avoid confusion

create_new_dataset="True"

dataset_name=$3

#logic_path=$folder_path"/"$dataset_name

# Processing

time_stamp_branch=$(date +%Y_%m_%d_%H_%M_%S)



function get_err_reponse {
  err_response=""
  err_response=$(grep -Po '"errorCode":.*?[^\\]",' $1 | \
            tr -d '"errorCode":' | \
            tr -d ',')
}

function get_rid_reponse {
  rid=""
  rid=$(grep -Po '"rid":.*?[^\\]",' $1 | \
            sed s/'"rid":'// | sed s/'"'// | sed s/'",'//)
}

function get_trasaction_rid_reponse {
  tranrid=""
  tranrid=$(grep -Po '"rid":.*?[^\\]",' $1 | \
            sed s/'"rid":'// | sed s/'"'// | sed s/'",'//)
}

# Upload file function
function upload_file {
  urlpath=""
  urlpath="https://nidap.nih.gov/foundry-data-proxy/api/dataproxy/datasets/$rid/transactions/$tranrid/putFile?logicalPath=$2"
  echo $urlpath
  
  upload_file_response=$(curl -X POST -H "Authorization: Bearer $key" \
                              $urlpath \
                              --data-binary "@$1");
                              
  current_log=File_upload_$2.log
  
  echo $upload_file_response > $current_log
  echo $upload_file_reponse >> master_job_log.log
  
  get_err_reponse $current_log
  
  if [ ! -z $err_response ]
    then
      echo "Error occured when uploading file: $2"
      echo $err_response
#      exit 1
  else
    echo "File $1 uploaded."
  fi
  
  rm $current_log
  
}

function commit_transaction {
  commit_transaction_response=$(curl --request POST "https://nidap.nih.gov/foundry-catalog/api/catalog/datasets/$rid/transactions/$tranrid/commit" \
                            -H "Authorization: Bearer $key" \
                            -H "Content-Type: application/json" \
                            -d '{"record":{}}')
                            
  echo $commit_transaction_response > Transaction_commit.log
  echo $commit_transaction_response >> master_job_log.log
  
  get_err_reponse Transaction_commit.log
  
  if [ ! -z $err_response ]
    then
      echo "Error occured when commiting transaction: "
      echo $err_response
      exit 1
  else
    echo "Transaction commited."
    echo $tranrid
  fi
  
  rm Transaction_commit.log
}

#Create upload log
# if [ "$create_new_dataset" = "True" ]
#   then
#     echo "Upload job at $time_stamp_branch to create dataset $dataset_name in $folder_path" > master_job_log.log
#   else
#     echo "Upload job at $time_stamp_branch to dataset $output_dataset_rid in $time_stamp_branch branch" > master_job_log.log
# fi

# Create dataset
if [ "$create_new_dataset" = "True" ]
  then
    create_dataset_response=$(curl --request POST 'https://nidap.nih.gov/foundry-catalog/api/catalog/datasets' \
                                -H "Authorization: Bearer $key" \
                                -H "Content-Type: application/json" \
                                -d '{"path":"'"$logic_path"'"}')
                                
    echo $create_dataset_response > Dataset_creation.log
    echo $create_dataset_response >> master_job_log.log
                                
    get_err_reponse Dataset_creation.log
    
    if [ ! -z $err_response ]
      then
        echo "Error occured when creating dataset: "
        echo $err_response
        exit 1
    else
      echo "Dataset created."
      get_rid_reponse Dataset_creation.log
      echo $rid
      branch_name="master"
    fi
    
    rm Dataset_creation.log
    
else
    echo "Output dataset selected."
    rid=$output_dataset_rid
    echo $rid
    branch_name=$time_stamp_branch
fi

# Create branch
if [ "$create_new_dataset" = "True" ]
  then
    branch_name="master"
fi

# check_master_branch=$(curl --request GET "https://nidap.nih.gov/foundry-catalog/api/catalog/datasets/$rid/branches" \
#                             -H "Authorization: Bearer $key" \
#                             -H "Content-Type: application/json" \
#                             -d '{}')

echo "Create branch $branch_name now."

branch_create_url="https://nidap.nih.gov/foundry-catalog/api/catalog/datasets/$rid/branchesUnrestricted2/$branch_name"

echo $branch_create_url >> master_job_log.log

create_branch_response=$(curl --request POST $branch_create_url \
                            -H "Authorization: Bearer $key" \
                            -H "Content-Type: application/json" \
                            -d '{}')

echo $create_branch_response > Branch_creation.log
echo $create_branch_response >> master_job_log.log

get_err_reponse Branch_creation.log

if [ ! -z $err_response ]
  then
    echo "Error occured when creating branch: "
    echo $err_response
    exit 1
else
  echo "Branch: $branch_name created."
fi

rm Branch_creation.log

# Create Transaction
create_transaction_response=$(curl --request POST "https://nidap.nih.gov/foundry-catalog/api/catalog/datasets/$rid/transactions" \
                            -H "Authorization: Bearer $key" \
                            -H "Content-Type: application/json" \
                            -d '{"branchId":"'"$branch_name"'"}')

echo $create_transaction_response > Transaction_creation.log
echo $create_transaction_response >> master_job_log.log

get_err_reponse Transaction_creation.log

if [ ! -z $err_response ]
  then
    echo "Error occured when creating transaction: "
    echo $err_response
    exit 1
else
  get_trasaction_rid_reponse Transaction_creation.log
  echo "Transaction created."
  echo $tranrid
fi

rm Transaction_creation.log

# Upload files

for i in ${!files_to_be_uploaded_list[@]}; do
  echo "Uploading ${names_to_be_uploaded_list[$i]}"
  upload_file ${files_to_be_uploaded_list[$i]} ${names_to_be_uploaded_list[$i]}
done

# Commit transaction

commit_transaction

cat master_job_log.log
rm master_job_log.log
