#!/bin/bash

if [ "$1" != "" ]
then
    echo "$1" | jq -r 'to_entries[] | "\(.key): \t \(.value)"'
fi