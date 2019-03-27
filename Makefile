.PHONY: serve

all: serve

serve:
	bundle exec jekyll serve --config _config.yml,_config-dev.yml
