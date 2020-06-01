#include <stdlib.h>
#include <stdio.h>
#include "scheme.h"


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

struct __env_6 {
 Value int ; 
 Value spread_91ref ; 
 Value spread_91set ; 
} ;

struct __env_6* __alloc_env6(Value int, Value spread_91ref, Value spread_91set){
  struct __env_6* txpto = malloc(sizeof(struct __env_6));
  txpto->int = int;
  txpto->spread_91ref = spread_91ref;
  txpto->spread_91set = spread_91set;
  return txpto;
}


struct __env_5 {
 Value int ; 
 Value spread_91ref ; 
 Value spread_91set ; 
 Value xx ; 
} ;

struct __env_5* __alloc_env5(Value int, Value spread_91ref, Value spread_91set, Value xx){
  struct __env_5* txpto = malloc(sizeof(struct __env_5));
  txpto->int = int;
  txpto->spread_91ref = spread_91ref;
  txpto->spread_91set = spread_91set;
  txpto->xx = xx;
  return txpto;
}


struct __env_4 {
 Value int ; 
 Value spread ; 
 Value spread_91ref ; 
 Value spread_91set ; 
} ;

struct __env_4* __alloc_env4(Value int, Value spread, Value spread_91ref, Value spread_91set){
  struct __env_4* txpto = malloc(sizeof(struct __env_4));
  txpto->int = int;
  txpto->spread = spread;
  txpto->spread_91ref = spread_91ref;
  txpto->spread_91set = spread_91set;
  return txpto;
}


struct __env_3 {
 Value int ; 
} ;

struct __env_3* __alloc_env3(Value int){
  struct __env_3* txpto = malloc(sizeof(struct __env_3));
  txpto->int = int;
  return txpto;
}


struct __env_2 {
 Value spread_91ref ; 
 Value spread_91set ; 
 Value xx ; 
} ;

struct __env_2* __alloc_env2(Value spread_91ref, Value spread_91set, Value xx){
  struct __env_2* txpto = malloc(sizeof(struct __env_2));
  txpto->spread_91ref = spread_91ref;
  txpto->spread_91set = spread_91set;
  txpto->xx = xx;
  return txpto;
}


struct __env_1 {
 Value spread_91ref ; 
 Value spread_91set ; 
 Value xx ; 
} ;

struct __env_1* __alloc_env1(Value spread_91ref, Value spread_91set, Value xx){
  struct __env_1* txpto = malloc(sizeof(struct __env_1));
  txpto->spread_91ref = spread_91ref;
  txpto->spread_91set = spread_91set;
  txpto->xx = xx;
  return txpto;
}


struct __env_0 {
 Value spread_91ref ; 
} ;

struct __env_0* __alloc_env0(Value spread_91ref){
  struct __env_0* txpto = malloc(sizeof(struct __env_0));
  txpto->spread_91ref = spread_91ref;
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
Value __lambda_6() ;
Value __lambda_5() ;
Value __lambda_4() ;
Value __lambda_3() ;
Value __lambda_2() ;
Value __lambda_1() ;
Value __lambda_0() ;

Value __lambda_6(Value env_7319, Value spread, Value xx) {
  Value tmp_7327 ; 
  return (tmp_7327 = MakeClosure(__lambda_5,MakeEnv(__alloc_env5(((struct __env_6*)env_7319.env.env)->int, ((struct __env_6*)env_7319.env.env)->spread_91ref, ((struct __env_6*)env_7319.env.env)->spread_91set, xx))),tmp_7327.clo.lam(MakeEnv(tmp_7327.clo.env),NewCell(spread))) ;
}

Value __lambda_5(Value env_7320, Value spread) {
  Value tmp_7328 ; 
  return (tmp_7328 = MakeClosure(__lambda_4,MakeEnv(__alloc_env4(((struct __env_5*)env_7320.env.env)->int, spread, ((struct __env_5*)env_7320.env.env)->spread_91ref, ((struct __env_5*)env_7320.env.env)->spread_91set))),tmp_7328.clo.lam(MakeEnv(tmp_7328.clo.env),NewCell(((struct __env_5*)env_7320.env.env)->xx))) ;
}

Value __lambda_4(Value env_7321, Value xx) {
  Value tmp_7329 ; 
  return (tmp_7329 = MakeClosure(__lambda_2,MakeEnv(__alloc_env2(((struct __env_4*)env_7321.env.env)->spread_91ref, ((struct __env_4*)env_7321.env.env)->spread_91set, xx))),tmp_7329.clo.lam(MakeEnv(tmp_7329.clo.env),(*(((struct __env_4*)env_7321.env.env)->spread.cell.addr) = MakeClosure(__lambda_3,MakeEnv(__alloc_env3(((struct __env_4*)env_7321.env.env)->int)))))) ;
}

Value __lambda_3(Value env_7325, Value i, Value j) {
  Value tmp_7336 ; 
  return (tmp_7336 = ((struct __env_3*)env_7325.env.env)->int,tmp_7336.clo.lam(MakeEnv(tmp_7336.clo.env),MakeInt(10), MakeInt(11))) ;
}

Value __lambda_2(Value env_7322, Value _73_191) {
  Value tmp_7330 ; 
  return (tmp_7330 = MakeClosure(__lambda_1,MakeEnv(__alloc_env1(((struct __env_2*)env_7322.env.env)->spread_91ref, ((struct __env_2*)env_7322.env.env)->spread_91set, ((struct __env_2*)env_7322.env.env)->xx))),tmp_7330.clo.lam(MakeEnv(tmp_7330.clo.env),(*(((struct __env_2*)env_7322.env.env)->xx.cell.addr) = MakeFloat(42.0)))) ;
}

Value __lambda_1(Value env_7323, Value _73_191) {
  Value tmp_7331 ; 
  Value tmp_7334 ; 
  Value tmp_7335 ; 
  return (tmp_7331 = MakeClosure(__lambda_0,MakeEnv(__alloc_env0(((struct __env_1*)env_7323.env.env)->spread_91ref))),tmp_7331.clo.lam(MakeEnv(tmp_7331.clo.env),(tmp_7334 = __display,tmp_7334.clo.lam(MakeEnv(tmp_7334.clo.env),(tmp_7335 = ((struct __env_1*)env_7323.env.env)->spread_91set,tmp_7335.clo.lam(MakeEnv(tmp_7335.clo.env),MakeInt(0), MakeInt(0), (*(((struct __env_1*)env_7323.env.env)->xx.cell.addr)))))))) ;
}

Value __lambda_0(Value env_7324, Value _73_191) {
  Value tmp_7332 ; 
  Value tmp_7333 ; 
  return (tmp_7332 = __display,tmp_7332.clo.lam(MakeEnv(tmp_7332.clo.env),(tmp_7333 = ((struct __env_0*)env_7324.env.env)->spread_91ref,tmp_7333.clo.lam(MakeEnv(tmp_7333.clo.env),MakeInt(0), MakeInt(0))))) ;
}

int main (int argc, char* argv[]) {
  Value tmp_7326 ; 
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
  (tmp_7326 = MakeClosure(__lambda_6,MakeEnv(__alloc_env6(int, spread_91ref, spread_91set))),tmp_7326.clo.lam(MakeEnv(tmp_7326.clo.env),MakeBoolean(0), MakeBoolean(0))) ;
  return 0;
 }

