# Stanford Pascal Port for FreeBSD 15
# Top-level Makefile for Installation

PREFIX?=/usr/local
LOCAL_PREFIX?=$(HOME)/.local
BIN_DIR=$(PREFIX)/bin
LOCAL_BIN_DIR=$(LOCAL_PREFIX)/bin
LIB_DIR=$(PREFIX)/lib/stanford-pascal
LOCAL_LIB_DIR=$(LOCAL_PREFIX)/lib/stanford-pascal

all: build

build:
	cd bin && make

install-local: 
	$(MAKE) PREFIX=$(LOCAL_PREFIX) install

install:
	# Create directories
	install -d $(DESTDIR)$(BIN_DIR)
	install -d $(DESTDIR)$(LIB_DIR)
	
	# Install the interpreter
	install -m 755 bin/pcint $(DESTDIR)$(BIN_DIR)/pcint
	
	# Install P-code and messages to LIB_DIR
	install -m 644 src/*.pcode $(DESTDIR)$(LIB_DIR)/
	install -m 644 etc/pascal.messages $(DESTDIR)$(LIB_DIR)/
	
	# Install wrappers to BIN_DIR
	# We'll customize them to point to LIB_DIR during install
	sed 's|^PASCAL_ROOT=.*|PASCAL_ROOT=\"$(LIB_DIR)\"|' script_ix/pp > $(DESTDIR)$(BIN_DIR)/pcomp
	sed 's|^PASCAL_ROOT=.*|PASCAL_ROOT=\"$(LIB_DIR)\"|' script_ix/prun > $(DESTDIR)$(BIN_DIR)/prun
	sed 's|^PASCAL_ROOT=.*|PASCAL_ROOT=\"$(LIB_DIR)\"|' script_ix/pasf > $(DESTDIR)$(BIN_DIR)/pfmt
	sed 's|^PASCAL_ROOT=.*|PASCAL_ROOT=\"$(LIB_DIR)\"|' script_ix/pas2 > $(DESTDIR)$(BIN_DIR)/pas2
	install -m 755 script_ix/spascal $(DESTDIR)$(BIN_DIR)/spascal
	
	# Ensure they are executable
	chmod 755 $(DESTDIR)$(BIN_DIR)/pcomp $(DESTDIR)$(BIN_DIR)/prun $(DESTDIR)$(BIN_DIR)/pfmt $(DESTDIR)$(BIN_DIR)/pas2 $(DESTDIR)$(BIN_DIR)/spascal
	
	# Correct path logic in wrappers for an installed system
	# The wrappers need to know where BIN_DIR and LIB_DIR are.
	# We redefine the logic to be more specific.
	# But we've already set PASCAL_ROOT to LIB_DIR, so we just need
	# to ensure BIN_DIR is corrected to PREFIX/bin if pcint isn't there.
	sed -i '' 's|^BIN_DIR=.*|BIN_DIR=\"$(BIN_DIR)\"|' $(DESTDIR)$(BIN_DIR)/pcomp
	sed -i '' 's|^BIN_DIR=.*|BIN_DIR=\"$(BIN_DIR)\"|' $(DESTDIR)$(BIN_DIR)/prun
	sed -i '' 's|^BIN_DIR=.*|BIN_DIR=\"$(BIN_DIR)\"|' $(DESTDIR)$(BIN_DIR)/pfmt
	sed -i '' 's|^BIN_DIR=.*|BIN_DIR=\"$(BIN_DIR)\"|' $(DESTDIR)$(BIN_DIR)/pas2
	
	# Also fix folders in LIB_DIR structure
	sed -i '' 's|^SRC_DIR=.*|SRC_DIR=\"$(LIB_DIR)\"|' $(DESTDIR)$(BIN_DIR)/pcomp
	sed -i '' 's|^SRC_DIR=.*|SRC_DIR=\"$(LIB_DIR)\"|' $(DESTDIR)$(BIN_DIR)/prun
	sed -i '' 's|^SRC_DIR=.*|SRC_DIR=\"$(LIB_DIR)\"|' $(DESTDIR)$(BIN_DIR)/pfmt
	sed -i '' 's|^SRC_DIR=.*|SRC_DIR=\"$(LIB_DIR)\"|' $(DESTDIR)$(BIN_DIR)/pas2
	
	sed -i '' 's|^ETC_DIR=.*|ETC_DIR=\"$(LIB_DIR)\"|' $(DESTDIR)$(BIN_DIR)/pcomp
	sed -i '' 's|^ETC_DIR=.*|ETC_DIR=\"$(LIB_DIR)\"|' $(DESTDIR)$(BIN_DIR)/prun
	sed -i '' 's|^ETC_DIR=.*|ETC_DIR=\"$(LIB_DIR)\"|' $(DESTDIR)$(BIN_DIR)/pfmt
	sed -i '' 's|^ETC_DIR=.*|ETC_DIR=\"$(LIB_DIR)\"|' $(DESTDIR)$(BIN_DIR)/pas2

clean:
	cd bin && make clean
	rm -f debug.log truss.log truss_n.log helloworld.lis helloworld.pcode helloworld.listing helloworld.runlisting
