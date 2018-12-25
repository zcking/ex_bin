test:
	mix test --color --cover --trace

build:
	mix compile

docs:
	mix docs

.PHONY: test build docs