.PHONY: all

all: movie.svg movie.png

%.svg: %.drawio
	drawio -x -f svg -o $@ $<

%.png: %.drawio
	drawio -x -f png -o $@ $<
