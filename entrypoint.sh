#!/bin/sh

# Store paramenters:
#ARTIFACTS_REPO=$1
#ARTIFACTS_DIR=$2

# Set paths inside Docker container:
local_input_dir=$INPUT_DIR
local_output_dir="output"
wiki_upload_dir=$OUTPUT_DIR

# Print debug info:
echo "all args: $0"
echo ""
echo "local_input_dir:  $local_input_dir"
echo "local_output_dir: $local_output_dir"
echo "wiki_upload_dir:  $wiki_upload_dir"
echo ""
echo "GITHUB_TOKEN:   $GITHUB_TOKEN"
echo "INPUT_DIR:      $INPUT_DIR"
echo "OUTPUT_DIR:     $OUTPUT_DIR"
echo "---"

echo "root directory contents:"
ls -la 

echo "input directory contents:"
ls -la "$local_input_dir"

# Get paths to all files in input directory:
input_files=$(find "$local_input_dir" -type f -name '*' -print)
echo "files found:\n$input_files"
echo "---"

# Download plantuml Java app:
wget --quiet -O plantuml.jar https://sourceforge.net/projects/plantuml/files/plantuml.1.2020.15.jar/download

# Prepare output dir:
mkdir -p "$local_output_dir"

# DEBUG:
echo "Hello World!" > "$local_output_dir/hello.txt"

# Run PlantUML for each file path:
for file in $input_files
do
    input_filepath=$file
    output_filepath=$(dirname $(echo $file | sed -e "s@^$local_input_dir@$local_output_dir@"))

    echo "processing '$input_filepath' --> '$output_filepath'"
    java -jar plantuml.jar -output "$output_filepath" "$input_filepath"
done
echo "---"

echo "root directory contents:"
ls -la 

echo "output dir contents:"
ls -la "$local_output_dir"

exit 0 # DEBUG

echo "Cloning $ARTIFACTS_REPO"
git clone $ARTIFACTS_REPO pushrepo

echo "DEBUG: directory before copy:"
ls -la ./pushrepo$ARTIFACTS_DIR

echo "Moving generated files to $ARTIFACTS_DIR"
mkdir -p $ARTIFACTS_DIR
yes | cp -rf $output_filepath ./pushrepo$ARTIFACTS_DIR

echo "DEBUG: directory after copy:"
ls -la ./pushrepo$ARTIFACTS_DIR

# Print debug info:
echo "done"
