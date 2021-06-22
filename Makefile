.PHONY: serve

all: serve

install: install-checks
	bundle install

install-checks:
	${PRECOMMAND} npm i -g markdownlint-cli

serve:
	bundle exec jekyll serve --incremental --config _config.yml,_config-dev.yml

serve-hard:
	bundle exec jekyll serve --config _config.yml,_config-dev.yml

checks: spellcheck mdlint

spellcheck:
	go run github.com/client9/misspell/cmd/misspell -locale UK -source text -i "center,color,airplane" ${SHELLCHECK_FLAGS} \
		README.md index.html about.md blog open-source content

mdlint:
	markdownlint -c .markdownlint.json --ignore _site .
