#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# clean up public
cd public
find . -maxdepth 1 ! -name '.git' ! -name '.' -exec rm -rf {} +

cd ..
# Build the project.
# main website
hugo --config config.toml 
# presentations part
hugo --config config-reveal.toml


# Go To Public folder
cd public

# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master
