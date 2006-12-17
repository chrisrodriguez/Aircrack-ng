CC              = gcc
CFLAGS          ?= -g -W -Wall -O3
OPTFLAGS        = -D_FILE_OFFSET_BITS=64

iCC             = /opt/intel/cc/9.0/bin/icc
iCFLAGS         = -w -mcpu=pentiumpro -march=pentiumpro
iOPTFLAGS       = -O3 -ip -ipo -D_FILE_OFFSET_BITS=64
PROF_DIR	= $(PWD)/prof

destdir         = 
prefix          = /usr/local
bindir          = $(prefix)/bin
sbindir         = $(prefix)/sbin
mandir          = $(prefix)/man/man1
datadir         = $(prefix)/share
docdir          = $(datadir)/doc/aircrack-ng

BINFILES        = aircrack-ng airdecap-ng packetforge-ng ivstools kstats
SBINFILES       = aireplay-ng airodump-ng
SCRIPTS         = airmon-ng
TESTFILES       = makeivs
OPTFILES	= aircrack-ng-opt-prof_gen aircrack-ng-opt aircrack-ng-opt-prof prof/*
DOCFILES        = ChangeLog INSTALL README LICENSE AUTHORS VERSION

default:all

all: aircrack-ng airdecap-ng packetforge-ng aireplay-ng airodump-ng ivstools kstats makeivs

aircrack-ng-opt: src/aircrack-ng.c src/crypto.c src/sha1-mmx.S src/common.c
	$(iCC) $(iCFLAGS) $(iOPTFLAGS) src/aircrack-ng.c src/crypto.c src/sha1-mmx.S src/common.c -o aircrack-ng-opt -lpthread

aircrack-ng-opt-prof_gen: src/aircrack-ng.c src/crypto.c src/sha1-mmx.S src/common.c
	mkdir -p prof
	$(iCC) $(iCFLAGS) $(iOPTFLAGS) -prof_genx -DDO_PGO_DUMP -prof_dir$(PROF_DIR) src/aircrack-ng.c src/crypto.c src/sha1-mmx.S src/common.c -o aircrack-ng-opt-prof_gen -lpthread

aircrack-ng-opt-prof_use: src/aircrack-ng.c src/crypto.c src/sha1-mmx.S src/common.c
	$(iCC) $(iCFLAGS) $(iOPTFLAGS) -prof_use -prof_dir$(PROF_DIR) src/aircrack-ng.c src/crypto.c src/sha1-mmx.S src/common.c -o aircrack-ng-opt-prof -lpthread

aircrack-ng: src/aircrack-ng.c src/crypto.c src/sha1-mmx.S src/common.c
	$(CC) $(CFLAGS) $(OPTFLAGS) src/aircrack-ng.c src/crypto.c src/sha1-mmx.S src/common.c -o aircrack-ng -lpthread

airdecap-ng: src/airdecap-ng.c src/crypto.c src/common.c src/crc.c
	$(CC) $(CFLAGS) $(OPTFLAGS) src/airdecap-ng.c src/crypto.c src/common.c src/crc.c -o airdecap-ng

packetforge-ng: src/packetforge-ng.c src/common.c src/crc.c
	$(CC) $(CFLAGS) $(OPTFLAGS) src/packetforge-ng.c src/common.c src/crc.c -o packetforge-ng

aireplay-ng: src/aireplay-ng.c src/common.c src/crc.c
	$(CC) $(CFLAGS) $(OPTFLAGS) src/aireplay-ng.c src/common.c src/crc.c -o aireplay-ng

airodump-ng: src/airodump-ng.c src/common.c
	$(CC) $(CFLAGS) $(OPTFLAGS) src/airodump-ng.c src/common.c -o airodump-ng

ivstools: src/ivstools.c src/common.c
	$(CC) $(CFLAGS) $(OPTFLAGS) src/ivstools.c src/common.c -o ivstools

kstats: src/kstats.c
	$(CC) $(CFLAGS) $(OPTFLAGS) src/kstats.c  -o kstats

makeivs: test/makeivs.c
	$(CC) $(CFLAGS) $(OPTFLAGS) test/makeivs.c -o makeivs

strip: $(BINFILES) $(SBINFILES) $(TESTFILES)
	strip $(BINFILES) $(SBINFILES) $(TESTFILES)

airmon-ng:
	chmod +x makeAirmonNG.sh
	./makeAirmonNG.sh

install:
	install -d $(destdir)$(bindir)
	install -m 755 $(BINFILES) $(destdir)$(bindir)
	install -m 755 $(TESTFILES) $(destdir)$(bindir)
	install -d $(destdir)$(sbindir)
	install -m 755 $(SBINFILES) $(destdir)$(sbindir)
	install -m 755 $(SCRIPTS) $(destdir)$(sbindir)
	install -d $(destdir)$(mandir)
	install -m 644 ./manpages/* $(destdir)$(mandir)

uninstall:
	-rm -f $(destdir)$(bindir)/aircrack-ng
	-rm -f $(destdir)$(bindir)/airodump-ng
	-rm -f $(destdir)$(bindir)/airdecap-ng
	-rm -f $(destdir)$(bindir)/arpforge
	-rm -f $(destdir)$(bindir)/packetforge-ng
	-rm -f $(destdir)$(bindir)/aireplay-ng
	-rm -f $(destdir)$(bindir)/airmon.sh
	-rm -f $(destdir)$(bindir)/mergeivs
	-rm -f $(destdir)$(bindir)/pcap2ivs
	-rm -f $(destdir)$(bindir)/ivstools
	-rm -f $(destdir)$(bindir)/kstats
	-rm -f $(destdir)$(bindir)/ivstools-ng
	-rm -f $(destdir)$(sbindir)/airodump-ng
	-rm -f $(destdir)$(sbindir)/aireplay-ng
	-rm -f $(destdir)$(sbindir)/airmon.sh
	-rm -f $(destdir)$(sbindir)/airmon-ng
	-rm -f $(destdir)$(sbindir)/airmon
	-rm -f $(destdir)$(mandir)/aircrack-ng.1
	-rm -f $(destdir)$(mandir)/airdecap-ng.1
	-rm -f $(destdir)$(mandir)/aireplay-ng.1
	-rm -f $(destdir)$(mandir)/airmon.sh.1
	-rm -f $(destdir)$(mandir)/airmon-ng.1
	-rm -f $(destdir)$(mandir)/airodump-ng.1
	-rm -f $(destdir)$(mandir)/arpforge.1
	-rm -f $(destdir)$(mandir)/mergeivs.1
	-rm -f $(destdir)$(mandir)/pcap2ivs.1
	-rm -f $(destdir)$(mandir)/ivstools.1
	-rm -f $(destdir)/usr/man/man1/aircrack-ng.1
	-rm -f $(destdir)/usr/man/man1/airdecap-ng.1
	-rm -f $(destdir)/usr/man/man1/aireplay-ng.1
	-rm -f $(destdir)/usr/man/man1/airmon.sh.1
	-rm -f $(destdir)/usr/man/man1/airodump-ng.1
	-rm -f $(destdir)/usr/man/man1/arpforge.1
	-rm -f $(destdir)/usr/man/man1/mergeivs.1
	-rm -f $(destdir)/usr/man/man1/pcap2ivs.1
	
doc:
	install -d $(destdir)$(docdir)
	install -m 644 $(DOCFILES) $(destdir)$(docdir)
	

clean:
	-rm -f $(SBINFILES) $(BINFILES) $(TESTFILES) $(OPTFILES) $(SCRIPTS)


