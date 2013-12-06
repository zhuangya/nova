
all: bower_components Gruntfile.js  karma.conf.js  karma-e2e.conf.js 
	grunt build --force

bower_components: bower.json  node_modules
	bower install

node_modules: package.json
	npm install

clean:
	rm -rf dist

dist-clean: clean
	rm -rf bower_components node_modules
