#!/bin/bash

# Version 0.1 Download single file at a time

key=$1

dataset_rid=$2

transection_rid="$3"

file_name="$4"

output_file_name="$5"


file_url="https://nidap.nih.gov/foundry-data-proxy/api/dataproxy/datasets/$dataset_rid/transactions/$transection_rid/$file_name"

echo $file_url

get_message=$(curl  -X GET $file_url \
                    -o $output_file_name \
                    -H "Authorization: Bearer $key")

echo $get_message
