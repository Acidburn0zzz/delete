/*
 * $Id: stack.c,v 1.13 1999-01-22 23:09:06 ghudson Exp $
 *
 * This program is part of a package including delete, undelete,
 * lsdel, expunge and purge.  The software suite is meant as a
 * replacement for rm which allows for file recovery.
 * 
 * Copyright (c) 1989 by the Massachusetts Institute of Technology.
 * For copying and distribution information, see the file "mit-copying.h."
 */

#include <string.h>
#include <sys/types.h>
#include <stdio.h>
#include <errno.h>
#include "stack.h"
#include "delete_errs.h"
#include "errors.h"
#include "mit-copying.h"
#include "util.h"

#define STACK_INC 	25



int dostack(caddr_t data, int op, int bytes)
{
     static caddr_t stack = (caddr_t) NULL;
     static int size = 0, count = 0;
     
     switch (op) {
     case EMPTY_STACK:
	  if (size) {
	       free(stack);
	       stack = (caddr_t) NULL;
	       size = count = 0;
	  }
#ifdef STACK_DEBUG
	  fprintf(stderr, "dostack: return 1 (EMPTY_STACK).\n");
#endif
	  return 0;
     case STACK_PUSH:
	  if (bytes == 0) {
#ifdef STACK_DEBUG
	       fprintf(stderr, "Pushing 0 bytes at %d offset.\n", count);
	       fprintf(stderr, "dostack: return 2 (STACK_PUSH).\n");
#endif
	       return 0;
	  }
	  if (size - count < bytes) {
	       do
		    size += STACK_INC;
	       while (size - count < bytes);
	       stack = (caddr_t) (stack ? realloc((char *) stack,
						  (unsigned) size) :
				  Malloc((unsigned) size));
	       if ((! stack) && size)
	       {
		    size = count = 0;
		    set_error(errno);
		    error("Malloc");
#ifdef STACK_DEBUG
		    fprintf(stderr, "dostack: return 3 (STACK_PUSH).\n");
#endif
		    return error_code;
	       }
	  }
#ifdef STACK_DEBUG
	  fprintf(stderr, "Pushing %d bytes at %d offset.\n", bytes, count);
#endif
	  memcpy(stack + count, data, bytes);
	  count += bytes;
#ifdef STACK_DEBUG
	  fprintf(stderr, "dostack: return 4 (STACK_PUSH).\n");
#endif
	  return 0;
     case STACK_POP:
	  if (bytes == 0) {
#ifdef STACK_DEBUG
	       fprintf(stderr, "Popping 0 bytes at %d offset.\n", count);
	       fprintf(stderr, "dostack: return 5 (STACK_POP).\n");
#endif
	       return 0;
	  }
	  if (count == 0) {
	       set_status(STACK_EMPTY);
#ifdef STACK_DEBUG
	       fprintf(stderr, "dostack: return 6 (STACK_POP).\n");
#endif
	       return error_code;
	  }
	  else {
	       int newblocks, newsize;

	       count -= bytes;
#ifdef STACK_DEBUG
	       fprintf(stderr, "Popping %d bytes at %d offset.\n", bytes,
		       count);
#endif
	       memcpy(data, stack + count, bytes);
	       newblocks = count / STACK_INC + ((count % STACK_INC) ? 1 : 0);
	       newsize = newblocks * STACK_INC;
	       if (newsize < size) {
		    size = newsize;
		    stack = (caddr_t) realloc((char *) stack, (unsigned) size);
		    if ((! stack) && size)
	            {
			 set_error(errno);
			 error("realloc");
#ifdef STACK_DEBUG
			 fprintf(stderr, "dostack: return 7 (STACK_POP).\n");
#endif
			 return error_code;
		    }
	       }
#ifdef STACK_DEBUG
	       fprintf(stderr, "dostack: return 8 (STACK_POP).\n");
#endif
	       return 0;
	  }
     default:
	  set_error(STACK_BAD_OP);
#ifdef STACK_DEBUG
	  fprintf(stderr, "dostack: return 9.\n");
#endif
	  return error_code;
     }
}
