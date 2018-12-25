test:
	mix test --color --cover

build:
	mix compile

docs:
	mix docs

.PHONY: test build docs