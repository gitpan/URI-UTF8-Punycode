#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "idnfkc.c"
#include "strerr.c"
#include "pcodes.c"

int length(void *ptr)
{
  char *chr = (char *)ptr;
  if(chr == NULL){ return 0; }
  else if(chr[0] == '\0'){ return 0 ; }
  return strlen(chr);
}

char *_puny_enc(pTHX,char *i)
{
  size_t lu, lp;
  uint32_t *q;
  char *p;
  int r;
  q = stringprep_utf8_to_ucs4(i,-1,&lu);
  if(!q){
    Perl_croak(aTHX_ "failed stringprep_utf8_to_ucs4");
    return NULL;
  }
  if((p = (char *)malloc(BUFSIZ+5)) == NULL){ return NULL; }
  p += 4;
  lp = BUFSIZ-1;
  r = punycode_encode(lu,q,NULL,&lp,p);
  free(q);
  if(r != PUNYCODE_SUCCESS){
    Perl_croak(aTHX_ "%s",punycode_strerror(r));
    return NULL;
  }
  p[lp] = '\0'; p -= 4; p[0] = 'x'; p[1] = 'n'; p[2] = '-'; p[3] = '-';
  return p;
}

char *_puny_dec(pTHX,char *i)
{
  size_t lp;
  uint32_t *q;
  char *p;
  int r;
  lp = BUFSIZ;
  if((q = (uint32_t *)malloc((lp*sizeof(q[0]))+1)) == NULL){
    Perl_croak(aTHX_ "failed malloc");
    return NULL;
  }
  r = punycode_decode(length(i),i,&lp,q,NULL);
  if (r != PUNYCODE_SUCCESS){
    free (q);
    fprintf(stderr,"%s\n",punycode_strerror(r));
    return NULL;
  }
  q[lp] = 0;
  p = stringprep_ucs4_to_utf8(q,-1,NULL,NULL);
  free (q);
  if(!p){ return NULL; }
  return p;
}

MODULE = URI::UTF8::Punycode    PACKAGE = URI::UTF8::Punycode

char*
puny_enc(u8s)
  char *u8s;
  CODE:
    RETVAL = _puny_enc(aTHX_ u8s);
  OUTPUT:
    RETVAL

char*
puny_dec(u8s)
  char *u8s;
  CODE:
    if(strncmp(u8s,"xn--",4) == 0){ u8s += 4; }
    RETVAL = _puny_dec(aTHX_ u8s);
  OUTPUT:
    RETVAL
