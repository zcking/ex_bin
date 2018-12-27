test:
	MIX_ENV=test mix coveralls

coverage:
	MIX_ENV=test mix coveralls.html

build:
	mix compile

docs:
	mix docs

.PHONY: test build docs