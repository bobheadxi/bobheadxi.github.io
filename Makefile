.PHONY: serve

all: serve

install: install-checks
	bundle install

install-checks:
	gem install mdl
	go get -u github.com/client9/misspell/cmd/misspell

serve:
	bundle exec jekyll serve --config _config.yml,_config-dev.yml

checks: spellcheck mdlint

spellcheck:
	misspell -locale UK -source text -i "center,color" ${SHELLCHECK_FLAGS} \
		README.md index.html about.md blog open-source _posts

mdlint:
	mdl .
