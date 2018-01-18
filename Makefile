###
### Makefile
###

PREFIX ?= /usr/local
TOOLS  = tools

.PHONY: all install uninstall

all: install

install:
	@unset CDPATH; cd $(TOOLS) && ./install.sh $(PREFIX)

uninstall:
	@unset CDPATH; cd $(TOOLS) && ./uninstall.sh $(PREFIX)
