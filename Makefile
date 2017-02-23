define HELP_MESSAGE
Usage: make [COMMAND]

Commands:
	help     Display this help message.
	serve    Run dev server.
endef

export HELP_MESSAGE

PWD := $(shell pwd)

.PHONY: serve

serve:
	docker run -it --rm --label=jekyll --volume=$(PWD):/srv/jekyll -p 4000:4000 jekyll/jekyll:pages jekyll serve --drafts

help:
	docker run -it --rm --label=jekyll jekyll/jekyll:pages jekyll --help
