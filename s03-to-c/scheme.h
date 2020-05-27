// #include <gc.h>
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
  double value ;
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
  newstr= malloc(len+1);
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
  v.cell.addr = malloc(sizeof(Value)) ;
  *v.cell.addr = initialValue ;
  return v ;
}

static Value NewCons(Value fst, Value rst) {
  Value v ;
  v.cons.t = CONS ;
  v.cons.car = malloc(sizeof(Value)) ;
  *v.cons.car = fst ;
  v.cons.cdr = malloc(sizeof(Value));
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


// Read sexpr

char * ss= " (\"Rosa\" (84) (tu (56.3 57) tu) 42)";

void whine(const char *s) {
  fprintf(stderr, "parse error before ==>%.10s\n", s);}

char *ignore_blank(int e, char *s) {
  while ( (*s == ' ') || (*s == '\n') ) s++;
  if ((!*s) && (e != 0)) {
    fprintf(stderr, "Malformed sexpr -ignore blank\n");
    exit(512);}
  return s;
}

Value parse_string(int *e)
{
	Value ex;
	char buf[256] = {0};
	int i = 0;
	ss= ignore_blank(*e, ss);
        while (*ss) {
		if (i >= 256) {
			fprintf(stderr, "string too long:\n");
			goto fail;
		}
		switch (*ss) {
		case '\\':
			switch (*++ss) {
			case '\\':
			case '"':	buf[i++] = *ss++;
					continue;
 
			default:	whine(ss);
					goto fail;
			}
		case '"':
		  ss++;
		   goto success;
		default:	buf[i++] = *ss++;
		}
	}
	if ((!*ss) && *e !=0) {printf("Malformed sexpr"); exit(3);}
fail:
	return MakeBoolean(0);
 
success:
	return MakeStr(buf);
}

Value parse_symbol(int *e){
	char buf[256] = {0};
	int i = 0;
	ss= ignore_blank(*e, ss);
        while (*ss) {
		if (i >= 256) {
			fprintf(stderr, "symbol too long:\n");
			goto fail;
		}
		switch (*ss) {
		case ' ':
		case '\n':
		  ss++;
		   goto success;
		default:
                   if (*ss == ')' || *ss == '(') {goto success;}
                   else buf[i++] = *ss++;}
	}
	if ((!*ss) && *e !=0) {printf("Malformed sexpr"); exit(3);}
fail:
	return MakeBoolean(0);
 
success:
	return MakeStr(buf);}


Value parse_int(int *e)
{
  int fp= 0;
  int i = 0;
  double acc= 0.0;
	
	while (*ss) {
		if (i >= 5) {
			fprintf(stderr, "integer too long:\n");
			whine(ss);
			goto fail;
		}
		if ((*ss == ' ') || (*ss == '\n') ) goto success;
		if (ss == NULL) goto success;
		if (*ss == ')' || *ss == '(') {
		  goto success;
		}
		if (*ss == '.') {fp= 1; ss++; continue; }
		if ( ((*ss - 48) >= 0) &&
		     ((*ss - 48) <= 9) && (!fp))
		  { acc = acc*10 + (*ss++ - 48); continue;}
		if ( ((*ss - 48) >= 0) &&
		     ((*ss - 48) <= 9) && fp)
		  {fp= fp*10; 
		    acc= acc + (*ss++ - 48)/((double) fp);
		    continue; }
	}
	if ((!*ss) && *e !=0) {printf("Malformed sexpr"); exit(3);}

fail:
	return MakeBoolean(0);
 
success:
	if (!fp) return MakeInt((int) acc);
	else return MakeFloat(acc);
}

Value parse_term(int *e);


Value parse_list(int *e)
{
	Value ex;
        Value hd;
	Value tl;
	hd= parse_term(e);
	ss= ignore_blank(*e, ss);
	if (*ss == ')') {
	  ss++; *e= *e-1;
	  return NewCons(hd, MakeNil());}
	
	ss = ignore_blank(*e, ss);
	tl= parse_list(e);
	return NewCons(hd, tl);
}


Value parse_term(int *e)
{ 
 
  ss= ignore_blank(*e, ss);
		switch(*ss) {
		case '(':
		  ss++;
		  ss= ignore_blank(*e, ss);
		  if (*ss == ')') {ss++; return MakeNil();} 
		  else {
                    *e= *e+1;
		    return parse_list(e);}
		case '"':
		  ss= ss+1;
			return parse_string(e);
		case '0': case '1': case '2': case '3':
		case '4': case '5': case '6': case '7':
		case '8': case '9':
		  return parse_int(e);
		default:
		  if ( (*ss >= 'a') && (*ss <= 'z')) 
		    return parse_symbol(e);
		}
	
	return MakeBoolean(0);
}
