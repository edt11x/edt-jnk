#
# Makefile for memtester by Charles Cazabon.
#
# Copyright (C) 1999 Simon Kirby.
# Version 2 Copyright (C) 1999 Charles Cazabon.
# Licensed under the GNU General Public License version 2.  See the file
# COPYING for details.
#
# See the file ABOUT for details.  See the file CHANGELOG for changes.
#


TARGET		= memtest
SOURCES		= memtest.c memtest-tests.c
BSD_STRSIGNAL = strsignal.c

# If we're making on a SVR5-type system, we need
ifeq ($(MAKECMDGOALS), bsd)
  SOURCES += $(BSD_STRSIGNAL)
endif

OBJECTS		= $(SOURCES:.c=.o)
HEADERS		= memtest.h memtest-tests.h
CLEANOBJS	= core memtest.log
VERSION		= $(shell version_memtest.sh)
TARNAME		= memtester
TAREXT		= tar
GZEXT		= gz
BZ2EXT		= bz2
TARCONTENTS	= Makefile $(SOURCES) $(HEADERS) \
                    README.tests ABOUT BUGS CHANGELOG COPYING TODO memtest.1

#
# Programs
#
CC		= gcc
RM		= rm -f
MV		= mv
CHMOD	= chmod
TAR		= tar
GZIP	= gzip -9
BZIP2	= bzip2 -9 --repetitive-best
CP		= cp
MKDIR	= mkdir

#
# Make variables
#
CFLAGS		+= -Wall -g
DEFINES		+=
INCLUDEDIRS	+=
LDFLAGS		+= -g

ifeq ($(MAKECMDGOALS), debug)
  DEFINES += -DDEBUGMODE=1
  INCLUDEDIRS += -I/users/charlesc/software/personal
endif


#
# Targets
#
all:  $(TARGET) Makefile

debug:  clean all Makefile

normal:  clean all Makefile

bsd:  $(TARGET) Makefile

clean:
	$(RM) $(TARGET) $(OBJECTS) $(CLEANOBJS)

$(TARGET):  $(OBJECTS) Makefile
	$(CC) $(LDFLAGS) -o $(TARGET) $(OBJECTS)

release:  $(TARCONTENTS) clean
	touch $(SOURCES) $(HEADERS) Makefile
	domakemanpage.sh
	gen_cur_ver_frag.sh
	$(RM) -f ABOUT $(TARNAME)-latest.$(TAREXT).$(GZEXT) $(TARNAME)-latest.$(TAREXT).$(BZ2EXT)
	lynx -nolist -dump http://www.qcc.sk.ca/~charlesc/software/$(TARNAME)/ >ABOUT
	$(CHMOD) 644 $(TARCONTENTS) index.shtml current_ver_info_frag.html memtest.pod
	-$(MV) $(TARNAME)*.$(TAREXT).* old-tarballs/
	$(CHMOD) 644 old-tarballs/*
	$(MKDIR) $(TARNAME)-$(VERSION)
	$(CP) $(TARCONTENTS) $(TARNAME)-$(VERSION)/
	$(CHMOD) 755 $(TARNAME)-$(VERSION)
	$(CHMOD) 644 $(TARNAME)-$(VERSION)/*
	$(TAR) cf $(TARNAME)-$(VERSION).$(TAREXT) $(TARNAME)-$(VERSION)
	$(GZIP) -c $(TARNAME)-$(VERSION).$(TAREXT) >$(TARNAME)-$(VERSION).$(TAREXT).$(GZEXT)
	$(BZIP2) -c $(TARNAME)-$(VERSION).$(TAREXT) >$(TARNAME)-$(VERSION).$(TAREXT).$(BZ2EXT)
	$(CHMOD) 644 $(TARNAME)-$(VERSION).$(TAREXT).$(GZEXT)
	$(CHMOD) 644 $(TARNAME)-$(VERSION).$(TAREXT).$(BZ2EXT)
	$(RM) -r $(TARNAME)-$(VERSION) $(TARNAME)-$(VERSION).$(TAREXT)
	ln -s $(TARNAME)-$(VERSION).$(TAREXT).$(GZEXT) $(TARNAME)-latest.$(TAREXT).$(GZEXT)
	ln -s $(TARNAME)-$(VERSION).$(TAREXT).$(BZ2EXT) $(TARNAME)-latest.$(TAREXT).$(BZ2EXT)
	@echo "Done."

#
# Compiling rules
#
%.o : %.c
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDEDIRS) -c -o $(<:.c=.o) $<
