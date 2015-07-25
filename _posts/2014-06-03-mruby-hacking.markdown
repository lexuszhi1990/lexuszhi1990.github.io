---
layout: post
title: "mruby-hacking"
date: 2014-06-03 13:02:42 +0800
comments: true
published: false
categories: [dev, mruby]
---

mruby hacking
-------------

### mruby value

```
# http://lian-notes.readthedocs.org/en/latest/mruby-object-model.html

# value.h:136
typedef struct mrb_value {
  union {
    mrb_float f;
    union {
      void *p;
      struct {
  MRB_ENDIAN_LOHI(
    uint32_t ttt;
          ,union {
      mrb_int i;
      mrb_sym sym;
    };
        )
      };
    } value;
  };
} mrb_value;

enum mrb_vtype {
  MRB_TT_FALSE = 0,   /*   0 */
  MRB_TT_FREE,        /*   1 */
  MRB_TT_TRUE,        /*   2 */
  MRB_TT_FIXNUM,      /*   3 */
  MRB_TT_SYMBOL,      /*   4 */
  MRB_TT_UNDEF,       /*   5 */
  MRB_TT_FLOAT,       /*   6 */
  MRB_TT_CPTR,        /*   7 */
  MRB_TT_OBJECT,      /*   8 */
  MRB_TT_CLASS,       /*   9 */
  MRB_TT_MODULE,      /*  10 */
  MRB_TT_ICLASS,      /*  11 */
  MRB_TT_SCLASS,      /*  12 */
  MRB_TT_PROC,        /*  13 */
  MRB_TT_ARRAY,       /*  14 */
  MRB_TT_HASH,        /*  15 */
  MRB_TT_STRING,      /*  16 */
  MRB_TT_RANGE,       /*  17 */
  MRB_TT_EXCEPTION,   /*  18 */
  MRB_TT_FILE,        /*  19 */
  MRB_TT_ENV,         /*  20 */
  MRB_TT_DATA,        /*  21 */
  MRB_TT_FIBER,       /*  22 */
  MRB_TT_MAXDEFINE    /*  23 */
};

```

* mrb state *

```ruby
# mruby.h:105

typedef struct mrb_state {
  struct mrb_jmpbuf *jmp;

  mrb_allocf allocf;                      /* memory allocation function */

  struct mrb_context *c;
  struct mrb_context *root_c;

  struct RObject *exc;                    /* exception */
  struct iv_tbl *globals;                 /* global variable table */

  struct RObject *top_self;
  struct RClass *object_class;            /* Object class */
  struct RClass *class_class;
  struct RClass *module_class;
  struct RClass *proc_class;
  struct RClass *string_class;
  struct RClass *array_class;
  struct RClass *hash_class;

  struct RClass *float_class;
  struct RClass *fixnum_class;
  struct RClass *true_class;
  struct RClass *false_class;
  struct RClass *nil_class;
  struct RClass *symbol_class;
  struct RClass *kernel_module;

  struct heap_page *heaps;                /* heaps for GC */
  struct heap_page *sweeps;
  struct heap_page *free_heaps;
  size_t live; /* count of live objects */
#ifdef MRB_GC_FIXED_ARENA
  struct RBasic *arena[MRB_GC_ARENA_SIZE]; /* GC protection array */
#else
  struct RBasic **arena;                   /* GC protection array */
  int arena_capa;
#endif
  int arena_idx;

  enum gc_state gc_state; /* state of gc */
  int current_white_part; /* make white object by white_part */
  struct RBasic *gray_list; /* list of gray objects to be traversed incrementally */
  struct RBasic *atomic_gray_list; /* list of objects to be traversed atomically */
  size_t gc_live_after_mark;
  size_t gc_threshold;
  int gc_interval_ratio;
  int gc_step_ratio;
  mrb_bool gc_disabled:1;
  mrb_bool gc_full:1;
  mrb_bool is_generational_gc_mode:1;
  mrb_bool out_of_memory:1;
  size_t majorgc_old_threshold;
  struct alloca_header *mems;

  mrb_sym symidx;
  struct kh_n2s *name2sym;      /* symbol table */

#ifdef ENABLE_DEBUG
  void (*code_fetch_hook)(struct mrb_state* mrb, struct mrb_irep *irep, mrb_code *pc, mrb_value *regs);
  void (*debug_op_hook)(struct mrb_state* mrb, struct mrb_irep *irep, mrb_code *pc, mrb_value *regs);
#endif

  struct RClass *eException_class;
  struct RClass *eStandardError_class;

  void *ud; /* auxiliary data */
} mrb_state;
```

### struct RClass

```
# class.h:14
struct RClass {
  MRB_OBJECT_HEADER;
  struct iv_tbl *iv;
  struct kh_mt *mt;
  struct RClass *super;
};

# value.h:345
#define MRB_OBJECT_HEADER \
  enum mrb_vtype tt:8;\
  uint32_t color:3;\
  uint32_t flags:21;\
  struct RClass *c;\
  struct RBasic *gcnext


# TODO: to be hacking
```

### `mrb_get_args` function

```
retrieve arguments from mrb_state.
class.c:187

/*
  mrb_get_args(mrb, format, ...)

  returns number of arguments parsed.

  format specifiers:

    string  mruby type     C type                 note
    ----------------------------------------------------------------------------------------------
    o:      Object         [mrb_value]
    C:      class/module   [mrb_value]
    S:      String         [mrb_value]
    A:      Array          [mrb_value]
    H:      Hash           [mrb_value]
    s:      String         [char*,mrb_int]        Receive two arguments.
    z:      String         [char*]                NUL terminated string.
    a:      Array          [mrb_value*,mrb_int]   Receive two arguments.
    f:      Float          [mrb_float]
    i:      Integer        [mrb_int]
    b:      Boolean        [mrb_bool]
    n:      Symbol         [mrb_sym]
    d:      Data           [void*,mrb_data_type const] 2nd argument will be used to check data type so it won't be modified
    &:      Block          [mrb_value]
    *:      rest argument  [mrb_value*,mrb_int]   Receive the rest of the arguments as an array.
    |:      optional                              Next argument of '|' and later are optional.
    ?:      optional given [mrb_bool]             true if preceding argument (optional) is given.
 */
mrb_int
mrb_get_args(mrb_state *mrb, const char *format, ...)
{
  char c;
  int i = 0;
  mrb_value *sp = mrb->c->stack + 1;
  va_list ap;
  int argc = mrb->c->ci->argc;
  mrb_bool opt = 0;
  mrb_bool given = 1;

  va_start(ap, format);
  if (argc < 0) {
    struct RArray *a = mrb_ary_ptr(mrb->c->stack[1]);

    argc = a->len;
    sp = a->ptr;
  }
  while ((c = *format++)) {
    switch (c) {
    case '|': case '*': case '&': case '?':
      break;
    default:
      if (argc <= i) {
        if (opt) {
          given = 0;
        }
        else {
          mrb_raise(mrb, E_ARGUMENT_ERROR, "wrong number of arguments");
        }
      }
      break;
    }

    switch (c) {
    case 'o':
      {
        mrb_value *p;

        p = va_arg(ap, mrb_value*);
        if (i < argc) {
          *p = *sp++;
          i++;
        }
      }
      break;
    case 'C':
      {
        mrb_value *p;

        p = va_arg(ap, mrb_value*);
        if (i < argc) {
          mrb_value ss;

          ss = *sp++;
          switch (mrb_type(ss)) {
          case MRB_TT_CLASS:
          case MRB_TT_MODULE:
          case MRB_TT_SCLASS:
            break;
          default:
            mrb_raisef(mrb, E_TYPE_ERROR, "%S is not class/module", ss);
            break;
          }
          *p = ss;
          i++;
        }
      }
      break;
    case 'S':
      {
        mrb_value *p;

        p = va_arg(ap, mrb_value*);
        if (i < argc) {
          *p = to_str(mrb, *sp++);
          i++;
        }
      }
      break;
    case 'A':
      {
        mrb_value *p;

        p = va_arg(ap, mrb_value*);
        if (i < argc) {
          *p = to_ary(mrb, *sp++);
          i++;
        }
      }
      break;
    case 'H':
      {
        mrb_value *p;

        p = va_arg(ap, mrb_value*);
        if (i < argc) {
          *p = to_hash(mrb, *sp++);
          i++;
        }
      }
      break;
    case 's':
      {
        mrb_value ss;
        char **ps = 0;
        mrb_int *pl = 0;

        ps = va_arg(ap, char**);
        pl = va_arg(ap, mrb_int*);
        if (i < argc) {
          ss = to_str(mrb, *sp++);
          *ps = RSTRING_PTR(ss);
          *pl = RSTRING_LEN(ss);
          i++;
        }
      }
      break;
    case 'z':
      {
        mrb_value ss;
        char **ps;

        ps = va_arg(ap, char**);
        if (i < argc) {
          ss = to_str(mrb, *sp++);
          *ps = mrb_string_value_cstr(mrb, &ss);
          i++;
        }
      }
      break;
    case 'a':
      {
        mrb_value aa;
        struct RArray *a;
        mrb_value **pb;
        mrb_int *pl;

        pb = va_arg(ap, mrb_value**);
        pl = va_arg(ap, mrb_int*);
        if (i < argc) {
          aa = to_ary(mrb, *sp++);
          a = mrb_ary_ptr(aa);
          *pb = a->ptr;
          *pl = a->len;
          i++;
        }
      }
      break;
    case 'f':
      {
        mrb_float *p;

        p = va_arg(ap, mrb_float*);
        if (i < argc) {
          *p = mrb_to_flo(mrb, *sp);
          sp++;
          i++;
        }
      }
      break;
    case 'i':
      {
        mrb_int *p;

        p = va_arg(ap, mrb_int*);
        if (i < argc) {
          switch (mrb_type(*sp)) {
            case MRB_TT_FIXNUM:
              *p = mrb_fixnum(*sp);
              break;
            case MRB_TT_FLOAT:
              {
                mrb_float f = mrb_float(*sp);

                if (!FIXABLE(f)) {
                  mrb_raise(mrb, E_RANGE_ERROR, "float too big for int");
                }
                *p = (mrb_int)f;
              }
              break;
            case MRB_TT_STRING:
              mrb_raise(mrb, E_TYPE_ERROR, "no implicit conversion of String into Integer");
              break;
            default:
              *p = mrb_fixnum(mrb_Integer(mrb, *sp));
              break;
          }
          sp++;
          i++;
        }
      }
      break;
    case 'b':
      {
        mrb_bool *boolp = va_arg(ap, mrb_bool*);

        if (i < argc) {
          mrb_value b = *sp++;
          *boolp = mrb_test(b);
          i++;
        }
      }
      break;
    case 'n':
      {
        mrb_sym *symp;

        symp = va_arg(ap, mrb_sym*);
        if (i < argc) {
          mrb_value ss;

          ss = *sp++;
          if (mrb_type(ss) == MRB_TT_SYMBOL) {
            *symp = mrb_symbol(ss);
          }
          else if (mrb_string_p(ss)) {
            *symp = mrb_intern_str(mrb, to_str(mrb, ss));
          }
          else {
            mrb_value obj = mrb_funcall(mrb, ss, "inspect", 0);
            mrb_raisef(mrb, E_TYPE_ERROR, "%S is not a symbol", obj);
          }
          i++;
        }
      }
      break;
    case 'd':
      {
        void** datap;
        struct mrb_data_type const* type;

        datap = va_arg(ap, void**);
        type = va_arg(ap, struct mrb_data_type const*);
        if (i < argc) {
          *datap = mrb_data_get_ptr(mrb, *sp++, type);
          ++i;
        }
      }
      break;

    case '&':
      {
        mrb_value *p, *bp;

        p = va_arg(ap, mrb_value*);
        if (mrb->c->ci->argc < 0) {
          bp = mrb->c->stack + 2;
        }
        else {
          bp = mrb->c->stack + mrb->c->ci->argc + 1;
        }
        *p = *bp;
      }
      break;
    case '|':
      opt = 1;
      break;
    case '?':
      {
        mrb_bool *p;

        p = va_arg(ap, mrb_bool*);
        *p = given;
      }
      break;

    case '*':
      {
        mrb_value **var;
        mrb_int *pl;

        var = va_arg(ap, mrb_value**);
        pl = va_arg(ap, mrb_int*);
        if (argc > i) {
          *pl = argc-i;
          if (*pl > 0) {
            *var = sp;
          }
          i = argc;
          sp += *pl;
        }
        else {
          *pl = 0;
          *var = NULL;
        }
      }
      break;
    default:
      mrb_raisef(mrb, E_ARGUMENT_ERROR, "invalid argument specifier %S", mrb_str_new(mrb, &c, 1));
      break;
    }
  }
  if (!c && argc > i) {
    mrb_raise(mrb, E_ARGUMENT_ERROR, "wrong number of arguments");
  }
  va_end(ap);
  return i;
}


# TODO: to be hacking.
```
