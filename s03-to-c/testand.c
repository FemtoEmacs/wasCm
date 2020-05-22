#include <stdlib.h>
#include <stdio.h>
#include "scheme.h"

Value __top ;

Value __rest ;

Value __floopsum ;

Value __floop ;

Value __fadd ;

Value __mcons ;


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

struct __env_8 {
} ;

struct __env_8* __alloc_env8(){
  struct __env_8* txpto = malloc(sizeof(struct __env_8));
  return txpto;
}


struct __env_7 {
} ;

struct __env_7* __alloc_env7(){
  struct __env_7* txpto = malloc(sizeof(struct __env_7));
  return txpto;
}


struct __env_6 {
 Value fib ; 
} ;

struct __env_6* __alloc_env6(Value fib){
  struct __env_6* txpto = malloc(sizeof(struct __env_6));
  txpto->fib = fib;
  return txpto;
}


struct __env_5 {
 Value fib ; 
} ;

struct __env_5* __alloc_env5(Value fib){
  struct __env_5* txpto = malloc(sizeof(struct __env_5));
  txpto->fib = fib;
  return txpto;
}


struct __env_4 {
 Value fib ; 
} ;

struct __env_4* __alloc_env4(Value fib){
  struct __env_4* txpto = malloc(sizeof(struct __env_4));
  txpto->fib = fib;
  return txpto;
}


struct __env_3 {
 Value fib ; 
} ;

struct __env_3* __alloc_env3(Value fib){
  struct __env_3* txpto = malloc(sizeof(struct __env_3));
  txpto->fib = fib;
  return txpto;
}


struct __env_2 {
 Value fib ; 
} ;

struct __env_2* __alloc_env2(Value fib){
  struct __env_2* txpto = malloc(sizeof(struct __env_2));
  txpto->fib = fib;
  return txpto;
}


struct __env_1 {
 Value fib ; 
} ;

struct __env_1* __alloc_env1(Value fib){
  struct __env_1* txpto = malloc(sizeof(struct __env_1));
  txpto->fib = fib;
  return txpto;
}


struct __env_0 {
 Value fib ; 
} ;

struct __env_0* __alloc_env0(Value fib){
  struct __env_0* txpto = malloc(sizeof(struct __env_0));
  txpto->fib = fib;
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
Value top(Value e,Value sexpr){
return __prim_pairCar(e, sexpr);}

Value __prim_top(Value e,Value sexpr){
return (top(e, sexpr)) ;
}


Value rest(Value e,Value sexpr){
return __prim_pairCdr(e, sexpr);}

Value __prim_rest(Value e,Value sexpr){
return (rest(e, sexpr)) ;
}


double floopsum(Value e,int ix,Value sx,double facc){
return __isNil(e,sx) ? facc : floopsum(e,(ix - 1),__prim_pairCdr(e, sx),(__fl(__prim_pairCar(e, sx)) + facc));}

Value __prim_floopsum(Value e,Value ix,Value sx,Value facc){
return MakeFloat(floopsum(e, ix.z.value, sx, facc.f.value)) ;
}


double floop(Value e,int ix,double fy){
return (ix < 1) ? fy : floop(e,(ix - 1),(fy + 0.1));}

Value __prim_floop(Value e,Value ix,Value fy){
return MakeFloat(floop(e, ix.z.value, fy.f.value)) ;
}


double fadd(Value e,double fx,double fy){
return (fx + fy);}

Value __prim_fadd(Value e,Value fx,Value fy){
return MakeFloat(fadd(e, fx.f.value, fy.f.value)) ;
}


Value mcons(Value e,Value xs){
return __prim_pairCons(e, __iexpr(e, 42), xs);}

Value __prim_mcons(Value e,Value xs){
return (mcons(e, xs)) ;
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
Value __lambda_8() ;
Value __lambda_7() ;
Value __lambda_6() ;
Value __lambda_5() ;
Value __lambda_4() ;
Value __lambda_3() ;
Value __lambda_2() ;
Value __lambda_1() ;
Value __lambda_0() ;

Value __lambda_8(Value env_731, Value fib) {
  Value tmp_7311 ; 
  return (tmp_7311 = MakeClosure(__lambda_7,MakeEnv(__alloc_env7())),tmp_7311.clo.lam(MakeEnv(tmp_7311.clo.env),NewCell(fib))) ;
}

Value __lambda_7(Value env_732, Value fib) {
  Value tmp_7312 ; 
  return (tmp_7312 = MakeClosure(__lambda_5,MakeEnv(__alloc_env5(fib))),tmp_7312.clo.lam(MakeEnv(tmp_7312.clo.env),(*(fib.cell.addr) = MakeClosure(__lambda_6,MakeEnv(__alloc_env6(fib)))))) ;
}

Value __lambda_6(Value env_739, Value n) {
  Value tmp_7330 ; 
  Value tmp_7331 ; 
  Value tmp_7332 ; 
  Value tmp_7333 ; 
  Value tmp_7334 ; 
  Value tmp_7335 ; 
  Value tmp_7336 ; 
  Value tmp_7337 ; 
  Value tmp_7338 ; 
  return (((tmp_7330 = __numLT,tmp_7330.clo.lam(MakeEnv(tmp_7330.clo.env),n, MakeInt(2)))).b.value ? ((tmp_7331 = __sum,tmp_7331.clo.lam(MakeEnv(tmp_7331.clo.env),n, MakeInt(1)))) : (MakeBoolean(0))).b.value ? (((tmp_7332 = __numLT,tmp_7332.clo.lam(MakeEnv(tmp_7332.clo.env),n, MakeInt(2)))).b.value ? ((tmp_7333 = __sum,tmp_7333.clo.lam(MakeEnv(tmp_7333.clo.env),n, MakeInt(1)))) : (MakeBoolean(0))) : ((tmp_7334 = __sum,tmp_7334.clo.lam(MakeEnv(tmp_7334.clo.env),(tmp_7335 = (*(((struct __env_6*)env_739.env.env)->fib.cell.addr)),tmp_7335.clo.lam(MakeEnv(tmp_7335.clo.env),(tmp_7336 = __difference,tmp_7336.clo.lam(MakeEnv(tmp_7336.clo.env),n, MakeInt(1))))), (tmp_7337 = (*(((struct __env_6*)env_739.env.env)->fib.cell.addr)),tmp_7337.clo.lam(MakeEnv(tmp_7337.clo.env),(tmp_7338 = __difference,tmp_7338.clo.lam(MakeEnv(tmp_7338.clo.env),n, MakeInt(2)))))))) ;
}

Value __lambda_5(Value env_733, Value _73_191) {
  Value tmp_7313 ; 
  Value tmp_7328 ; 
  Value tmp_7329 ; 
  return (tmp_7313 = MakeClosure(__lambda_4,MakeEnv(__alloc_env4(((struct __env_5*)env_733.env.env)->fib))),tmp_7313.clo.lam(MakeEnv(tmp_7313.clo.env),(tmp_7328 = __display,tmp_7328.clo.lam(MakeEnv(tmp_7328.clo.env),(tmp_7329 = (*(((struct __env_5*)env_733.env.env)->fib.cell.addr)),tmp_7329.clo.lam(MakeEnv(tmp_7329.clo.env),MakeInt(0))))))) ;
}

Value __lambda_4(Value env_734, Value _73_191) {
  Value tmp_7314 ; 
  Value tmp_7326 ; 
  Value tmp_7327 ; 
  return (tmp_7314 = MakeClosure(__lambda_3,MakeEnv(__alloc_env3(((struct __env_4*)env_734.env.env)->fib))),tmp_7314.clo.lam(MakeEnv(tmp_7314.clo.env),(tmp_7326 = __display,tmp_7326.clo.lam(MakeEnv(tmp_7326.clo.env),(tmp_7327 = (*(((struct __env_4*)env_734.env.env)->fib.cell.addr)),tmp_7327.clo.lam(MakeEnv(tmp_7327.clo.env),MakeInt(1))))))) ;
}

Value __lambda_3(Value env_735, Value _73_191) {
  Value tmp_7315 ; 
  Value tmp_7324 ; 
  Value tmp_7325 ; 
  return (tmp_7315 = MakeClosure(__lambda_2,MakeEnv(__alloc_env2(((struct __env_3*)env_735.env.env)->fib))),tmp_7315.clo.lam(MakeEnv(tmp_7315.clo.env),(tmp_7324 = __display,tmp_7324.clo.lam(MakeEnv(tmp_7324.clo.env),(tmp_7325 = (*(((struct __env_3*)env_735.env.env)->fib.cell.addr)),tmp_7325.clo.lam(MakeEnv(tmp_7325.clo.env),MakeInt(2))))))) ;
}

Value __lambda_2(Value env_736, Value _73_191) {
  Value tmp_7316 ; 
  Value tmp_7322 ; 
  Value tmp_7323 ; 
  return (tmp_7316 = MakeClosure(__lambda_1,MakeEnv(__alloc_env1(((struct __env_2*)env_736.env.env)->fib))),tmp_7316.clo.lam(MakeEnv(tmp_7316.clo.env),(tmp_7322 = __display,tmp_7322.clo.lam(MakeEnv(tmp_7322.clo.env),(tmp_7323 = (*(((struct __env_2*)env_736.env.env)->fib.cell.addr)),tmp_7323.clo.lam(MakeEnv(tmp_7323.clo.env),MakeInt(3))))))) ;
}

Value __lambda_1(Value env_737, Value _73_191) {
  Value tmp_7317 ; 
  Value tmp_7320 ; 
  Value tmp_7321 ; 
  return (tmp_7317 = MakeClosure(__lambda_0,MakeEnv(__alloc_env0(((struct __env_1*)env_737.env.env)->fib))),tmp_7317.clo.lam(MakeEnv(tmp_7317.clo.env),(tmp_7320 = __display,tmp_7320.clo.lam(MakeEnv(tmp_7320.clo.env),(tmp_7321 = (*(((struct __env_1*)env_737.env.env)->fib.cell.addr)),tmp_7321.clo.lam(MakeEnv(tmp_7321.clo.env),MakeInt(4))))))) ;
}

Value __lambda_0(Value env_738, Value _73_191) {
  Value tmp_7318 ; 
  Value tmp_7319 ; 
  return (tmp_7318 = __display,tmp_7318.clo.lam(MakeEnv(tmp_7318.clo.env),(tmp_7319 = (*(((struct __env_0*)env_738.env.env)->fib.cell.addr)),tmp_7319.clo.lam(MakeEnv(tmp_7319.clo.env),MakeInt(5))))) ;
}

int main (int argc, char* argv[]) {
  Value tmp_7310 ; 
__top = MakePrimitive(__prim_top) ;
__rest = MakePrimitive(__prim_rest) ;
__floopsum = MakePrimitive(__prim_floopsum) ;
__floop = MakePrimitive(__prim_floop) ;
__fadd = MakePrimitive(__prim_fadd) ;
__mcons = MakePrimitive(__prim_mcons) ;
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
  (tmp_7310 = MakeClosure(__lambda_8,MakeEnv(__alloc_env8())),tmp_7310.clo.lam(MakeEnv(tmp_7310.clo.env),MakeBoolean(0))) ;
  return 0;
 }

