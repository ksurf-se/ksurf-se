PYTHON_BIN := .venv/bin
BOOTSTRAP_RLS := https://github.com/twbs/bootstrap-sass/archive/v3.3.6.tar.gz
BOOTSTRAP_DIR := webpack/bootstrap

all: ubuntu-deps install

.PHONY: install .venv ubuntu-deps

install: .venv

.venv: $(PYTHON_BIN)/activate

$(PYTHON_BIN)/activate: requirements.txt
	test -d $(PYTHON_BIN) || virtualenv .venv
	$(PYTHON_BIN)/pip install -Ur requirements.txt
	touch $(PYTHON_BIN)/activate

ubuntu-deps:
	sudo apt-get install -y libssl-dev libffi-dev

clean:
	rm -rf .venv

server:
	$(PYTHON_BIN)/lektor --project site server

build: .venv
	$(PYTHON_BIN)/lektor --project site build --output-path .build


assets:
	$(PYTHON_BIN)/lektor --project site build -f webpack


bootstrap: $(BOOTSTRAP_DIR)/package.json


$(BOOTSTRAP_DIR)/package.json:
	curl -L $(BOOTSTRAP_RLS) | tar -zx -C $(BOOTSTRAP_DIR) --strip-components=1
