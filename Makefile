#     Copyright 1988 Massachusetts Institute of Technology.
#
#     For copying and distribution information, see the file
#     "mit-copyright.h".
#
#     $Source: /afs/dev.mit.edu/source/repository/athena/bin/delete/Makefile,v $
#     $Author: jik $
#     $Header: /afs/dev.mit.edu/source/repository/athena/bin/delete/Makefile,v 1.27 1991-02-22 07:26:16 jik Exp $
#

DESTDIR=
TARGETS= 	delete undelete expunge purge lsdel
INSTALLDIR= 	/usr/bin
MANDIR=		/usr/man
MANSECT=	1
CC= 		cc
DEPEND=		/usr/bin/X11/makedepend
COMPILE_ET= 	compile_et
LINT= 		lint
DEFINES=	


# These variables apply only if you want this program to recognize
# Andrew File System mount points.  If you don't want to support AFS,
# then they should all be commented out or set to nothing.
# 
# AFSINC is the include directory for AFS header files.  
# AFSLIB is the library directory that contains the AFS libraries.
# 
# AFSINC=		
# AFSLIB=		
# AFSINCS=	-I$(AFSINC)
# AFSLDFLAGS=	-L$(AFSLIB) -L$(AFSLIB)/afs
# AFSLIBS=	-lsys -lrx -llwp $(AFSLIB)/afs/util.a
# AFSDEFINES=	-DAFS_MOUNTPOINTS


# If you install the com_err library and include files in directories
# that your compiler and linker know how to find, you don't have to
# set these variables.  Otherwise, you do.
# 
# ETINCS is a -I flag pointing to the directory in which the et header
# files are stored. 
# ETLDFLAGS is a -L flag pointing to the directory where the et
# library is stored.
# 
# ETINCS=		
# ETLDFLAGS=	


# You probably won't have to edit anything below this line.

ETLIBS=		-lcom_err
INCLUDES=	$(ETINCS) $(AFSINCS)
LDFLAGS=	$(ETLDFLAGS) $(AFSLDFLAGS) 
LIBS= 		$(ETLIBS) $(AFSLIBS)
CDEBUGFLAGS=	-O
CFLAGS= 	$(INCLUDES) $(DEFINES) $(AFSDEFINES) $(CDEBUGFLAGS)
LINTFLAGS=	-u $(INCLUDES) $(DEFINES) $(AFSDEFINES) $(CDEBUGFLAGS)
LINTLIBS=	

SRCS= 		delete.c undelete.c directories.c pattern.c util.c\
		expunge.c lsdel.c col.c shell_regexp.c\
		errors.c stack.c
INCS= 		col.h delete.h directories.h expunge.h lsdel.h\
		mit-copyright.h pattern.h undelete.h util.h\
		shell_regexp.h errors.h stack.h
ETS=		delete_errs.h delete_errs.c
ETSRCS=		delete_errs.et

MANS= 		man1/delete.1 man1/expunge.1 man1/lsdel.1 man1/purge.1\
		man1/undelete.1

ARCHIVE=	README Makefile PATCHLEVEL $(SRCS) $(INCS) $(MANS)\
		$(ETSRCS)
ARCHIVEDIRS= 	man1

DELETEOBJS= 	delete.o util.o delete_errs.o errors.o
UNDELETEOBJS= 	undelete.o directories.o util.o pattern.o\
		shell_regexp.o delete_errs.o errors.o stack.o
EXPUNGEOBJS= 	expunge.o directories.o pattern.o util.o col.o\
		shell_regexp.o delete_errs.o errors.o stack.o
LSDELOBJS= 	lsdel.o util.o directories.o pattern.o col.o\
		shell_regexp.o delete_errs.o errors.o stack.o

DELETESRC= 	delete.c util.c delete_errs.c errors.c
UNDELETESRC= 	undelete.c directories.c util.c pattern.c\
		shell_regexp.c delete_errs.c errors.c stack.c
EXPUNGESRC= 	expunge.c directories.c pattern.c util.c col.c\
		shell_regexp.c delete_errs.c errors.c stack.c
LSDELSRC= 	lsdel.c util.c directories.c pattern.c col.c\
		shell_regexp.c delete_errs.c errors.c stack.c

.SUFFIXES: .c .h .et

.et.h: $*.et
	${COMPILE_ET} $*.et
.et.c: $*.et
	${COMPILE_ET} $*.et

all: $(TARGETS)

lint_all: lint_delete lint_undelete lint_expunge lint_lsdel

install:: bin_install man_install

# Errors are ignored on bin_install and man_install because make on
# some platforms, in combination with the shell, does really stupid
# things and detects an error where there is none.

man_install:
	-for i in $(TARGETS) ; do\
	  install -c man1/$$i.1\
		$(DESTDIR)$(MANDIR)/man$(MANSECT)/$$i.$(MANSECT);\
	done

bin_install: $(TARGETS)
	-for i in $(TARGETS) ; do\
          if [ -f $(DESTDIR)$(INSTALLDIR)/$$i ]; then\
            mv $(DESTDIR)$(INSTALLDIR)/$$i $(DESTDIR)$(INSTALLDIR)/.#$$i ; \
          fi; \
	  install -c -s $$i $(DESTDIR)$(INSTALLDIR) ; \
        done

delete: $(DELETEOBJS)
	$(CC) $(LDFLAGS) $(CFLAGS) -o delete $(DELETEOBJS) $(LIBS)

saber_delete:
	#setopt program_name delete
	#load $(LDFLAGS) $(CFLAGS) $(DELETESRC) $(LIBS)

lint_delete: $(DELETESRC)
	$(LINT) $(LINTFLAGS) $(DELETESRC) $(LINTLIBS)

undelete: $(UNDELETEOBJS)
	$(CC) $(LDFLAGS) $(CFLAGS) -o undelete $(UNDELETEOBJS) $(LIBS)

saber_undelete:
	#setopt program_name undelete
	#load $(LDFLAGS) $(CFLAGS) $(UNDELETESRC) $(LIBS)

lint_undelete: $(UNDELETESRC)
	$(LINT) $(LINTFLAGS) $(UNDELETESRC) $(LINTLIBS)

expunge: $(EXPUNGEOBJS)
	$(CC) $(LDFLAGS) $(CFLAGS) -o expunge $(EXPUNGEOBJS) $(LIBS)

saber_expunge:
	#setopt program_name expunge
	#load $(LDFLAGS) $(CFLAGS) $(EXPUNGESRC) $(LIBS)

lint_expunge: $(EXPUNGESRC)
	$(LINT) $(LINTFLAGS) $(EXPUNGESRC) $(LINTLIBS)

purge: expunge
	ln -s expunge purge

lsdel: $(LSDELOBJS)
	$(CC) $(LDFLAGS) $(CFLAGS) -o lsdel $(LSDELOBJS) $(LIBS)

lint_lsdel: $(LSDELSRC)
	$(LINT) $(LINTFLAGS) $(LSDELSRC) $(LINTLIBS)

saber_lsdel:
	#setopt program_name lsdel
	#load $(LDFLAGS) $(CFLAGS) $(LSDELSRC) $(LIBS)

tar: $(ARCHIVE)
	tar cvf - $(ARCHIVE) $(ETLIBSRCS) | compress > delete.tar.Z

shar: $(ARCHIVE)
	makekit -oMANIFEST $(ARCHIVEDIRS) $(ARCHIVE) $(ETLIBSRCS)

patch: $(ARCHIVE)
	makepatch $(ARCHIVE)
	mv patch delete.patch`cat PATCHLEVEL`
	shar delete.patch`cat PATCHLEVEL` > delete.patch`cat PATCHLEVEL`.shar

clean::
	-rm -f *~ *.bak *.o delete undelete lsdel expunge purge\
		delete_errs.h delete_errs.c

depend: $(SRCS) $(INCS) $(ETS)
	$(DEPEND) -v $(CFLAGS) -s'# DO NOT DELETE' $(SRCS)

$(DELETEOBJS): delete_errs.h
$(EXPUNGEOBJS): delete_errs.h
$(UNDELETEOBJS): delete_errs.h
$(LSDELOBJS): delete_errs.h

# DO NOT DELETE THIS LINE -- makedepend depends on it
