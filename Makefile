define HELP_MESSAGE
Usage: make [COMMAND]

Commands:
	help           Display this help message.
	serve          Run dev server.
	deploy-test    Deploy to test domain
	deploy         Deploy to production domain
endef

export HELP_MESSAGE

PWD := $(shell pwd)
CACHE_TIME := 3000000
JEKYLL_VERSION := 3.8

.PHONY: serve help

clean:
	rm -rf .venv
	rm -rf _site

serve: build
	docker run -it --rm --label=jekyll --volume=$(PWD):/srv/jekyll -p 4000:4000 jekyll/jekyll:$(JEKYLL_VERSION) jekyll serve --drafts --trace

help:
	docker run -it --rm --label=jekyll jekyll/jekyll:$(JEKYLL_VERSION) jekyll --help

build:
	docker run -it --rm --label=jekyll --volume=$(PWD):/srv/jekyll jekyll/jekyll:$(JEKYLL_VERSION) jekyll clean
	docker run -it --rm --label=jekyll --volume=$(PWD):/srv/jekyll jekyll/jekyll:$(JEKYLL_VERSION) jekyll build

deploy-test: build
	aws-vault exec ksurf --no-session -- aws s3 sync --cache-control max-age=$(CACHE_TIME),public --delete ./_site/ s3://test.ksurf.se/
	AWS_PAGER="" aws-vault exec ksurf --no-session -- aws cloudfront create-invalidation --distribution-id E3KM3KMSV24EGT --paths "/*"
	echo "Done"

deploy: build
	aws-vault exec ksurf --no-session -- aws s3 sync --cache-control max-age=$(CACHE_TIME),public --delete ./_site/ s3://www.ksurf.se/
	AWS_PAGER="" aws-vault exec ksurf --no-session -- aws cloudfront create-invalidation --distribution-id E1J6DO1K0O6IEA --paths "/*"
	echo "Done"
