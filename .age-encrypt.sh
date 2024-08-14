#!/bin/bash
# Takes one file path as input
# Outputs to a new file named `$1.enc`

input_file=$1
file_extension=${input_file##*.}
file_name=${input_file%%.*}
output_file="$file_name.enc.$file_extension"

sops --encrypt --age ${SOPS_AGE_RECIPIENTS} $input_file > $output_file