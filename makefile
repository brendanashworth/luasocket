# luasocket Makefile
# first run `make`, then `make install`

LUA ?= $(which lua)
OUTPUTDIR ?= /usr/local/lib/lua/5.2/

all:
	$(MAKE) -C src macosx

install:
	mkdir -p $(OUTPUTDIR)
	mv src/*.so $(OUTPUTDIR)

clean:
	$(MAKE) -C src $@

test:
	$(LUA) test/hello.lua

.PHONY: test samples etc
