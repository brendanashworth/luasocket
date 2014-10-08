# luasocket src/makefile
# only works on macosx :)

PLAT ?= macosx

# Lua version (lua -v)
LUAV ?= 5.2

# Flags to be set by user (probably not).
MYCFLAGS=
MYLDFLAGS=

# DEBUG: NODEBUG DEBUG
# debug mode causes luasocket to collect and returns timing information useful
# for testing and debugging luasocket itself
DEBUG ?= NODEBUG

# COMPAT: COMPAT NOCOMPAT
# when compiling for 5.2, use LUA_COMPAT_MODULE
COMPAT ?= COMPAT

# where lua headers are found for macosx builds
# LUAINC_macosx:
# /opt/local/include
LUAINC_macosx_base ?= /opt/local/include
LUAINC_macosx ?= $(LUAINC_macosx_base)/lua/$(LUAV)
# FIXME default should this default to fink or to macports?
# What happens when more than one Lua version is installed?
LUAPREFIX_macosx ?= /opt/local
CDIR_macosx ?= lib/lua/$(LUAV)
LDIR_macosx ?= share/lua/$(LUAV)

# prefix: /usr/local /usr /opt/local /sw
# the top of the default install tree
prefix ?= $(LUAPREFIX_$(PLAT))

CDIR ?= $(CDIR_$(PLAT))
LDIR ?= $(LDIR_$(PLAT))

# Install directories
INSTALL_DIR=install -d
INSTALL_DATA=install -m644
INSTALL_EXEC=install
INSTALL_TOP=$(DESTDIR)$(prefix)

INSTALL_TOP_LDIR=$(INSTALL_TOP)/$(LDIR)
INSTALL_TOP_CDIR=$(INSTALL_TOP)/$(CDIR)

INSTALL_SOCKET_LDIR=$(INSTALL_TOP_LDIR)/socket
INSTALL_SOCKET_CDIR=$(INSTALL_TOP_CDIR)/socket
INSTALL_MIME_LDIR=$(INSTALL_TOP_LDIR)/mime
INSTALL_MIME_CDIR=$(INSTALL_TOP_CDIR)/mime

print:
	@echo PLAT=$(PLAT)
	@echo LUAV=$(LUAV)
	@echo DEBUG=$(DEBUG)
	@echo prefix=$(prefix)
	@echo LUAINC_$(PLAT)=$(LUAINC_$(PLAT))
	@echo LUALIB_$(PLAT)=$(LUALIB_$(PLAT))
	@echo INSTALL_TOP_CDIR=$(INSTALL_TOP_CDIR)
	@echo INSTALL_TOP_LDIR=$(INSTALL_TOP_LDIR)

#------
# Compiler and linker settings
# for Mac OS X
SO_macosx = so
O_macosx = o
CC_macosx = gcc
DEF_macosx = -DLUASOCKET_$(DEBUG) -DUNIX_HAS_SUN_LEN -DLUA_$(COMPAT)_MODULE \
	-DLUASOCKET_API='__attribute__((visibility("default")))' \
	-DUNIX_API='__attribute__((visibility("default")))' \
	-DMIME_API='__attribute__((visibility("default")))'
CFLAGS_macosx = -I$(LUAINC) $(DEF) -pedantic -Wall -O2 -fno-common \
	-fvisibility=hidden
LDFLAGS_macosx = -bundle -undefined dynamic_lookup -o 
LD_macosx = export MACOSX_DEPLOYMENT_TARGET="10.3"; gcc
SOCKET_macosx =usocket.o

# Output file names
SO=$(SO_$(PLAT))
O=$(O_$(PLAT))
SOCKET_V=3.0-rc1
MIME_V=1.0.3
SOCKET_SO=socket.$(SO).$(SOCKET_V)
MIME_SO=mime.$(SO).$(MIME_V)
UNIX_SO=unix.$(SO)
SERIAL_SO=serial.$(SO)
SOCKET=$(SOCKET_$(PLAT))

# Settings selected for platform
CC=$(CC_$(PLAT))
DEF=$(DEF_$(PLAT))
CFLAGS=$(MYCFLAGS) $(CFLAGS_$(PLAT))
LDFLAGS=$(MYLDFLAGS) $(LDFLAGS_$(PLAT))
LD=$(LD_$(PLAT))
LUAINC= $(LUAINC_$(PLAT))
LUALIB= $(LUALIB_$(PLAT))

# Modules belonging to socket-core
SOCKET_OBJS= \
	luasocket.$(O) \
	timeout.$(O) \
	buffer.$(O) \
	io.$(O) \
	auxiliar.$(O) \
	options.$(O) \
	inet.$(O) \
	$(SOCKET) \
	except.$(O) \
	select.$(O) \
	tcp.$(O) \
	udp.$(O)

# Modules belonging mime-core
MIME_OBJS= \
	mime.$(O)

# Modules belonging unix (local domain sockets)
UNIX_OBJS=\
	buffer.$(O) \
	auxiliar.$(O) \
	options.$(O) \
	timeout.$(O) \
	io.$(O) \
	usocket.$(O) \
	unix.$(O)

# Modules belonging to serial (device streams)
SERIAL_OBJS=\
	buffer.$(O) \
	auxiliar.$(O) \
	options.$(O) \
	timeout.$(O) \
	io.$(O) \
	usocket.$(O) \
	serial.$(O)

# Files to install
TO_SOCKET_LDIR= \
	http.lua \
	url.lua \
	tp.lua \
	ftp.lua \
	headers.lua \
	smtp.lua

TO_TOP_LDIR= \
	ltn12.lua \
	socket.lua \
	mime.lua

# Targets
default: macosx

macosx:
	$(MAKE) all-unix PLAT=macosx

all: $(SOCKET_SO) $(MIME_SO)

$(SOCKET_SO): $(SOCKET_OBJS)
	$(LD) $(SOCKET_OBJS) $(LDFLAGS)$@

$(MIME_SO): $(MIME_OBJS)
	$(LD) $(MIME_OBJS) $(LDFLAGS)$@

all-unix: all $(UNIX_SO) $(SERIAL_SO)

$(UNIX_SO): $(UNIX_OBJS)
	$(LD) $(UNIX_OBJS) $(LDFLAGS)$@

$(SERIAL_SO): $(SERIAL_OBJS)
	$(LD) $(SERIAL_OBJS) $(LDFLAGS)$@

install: 
	$(INSTALL_DIR) $(INSTALL_TOP_LDIR)
	$(INSTALL_DATA) $(TO_TOP_LDIR) $(INSTALL_TOP_LDIR)
	$(INSTALL_DIR) $(INSTALL_SOCKET_LDIR)
	$(INSTALL_DATA) $(TO_SOCKET_LDIR) $(INSTALL_SOCKET_LDIR)
	$(INSTALL_DIR) $(INSTALL_SOCKET_CDIR)
	$(INSTALL_EXEC) $(SOCKET_SO) $(INSTALL_SOCKET_CDIR)/core.$(SO)
	$(INSTALL_DIR) $(INSTALL_MIME_CDIR)
	$(INSTALL_EXEC) $(MIME_SO) $(INSTALL_MIME_CDIR)/core.$(SO)

install-unix: install
	$(INSTALL_EXEC) $(UNIX_SO) $(INSTALL_SOCKET_CDIR)/$(UNIX_SO)
	$(INSTALL_EXEC) $(SERIAL_SO) $(INSTALL_SOCKET_CDIR)/$(SERIAL_SO)

local:
	$(MAKE) install INSTALL_TOP_CDIR=.. INSTALL_TOP_LDIR=..

clean:
	rm -f $(SOCKET_SO) $(SOCKET_OBJS) $(SERIAL_OBJS)
	rm -f $(MIME_SO) $(UNIX_SO) $(SERIAL_SO) $(MIME_OBJS) $(UNIX_OBJS)

.PHONY: all $(PLATS) default clean echo none

#------
# List of dependencies
#
auxiliar.$(O): auxiliar.c auxiliar.h
buffer.$(O): buffer.c buffer.h io.h timeout.h
except.$(O): except.c except.h
inet.$(O): inet.c inet.h socket.h io.h timeout.h usocket.h
io.$(O): io.c io.h timeout.h
luasocket.$(O): luasocket.c luasocket.h auxiliar.h except.h \
	timeout.h buffer.h io.h inet.h socket.h usocket.h tcp.h \
	udp.h select.h
mime.$(O): mime.c mime.h
options.$(O): options.c auxiliar.h options.h socket.h io.h \
	timeout.h usocket.h inet.h
select.$(O): select.c socket.h io.h timeout.h usocket.h select.h
serial.$(O): serial.c auxiliar.h socket.h io.h timeout.h usocket.h \
  options.h unix.h buffer.h
tcp.$(O): tcp.c auxiliar.h socket.h io.h timeout.h usocket.h \
	inet.h options.h tcp.h buffer.h
timeout.$(O): timeout.c auxiliar.h timeout.h
udp.$(O): udp.c auxiliar.h socket.h io.h timeout.h usocket.h \
	inet.h options.h udp.h
unix.$(O): unix.c auxiliar.h socket.h io.h timeout.h usocket.h \
	options.h unix.h buffer.h
usocket.$(O): usocket.c socket.h io.h timeout.h usocket.h
wsocket.$(O): wsocket.c socket.h io.h timeout.h usocket.h
