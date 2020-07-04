#!/bin/sh

# Compiling and commiting. This script is designed to be used inside a crontab.

today=$(date +'%Y-%m-%d')
commit_message="Updating document for ${today}"

Rscript -e "rmarkdown::render('./index.Rmd')"

git add index.html

git commit -m "$commit_message"

git push origin master
