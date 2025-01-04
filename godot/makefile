all: web.zip

build/index.html: project.godot export_presets.cfg
	mkdir -p build
	godot --export-release Web build/index.html

web.zip: build/index.html
	zip web.zip -r build/

clean:
	rm -rf web.zip build/

.PHONY: all clean
