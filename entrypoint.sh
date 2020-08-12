#!/bin/sh

# Exit immediately if a command exits with a non-zero status:
set -e

# Set paths inside Docker container:
local_input_dir=$INPUT_DIR
local_output_dir="output"

# artifacts_repo="git@github.com:social-gardeners/pot-pourri-pro.wiki.git"
artifacts_repo="https://${WIKI_AUTH_TOKEN}@github.com/${GITHUB_REPOSITORY}.wiki.git"
artifacts_upload_dir=$OUTPUT_DIR

# Print debug info:
echo "DEBUG: all variables"
echo "> all args: $0"
echo ""
echo "> local_input_dir:  $local_input_dir"
echo "> local_output_dir: $local_output_dir"
echo "> artifacts_repo:       $artifacts_repo"
echo "> artifacts_upload_dir: $artifacts_upload_dir"
echo ""
echo "> WIKI_AUTH_TOKEN: $WIKI_AUTH_TOKEN"
echo "> INPUT_DIR:  $INPUT_DIR"
echo "> OUTPUT_DIR: $OUTPUT_DIR"
echo ""
echo "> GITHUB_REPOSITORY: $GITHUB_REPOSITORY"
echo "> GITHUB_WORKSPACE:  $GITHUB_WORKSPACE"
echo "> GITHUB_ACTOR:      $GITHUB_ACTOR"
echo "---"

# Set git user settings (this is needed to commit and push):
git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
# git config --global user.name "GitHub Action 'Render PlantUML'"
# git config --global user.email "github-action@users.noreply.github.com"

# Get paths to all files in input directory:

input_files=$(find "$local_input_dir" -type f -name '*' -print)

echo "---"

# Download PlantUML Java app:
echo "Downloading PlantUML Java app ..."
wget --quiet -O plantuml.jar https://sourceforge.net/projects/plantuml/files/plantuml.1.2020.15.jar/download

# Create output dir:
echo "Preparing output dir ..."
mkdir -p "$local_output_dir"

# Run PlantUML for each file path:
echo "Starting render process ..."
ORIGINAL_IFS="$IFS"
IFS='
'
for file in $input_files
do
    input_filepath=$file
    output_filepath=$(dirname $(echo $file | sed -e "s@^${local_input_dir}@${local_output_dir}@"))

    echo " > processing '$input_filepath'
    java -jar plantuml.jar -output "${GITHUB_WORKSPACE}/${output_filepath}" "${GITHUB_WORKSPACE}/${input_filepath}"
done
IFS="$ORIGINAL_IFS"
# source: https://unix.stackexchange.com/questions/9496/looping-through-files-with-spaces-in-the-names

echo "Generated files:"
ls -l "${GITHUB_WORKSPACE}/${output_filepath}"

echo "---"

echo "Cloning $artifacts_repo ..."
git clone $artifacts_repo "${GITHUB_WORKSPACE}/artifacts_repo"

echo "Moving generated files to ${GITHUB_WORKSPACE}/artifacts_repo/${artifacts_upload_dir} ..."
mkdir -p "${GITHUB_WORKSPACE}/artifacts_repo/${artifacts_upload_dir}"
yes | cp --recursive --force "${GITHUB_WORKSPACE}/${local_output_dir}/." "${GITHUB_WORKSPACE}/artifacts_repo/${artifacts_upload_dir}"

echo "Committing artifacts ..."
cd "${GITHUB_WORKSPACE}/artifacts_repo"
git status
git add .
git commit -m"Auto-generated PlantUML diagrams"

echo "Pushing artifacts ..."
git push

# Print debug info:
echo "Done."
echo ""
echo "Use the following tags to embed the generated images into the wiki:"
output_files=$(find "${GITHUB_WORKSPACE}/artifacts_repo/${artifacts_upload_dir}" -type f -name '*' -print)

ORIGINAL_IFS="$IFS"
IFS='
'
for file in $output_files
do
    echo "[[$(echo $file | sed -e "s@^${GITHUB_WORKSPACE}/artifacts_repo@@")|alt text]]"
done
IFS="$ORIGINAL_IFS"
