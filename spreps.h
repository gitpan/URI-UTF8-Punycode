/* stringprep.h --- Header file for stringprep functions.
 * Copyright (C) 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010  Simon Josefsson
 *
 * This file is part of GNU Libidn.
 *
 * GNU Libidn is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * GNU Libidn is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with GNU Libidn; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
 *
 */

#ifndef _STRINGPREP_H
# define _STRINGPREP_H

# include <stddef.h>		/* size_t */
# include <unistd.h>		/* ssize_t */
# include <stdint.h>		/* uint32_t */

# define STRINGPREP_VERSION "1.19"

extern uint32_t *stringprep_utf8_to_ucs4 (const char *str,
						   ssize_t len,
						   size_t * items_written);

extern char *stringprep_ucs4_to_utf8 (const uint32_t * str,
					       ssize_t len,
					       size_t * items_read,
					       size_t * items_written);

#endif				/* STRINGPREP_H */
