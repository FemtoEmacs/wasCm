#include <gc.h>
#include <string.h>

struct Int ;
struct Boolean ;
struct Closure ;
union Value ;

enum Tag { VOID, INT, BOOLEAN, CLOSURE, CELL,
             ENV, CONS, FLOAT, STR, NIL, CHAR} ;

typedef union Value (*Lambda)()  ;

struct Int {
  enum Tag t ;
  int value ;
} ;

struct Float {
  enum Tag t ;
  float value ;
} ;

struct Nil {
  enum Tag t ;
} ;

struct Str {
  enum Tag t ;
  char *value ;
} ;

struct Boolean {
  enum Tag t ;
  unsigned int value ;
} ;

struct Closure {
  enum Tag t ;
  Lambda lam ;
  void* env ;
} ;

struct Env {
  enum Tag t ;
  void* env ;
} ;

struct Cell {
  enum Tag t ;
  union Value* addr ; 
} ;

struct Cons {
  enum Tag t ;
  union Value* car ;
  union Value* cdr;
} ;

struct Char {
  enum Tag t ;
  unsigned int value ;
};

union Value {
  enum Tag t ;
  struct Int z ;
  struct Boolean b ;
  struct Closure clo ;
  struct Env env ;
  struct Cell cell ;
  struct Cons cons;
  struct Float f;
  struct Str s;
  struct Nil n;
  struct Char c;
} ;

typedef union Value Value ;

static Value MakeClosure(Lambda lam, Value env) {
  Value v ;
  v.clo.t = CLOSURE ;
  v.clo.lam = lam ;
  v.clo.env = env.env.env ;
  return v ;
}

static Value MakeNil() {
  Value v ;
  v.n.t = NIL ;
  return v ;
}

static Value MakeChar(int n) {
  Value v ;
  v.c.t = CHAR ;
  v.c.value = n ;
  return v ;
}

static Value MakeInt(int n) {
  Value v ;
  v.z.t = INT ;
  v.z.value = n ;
  return v ;
}

static Value MakeFloat(double n) {
  Value v ;
  v.f.t = FLOAT ;
  v.f.value = n ;
  return v ;
}

static Value MakeStr(char *str) {
  Value v ;
  char *newstr;
  int len= strlen(str);
  newstr= GC_MALLOC(len+1);
  strcpy(newstr, str);
  *(newstr+len)= 0;
  v.s.t = STR ;
  v.s.value = newstr ;
  return v ;
}


static Value MakeBoolean(unsigned int b) {
  Value v ;
  v.b.t = BOOLEAN ;
  v.b.value = b ;
  return v ;
}

static Value MakePrimitive(Lambda prim) {
  Value v ;
  v.clo.t = CLOSURE ;
  v.clo.lam = prim ;
  v.clo.env = NULL ;
  return v ;
}

static Value MakeEnv(void* env) {
  Value v ;
  v.env.t = ENV ;
  v.env.env = env ;
  return v ;
}


static Value NewCell(Value initialValue) {
  Value v ;
  v.cell.t = CELL ;
  v.cell.addr = GC_MALLOC(sizeof(Value)) ;
  *v.cell.addr = initialValue ;
  return v ;
}

static Value NewCons(Value fst, Value rst) {
  Value v ;
  v.cons.t = CONS ;
  v.cons.car = GC_MALLOC(sizeof(Value)) ;
  *v.cons.car = fst ;
  v.cons.cdr = GC_MALLOC(sizeof(Value));
  if (rst.b.t == BOOLEAN) 
       *v.cons.cdr= MakeNil();
  else *v.cons.cdr = rst;
  return v ;
}

int prsexpr (Value s) {
    if (s.z.t == INT) {
     printf("%i", s.z.value);
     return 1;}
    if (s.b.t == BOOLEAN) {
      if (s.b.value == 0) printf("#f");
      else printf("#t");
      return 1;}
    if (s.f.t == FLOAT) {
      printf("%.4f", s.f.value);
      return 1;}
    if (s.s.t == STR) {
      printf("%s", s.s.value);
    }
    if (s.c.t == CHAR) {
      printf("#\\%c", s.c.value);
    }
   if (s.cons.t != CONS) {
     return 0;}
   printf("(");
   while (s.cons.t == CONS) {
      prsexpr(*s.cons.car);
      s = *s.cons.cdr;
      if (s.cons.t == CONS) printf(" ");
   }
   printf(")");
   return 1;
}

extern Value __sum ;
extern Value __difference ;
extern Value __product ;
extern Value __display ;
extern Value __numEqual ;

