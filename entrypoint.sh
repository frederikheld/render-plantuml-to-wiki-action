#!/bin/sh

# Store paramenters:
#ARTIFACTS_REPO=$1
#ARTIFACTS_DIR=$2

# Set paths inside Docker container:
input_dir="/input"
output_dir="/output"

# Print debug info:
echo "all args: $*"
echo "output dir: $output_dir"
echo "input  dir: $input_dir"
echo "ARTIFACTS_REPO: $ARTIFACTS_REPO"
echo "ARTIFACTS_DIR:  $ARTIFACTS_DIR"
echo "GITHUB_TOKEN:   $GITHUB_TOKEN"
echo "arg_1: $1"
echo "arg_2: $2"
echo "---"

# Get paths to all files in input directory:
input_files=$(find $input_dir -type f -name '*' -print)
echo "files found:\n$input_files"
echo "---"

exit 0 # DEBUG

# Run PlantUML for each file path:
for file in $input_files
do
    input_filepath=$file
    output_filepath=$(dirname $(echo $file | sed -e "s@^$input_dir@$output_dir@"))

    echo "processing '$input_filepath' --> '$output_filepath'"
    java -jar plantuml.jar -output "$output_filepath" "$input_filepath"
done
echo "---"

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
