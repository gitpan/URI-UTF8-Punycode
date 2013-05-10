#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "idnfkc.c"
#include "strerr.c"
#include "pcodes.c"

int ex_strlen(void *ptr)
{
  char *chr = (char *)ptr;
  if(chr == NULL){ return 0; }
  else if(chr[0] == '\0'){ return 0 ; }
  return strlen(chr);
}

char *_puny_enc(pTHX_ char *i)
{
  size_t lu, lp;
  uint32_t *q;
  char *p;
  int r;
  q = stringprep_utf8_to_ucs4(i, -1 ,&lu);
  if(!q){
    Perl_warn(aTHX_ "failed stringprep_utf8_to_ucs4");
    return NULL;
  }
  if((p = (char *)malloc(BUFSIZ+5)) == NULL){ return NULL; }
  p += 4;
  lp = BUFSIZ - 1;
  r = punycode_encode(lu, q, NULL, &lp, p);
  free(q);
  if(r != PUNYCODE_SUCCESS){
    Perl_warn(aTHX_ "%s", punycode_strerror(r));
    return NULL;
  }
  p[lp] = '\0'; p -= 4; p[0] = 'x'; p[1] = 'n'; p[2] = '-'; p[3] = '-';
  return p;
}

char *_puny_dec(pTHX_ char *i)
{
  size_t lp;
  uint32_t *q;
  char *p;
  int r;
  lp = BUFSIZ;
  if((q = (uint32_t *)malloc((lp*sizeof(q[0]))+1)) == NULL){
    Perl_warn(aTHX_ "failed malloc");
    return NULL;
  }
  r = punycode_decode(ex_strlen(i), i, &lp, q, NULL);
  if (r != PUNYCODE_SUCCESS){
    free (q);
    Perl_warn(aTHX_ "%s", punycode_strerror(r));
    return NULL;
  }
  q[lp] = 0;
  p = stringprep_ucs4_to_utf8(q, -1, NULL, NULL);
  free(q);
  if(!p){ return NULL; }
  return p;
}

MODULE = URI::UTF8::Punycode    PACKAGE = URI::UTF8::Punycode

SV*
puny_enc(str)
  char *str;
  CODE:
    char *tmp;
      SV *u8n;
    if((tmp = _puny_enc(aTHX_ str)) != NULL){
      u8n = newSVpv(tmp, 0);
      free(tmp);
      //SvUTF8_off(u8n);
      SvTAINTED_on(u8n);
    } else{
      Perl_croak(aTHX_ "subroutine puny_enc()");
    }
    RETVAL = u8n;
  OUTPUT:
    RETVAL

SV*
puny_dec(str)
  char *str;
  CODE:
    char *tmp;
      SV *u8s;
    if(strncmp(str, "xn--", 4) == 0){ str += 4; }
    if((tmp = _puny_dec(aTHX_ str)) != NULL){
      u8s = newSVpv(tmp, 0);
      free(tmp);
      sv_utf8_upgrade(u8s);
      SvTAINTED_on(u8s);
    } else{
      Perl_croak(aTHX_ "subroutine puny_dec_flags()");
    }
    RETVAL = u8s;
  OUTPUT:
    RETVAL
