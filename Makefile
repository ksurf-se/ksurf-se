PYTHON_BIN := .venv/bin

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
