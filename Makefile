PYTHON_BIN := .venv/bin

all: ubuntu-deps install

.PHONY: install .venv ubuntu-deps deploy-test clean server build check-aws-env

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

deploy-test: check-aws-env build
	$(PYTHON_BIN)/s3cmd sync --add-header="Cache-Control:max-age=3600" --no-mime-magic --no-preserve --delete-removed --delete-after ./site/.build/ s3://test.ksurf.se/

check-aws-env:
ifndef AWS_ACCESS_KEY_ID
	$(error AWS_ACCESS_KEY_ID is undefined)
endif
ifndef AWS_SECRET_ACCESS_KEY
	$(error AWS_SECRET_ACCESS_KEY is undefined)
endif