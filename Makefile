SHELL := /bin/bash

init:
	if [ ! -d output ]; then git clone git@github.com:trilan/trilan.github.com.git output; fi
	cd output && git checkout --quiet master
	cd output && git reset --quiet HEAD && git checkout --quiet .

html: init
	pelican -s settings.py content

prepare-output: init
	cd output && git clean -f -d
	cd output && git rm --quiet -rf *

deploy: prepare-output html
	cd output && git add .
	cd output && if ! git diff-index --quiet HEAD --; then git commit -m "Update blog"; fi
	cd output && git push origin master
