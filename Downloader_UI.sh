#!/bin/bash

# User interface for using Download_from_NIDAP.sh 
# Author rui.he@nih.gov

# User's NIDAP Token
NIDAP_token=; 

# RID of target dataset
dataset_rid=; v

# RID of target transaction. Note this value may change for different files in a branch and among branches.
tranx_rid=; 

# Local directory to store files 
target_folder_path=; 

# File name on NIDAP including extension, can be a single filecan or a List of files, eg ("file1.ext" "file2.ext" ...) 
filename_on_NIDAP=; #

# File name on local including extension, can be a single filecan or a List of files, eg ("file1.ext" "file2.ext" ...) 
filename_on_local=;



#########################################################################
##################################### DO NOT CHANGE######################
#########################################################################

for i in ${!filename_on_NIDAP[@]}; do
  
  echo "------------------------------------------------------"
  echo "------------------------------------------------------"
  echo "Processing file $(($i+1))"
  echo "Downloading ${filename_on_NIDAP[$i]}"
  echo "to $target_folder_path/${filename_on_RSW[$i]}"
  
  source ./Download_from_NIDAP.sh $key \
          "$dataset_rid" \
          "$tranx_rid" \
          "${filename_on_NIDAP[$i]}" \
          "$target_folder_path/${filename_on_local[$i]}";
          
  echo "------------------------------------------------------"
  echo "------------------------------------------------------"
done


