html:
	pelican -s settings.py content

deploy: html
	ghp-import -m "Update blog" -p
