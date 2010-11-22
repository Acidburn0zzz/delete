/*
 * $Id: util.h,v 1.14 1999-01-22 23:09:09 ghudson Exp $
 * 
 * This file is part of a package including delete, undelete,
 * lsdel, expunge and purge.  The software suite is meant as a
 * replacement for rm which allows for file recovery.
 * 
 * Copyright (c) 1989 by the Massachusetts Institute of Technology.
 * For copying and distribution information, see the file "mit-copying.h."
 */
#include "mit-copying.h"

#include <sys/stat.h>
#ifndef S_IFLNK
#define lstat stat
#endif

#include "directories.h"
#include <stdlib.h>

char *append();
char *convert_to_user_name();
char *firstpart();
char *lastpart();
int get_home(char *buf);
int timed_out(filerec *file_ent, time_t current_time, time_t min_days);
char *strindex();
char *strrindex();
#ifdef MALLOC_DEBUG
char *Malloc();
#else
#define Malloc(a) malloc(a)
#endif

int is_mountpoint(), is_link(char *name, struct stat *oldbuf), yes(void);
int directory_exists(char *dirname);


#define is_dotfile(A) ((*A == '.') && \
		       ((*(A + 1) == '\0') || \
			((*(A + 1) == '.') && \
			 (*(A + 2) == '\0'))))

#define is_deleted(A) ((*A == '.') && (*(A + 1) == '#'))

 /* It would be BAD to pass something with a ++ anywhere near it into */
 /* this macro! 						      */
#define Opendir(dir) opendir(*(dir) ? (dir) : ".")
