SHELL := /bin/bash

init:
	if [ ! -d output ]; then git clone git@github.com:trilan/trilan.github.com.git output; fi
	cd output && git checkout master

html: init
	pelican -s settings.py content

deploy: html
	cd output && git add .
	cd output && if ! git diff-index --quiet HEAD --; then git commit -m "Update blog"; fi
	cd output && git push origin master
