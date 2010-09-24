#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "mypuny.c"

MODULE = URI::UTF8::Punycode    PACKAGE = URI::UTF8::Punycode

char*
puny_enc(u8s)
  char *u8s;
  CODE:
    RETVAL = _puny_enc(u8s);
  OUTPUT:
    RETVAL

char*
puny_dec(u8s)
  char *u8s;
  CODE:
    RETVAL = _puny_dec(u8s);
  OUTPUT:
    RETVAL
