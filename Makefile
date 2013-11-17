NPM=npm
NODE=node

COFFEE=node_modules/coffee-script/bin/coffee
STYLUS=node_modules/stylus/bin/stylus 
JADE=node_modules/jade/bin/jade
RJS=node_modules/requirejs/bin/r.js

TARGETS_src = $(patsubst src/%.coffee,lib/%.js,$(shell find src -name \*.coffee))

#WEBROOT_TEMPLATE=$(shell find webroot/js/templates)
#WEBROOT_COFFEE=$(shell find webroot -name \*.coffee)
#WEBROOT_STYLUS=$(shell find webroot -name \*.styl)
#WEBROOT_JADE=$(shell find webroot -name \*.jade)

#TARGETS_webjs += $(patsubst %.coffee,%.js,$(WEBROOT_COFFEE))
#TARGETS_css   += $(patsubst %.styl,%.css, $(WEBROOT_STYLUS))
#TARGETS_jade  += $(patsubst %.jade,%.html,$(WEBROOT_JADE))

TARGETS = $(TARGETS_src) 
#TARGETS +=$(TARGETS_webjs) 
#TARGETS +=$(TARGETS_css)
#TARGETS +=$(TARGETS_jade)
#TARGETS += webroot/js/main.min.js

all: node_modules $(TARGETS)

lib/%.js: src/%.coffee
	@mkdir -p $(shell dirname $@)
	$(COFFEE) -c -m -o $(shell dirname $@) "$<"

%.js: %.coffee
	$(COFFEE) -c -m "$<"

%.css: %.styl
	$(STYLUS) < "$<" > "$@"

webroot/js/main.min.js: webroot/r.config.js $(TARGETS_webjs) $(WEBROOT_TEMPLATE)
	$(RJS) -o "$<"

#%.html: %.jade
#	$(JADE) < "$<" > "$@"

node_modules: package.json
	$(NPM) install

clean:
	find lib -name \*.map -delete
	find webroot -name \*.map -delete
	rm -rf $(TARGETS)

run: all
	$(NODE) lib/main

watch:
	nodemon -w src --exec ./build_and_run lib/main.js

.PHONY: all clean run watch
