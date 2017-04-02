define HELP_MESSAGE
Usage: make [COMMAND]

Commands:
	help           Display this help message.
	serve          Run dev server.
	deploy-test    Deploy to test domain
	deploy         Deploy to production domain
endef

export HELP_MESSAGE

PYTHON_BIN := .venv/bin
PWD := $(shell pwd)

.PHONY: serve help

$(PYTHON_BIN)/activate:
	test -d $(PYTHON_BIN) || virtualenv .venv
	$(PYTHON_BIN)/pip install s3cmd
	touch $(PYTHON_BIN)/activate

.venv: $(PYTHON_BIN)/activate

clean:
	rm -rf .venv
	rm -rf _site

serve:
	docker run -it --rm --label=jekyll --volume=$(PWD):/srv/jekyll -p 4000:4000 jekyll/jekyll:pages jekyll serve --drafts

help:
	docker run -it --rm --label=jekyll jekyll/jekyll:pages jekyll --help

build:
	docker run -it --rm --label=jekyll --volume=$(PWD):/srv/jekyll jekyll/jekyll:pages jekyll clean
	docker run -it --rm --label=jekyll --volume=$(PWD):/srv/jekyll jekyll/jekyll:pages jekyll build

deploy-test: check-aws-env .venv build
	$(PYTHON_BIN)/s3cmd sync --add-header="Cache-Control:max-age=3600" --no-mime-magic --no-preserve --delete-removed --delete-after ./_site/ s3://test.ksurf.se/

deploy: check-aws-env .venv build
	$(PYTHON_BIN)/s3cmd sync --add-header="Cache-Control:max-age=3600" --no-mime-magic --no-preserve --delete-removed --delete-after ./_site/ s3://www.ksurf.se/

check-aws-env:
ifndef AWS_ACCESS_KEY_ID
	$(error AWS_ACCESS_KEY_ID is undefined)
endif
ifndef AWS_SECRET_ACCESS_KEY
	$(error AWS_SECRET_ACCESS_KEY is undefined)
endif
