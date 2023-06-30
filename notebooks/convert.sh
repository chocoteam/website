#!/bin/sh

function quit() {
    echo "ERROR: $*"
    exit 1
}


# If a command fails then the deploy stops
set -e

printf "\033[0;32mConverting notebooks...\033[0m\n"

source docenv/bin/activate

CONTENT_DIR="../"
STATIC_DIR="../static/notebooks"

find ./content -type f -name "*.ipynb" -not -path "*ipynb_checkpoints*" -print0 | 
while IFS= read -r -d '' file; do
    printf '%s\n' "$file"
	fname=$(basename "$file")
	dname=$(dirname "$file")
	printf "\033[0;32mCheck ${fname}\033[0m\n"
	jupyter nbconvert --to notebook --ExecutePreprocessor.kernel_name=java --stdout --execute "$file" 1>/dev/null || quit "unable to execute ${fname}"
	printf "\033[0;32mConvert ${fname}\033[0m\n"
	jupyter nbconvert --to markdown --output-dir="${CONTENT_DIR}/${dname}" "$file" || quit "unable to convert ${fname}"
	printf "\033[0;32mCopy ${fname}\033[0m\n"
	dest=${STATIC_DIR}/${dname}
	mkdir -p "${dest}" &&	cp "$file" "${dest}" || quit "unable to copy ${fname}"
done
