.PHONY: serve

all: serve

install:
	bundle install

serve:
	bundle exec jekyll serve --config _config.yml,_config-dev.yml
