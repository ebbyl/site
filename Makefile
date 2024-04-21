install:
	npm install 

.PHONY: build 
build:
	rm -rf ./dist/
	npm run build 

run:
	npm run dev 
