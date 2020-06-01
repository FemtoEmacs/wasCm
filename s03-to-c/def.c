#include <stdlib.h>
#include <stdio.h>
#include "scheme.h"

Value __floop ;

Value __fadd ;


Value __idiv ;
Value __sum ;
Value __difference ;
Value __product ;
Value __fsum ;
Value __fdifference ;
Value __fproduct ;
Value __fdiv ;
Value __display ;

Value __numLT ;
Value __numLE ;
Value __numGT ;
Value __numGE ;

Value __fnumLT ;
Value __fnumLE ;
Value __fnumGT ;
Value __fnumGE ;
Value __fnumEqual ;

Value __numREM;
Value __numQUOT;
Value __pairCons;
Value __pairCar;
Value __pairCdr;
Value __pairNULL;
Value __numEqual ;
Value __argvOne ;
Value __stringRef ;
Value __stringSet ;
Value __stringLength ;
Value __substr ;
Value __charEq ;
Value __charGT ;
Value __charLT ;
Value __charGE ;
Value __charLE ;
Value __charNE ;
Value __strEq ;
Value __strGT ;
Value __strLT ;
Value __strCat ;
Value __NOT ;
Value __strP ;
Value __charP ;
Value __pairP ;
Value __intP ;
Value __floatP ;
Value __rdFile ;
Value __wrtFile ;
Value __rdFromStr ;

struct __env_19 {
} ;

struct __env_19* __alloc_env19(){
  struct __env_19* txpto = malloc(sizeof(struct __env_19));
  return txpto;
}


struct __env_18 {
 Value chr ; 
 Value cns ; 
 Value fl ; 
 Value n ; 
 Value str ; 
} ;

struct __env_18* __alloc_env18(Value chr, Value cns, Value fl, Value n, Value str){
  struct __env_18* txpto = malloc(sizeof(struct __env_18));
  txpto->chr = chr;
  txpto->cns = cns;
  txpto->fl = fl;
  txpto->n = n;
  txpto->str = str;
  return txpto;
}


struct __env_17 {
 Value chr ; 
 Value cns ; 
 Value fl ; 
 Value fn ; 
 Value n ; 
} ;

struct __env_17* __alloc_env17(Value chr, Value cns, Value fl, Value fn, Value n){
  struct __env_17* txpto = malloc(sizeof(struct __env_17));
  txpto->chr = chr;
  txpto->cns = cns;
  txpto->fl = fl;
  txpto->fn = fn;
  txpto->n = n;
  return txpto;
}


struct __env_16 {
 Value cns ; 
 Value fl ; 
 Value fn ; 
 Value n ; 
 Value str ; 
} ;

struct __env_16* __alloc_env16(Value cns, Value fl, Value fn, Value n, Value str){
  struct __env_16* txpto = malloc(sizeof(struct __env_16));
  txpto->cns = cns;
  txpto->fl = fl;
  txpto->fn = fn;
  txpto->n = n;
  txpto->str = str;
  return txpto;
}


struct __env_15 {
 Value chr ; 
 Value fl ; 
 Value fn ; 
 Value n ; 
 Value str ; 
} ;

struct __env_15* __alloc_env15(Value chr, Value fl, Value fn, Value n, Value str){
  struct __env_15* txpto = malloc(sizeof(struct __env_15));
  txpto->chr = chr;
  txpto->fl = fl;
  txpto->fn = fn;
  txpto->n = n;
  txpto->str = str;
  return txpto;
}


struct __env_14 {
 Value chr ; 
 Value cns ; 
 Value fl ; 
 Value fn ; 
 Value str ; 
} ;

struct __env_14* __alloc_env14(Value chr, Value cns, Value fl, Value fn, Value str){
  struct __env_14* txpto = malloc(sizeof(struct __env_14));
  txpto->chr = chr;
  txpto->cns = cns;
  txpto->fl = fl;
  txpto->fn = fn;
  txpto->str = str;
  return txpto;
}


struct __env_13 {
 Value chr ; 
 Value cns ; 
 Value fn ; 
 Value n ; 
 Value str ; 
} ;

struct __env_13* __alloc_env13(Value chr, Value cns, Value fn, Value n, Value str){
  struct __env_13* txpto = malloc(sizeof(struct __env_13));
  txpto->chr = chr;
  txpto->cns = cns;
  txpto->fn = fn;
  txpto->n = n;
  txpto->str = str;
  return txpto;
}


struct __env_12 {
} ;

struct __env_12* __alloc_env12(){
  struct __env_12* txpto = malloc(sizeof(struct __env_12));
  return txpto;
}


struct __env_11 {
 Value chr ; 
 Value cns ; 
 Value fl ; 
 Value fn ; 
 Value n ; 
 Value str ; 
} ;

struct __env_11* __alloc_env11(Value chr, Value cns, Value fl, Value fn, Value n, Value str){
  struct __env_11* txpto = malloc(sizeof(struct __env_11));
  txpto->chr = chr;
  txpto->cns = cns;
  txpto->fl = fl;
  txpto->fn = fn;
  txpto->n = n;
  txpto->str = str;
  return txpto;
}


struct __env_10 {
 Value chr ; 
 Value cns ; 
 Value fl ; 
 Value fn ; 
 Value n ; 
 Value str ; 
} ;

struct __env_10* __alloc_env10(Value chr, Value cns, Value fl, Value fn, Value n, Value str){
  struct __env_10* txpto = malloc(sizeof(struct __env_10));
  txpto->chr = chr;
  txpto->cns = cns;
  txpto->fl = fl;
  txpto->fn = fn;
  txpto->n = n;
  txpto->str = str;
  return txpto;
}


struct __env_9 {
 Value chr ; 
 Value cns ; 
 Value fl ; 
 Value fn ; 
 Value n ; 
 Value str ; 
} ;

struct __env_9* __alloc_env9(Value chr, Value cns, Value fl, Value fn, Value n, Value str){
  struct __env_9* txpto = malloc(sizeof(struct __env_9));
  txpto->chr = chr;
  txpto->cns = cns;
  txpto->fl = fl;
  txpto->fn = fn;
  txpto->n = n;
  txpto->str = str;
  return txpto;
}


struct __env_8 {
 Value chr ; 
 Value cns ; 
 Value fl ; 
 Value fn ; 
 Value n ; 
 Value str ; 
} ;

struct __env_8* __alloc_env8(Value chr, Value cns, Value fl, Value fn, Value n, Value str){
  struct __env_8* txpto = malloc(sizeof(struct __env_8));
  txpto->chr = chr;
  txpto->cns = cns;
  txpto->fl = fl;
  txpto->fn = fn;
  txpto->n = n;
  txpto->str = str;
  return txpto;
}


struct __env_7 {
 Value chr ; 
 Value cns ; 
 Value fl ; 
 Value fn ; 
 Value n ; 
 Value str ; 
} ;

struct __env_7* __alloc_env7(Value chr, Value cns, Value fl, Value fn, Value n, Value str){
  struct __env_7* txpto = malloc(sizeof(struct __env_7));
  txpto->chr = chr;
  txpto->cns = cns;
  txpto->fl = fl;
  txpto->fn = fn;
  txpto->n = n;
  txpto->str = str;
  return txpto;
}


struct __env_6 {
 Value chr ; 
 Value cns ; 
 Value fl ; 
 Value fn ; 
 Value n ; 
 Value str ; 
} ;

struct __env_6* __alloc_env6(Value chr, Value cns, Value fl, Value fn, Value n, Value str){
  struct __env_6* txpto = malloc(sizeof(struct __env_6));
  txpto->chr = chr;
  txpto->cns = cns;
  txpto->fl = fl;
  txpto->fn = fn;
  txpto->n = n;
  txpto->str = str;
  return txpto;
}


struct __env_5 {
 Value chr ; 
 Value cns ; 
 Value fl ; 
 Value fn ; 
 Value n ; 
 Value str ; 
} ;

struct __env_5* __alloc_env5(Value chr, Value cns, Value fl, Value fn, Value n, Value str){
  struct __env_5* txpto = malloc(sizeof(struct __env_5));
  txpto->chr = chr;
  txpto->cns = cns;
  txpto->fl = fl;
  txpto->fn = fn;
  txpto->n = n;
  txpto->str = str;
  return txpto;
}


struct __env_4 {
 Value chr ; 
 Value cns ; 
 Value fl ; 
 Value fn ; 
 Value n ; 
} ;

struct __env_4* __alloc_env4(Value chr, Value cns, Value fl, Value fn, Value n){
  struct __env_4* txpto = malloc(sizeof(struct __env_4));
  txpto->chr = chr;
  txpto->cns = cns;
  txpto->fl = fl;
  txpto->fn = fn;
  txpto->n = n;
  return txpto;
}


struct __env_3 {
 Value cns ; 
 Value fl ; 
 Value fn ; 
 Value n ; 
} ;

struct __env_3* __alloc_env3(Value cns, Value fl, Value fn, Value n){
  struct __env_3* txpto = malloc(sizeof(struct __env_3));
  txpto->cns = cns;
  txpto->fl = fl;
  txpto->fn = fn;
  txpto->n = n;
  return txpto;
}


struct __env_2 {
 Value fl ; 
 Value fn ; 
 Value n ; 
} ;

struct __env_2* __alloc_env2(Value fl, Value fn, Value n){
  struct __env_2* txpto = malloc(sizeof(struct __env_2));
  txpto->fl = fl;
  txpto->fn = fn;
  txpto->n = n;
  return txpto;
}


struct __env_1 {
 Value fl ; 
 Value fn ; 
} ;

struct __env_1* __alloc_env1(Value fl, Value fn){
  struct __env_1* txpto = malloc(sizeof(struct __env_1));
  txpto->fl = fl;
  txpto->fn = fn;
  return txpto;
}


struct __env_0 {
 Value fn ; 
} ;

struct __env_0* __alloc_env0(Value fn){
  struct __env_0* txpto = malloc(sizeof(struct __env_0));
  txpto->fn = fn;
  return txpto;
}


int argtop ;

Value arg[20] ;

char* substr(char *src, int m, int len)
{ char *dest= (char *)malloc(sizeof(char) * (len+1));
  for (int i=m; i< m+len &&(*(src + i) != 0); i++) {
    *dest= *(src+i); dest++;}
  *dest= 0;
  return dest - len ;
}
Value __prim_pairCons(Value e, Value a, Value b) {
  return NewCons(a, b) ;
}
Value __prim_pairCar(Value e, Value a) {
  return *a.cons.car ;
}
double __fl(Value a) {
  return a.f.value ;
}
int __int(Value a) {
  return a.z.value ;
}
Value __fexpr(Value e, double a) {
  return MakeFloat(a) ;
}
Value __iexpr(Value e, int a) {
  return MakeInt(a) ;
}
Value __prim_pairCdr(Value e, Value d) {
  return *d.cons.cdr ;
}
Value __prim_pairNULL(Value e, Value d) {
  return MakeBoolean(d.n.t == NIL) ;
}
int __isNil(Value e, Value d) {
  return (d.n.t == NIL) ;
}
double floop(Value env,int ix,double fy){
return (ix < 1) ? fy : floop(env,(ix - 1),(fy + 0.1));}

Value __prim_floop(Value env,Value ix,Value fy){
return MakeFloat(floop(env, ix.z.value, fy.f.value)) ;
}


double fadd(Value env,double fx,double fy){
return (fx + fy);}

Value __prim_fadd(Value env,Value fx,Value fy){
return MakeFloat(fadd(env, fx.f.value, fy.f.value)) ;
}


Value __prim_sum(Value e, Value a, Value b) {
    if ((a.z.t != INT) || (b.z.t != INT))
      {printf("Type error in addition.\n"); exit(503);}
  return MakeInt(a.z.value + b.z.value) ;
}
Value __prim_product(Value e, Value a, Value b) {
    if ((a.z.t != INT) || (b.z.t != INT))
      {printf("Type error in multiplication.\n"); exit(503);}
  return MakeInt(a.z.value * b.z.value) ;
}
Value __prim_difference(Value e, Value a, Value b) {
     if ((a.z.t != INT) || (b.z.t != INT))
      {printf("Type error in subtraction.\n"); exit(503);}
  return MakeInt(a.z.value - b.z.value) ;
}
Value __prim_fsum(Value e, Value a, Value b) {
  return MakeFloat(a.f.value + b.f.value) ;
}
Value __prim_fproduct(Value e, Value a, Value b) {
  return MakeFloat(a.f.value * b.f.value) ;
}
Value __prim_fdifference(Value e, Value a, Value b) {
  return MakeFloat(a.f.value - b.f.value) ;
}
Value __prim_fdiv(Value e, Value a, Value b) {
  return MakeFloat(a.f.value / b.f.value) ;
}
Value __prim_display(Value e, Value v) {
  //printf("%i\n",v.z.value) ;
  prsexpr(v);
  printf("\n");
  return v ;
}
Value __prim_argvOne(Value e, Value i) {
    if (i.z.value < argtop) return arg[i.z.value];
    else return arg[0];
  };
Value __prim_NOT(Value e, Value g) {
  if ((g.b.t == BOOLEAN) && (g.b.value == 0)) {return MakeBoolean(0);}
  else return MakeBoolean(1);
}
Value __prim_strP(Value e, Value g) {
     return MakeBoolean(g.s.t == STR);
  }
Value __prim_charP(Value e, Value g) {
     return MakeBoolean(g.c.t == CHAR);
  }
Value __prim_pairP(Value e, Value g) {
     return MakeBoolean(g.cons.t == CONS);
  }
Value __prim_intP(Value e, Value g) {
     return MakeBoolean(g.z.t == INT);
  }
Value __prim_floatP(Value e, Value g) {
     return MakeBoolean(g.f.t == FLOAT );
  }
Value __prim_numLT(Value e, Value a, Value b) {
  return MakeBoolean(a.z.value < b.z.value) ;
}
Value __prim_numGT(Value e, Value a, Value b) {
  return MakeBoolean(a.z.value > b.z.value) ;
}
Value __prim_numGE(Value e, Value a, Value b) {
  return MakeBoolean(a.z.value >= b.z.value) ;
}
Value __prim_numLE(Value e, Value a, Value b) {
  return MakeBoolean(a.z.value <= b.z.value) ;
}
Value __prim_fnumLT(Value e, Value a, Value b) {
  return MakeBoolean(a.f.value < b.f.value) ;
}
Value __prim_fnumGT(Value e, Value a, Value b) {
  return MakeBoolean(a.f.value > b.f.value) ;
}
Value __prim_fnumGE(Value e, Value a, Value b) {
  return MakeBoolean(a.f.value >= b.f.value) ;
}
Value __prim_fnumLE(Value e, Value a, Value b) {
  return MakeBoolean(a.f.value <= b.f.value) ;
}
Value __prim_fnumEqual(Value e, Value a, Value b) {
  return MakeBoolean(a.f.value == b.f.value) ;
}
Value __prim_charEq(Value e, Value a, Value b) {
    if ((a.c.t != CHAR) || (b.c.t != CHAR))
      {printf("Type error in char=?\n"); exit(503);}
  return MakeBoolean(a.c.value == b.c.value) ;
}
Value __prim_charGT(Value e, Value a, Value b) {
    if ((a.c.t != CHAR) || (b.c.t != CHAR))
      {printf("Type error in char>?\n"); exit(503);}
  return MakeBoolean(a.c.value > b.c.value) ;
}
Value __prim_charLT(Value e, Value a, Value b) {
    if ((a.c.t != CHAR) || (b.c.t != CHAR))
      {printf("Type error in char<?\n"); exit(503);}
  return MakeBoolean(a.c.value < b.c.value) ;
}
Value __prim_charGE(Value e, Value a, Value b) {
    if ((a.c.t != CHAR) || (b.c.t != CHAR))
      {printf("Type error in char>=?\n"); exit(503);}
  return MakeBoolean(a.c.value >= b.c.value) ;
}
Value __prim_charLE(Value e, Value a, Value b) {
    if ((a.c.t != CHAR) || (b.c.t != CHAR))
      {printf("Type error in char<=?\n"); exit(503);}
  return MakeBoolean(a.c.value <= b.c.value) ;
}
Value __prim_charNE(Value e, Value a, Value b) {
    if ((a.c.t != CHAR) || (b.c.t != CHAR))
      {printf("Type error in char~=?\n"); exit(503);}
  return MakeBoolean(a.c.value != b.c.value) ;
}
Value __prim_strEq(Value e, Value a, Value b) {
    if ((a.s.t != STR) || (b.s.t != STR))
      {printf("Type error in string=?\n"); exit(503);}
  return MakeBoolean(strcmp(a.s.value, b.s.value) == 0) ;
}
Value __prim_strLT(Value e, Value a, Value b) {
    if ((a.s.t != STR) || (b.s.t != STR))
      {printf("Type error in string<?\n"); exit(503);}
  return MakeBoolean(strcmp(a.s.value, b.s.value) < 0) ;
}
Value __prim_strGT(Value e, Value a, Value b) {
    if ((a.s.t != STR) || (b.s.t != STR))
      {printf("Type error in string>?\n"); exit(503);}
  return MakeBoolean(strcmp(a.s.value, b.s.value) > 0) ;
}
Value __prim_strCat(Value e, Value a, Value b) {
    if ((a.s.t != STR) || (b.s.t != STR))
      {printf("Type error in strcat\n"); exit(503);}
  char *result;
  result = malloc(strlen(a.s.value)+strlen(b.s.value)+2);
  strcpy(result, a.s.value);
  strcpy(result+strlen(a.s.value), b.s.value);
  return MakeStr(result) ;

}
Value __prim_numREM(Value e, Value a, Value b) {
     if ((a.z.t != INT) || (b.z.t != INT))
      {printf("Type error in division.\n"); exit(503);}
      if (b.z.value == 0) {
        {printf("Division by 0.\n"); exit(503);}
      }
  return MakeInt(a.z.value % b.z.value) ;
}
Value __prim_numQUOT(Value e, Value a, Value b) {
      if ((a.z.t != INT) || (b.z.t != INT))
        {printf("Type error in division.\n"); exit(503);}
      if (b.z.value == 0) {
        {printf("Division by 0.\n"); exit(503);}
      }
  return MakeInt(((int) a.z.value) / 
                       ((int) b.z.value)) ;
}
Value __prim_numEqual(Value e, Value a, Value b) {
  return MakeBoolean(a.z.value == b.z.value) ;
}
Value __prim_stringRef(Value e, Value a, Value i) {
  if ((a.s.t != STR) || (i.z.t != INT)) {
    printf("Type error in string-ref\n");
    exit(518);
  }
  if ( (i.z.value >= strlen(a.s.value)) ||
       (i.z.value < 0)) {
    printf("String index out of range: %i.\n", i.z.value);
    exit(518);}
  else return MakeChar(a.s.value[i.z.value]);
}
Value __prim_stringSet(Value e, Value a, Value i, Value b) {
  if ( (a.s.t != STR) || (i.z.t != INT) ||
       (b.c.t != CHAR) ) {
    printf("Type error in string-set!\n");
    exit(518);
  }
  if ( (i.z.value >= strlen(a.s.value)) ||
       (i.z.value < 0)) {
    printf("Index out of range in string-set!: %i.\n", i.z.value);
    exit(518);}

     a.s.value[i.z.value]= b.c.value;
     return a;}
Value __prim_stringLength(Value e, Value a) {
    if ( (a.s.t != STR)  ) {
      printf("Type error in string-length\n");
      exit(518);}
    
    return MakeInt(strlen(a.s.value));}
Value __prim_substr(Value e, Value a, Value i, Value j) {
  if ( (a.s.t != STR) || (i.z.t != INT) ||
       (j.z.t != INT) ) {
    printf("Type error in substr\n");
    exit(518);
  }
  if ( (i.z.value >= strlen(a.s.value)) ||
       (i.z.value < 0) || 
       ((i.z.value + j.z.value) >= strlen(a.s.value))) {
    printf("Index out of range in substr: %i.\n", 
                   i.z.value + j.z.value);
    exit(518);}

      return MakeStr(substr(a.s.value, i.z.value, j.z.value));
}
Value __prim_rdFile(Value e, Value a) {
  if (a.s.t != STR) {
    printf("Type error in read-file\n");
	  exit(518);
	  }
  Value v;
  char *buffer=0;
  long length;
  FILE *f= fopen(a.s.value, "rb");
  if (f)
  { fseek(f, 0, SEEK_END);
    length= ftell(f);
    fseek(f, 0, SEEK_SET);
    buffer = malloc(length);
    if (buffer) { if (!fread(buffer, 1, length, f))
                   printf("Read failed");
		}
    fclose(f);
    }
  //*(buffer+length)= 0;
  v.s.t= STR;
  v.s.value= buffer;
  return v;
}
Value __prim_wrtFile(Value e, Value fpth, Value c) {
    if ( (fpth.s.t != STR) || (c.s.t != STR )) {
      printf("Type error in write-file\n");
      exit(517);
     }
    FILE *fpw;
    fpw= fopen(fpth.s.value, "w");
    if (fpw == NULL) {
      puts("Issue in opening output file");
    }
    fputs(c.s.value, fpw);
    fclose(fpw);
    return MakeBoolean(0);
}
Value __prim_rdFromStr(Value e, Value a) {
  if (a.s.t != STR) {
    printf("Type error in read-from-string\n");
	  exit(518);
  }//end type check
  int checkParens;
  checkParens= 0;
  ss= a.s.value;
  return parse_term(&checkParens);
}
Value __lambda_19() ;
Value __lambda_18() ;
Value __lambda_17() ;
Value __lambda_16() ;
Value __lambda_15() ;
Value __lambda_14() ;
Value __lambda_13() ;
Value __lambda_12() ;
Value __lambda_11() ;
Value __lambda_10() ;
Value __lambda_9() ;
Value __lambda_8() ;
Value __lambda_7() ;
Value __lambda_6() ;
Value __lambda_5() ;
Value __lambda_4() ;
Value __lambda_3() ;
Value __lambda_2() ;
Value __lambda_1() ;
Value __lambda_0() ;

Value __lambda_19(Value env_7334, Value fn, Value str, Value chr, Value cns, Value n, Value fl) {
  Value tmp_7355 ; 
  return (tmp_7355 = MakeClosure(__lambda_18,MakeEnv(__alloc_env18(chr, cns, fl, n, str))),tmp_7355.clo.lam(MakeEnv(tmp_7355.clo.env),NewCell(fn))) ;
}

Value __lambda_18(Value env_7335, Value fn) {
  Value tmp_7356 ; 
  return (tmp_7356 = MakeClosure(__lambda_17,MakeEnv(__alloc_env17(((struct __env_18*)env_7335.env.env)->chr, ((struct __env_18*)env_7335.env.env)->cns, ((struct __env_18*)env_7335.env.env)->fl, fn, ((struct __env_18*)env_7335.env.env)->n))),tmp_7356.clo.lam(MakeEnv(tmp_7356.clo.env),NewCell(((struct __env_18*)env_7335.env.env)->str))) ;
}

Value __lambda_17(Value env_7336, Value str) {
  Value tmp_7357 ; 
  return (tmp_7357 = MakeClosure(__lambda_16,MakeEnv(__alloc_env16(((struct __env_17*)env_7336.env.env)->cns, ((struct __env_17*)env_7336.env.env)->fl, ((struct __env_17*)env_7336.env.env)->fn, ((struct __env_17*)env_7336.env.env)->n, str))),tmp_7357.clo.lam(MakeEnv(tmp_7357.clo.env),NewCell(((struct __env_17*)env_7336.env.env)->chr))) ;
}

Value __lambda_16(Value env_7337, Value chr) {
  Value tmp_7358 ; 
  return (tmp_7358 = MakeClosure(__lambda_15,MakeEnv(__alloc_env15(chr, ((struct __env_16*)env_7337.env.env)->fl, ((struct __env_16*)env_7337.env.env)->fn, ((struct __env_16*)env_7337.env.env)->n, ((struct __env_16*)env_7337.env.env)->str))),tmp_7358.clo.lam(MakeEnv(tmp_7358.clo.env),NewCell(((struct __env_16*)env_7337.env.env)->cns))) ;
}

Value __lambda_15(Value env_7338, Value cns) {
  Value tmp_7359 ; 
  return (tmp_7359 = MakeClosure(__lambda_14,MakeEnv(__alloc_env14(((struct __env_15*)env_7338.env.env)->chr, cns, ((struct __env_15*)env_7338.env.env)->fl, ((struct __env_15*)env_7338.env.env)->fn, ((struct __env_15*)env_7338.env.env)->str))),tmp_7359.clo.lam(MakeEnv(tmp_7359.clo.env),NewCell(((struct __env_15*)env_7338.env.env)->n))) ;
}

Value __lambda_14(Value env_7339, Value n) {
  Value tmp_7360 ; 
  return (tmp_7360 = MakeClosure(__lambda_13,MakeEnv(__alloc_env13(((struct __env_14*)env_7339.env.env)->chr, ((struct __env_14*)env_7339.env.env)->cns, ((struct __env_14*)env_7339.env.env)->fn, n, ((struct __env_14*)env_7339.env.env)->str))),tmp_7360.clo.lam(MakeEnv(tmp_7360.clo.env),NewCell(((struct __env_14*)env_7339.env.env)->fl))) ;
}

Value __lambda_13(Value env_7340, Value fl) {
  Value tmp_7361 ; 
  return (tmp_7361 = MakeClosure(__lambda_11,MakeEnv(__alloc_env11(((struct __env_13*)env_7340.env.env)->chr, ((struct __env_13*)env_7340.env.env)->cns, fl, ((struct __env_13*)env_7340.env.env)->fn, ((struct __env_13*)env_7340.env.env)->n, ((struct __env_13*)env_7340.env.env)->str))),tmp_7361.clo.lam(MakeEnv(tmp_7361.clo.env),(*(((struct __env_13*)env_7340.env.env)->fn.cell.addr) = MakeClosure(__lambda_12,MakeEnv(__alloc_env12()))))) ;
}

Value __lambda_12(Value env_7353, Value x, Value y) {
  Value tmp_7390 ; 
  Value tmp_7391 ; 
  Value tmp_7392 ; 
  return (tmp_7390 = __product,tmp_7390.clo.lam(MakeEnv(tmp_7390.clo.env),x, (tmp_7391 = __product,tmp_7391.clo.lam(MakeEnv(tmp_7391.clo.env),x, (tmp_7392 = __product,tmp_7392.clo.lam(MakeEnv(tmp_7392.clo.env),y, y)))))) ;
}

Value __lambda_11(Value env_7341, Value _73_191) {
  Value tmp_7362 ; 
  return (tmp_7362 = MakeClosure(__lambda_10,MakeEnv(__alloc_env10(((struct __env_11*)env_7341.env.env)->chr, ((struct __env_11*)env_7341.env.env)->cns, ((struct __env_11*)env_7341.env.env)->fl, ((struct __env_11*)env_7341.env.env)->fn, ((struct __env_11*)env_7341.env.env)->n, ((struct __env_11*)env_7341.env.env)->str))),tmp_7362.clo.lam(MakeEnv(tmp_7362.clo.env),(*(((struct __env_11*)env_7341.env.env)->str.cell.addr) = MakeStr("Rose")))) ;
}

Value __lambda_10(Value env_7342, Value _73_191) {
  Value tmp_7363 ; 
  return (tmp_7363 = MakeClosure(__lambda_9,MakeEnv(__alloc_env9(((struct __env_10*)env_7342.env.env)->chr, ((struct __env_10*)env_7342.env.env)->cns, ((struct __env_10*)env_7342.env.env)->fl, ((struct __env_10*)env_7342.env.env)->fn, ((struct __env_10*)env_7342.env.env)->n, ((struct __env_10*)env_7342.env.env)->str))),tmp_7363.clo.lam(MakeEnv(tmp_7363.clo.env),(*(((struct __env_10*)env_7342.env.env)->chr.cell.addr) = MakeChar(99)))) ;
}

Value __lambda_9(Value env_7343, Value _73_191) {
  Value tmp_7364 ; 
  Value tmp_7387 ; 
  Value tmp_7388 ; 
  Value tmp_7389 ; 
  return (tmp_7364 = MakeClosure(__lambda_8,MakeEnv(__alloc_env8(((struct __env_9*)env_7343.env.env)->chr, ((struct __env_9*)env_7343.env.env)->cns, ((struct __env_9*)env_7343.env.env)->fl, ((struct __env_9*)env_7343.env.env)->fn, ((struct __env_9*)env_7343.env.env)->n, ((struct __env_9*)env_7343.env.env)->str))),tmp_7364.clo.lam(MakeEnv(tmp_7364.clo.env),(*(((struct __env_9*)env_7343.env.env)->cns.cell.addr) = (tmp_7387 = __pairCons,tmp_7387.clo.lam(MakeEnv(tmp_7387.clo.env),MakeInt(3), (tmp_7388 = __pairCons,tmp_7388.clo.lam(MakeEnv(tmp_7388.clo.env),MakeInt(4), (tmp_7389 = __pairCons,tmp_7389.clo.lam(MakeEnv(tmp_7389.clo.env),MakeInt(5), MakeBoolean(0)))))))))) ;
}

Value __lambda_8(Value env_7344, Value _73_191) {
  Value tmp_7365 ; 
  return (tmp_7365 = MakeClosure(__lambda_7,MakeEnv(__alloc_env7(((struct __env_8*)env_7344.env.env)->chr, ((struct __env_8*)env_7344.env.env)->cns, ((struct __env_8*)env_7344.env.env)->fl, ((struct __env_8*)env_7344.env.env)->fn, ((struct __env_8*)env_7344.env.env)->n, ((struct __env_8*)env_7344.env.env)->str))),tmp_7365.clo.lam(MakeEnv(tmp_7365.clo.env),(*(((struct __env_8*)env_7344.env.env)->n.cell.addr) = MakeInt(42)))) ;
}

Value __lambda_7(Value env_7345, Value _73_191) {
  Value tmp_7366 ; 
  return (tmp_7366 = MakeClosure(__lambda_6,MakeEnv(__alloc_env6(((struct __env_7*)env_7345.env.env)->chr, ((struct __env_7*)env_7345.env.env)->cns, ((struct __env_7*)env_7345.env.env)->fl, ((struct __env_7*)env_7345.env.env)->fn, ((struct __env_7*)env_7345.env.env)->n, ((struct __env_7*)env_7345.env.env)->str))),tmp_7366.clo.lam(MakeEnv(tmp_7366.clo.env),(*(((struct __env_7*)env_7345.env.env)->fl.cell.addr) = MakeFloat(42.0)))) ;
}

Value __lambda_6(Value env_7346, Value _73_191) {
  Value tmp_7367 ; 
  Value tmp_7385 ; 
  Value tmp_7386 ; 
  return (tmp_7367 = MakeClosure(__lambda_5,MakeEnv(__alloc_env5(((struct __env_6*)env_7346.env.env)->chr, ((struct __env_6*)env_7346.env.env)->cns, ((struct __env_6*)env_7346.env.env)->fl, ((struct __env_6*)env_7346.env.env)->fn, ((struct __env_6*)env_7346.env.env)->n, ((struct __env_6*)env_7346.env.env)->str))),tmp_7367.clo.lam(MakeEnv(tmp_7367.clo.env),(tmp_7385 = __display,tmp_7385.clo.lam(MakeEnv(tmp_7385.clo.env),(tmp_7386 = __floop,tmp_7386.clo.lam(MakeEnv(tmp_7386.clo.env),MakeInt(1000000), MakeFloat(0.0))))))) ;
}

Value __lambda_5(Value env_7347, Value _73_191) {
  Value tmp_7368 ; 
  Value tmp_7383 ; 
  Value tmp_7384 ; 
  return (tmp_7368 = MakeClosure(__lambda_4,MakeEnv(__alloc_env4(((struct __env_5*)env_7347.env.env)->chr, ((struct __env_5*)env_7347.env.env)->cns, ((struct __env_5*)env_7347.env.env)->fl, ((struct __env_5*)env_7347.env.env)->fn, ((struct __env_5*)env_7347.env.env)->n))),tmp_7368.clo.lam(MakeEnv(tmp_7368.clo.env),(tmp_7383 = __display,tmp_7383.clo.lam(MakeEnv(tmp_7383.clo.env),(tmp_7384 = __strP,tmp_7384.clo.lam(MakeEnv(tmp_7384.clo.env),(*(((struct __env_5*)env_7347.env.env)->str.cell.addr)))))))) ;
}

Value __lambda_4(Value env_7348, Value _73_191) {
  Value tmp_7369 ; 
  Value tmp_7381 ; 
  Value tmp_7382 ; 
  return (tmp_7369 = MakeClosure(__lambda_3,MakeEnv(__alloc_env3(((struct __env_4*)env_7348.env.env)->cns, ((struct __env_4*)env_7348.env.env)->fl, ((struct __env_4*)env_7348.env.env)->fn, ((struct __env_4*)env_7348.env.env)->n))),tmp_7369.clo.lam(MakeEnv(tmp_7369.clo.env),(tmp_7381 = __display,tmp_7381.clo.lam(MakeEnv(tmp_7381.clo.env),(tmp_7382 = __charP,tmp_7382.clo.lam(MakeEnv(tmp_7382.clo.env),(*(((struct __env_4*)env_7348.env.env)->chr.cell.addr)))))))) ;
}

Value __lambda_3(Value env_7349, Value _73_191) {
  Value tmp_7370 ; 
  Value tmp_7379 ; 
  Value tmp_7380 ; 
  return (tmp_7370 = MakeClosure(__lambda_2,MakeEnv(__alloc_env2(((struct __env_3*)env_7349.env.env)->fl, ((struct __env_3*)env_7349.env.env)->fn, ((struct __env_3*)env_7349.env.env)->n))),tmp_7370.clo.lam(MakeEnv(tmp_7370.clo.env),(tmp_7379 = __display,tmp_7379.clo.lam(MakeEnv(tmp_7379.clo.env),(tmp_7380 = __pairP,tmp_7380.clo.lam(MakeEnv(tmp_7380.clo.env),(*(((struct __env_3*)env_7349.env.env)->cns.cell.addr)))))))) ;
}

Value __lambda_2(Value env_7350, Value _73_191) {
  Value tmp_7371 ; 
  Value tmp_7377 ; 
  Value tmp_7378 ; 
  return (tmp_7371 = MakeClosure(__lambda_1,MakeEnv(__alloc_env1(((struct __env_2*)env_7350.env.env)->fl, ((struct __env_2*)env_7350.env.env)->fn))),tmp_7371.clo.lam(MakeEnv(tmp_7371.clo.env),(tmp_7377 = __display,tmp_7377.clo.lam(MakeEnv(tmp_7377.clo.env),(tmp_7378 = __intP,tmp_7378.clo.lam(MakeEnv(tmp_7378.clo.env),(*(((struct __env_2*)env_7350.env.env)->n.cell.addr)))))))) ;
}

Value __lambda_1(Value env_7351, Value _73_191) {
  Value tmp_7372 ; 
  Value tmp_7375 ; 
  Value tmp_7376 ; 
  return (tmp_7372 = MakeClosure(__lambda_0,MakeEnv(__alloc_env0(((struct __env_1*)env_7351.env.env)->fn))),tmp_7372.clo.lam(MakeEnv(tmp_7372.clo.env),(tmp_7375 = __display,tmp_7375.clo.lam(MakeEnv(tmp_7375.clo.env),(tmp_7376 = __floatP,tmp_7376.clo.lam(MakeEnv(tmp_7376.clo.env),(*(((struct __env_1*)env_7351.env.env)->fl.cell.addr)))))))) ;
}

Value __lambda_0(Value env_7352, Value _73_191) {
  Value tmp_7373 ; 
  Value tmp_7374 ; 
  return (tmp_7373 = __display,tmp_7373.clo.lam(MakeEnv(tmp_7373.clo.env),(tmp_7374 = (*(((struct __env_0*)env_7352.env.env)->fn.cell.addr)),tmp_7374.clo.lam(MakeEnv(tmp_7374.clo.env),MakeInt(3), MakeInt(9))))) ;
}

int main (int argc, char* argv[]) {
  Value tmp_7354 ; 
__floop = MakePrimitive(__prim_floop) ;
__fadd = MakePrimitive(__prim_fadd) ;
argtop= argc ;
for (int i=0; i<argc;i++) {arg[i]= MakeStr(argv[i]) ;}
  __sum         = MakePrimitive(__prim_sum) ;
  __product     = MakePrimitive(__prim_product) ;
  __difference  = MakePrimitive(__prim_difference) ;
  __fsum         = MakePrimitive(__prim_fsum) ;
  __fproduct     = MakePrimitive(__prim_fproduct) ;
  __fdifference  = MakePrimitive(__prim_fdifference) ;
  __fdiv         = MakePrimitive(__prim_fdiv) ;
  __display     = MakePrimitive(__prim_display) ;
  __numLT    = MakePrimitive(__prim_numLT) ;
  __numLE    = MakePrimitive(__prim_numLE) ;
  __numGT    = MakePrimitive(__prim_numGT) ;
  __numGE    = MakePrimitive(__prim_numGE) ;
  __fnumLT    = MakePrimitive(__prim_fnumLT) ;
  __fnumLE    = MakePrimitive(__prim_fnumLE) ;
  __fnumGT    = MakePrimitive(__prim_fnumGT) ;
  __fnumGE    = MakePrimitive(__prim_fnumGE) ;
  __fnumEqual = MakePrimitive(__prim_fnumEqual) ;
  __numREM   = MakePrimitive(__prim_numREM) ;
  __numQUOT  = MakePrimitive(__prim_numQUOT) ;
  __numEqual = MakePrimitive(__prim_numEqual) ;
  __pairCons  = MakePrimitive(__prim_pairCons) ;
  __pairCar  = MakePrimitive(__prim_pairCar) ;
  __pairCdr  = MakePrimitive(__prim_pairCdr) ;
  __pairNULL  = MakePrimitive(__prim_pairNULL) ;
  __argvOne   = MakePrimitive(__prim_argvOne) ;
 __stringRef  = MakePrimitive(__prim_stringRef) ;
 __stringSet = MakePrimitive(__prim_stringSet) ;
 __stringLength = MakePrimitive(__prim_stringLength) ;
 __substr = MakePrimitive(__prim_substr) ;
 __charEq = MakePrimitive(__prim_charEq) ;
 __charGT = MakePrimitive(__prim_charGT) ;
 __charLT = MakePrimitive(__prim_charLT) ;
 __charGE = MakePrimitive(__prim_charGE) ;
 __charLE = MakePrimitive(__prim_charLE) ;
 __charNE = MakePrimitive(__prim_charNE) ;
 __strEq = MakePrimitive(__prim_strEq) ;
 __strGT = MakePrimitive(__prim_strGT) ;
 __strLT = MakePrimitive(__prim_strLT) ;
 __strCat = MakePrimitive(__prim_strCat) ;
 __NOT    = MakePrimitive(__prim_NOT) ;
 __strP = MakePrimitive(__prim_strP) ;
 __charP = MakePrimitive(__prim_charP) ;
 __pairP = MakePrimitive(__prim_pairP) ;
 __intP  = MakePrimitive(__prim_intP) ;
 __floatP = MakePrimitive(__prim_floatP) ;
 __rdFile = MakePrimitive(__prim_rdFile) ;
 __wrtFile = MakePrimitive(__prim_wrtFile) ;
 __rdFromStr   = MakePrimitive(__prim_rdFromStr) ;
  (tmp_7354 = MakeClosure(__lambda_19,MakeEnv(__alloc_env19())),tmp_7354.clo.lam(MakeEnv(tmp_7354.clo.env),MakeBoolean(0), MakeBoolean(0), MakeBoolean(0), MakeBoolean(0), MakeBoolean(0), MakeBoolean(0))) ;
  return 0;
 }

