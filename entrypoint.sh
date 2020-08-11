#!/bin/sh

# Store paramenters:
#ARTIFACTS_REPO=$1
#ARTIFACTS_DIR=$2

# Set paths inside Docker container:
local_input_dir=$INPUT_DIR
local_output_dir="output"

# artifacts_repo="git@github.com:social-gardeners/pot-pourri-pro.wiki.git"
artifacts_repo="https://${WIKI_TOKEN}@github.com/social-gardeners/pot-pourri-pro.wiki.git"
artifacts_upload_dir=$OUTPUT_DIR

# Print debug info:
echo "all args: $0"
echo ""
echo "local_input_dir:  $local_input_dir"
echo "local_output_dir: $local_output_dir"
echo "artifacts_repo:       $artifacts_repo"
echo "artifacts_upload_dir: $artifacts_upload_dir"
echo ""
echo "WIKI_TOKEN: $WIKI_TOKEN"
echo "INPUT_DIR:  $INPUT_DIR"
echo "OUTPUT_DIR: $OUTPUT_DIR"
echo ""
echo "GITHUB_WORKSPACE: $GITHUB_WORKSPACE"
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

# Run PlantUML for each file path:
for file in $input_files
do
    input_filepath=$file
    output_filepath=$(dirname $(echo $file | sed -e "s@^${local_input_dir}@${local_output_dir}@"))

    echo "processing '$input_filepath' --> '$output_filepath'"
    java -jar plantuml.jar -output "${GITHUB_WORKSPACE}/${output_filepath}" "${GITHUB_WORKSPACE}/${input_filepath}"
done
echo "---"

# echo "root directory contents:"
# ls -la 

echo "output dir contents:"
ls -la "$local_output_dir"

echo "Cloning $artifacts_repo"
git clone $artifacts_repo "${GITHUB_WORKSPACE}/artifacts_repo"

echo "DEBUG: cloned wiki repo directory"
ls -la "${GITHUB_WORKSPACE}/artifacts_repo"

mkdir -p "${GITHUB_WORKSPACE}/artifacts_repo/${artifacts_upload_dir}"

echo "DEBUG: upload directory before copy:"
ls -la "${GITHUB_WORKSPACE}/artifacts_repo/${artifacts_upload_dir}"

echo "Moving generated files to $artifacts_upload_dir"
mkdir -p "${GITHUB_WORKSPACE}/${artifacts_upload_dir}"
yes | cp --recursive --force "${GITHUB_WORKSPACE}/${local_output_dir}/." "${GITHUB_WORKSPACE}/artifacts_repo/${artifacts_upload_dir}"

echo "DEBUG: upload directory after copy:"
ls -la "${GITHUB_WORKSPACE}/artifacts_repo/${artifacts_upload_dir}"

# Set git user settings (this is needed to commit and push):
git config user.email "github-action@users.noreply.github.com"
git config user.name "GitHub Action 'Render PlantUML'"

echo "Commit artifacts:"
cd "${GITHUB_WORKSPACE}/artifacts_repo"
git commit -am"Auto-generated PlantUML diagrams"

echo "Push artifacts:"
git push

# Print debug info:
echo "done"
