#!/bin/sh

# parameters:
#   $1: input directory
#   $2: output directory

echo "output dir:  $2"
echo "input  dir:  $1"
echo "---"

files=$(find $1 -type f -name '*' -print)
echo "files found:\n$files"
echo "---"

for file in $files
do
    input_filepath=$file
    output_filepath=$(dirname $(echo $file | sed -e "s@^$1@$2@"))
    echo "processing '$input_filepath' --> '$output_filepath'"
    java -jar plantuml.jar -nbthread auto -output "$output_filepath" "$input_filepath"
done
echo "---"

echo "done"
