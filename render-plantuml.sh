#!/bin/sh

# parameters:
#   $1: input directory
#   $2: output directory

echo "Hello World!"

# echo "Files list:" > $2/files.txt
# ls -a $1 >> $2/files.txt
# cat $2/files.txt

echo "output dir: $2"

echo "input  dir: $1"
#ls -R -a $1
#du -a $1
files=$(find $1 -name '*' -type f -print)
echo "files: $files"

echo "For loop ahead:"
for file in $files
do
    input_filepath=$file
    output_filepath=$(echo $file | sed -e "s@^$1@$2@")
    echo "input  filepath: $input_filepath"
    echo "output filepath: $output_filepath"
    java -jar plantuml.jar -o "$output_filepath" "$input_filepath"
    #echo $file
    #echo $(echo $file | sed -e "s@^$1@$2@")
done

echo "$(date +%T) Hello World!" >> $2/hello.txt

#java -jar plantuml.jar -r -o "$2" "$1"