test:
	MIX_ENV=test mix coveralls

coverage:
	MIX_ENV=test mix coveralls.html

build:
	mix compile

docs:
	mix docs

publish:
	mix hex.publish

.PHONY: test build docs