APP_SRC=$(shell find app | grep -v ' ')
all: dist

dist: $(APP_SRC)
	bower install
	grunt build --force

.PHONY: all
