/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30802

/* Bison version string.  */
#define YYBISON_VERSION "3.8.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Substitute the type names.  */
#define YYSTYPE         EX_STYPE
/* Substitute the variable and function names.  */
#define yyparse         ex_parse
#define yylex           ex_lex
#define yyerror         ex_error
#define yydebug         ex_debug
#define yynerrs         ex_nerrs
#define yylval          ex_lval
#define yychar          ex_char

/* First part of user prologue.  */
#line 19 "../../lib/expr/exparse.y"


/*
 * Glenn Fowler
 * AT&T Research
 *
 * expression library grammar and compiler
 */

#include <assert.h>
#include <expr/exop.h>
#include <stdalign.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ast/ast.h>
#include <util/arena.h>
#include <util/gv_ctype.h>
#include <util/streq.h>


#line 102 "exparse.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

#include "exparse.h"
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_MINTOKEN = 3,                   /* MINTOKEN  */
  YYSYMBOL_INTEGER = 4,                    /* INTEGER  */
  YYSYMBOL_UNSIGNED = 5,                   /* UNSIGNED  */
  YYSYMBOL_CHARACTER = 6,                  /* CHARACTER  */
  YYSYMBOL_FLOATING = 7,                   /* FLOATING  */
  YYSYMBOL_STRING = 8,                     /* STRING  */
  YYSYMBOL_VOIDTYPE = 9,                   /* VOIDTYPE  */
  YYSYMBOL_ADDRESS = 10,                   /* ADDRESS  */
  YYSYMBOL_ARRAY = 11,                     /* ARRAY  */
  YYSYMBOL_BREAK = 12,                     /* BREAK  */
  YYSYMBOL_CALL = 13,                      /* CALL  */
  YYSYMBOL_CASE = 14,                      /* CASE  */
  YYSYMBOL_CONSTANT = 15,                  /* CONSTANT  */
  YYSYMBOL_CONTINUE = 16,                  /* CONTINUE  */
  YYSYMBOL_DECLARE = 17,                   /* DECLARE  */
  YYSYMBOL_DEFAULT = 18,                   /* DEFAULT  */
  YYSYMBOL_DYNAMIC = 19,                   /* DYNAMIC  */
  YYSYMBOL_ELSE = 20,                      /* ELSE  */
  YYSYMBOL_EXIT = 21,                      /* EXIT  */
  YYSYMBOL_FOR = 22,                       /* FOR  */
  YYSYMBOL_FUNCTION = 23,                  /* FUNCTION  */
  YYSYMBOL_GSUB = 24,                      /* GSUB  */
  YYSYMBOL_ITERATE = 25,                   /* ITERATE  */
  YYSYMBOL_ITERATOR = 26,                  /* ITERATOR  */
  YYSYMBOL_ID = 27,                        /* ID  */
  YYSYMBOL_IF = 28,                        /* IF  */
  YYSYMBOL_LABEL = 29,                     /* LABEL  */
  YYSYMBOL_MEMBER = 30,                    /* MEMBER  */
  YYSYMBOL_NAME = 31,                      /* NAME  */
  YYSYMBOL_POS = 32,                       /* POS  */
  YYSYMBOL_PRAGMA = 33,                    /* PRAGMA  */
  YYSYMBOL_PRE = 34,                       /* PRE  */
  YYSYMBOL_PRINT = 35,                     /* PRINT  */
  YYSYMBOL_PRINTF = 36,                    /* PRINTF  */
  YYSYMBOL_PROCEDURE = 37,                 /* PROCEDURE  */
  YYSYMBOL_QUERY = 38,                     /* QUERY  */
  YYSYMBOL_RAND = 39,                      /* RAND  */
  YYSYMBOL_RETURN = 40,                    /* RETURN  */
  YYSYMBOL_SCANF = 41,                     /* SCANF  */
  YYSYMBOL_SPLIT = 42,                     /* SPLIT  */
  YYSYMBOL_SPRINTF = 43,                   /* SPRINTF  */
  YYSYMBOL_SRAND = 44,                     /* SRAND  */
  YYSYMBOL_SSCANF = 45,                    /* SSCANF  */
  YYSYMBOL_SUB = 46,                       /* SUB  */
  YYSYMBOL_SUBSTR = 47,                    /* SUBSTR  */
  YYSYMBOL_SWITCH = 48,                    /* SWITCH  */
  YYSYMBOL_TOKENS = 49,                    /* TOKENS  */
  YYSYMBOL_UNSET = 50,                     /* UNSET  */
  YYSYMBOL_WHILE = 51,                     /* WHILE  */
  YYSYMBOL_F2I = 52,                       /* F2I  */
  YYSYMBOL_F2S = 53,                       /* F2S  */
  YYSYMBOL_I2F = 54,                       /* I2F  */
  YYSYMBOL_I2S = 55,                       /* I2S  */
  YYSYMBOL_S2B = 56,                       /* S2B  */
  YYSYMBOL_S2F = 57,                       /* S2F  */
  YYSYMBOL_S2I = 58,                       /* S2I  */
  YYSYMBOL_F2X = 59,                       /* F2X  */
  YYSYMBOL_I2X = 60,                       /* I2X  */
  YYSYMBOL_S2X = 61,                       /* S2X  */
  YYSYMBOL_X2F = 62,                       /* X2F  */
  YYSYMBOL_X2I = 63,                       /* X2I  */
  YYSYMBOL_X2S = 64,                       /* X2S  */
  YYSYMBOL_X2X = 65,                       /* X2X  */
  YYSYMBOL_XPRINT = 66,                    /* XPRINT  */
  YYSYMBOL_67_ = 67,                       /* ','  */
  YYSYMBOL_68_ = 68,                       /* '='  */
  YYSYMBOL_69_ = 69,                       /* '?'  */
  YYSYMBOL_70_ = 70,                       /* ':'  */
  YYSYMBOL_OR = 71,                        /* OR  */
  YYSYMBOL_AND = 72,                       /* AND  */
  YYSYMBOL_73_ = 73,                       /* '|'  */
  YYSYMBOL_74_ = 74,                       /* '^'  */
  YYSYMBOL_75_ = 75,                       /* '&'  */
  YYSYMBOL_EQ = 76,                        /* EQ  */
  YYSYMBOL_NE = 77,                        /* NE  */
  YYSYMBOL_78_ = 78,                       /* '<'  */
  YYSYMBOL_79_ = 79,                       /* '>'  */
  YYSYMBOL_LE = 80,                        /* LE  */
  YYSYMBOL_GE = 81,                        /* GE  */
  YYSYMBOL_LSH = 82,                       /* LSH  */
  YYSYMBOL_RSH = 83,                       /* RSH  */
  YYSYMBOL_84_ = 84,                       /* '+'  */
  YYSYMBOL_85_ = 85,                       /* '-'  */
  YYSYMBOL_IN_OP = 86,                     /* IN_OP  */
  YYSYMBOL_87_ = 87,                       /* '*'  */
  YYSYMBOL_88_ = 88,                       /* '/'  */
  YYSYMBOL_89_ = 89,                       /* '%'  */
  YYSYMBOL_90_ = 90,                       /* '!'  */
  YYSYMBOL_91_ = 91,                       /* '~'  */
  YYSYMBOL_92_ = 92,                       /* '#'  */
  YYSYMBOL_UNARY = 93,                     /* UNARY  */
  YYSYMBOL_INC = 94,                       /* INC  */
  YYSYMBOL_DEC = 95,                       /* DEC  */
  YYSYMBOL_CAST = 96,                      /* CAST  */
  YYSYMBOL_97_ = 97,                       /* '('  */
  YYSYMBOL_MAXTOKEN = 98,                  /* MAXTOKEN  */
  YYSYMBOL_99_ = 99,                       /* '{'  */
  YYSYMBOL_100_ = 100,                     /* '}'  */
  YYSYMBOL_101_ = 101,                     /* ';'  */
  YYSYMBOL_102_ = 102,                     /* ')'  */
  YYSYMBOL_103_ = 103,                     /* '['  */
  YYSYMBOL_104_ = 104,                     /* ']'  */
  YYSYMBOL_105_ = 105,                     /* '.'  */
  YYSYMBOL_YYACCEPT = 106,                 /* $accept  */
  YYSYMBOL_program = 107,                  /* program  */
  YYSYMBOL_action_list = 108,              /* action_list  */
  YYSYMBOL_action = 109,                   /* action  */
  YYSYMBOL_110_1 = 110,                    /* $@1  */
  YYSYMBOL_statement_list = 111,           /* statement_list  */
  YYSYMBOL_statement = 112,                /* statement  */
  YYSYMBOL_113_2 = 113,                    /* $@2  */
  YYSYMBOL_114_3 = 114,                    /* $@3  */
  YYSYMBOL_switch_list = 115,              /* switch_list  */
  YYSYMBOL_switch_item = 116,              /* switch_item  */
  YYSYMBOL_case_list = 117,                /* case_list  */
  YYSYMBOL_case_item = 118,                /* case_item  */
  YYSYMBOL_dcl_list = 119,                 /* dcl_list  */
  YYSYMBOL_dcl_item = 120,                 /* dcl_item  */
  YYSYMBOL_121_4 = 121,                    /* $@4  */
  YYSYMBOL_dcl_name = 122,                 /* dcl_name  */
  YYSYMBOL_name = 123,                     /* name  */
  YYSYMBOL_else_opt = 124,                 /* else_opt  */
  YYSYMBOL_expr_opt = 125,                 /* expr_opt  */
  YYSYMBOL_expr = 126,                     /* expr  */
  YYSYMBOL_127_5 = 127,                    /* $@5  */
  YYSYMBOL_128_6 = 128,                    /* $@6  */
  YYSYMBOL_splitop = 129,                  /* splitop  */
  YYSYMBOL_constant = 130,                 /* constant  */
  YYSYMBOL_print = 131,                    /* print  */
  YYSYMBOL_scan = 132,                     /* scan  */
  YYSYMBOL_variable = 133,                 /* variable  */
  YYSYMBOL_array = 134,                    /* array  */
  YYSYMBOL_index = 135,                    /* index  */
  YYSYMBOL_args = 136,                     /* args  */
  YYSYMBOL_arg_list = 137,                 /* arg_list  */
  YYSYMBOL_formals = 138,                  /* formals  */
  YYSYMBOL_formal_list = 139,              /* formal_list  */
  YYSYMBOL_formal_item = 140,              /* formal_item  */
  YYSYMBOL_141_7 = 141,                    /* $@7  */
  YYSYMBOL_members = 142,                  /* members  */
  YYSYMBOL_member = 143,                   /* member  */
  YYSYMBOL_assign = 144,                   /* assign  */
  YYSYMBOL_initialize = 145,               /* initialize  */
  YYSYMBOL_146_8 = 146,                    /* $@8  */
  YYSYMBOL_147_9 = 147                     /* $@9  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;


/* Second part of user prologue.  */
#line 171 "../../lib/expr/exparse.y"


#include <expr/exgram.h>

void ex_error(const char *message);


#line 291 "exparse.c"


#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_int16 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if !defined yyoverflow

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* !defined yyoverflow */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined EX_STYPE_IS_TRIVIAL && EX_STYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1120

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  106
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  42
/* YYNRULES -- Number of rules.  */
#define YYNRULES  141
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  285

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   335


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    90,     2,    92,     2,    89,    75,     2,
      97,   102,    87,    84,    67,    85,   105,    88,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    70,   101,
      78,    68,    79,    69,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,   103,     2,   104,    74,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    99,    73,   100,    91,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    71,    72,    76,    77,    80,    81,    82,    83,
      86,    93,    94,    95,    96,    98
};

#if EX_DEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   181,   181,   199,   200,   203,   203,   238,   241,   256,
     260,   264,   264,   269,   279,   292,   307,   320,   328,   339,
     349,   349,   359,   371,   375,   388,   404,   407,   439,   440,
     443,   461,   467,   468,   475,   475,   523,   524,   525,   526,
     529,   530,   534,   537,   544,   547,   550,   554,   558,   611,
     615,   619,   623,   627,   631,   635,   639,   643,   647,   651,
     655,   659,   663,   667,   671,   684,   688,   698,   698,   698,
     739,   759,   766,   771,   775,   779,   783,   787,   791,   795,
     799,   803,   807,   811,   815,   821,   825,   829,   835,   840,
     844,   869,   905,   925,   933,   941,   952,   961,   965,   969,
     972,   973,   975,   983,   988,   993,   998,  1005,  1006,  1007,
    1010,  1011,  1014,  1018,  1036,  1049,  1052,  1056,  1070,  1073,
    1080,  1083,  1091,  1096,  1103,  1106,  1112,  1115,  1119,  1130,
    1130,  1146,  1149,  1160,  1178,  1182,  1188,  1191,  1198,  1199,
    1211,  1199
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if EX_DEBUG || 1
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "MINTOKEN", "INTEGER",
  "UNSIGNED", "CHARACTER", "FLOATING", "STRING", "VOIDTYPE", "ADDRESS",
  "ARRAY", "BREAK", "CALL", "CASE", "CONSTANT", "CONTINUE", "DECLARE",
  "DEFAULT", "DYNAMIC", "ELSE", "EXIT", "FOR", "FUNCTION", "GSUB",
  "ITERATE", "ITERATOR", "ID", "IF", "LABEL", "MEMBER", "NAME", "POS",
  "PRAGMA", "PRE", "PRINT", "PRINTF", "PROCEDURE", "QUERY", "RAND",
  "RETURN", "SCANF", "SPLIT", "SPRINTF", "SRAND", "SSCANF", "SUB",
  "SUBSTR", "SWITCH", "TOKENS", "UNSET", "WHILE", "F2I", "F2S", "I2F",
  "I2S", "S2B", "S2F", "S2I", "F2X", "I2X", "S2X", "X2F", "X2I", "X2S",
  "X2X", "XPRINT", "','", "'='", "'?'", "':'", "OR", "AND", "'|'", "'^'",
  "'&'", "EQ", "NE", "'<'", "'>'", "LE", "GE", "LSH", "RSH", "'+'", "'-'",
  "IN_OP", "'*'", "'/'", "'%'", "'!'", "'~'", "'#'", "UNARY", "INC", "DEC",
  "CAST", "'('", "MAXTOKEN", "'{'", "'}'", "';'", "')'", "'['", "']'",
  "'.'", "$accept", "program", "action_list", "action", "$@1",
  "statement_list", "statement", "$@2", "$@3", "switch_list",
  "switch_item", "case_list", "case_item", "dcl_list", "dcl_item", "$@4",
  "dcl_name", "name", "else_opt", "expr_opt", "expr", "$@5", "$@6",
  "splitop", "constant", "print", "scan", "variable", "array", "index",
  "args", "arg_list", "formals", "formal_list", "formal_item", "$@7",
  "members", "member", "assign", "initialize", "$@8", "$@9", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#define YYPACT_NINF (-181)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-126)

#define yytable_value_is_error(Yyn) \
  ((Yyn) == YYTABLE_NINF)

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    -181,     9,   231,  -181,  -181,  -181,  -181,  -181,   -71,   713,
    -181,   713,  -181,   -69,   -62,   -44,   -41,   -39,   -34,   -17,
       1,  -181,     8,  -181,    11,  -181,    14,   713,  -181,  -181,
    -181,    21,  -181,    28,    30,    31,  -181,    33,    36,    73,
     713,   713,   713,   713,   101,    73,    73,   619,  -181,    64,
    -181,    35,   893,    40,  -181,    46,    47,   -55,   713,    44,
      48,    72,   713,   -17,   713,   713,   713,   713,    73,   -11,
    -181,  -181,   713,   713,   713,    45,    55,   127,   713,   713,
     713,   133,   713,  -181,  -181,  -181,  -181,  -181,  -181,  -181,
    -181,  -181,    57,   314,   329,    83,  -181,  -181,   713,  -181,
     713,   713,   713,   713,   713,   713,   713,   713,   713,   713,
     713,   713,   713,   713,   713,   104,   713,   713,   713,   713,
     713,   713,   713,  -181,  -181,  -181,   937,    53,    93,  -181,
    -181,  -181,  -181,  -181,  -181,   -50,  -181,  -181,   216,  -181,
     411,    60,    19,    75,    76,    77,    99,  -181,   508,    78,
      86,  -181,  -181,  -181,   600,   103,   105,   893,   -57,   694,
     713,  -181,  -181,  -181,   937,   713,   955,   972,   988,  1003,
    1017,  1031,  1031,   112,   112,   112,   112,    98,    98,    52,
      52,  -181,  -181,  -181,  -181,  -181,   916,   106,   111,   937,
    -181,   713,    72,  -181,   100,  -181,  -181,   713,   523,  -181,
    -181,   523,    -2,  -181,   523,  -181,  -181,  -181,  -181,  -181,
     113,   713,  -181,   523,  -181,  -181,   870,   807,  -181,  -181,
     937,  -181,   -15,   -45,   119,  -181,  -181,  -181,   186,   115,
     788,  -181,   231,  -181,   -53,   121,  -181,  -181,  -181,  -181,
     713,   523,  -181,  -181,  -181,   713,   713,  -181,  -181,   206,
     124,  -181,    -6,   937,   836,   125,  -181,   161,  -181,   523,
     102,   160,  -181,  -181,   108,  -181,  -181,    -4,   129,   220,
    -181,   163,  -181,   231,  -181,  -181,  -181,  -181,   141,  -181,
    -181,  -181,  -181,   426,  -181
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       7,     0,     3,     1,   104,   106,   103,   105,     0,    44,
     102,    44,    11,   118,     0,     0,     0,     0,     0,   131,
       0,   114,     0,   107,     0,   108,     0,    44,   110,   100,
     109,     0,   111,     0,     0,     0,   101,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     7,     2,
       8,     0,    45,     0,    99,     0,     0,   136,   120,     0,
       0,     0,     0,   131,     0,    44,   120,   120,     0,     0,
     112,   132,     0,   120,   120,     0,     0,     0,   120,   120,
       0,     0,     0,    76,    75,    74,    70,    73,    72,    71,
      93,    97,     0,     0,    44,     0,     4,    10,     0,    67,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     120,   120,     0,    94,    98,    92,   122,     0,   121,    22,
      23,    37,    39,    38,    36,     0,    32,    34,     0,   113,
       0,     0,   136,     0,     0,     0,   134,   135,     0,     0,
       0,    85,    24,    86,     0,     0,     0,    20,     0,     0,
       0,    46,     9,     5,    66,     0,    65,    64,    61,    62,
      60,    58,    59,    48,    55,    56,    57,    53,    54,    63,
      49,    96,    95,    50,    51,    52,     0,     0,     0,   137,
      77,     0,     0,    12,   115,   119,    84,    44,    44,    78,
      79,    44,     0,   133,    44,    89,    88,    87,    80,    81,
       0,     0,    17,    44,    47,     7,     0,     0,    90,    91,
     123,    33,     0,   136,     0,    14,    16,   134,    42,     0,
       0,    19,     6,    68,   118,     0,   116,   139,   138,    35,
      44,    44,    13,    25,    18,     0,     0,    82,   117,   124,
       0,    43,     0,    69,     0,   129,   140,   126,   127,    44,
       0,     0,    21,    26,     7,    28,    83,     0,     0,     0,
      15,     0,    31,    27,    29,    41,    40,   130,     0,   129,
     128,    30,     7,    44,   141
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -181,  -181,  -181,  -181,  -181,   -48,  -180,  -181,  -181,  -181,
    -181,  -181,   -23,  -181,    59,  -181,  -181,  -181,  -181,    -8,
     -36,  -181,  -181,  -181,   -16,  -181,  -181,    51,  -181,  -181,
     -19,  -181,  -181,  -181,   -24,  -181,   193,   114,    26,  -181,
    -181,  -181
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
       0,     1,    49,    96,   215,     2,    50,    61,   210,   252,
     263,   264,   265,   135,   136,   194,   137,   277,   242,    51,
      52,   165,   245,    53,    54,    55,    56,    57,   223,    63,
     127,   128,   256,   257,   258,   267,    70,    71,   125,   239,
     249,   268
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      94,    59,   235,    60,    84,    85,    86,    87,   260,     3,
     211,    93,   261,   122,   246,   275,   146,   192,   225,    76,
     147,   226,   126,   122,   228,   227,   138,   276,   140,   147,
     126,   126,    58,   231,    62,    64,   148,   126,   126,   123,
     124,   154,   126,   126,   157,   212,   159,   143,   144,   247,
      62,   193,   237,    65,   149,   150,    66,   141,    67,   155,
     156,   251,   164,    68,   166,   167,   168,   169,   170,   171,
     172,   173,   174,   175,   176,   177,   178,   179,   180,   270,
     183,   184,   185,   186,   126,   126,   189,   122,    69,   236,
      83,   131,    13,    95,   262,   132,    90,    91,    72,   133,
      19,   187,   188,   134,    21,    73,     4,     5,    74,     6,
       7,    75,    88,   123,   124,   181,   142,    10,    77,   145,
      89,   198,   260,   182,   214,    78,   261,    79,    80,   216,
      81,     4,     5,    82,     6,     7,    97,   119,     8,   116,
     117,   118,    10,   120,   121,   129,    13,   151,    14,   130,
      16,    17,   158,   163,    19,   220,   152,   190,    21,   160,
     191,   197,    22,    23,    24,    25,    26,   232,    28,    29,
      30,    31,    32,    33,    34,   230,    36,   199,   200,   201,
     205,   164,   113,   114,   115,   116,   117,   118,   206,   224,
    -126,  -126,  -126,  -126,   111,   112,   113,   114,   115,   116,
     117,   118,    39,   222,   202,   208,   241,   209,   218,   253,
     254,    40,    41,   219,   243,   229,   273,    42,    43,    44,
     240,    45,    46,   255,    47,   248,   259,  -125,   269,   153,
     272,   278,   250,   281,   283,     4,     5,   279,     6,     7,
     282,   274,     8,     9,   271,   280,    10,    11,    12,   238,
      13,   221,    14,    15,    16,    17,   139,    18,    19,    20,
     203,     0,    21,     0,     0,     0,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    38,    98,     0,    99,     0,   100,   101,   102,
     103,   104,   105,   106,   107,   108,   109,   110,   111,   112,
     113,   114,   115,   116,   117,   118,    39,     0,     0,     0,
       0,     0,     0,     0,     0,    40,    41,     0,     0,     0,
     195,    42,    43,    44,     0,    45,    46,     0,    47,     0,
      48,     0,   -44,     4,     5,     0,     6,     7,     0,     0,
       8,     9,     0,     0,    10,    11,    12,     0,    13,     0,
      14,    15,    16,    17,     0,    18,    19,    20,     0,     0,
      21,     0,     0,     0,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
      38,    98,     0,    99,     0,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,   111,   112,   113,   114,
     115,   116,   117,   118,    39,     0,     0,     0,     0,     0,
       0,     0,     0,    40,    41,     0,   161,     0,     0,    42,
      43,    44,     0,    45,    46,     0,    47,     0,    48,   162,
       4,     5,     0,     6,     7,     0,     0,     8,     9,     0,
       0,    10,    11,    12,     0,    13,     0,    14,    15,    16,
      17,     0,    18,    19,    20,     0,     0,    21,     0,     0,
       0,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    38,    98,     0,
      99,     0,   100,   101,   102,   103,   104,   105,   106,   107,
     108,   109,   110,   111,   112,   113,   114,   115,   116,   117,
     118,    39,     0,     0,     0,     0,     0,     0,     0,     0,
      40,    41,     0,   196,     0,     0,    42,    43,    44,     0,
      45,    46,     0,    47,     0,    48,   284,     4,     5,     0,
       6,     7,     0,     0,     8,     9,     0,     0,    10,    11,
      12,     0,    13,     0,    14,    15,    16,    17,     0,    18,
      19,    20,     0,     0,    21,     0,     0,     0,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,    32,    33,
      34,    35,    36,    37,    38,    98,     0,    99,     0,   100,
     101,   102,   103,   104,   105,   106,   107,   108,   109,   110,
     111,   112,   113,   114,   115,   116,   117,   118,    39,     0,
       0,     0,     0,     0,     0,     0,     0,    40,    41,     0,
     204,     0,     0,    42,    43,    44,     0,    45,    46,     0,
      47,     0,    48,     4,     5,     0,     6,     7,     0,     0,
       8,     0,     0,     0,    10,     0,    92,     0,    13,     0,
      14,     0,    16,    17,     0,     0,    19,     0,     0,     0,
      21,     0,     0,     0,    22,    23,    24,    25,    26,     0,
      28,    29,    30,    31,    32,    33,    34,    98,    36,    99,
       0,   100,   101,   102,   103,   104,   105,   106,   107,   108,
     109,   110,   111,   112,   113,   114,   115,   116,   117,   118,
       0,     0,     0,     0,    39,     0,     0,     0,     0,     0,
       0,     0,   207,    40,    41,     0,     0,     0,     0,    42,
      43,    44,     0,    45,    46,     0,    47,     4,     5,     0,
       6,     7,     0,     0,     8,     0,     0,     0,    10,     0,
       0,     0,    13,     0,    14,     0,    16,    17,     0,     0,
      19,     0,     0,     0,    21,     0,     0,     0,    22,    23,
      24,    25,    26,     0,    28,    29,    30,    31,    32,    33,
      34,    98,    36,    99,     0,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,   111,   112,   113,   114,
     115,   116,   117,   118,     0,     0,     0,     0,    39,     0,
       0,     0,     0,     0,     0,     0,   213,    40,    41,     0,
       0,     0,     0,    42,    43,    44,     0,    45,    46,     0,
      47,     4,     5,     0,     6,     7,     0,     0,     8,     0,
       0,     0,    10,     0,     0,     0,   234,     0,    14,     0,
      16,    17,     0,     0,    19,     0,     0,     0,    21,     0,
       0,     0,    22,    23,    24,    25,    26,     0,    28,    29,
      30,    31,    32,    33,    34,    98,    36,    99,     0,   100,
     101,   102,   103,   104,   105,   106,   107,   108,   109,   110,
     111,   112,   113,   114,   115,   116,   117,   118,     0,     0,
       0,     0,    39,     0,     0,     0,     0,     0,     0,     0,
     244,    40,    41,     0,     0,     0,     0,    42,    43,    44,
       0,    45,    46,    98,    47,    99,     0,   100,   101,   102,
     103,   104,   105,   106,   107,   108,   109,   110,   111,   112,
     113,   114,   115,   116,   117,   118,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    98,   266,    99,
     233,   100,   101,   102,   103,   104,   105,   106,   107,   108,
     109,   110,   111,   112,   113,   114,   115,   116,   117,   118,
      98,     0,    99,     0,   100,   101,   102,   103,   104,   105,
     106,   107,   108,   109,   110,   111,   112,   113,   114,   115,
     116,   117,   118,   217,     0,    99,     0,   100,   101,   102,
     103,   104,   105,   106,   107,   108,   109,   110,   111,   112,
     113,   114,   115,   116,   117,   118,    99,     0,   100,   101,
     102,   103,   104,   105,   106,   107,   108,   109,   110,   111,
     112,   113,   114,   115,   116,   117,   118,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,   111,   112,   113,
     114,   115,   116,   117,   118,   102,   103,   104,   105,   106,
     107,   108,   109,   110,   111,   112,   113,   114,   115,   116,
     117,   118,   103,   104,   105,   106,   107,   108,   109,   110,
     111,   112,   113,   114,   115,   116,   117,   118,   104,   105,
     106,   107,   108,   109,   110,   111,   112,   113,   114,   115,
     116,   117,   118,   105,   106,   107,   108,   109,   110,   111,
     112,   113,   114,   115,   116,   117,   118,  -126,  -126,   107,
     108,   109,   110,   111,   112,   113,   114,   115,   116,   117,
     118
};

static const yytype_int16 yycheck[] =
{
      48,     9,    17,    11,    40,    41,    42,    43,    14,     0,
      67,    47,    18,    68,    67,    19,    27,    67,   198,    27,
      31,   201,    58,    68,   204,    27,    62,    31,    64,    31,
      66,    67,   103,   213,   103,    97,    72,    73,    74,    94,
      95,    77,    78,    79,    80,   102,    82,    66,    67,   102,
     103,   101,    97,    97,    73,    74,    97,    65,    97,    78,
      79,   241,    98,    97,   100,   101,   102,   103,   104,   105,
     106,   107,   108,   109,   110,   111,   112,   113,   114,   259,
     116,   117,   118,   119,   120,   121,   122,    68,   105,   104,
      39,    19,    19,    29,   100,    23,    45,    46,    97,    27,
      27,   120,   121,    31,    31,    97,     4,     5,    97,     7,
       8,    97,    11,    94,    95,    11,    65,    15,    97,    68,
      19,   102,    14,    19,   160,    97,    18,    97,    97,   165,
      97,     4,     5,    97,     7,     8,   101,    97,    11,    87,
      88,    89,    15,    97,    97,   101,    19,   102,    21,   101,
      23,    24,    19,    70,    27,   191,   101,   104,    31,   102,
      67,   101,    35,    36,    37,    38,    39,   215,    41,    42,
      43,    44,    45,    46,    47,   211,    49,   102,   102,   102,
     102,   217,    84,    85,    86,    87,    88,    89,   102,   197,
      78,    79,    80,    81,    82,    83,    84,    85,    86,    87,
      88,    89,    75,   103,   105,   102,    20,   102,   102,   245,
     246,    84,    85,   102,    99,   102,   264,    90,    91,    92,
     101,    94,    95,    17,    97,   104,   102,   102,    67,   102,
      70,   102,   240,    70,   282,     4,     5,    17,     7,     8,
      99,   264,    11,    12,   260,   269,    15,    16,    17,   223,
      19,   192,    21,    22,    23,    24,    63,    26,    27,    28,
     146,    -1,    31,    -1,    -1,    -1,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    67,    -1,    69,    -1,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,    85,    86,    87,    88,    89,    75,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    84,    85,    -1,    -1,    -1,
     104,    90,    91,    92,    -1,    94,    95,    -1,    97,    -1,
      99,    -1,   101,     4,     5,    -1,     7,     8,    -1,    -1,
      11,    12,    -1,    -1,    15,    16,    17,    -1,    19,    -1,
      21,    22,    23,    24,    -1,    26,    27,    28,    -1,    -1,
      31,    -1,    -1,    -1,    35,    36,    37,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    67,    -1,    69,    -1,    71,    72,    73,    74,    75,
      76,    77,    78,    79,    80,    81,    82,    83,    84,    85,
      86,    87,    88,    89,    75,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    84,    85,    -1,   102,    -1,    -1,    90,
      91,    92,    -1,    94,    95,    -1,    97,    -1,    99,   100,
       4,     5,    -1,     7,     8,    -1,    -1,    11,    12,    -1,
      -1,    15,    16,    17,    -1,    19,    -1,    21,    22,    23,
      24,    -1,    26,    27,    28,    -1,    -1,    31,    -1,    -1,
      -1,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    67,    -1,
      69,    -1,    71,    72,    73,    74,    75,    76,    77,    78,
      79,    80,    81,    82,    83,    84,    85,    86,    87,    88,
      89,    75,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      84,    85,    -1,   102,    -1,    -1,    90,    91,    92,    -1,
      94,    95,    -1,    97,    -1,    99,   100,     4,     5,    -1,
       7,     8,    -1,    -1,    11,    12,    -1,    -1,    15,    16,
      17,    -1,    19,    -1,    21,    22,    23,    24,    -1,    26,
      27,    28,    -1,    -1,    31,    -1,    -1,    -1,    35,    36,
      37,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    50,    51,    67,    -1,    69,    -1,    71,
      72,    73,    74,    75,    76,    77,    78,    79,    80,    81,
      82,    83,    84,    85,    86,    87,    88,    89,    75,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    84,    85,    -1,
     102,    -1,    -1,    90,    91,    92,    -1,    94,    95,    -1,
      97,    -1,    99,     4,     5,    -1,     7,     8,    -1,    -1,
      11,    -1,    -1,    -1,    15,    -1,    17,    -1,    19,    -1,
      21,    -1,    23,    24,    -1,    -1,    27,    -1,    -1,    -1,
      31,    -1,    -1,    -1,    35,    36,    37,    38,    39,    -1,
      41,    42,    43,    44,    45,    46,    47,    67,    49,    69,
      -1,    71,    72,    73,    74,    75,    76,    77,    78,    79,
      80,    81,    82,    83,    84,    85,    86,    87,    88,    89,
      -1,    -1,    -1,    -1,    75,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   102,    84,    85,    -1,    -1,    -1,    -1,    90,
      91,    92,    -1,    94,    95,    -1,    97,     4,     5,    -1,
       7,     8,    -1,    -1,    11,    -1,    -1,    -1,    15,    -1,
      -1,    -1,    19,    -1,    21,    -1,    23,    24,    -1,    -1,
      27,    -1,    -1,    -1,    31,    -1,    -1,    -1,    35,    36,
      37,    38,    39,    -1,    41,    42,    43,    44,    45,    46,
      47,    67,    49,    69,    -1,    71,    72,    73,    74,    75,
      76,    77,    78,    79,    80,    81,    82,    83,    84,    85,
      86,    87,    88,    89,    -1,    -1,    -1,    -1,    75,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   102,    84,    85,    -1,
      -1,    -1,    -1,    90,    91,    92,    -1,    94,    95,    -1,
      97,     4,     5,    -1,     7,     8,    -1,    -1,    11,    -1,
      -1,    -1,    15,    -1,    -1,    -1,    19,    -1,    21,    -1,
      23,    24,    -1,    -1,    27,    -1,    -1,    -1,    31,    -1,
      -1,    -1,    35,    36,    37,    38,    39,    -1,    41,    42,
      43,    44,    45,    46,    47,    67,    49,    69,    -1,    71,
      72,    73,    74,    75,    76,    77,    78,    79,    80,    81,
      82,    83,    84,    85,    86,    87,    88,    89,    -1,    -1,
      -1,    -1,    75,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     102,    84,    85,    -1,    -1,    -1,    -1,    90,    91,    92,
      -1,    94,    95,    67,    97,    69,    -1,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,    85,    86,    87,    88,    89,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    67,   102,    69,
      70,    71,    72,    73,    74,    75,    76,    77,    78,    79,
      80,    81,    82,    83,    84,    85,    86,    87,    88,    89,
      67,    -1,    69,    -1,    71,    72,    73,    74,    75,    76,
      77,    78,    79,    80,    81,    82,    83,    84,    85,    86,
      87,    88,    89,    67,    -1,    69,    -1,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,    85,    86,    87,    88,    89,    69,    -1,    71,    72,
      73,    74,    75,    76,    77,    78,    79,    80,    81,    82,
      83,    84,    85,    86,    87,    88,    89,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      85,    86,    87,    88,    89,    73,    74,    75,    76,    77,
      78,    79,    80,    81,    82,    83,    84,    85,    86,    87,
      88,    89,    74,    75,    76,    77,    78,    79,    80,    81,
      82,    83,    84,    85,    86,    87,    88,    89,    75,    76,
      77,    78,    79,    80,    81,    82,    83,    84,    85,    86,
      87,    88,    89,    76,    77,    78,    79,    80,    81,    82,
      83,    84,    85,    86,    87,    88,    89,    76,    77,    78,
      79,    80,    81,    82,    83,    84,    85,    86,    87,    88,
      89
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,   107,   111,     0,     4,     5,     7,     8,    11,    12,
      15,    16,    17,    19,    21,    22,    23,    24,    26,    27,
      28,    31,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    75,
      84,    85,    90,    91,    92,    94,    95,    97,    99,   108,
     112,   125,   126,   129,   130,   131,   132,   133,   103,   125,
     125,   113,   103,   135,    97,    97,    97,    97,    97,   105,
     142,   143,    97,    97,    97,    97,   125,    97,    97,    97,
      97,    97,    97,   133,   126,   126,   126,   126,    11,    19,
     133,   133,    17,   126,   111,    29,   109,   101,    67,    69,
      71,    72,    73,    74,    75,    76,    77,    78,    79,    80,
      81,    82,    83,    84,    85,    86,    87,    88,    89,    97,
      97,    97,    68,    94,    95,   144,   126,   136,   137,   101,
     101,    19,    23,    27,    31,   119,   120,   122,   126,   142,
     126,   125,   133,   136,   136,   133,    27,    31,   126,   136,
     136,   102,   101,   102,   126,   136,   136,   126,    19,   126,
     102,   102,   100,    70,   126,   127,   126,   126,   126,   126,
     126,   126,   126,   126,   126,   126,   126,   126,   126,   126,
     126,    11,    19,   126,   126,   126,   126,   136,   136,   126,
     104,    67,    67,   101,   121,   104,   102,   101,   102,   102,
     102,   102,   105,   143,   102,   102,   102,   102,   102,   102,
     114,    67,   102,   102,   126,   110,   126,    67,   102,   102,
     126,   120,   103,   134,   125,   112,   112,    27,   112,   102,
     126,   112,   111,    70,    19,    17,   104,    97,   144,   145,
     101,    20,   124,    99,   102,   128,    67,   102,   104,   146,
     125,   112,   115,   126,   126,    17,   138,   139,   140,   102,
      14,    18,   100,   116,   117,   118,   102,   141,   147,    67,
     112,   130,    70,   111,   118,    19,    31,   123,   102,    17,
     140,    70,    99,   111,   100
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_uint8 yyr1[] =
{
       0,   106,   107,   108,   108,   110,   109,   111,   111,   112,
     112,   113,   112,   112,   112,   112,   112,   112,   112,   112,
     114,   112,   112,   112,   112,   115,   115,   116,   117,   117,
     118,   118,   119,   119,   121,   120,   122,   122,   122,   122,
     123,   123,   124,   124,   125,   125,   126,   126,   126,   126,
     126,   126,   126,   126,   126,   126,   126,   126,   126,   126,
     126,   126,   126,   126,   126,   126,   126,   127,   128,   126,
     126,   126,   126,   126,   126,   126,   126,   126,   126,   126,
     126,   126,   126,   126,   126,   126,   126,   126,   126,   126,
     126,   126,   126,   126,   126,   126,   126,   126,   126,   126,
     129,   129,   130,   130,   130,   130,   130,   131,   131,   131,
     132,   132,   133,   133,   133,   134,   134,   134,   135,   135,
     136,   136,   137,   137,   138,   138,   138,   139,   139,   141,
     140,   142,   142,   142,   143,   143,   144,   144,   145,   146,
     147,   145
};

/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     2,     0,     2,     0,     4,     0,     2,     3,
       2,     0,     4,     6,     5,     9,     5,     4,     6,     5,
       0,     8,     3,     3,     3,     0,     2,     2,     1,     2,
       3,     2,     1,     3,     0,     4,     1,     1,     1,     1,
       1,     1,     0,     2,     0,     1,     3,     4,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     0,     0,     7,
       2,     2,     2,     2,     2,     2,     2,     4,     4,     4,
       4,     4,     6,     8,     4,     3,     3,     4,     4,     4,
       4,     4,     2,     2,     2,     3,     3,     2,     2,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     2,     3,     1,     0,     2,     3,     0,     3,
       0,     1,     1,     3,     0,     1,     1,     1,     3,     0,
       3,     0,     1,     3,     2,     2,     0,     2,     1,     0,
       0,     8
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = EX_EMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYNOMEM         goto yyexhaustedlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == EX_EMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Backward compatibility with an undocumented macro.
   Use EX_error or EX_UNDEF. */
#define YYERRCODE EX_UNDEF


/* Enable debugging if requested.  */
#if EX_DEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)




# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  if (!yyvaluep)
    return;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !EX_DEBUG */
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !EX_DEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif






/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YY_USE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = EX_EMPTY; /* Cause a token to be read.  */

  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    YYNOMEM;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        YYNOMEM;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          YYNOMEM;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */


  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == EX_EMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= EX_EOF)
    {
      yychar = EX_EOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == EX_error)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = EX_UNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = EX_EMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2: /* program: statement_list action_list  */
#line 182 "../../lib/expr/exparse.y"
                {
			if ((yyvsp[-1].expr))	{
				if (expr.program->main.value)
					exfreenode(expr.program, expr.program->main.value);
				if ((yyvsp[-1].expr)->op == S2B)
				{
					Exnode_t *x = (yyvsp[-1].expr);
					(yyvsp[-1].expr) = x->data.operand.left;
					x->data.operand.left = 0;
					exfreenode(expr.program, x);
				}
				expr.program->main.lex = PROCEDURE;
				expr.program->main.value = exnewnode(expr.program, PROCEDURE, true, (yyvsp[-1].expr)->type, NULL, (yyvsp[-1].expr));
			}
		}
#line 1630 "exparse.c"
    break;

  case 5: /* $@1: %empty  */
#line 203 "../../lib/expr/exparse.y"
                                  {
				if (expr.procedure)
					exerror("no nested function definitions");
				(yyvsp[-1].id)->lex = PROCEDURE;
				expr.procedure = (yyvsp[-1].id)->value = exnewnode(expr.program, PROCEDURE, true, (yyvsp[-1].id)->type, NULL, NULL);
				expr.procedure->type = INTEGER;
				static Dtdisc_t disc = {.key = offsetof(Exid_t, name)};
				if (expr.assigned && !streq((yyvsp[-1].id)->name, "begin"))
				{
					if (!(expr.procedure->data.procedure.frame = dtopen(&disc, Dtset)) ||
					    !dtview(expr.procedure->data.procedure.frame, expr.program->symbols))
						exnospace();
					expr.program->symbols = expr.program->frame = expr.procedure->data.procedure.frame;
				}
			}
#line 1650 "exparse.c"
    break;

  case 6: /* action: LABEL ':' $@1 statement_list  */
#line 218 "../../lib/expr/exparse.y"
                {
			expr.procedure = NULL;
			if (expr.program->frame)
			{
				expr.program->symbols = expr.program->frame->view;
				dtview(expr.program->frame, NULL);
				expr.program->frame = NULL;
			}
			if ((yyvsp[0].expr) && (yyvsp[0].expr)->op == S2B)
			{
				Exnode_t *x = (yyvsp[0].expr);
				(yyvsp[0].expr) = x->data.operand.left;
				x->data.operand.left = 0;
				exfreenode(expr.program, x);
			}
			(yyvsp[-3].id)->value->data.procedure.body = excast(expr.program, (yyvsp[0].expr), (yyvsp[-3].id)->type, NULL, 0);
		}
#line 1672 "exparse.c"
    break;

  case 7: /* statement_list: %empty  */
#line 238 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = 0;
		}
#line 1680 "exparse.c"
    break;

  case 8: /* statement_list: statement_list statement  */
#line 242 "../../lib/expr/exparse.y"
                {
			if (!(yyvsp[-1].expr))
				(yyval.expr) = (yyvsp[0].expr);
			else if (!(yyvsp[0].expr))
				(yyval.expr) = (yyvsp[-1].expr);
			else if ((yyvsp[-1].expr)->op == CONSTANT)
			{
				exfreenode(expr.program, (yyvsp[-1].expr));
				(yyval.expr) = (yyvsp[0].expr);
			}
			else (yyval.expr) = exnewnode(expr.program, ';', true, (yyvsp[0].expr)->type, (yyvsp[-1].expr), (yyvsp[0].expr));
		}
#line 1697 "exparse.c"
    break;

  case 9: /* statement: '{' statement_list '}'  */
#line 257 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = (yyvsp[-1].expr);
		}
#line 1705 "exparse.c"
    break;

  case 10: /* statement: expr_opt ';'  */
#line 261 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = ((yyvsp[-1].expr) && (yyvsp[-1].expr)->type == STRING) ? exnewnode(expr.program, S2B, true, INTEGER, (yyvsp[-1].expr), NULL) : (yyvsp[-1].expr);
		}
#line 1713 "exparse.c"
    break;

  case 11: /* $@2: %empty  */
#line 264 "../../lib/expr/exparse.y"
                                {expr.declare = (yyvsp[0].id)->type;}
#line 1719 "exparse.c"
    break;

  case 12: /* statement: DECLARE $@2 dcl_list ';'  */
#line 265 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = (yyvsp[-1].expr);
			expr.declare = 0;
		}
#line 1728 "exparse.c"
    break;

  case 13: /* statement: IF '(' expr ')' statement else_opt  */
#line 270 "../../lib/expr/exparse.y"
                {
			if (exisAssign ((yyvsp[-3].expr)))
				exwarn ("assignment used as boolean in if statement");
			if ((yyvsp[-3].expr)->type == STRING)
				(yyvsp[-3].expr) = exnewnode(expr.program, S2B, true, INTEGER, (yyvsp[-3].expr), NULL);
			else if (!INTEGRAL((yyvsp[-3].expr)->type))
				(yyvsp[-3].expr) = excast(expr.program, (yyvsp[-3].expr), INTEGER, NULL, 0);
			(yyval.expr) = exnewnode(expr.program, (yyvsp[-5].id)->index, true, INTEGER, (yyvsp[-3].expr), exnewnode(expr.program, ':', true, (yyvsp[-1].expr) ? (yyvsp[-1].expr)->type : 0, (yyvsp[-1].expr), (yyvsp[0].expr)));
		}
#line 1742 "exparse.c"
    break;

  case 14: /* statement: FOR '(' variable ')' statement  */
#line 280 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, ITERATE, false, INTEGER, NULL, NULL);
			(yyval.expr)->data.generate.array = (yyvsp[-2].expr);
			if (!(yyvsp[-2].expr)->data.variable.index || (yyvsp[-2].expr)->data.variable.index->op != DYNAMIC)
				exerror("simple index variable expected");
			(yyval.expr)->data.generate.index = (yyvsp[-2].expr)->data.variable.index->data.variable.symbol;
			if ((yyvsp[-2].expr)->op == ID && (yyval.expr)->data.generate.index->type != INTEGER)
				exerror("integer index variable expected");
			exfreenode(expr.program, (yyvsp[-2].expr)->data.variable.index);
			(yyvsp[-2].expr)->data.variable.index = 0;
			(yyval.expr)->data.generate.statement = (yyvsp[0].expr);
		}
#line 1759 "exparse.c"
    break;

  case 15: /* statement: FOR '(' expr_opt ';' expr_opt ';' expr_opt ')' statement  */
#line 293 "../../lib/expr/exparse.y"
                {
			if (!(yyvsp[-4].expr))
			{
				(yyvsp[-4].expr) = exnewnode(expr.program, CONSTANT, false, INTEGER, NULL, NULL);
				(yyvsp[-4].expr)->data.constant.value.integer = 1;
			}
			else if ((yyvsp[-4].expr)->type == STRING)
				(yyvsp[-4].expr) = exnewnode(expr.program, S2B, true, INTEGER, (yyvsp[-4].expr), NULL);
			else if (!INTEGRAL((yyvsp[-4].expr)->type))
				(yyvsp[-4].expr) = excast(expr.program, (yyvsp[-4].expr), INTEGER, NULL, 0);
			(yyval.expr) = exnewnode(expr.program, (yyvsp[-8].id)->index, true, INTEGER, (yyvsp[-4].expr), exnewnode(expr.program, ';', 1, 0, (yyvsp[-2].expr), (yyvsp[0].expr)));
			if ((yyvsp[-6].expr))
				(yyval.expr) = exnewnode(expr.program, ';', true, INTEGER, (yyvsp[-6].expr), (yyval.expr));
		}
#line 1778 "exparse.c"
    break;

  case 16: /* statement: ITERATOR '(' variable ')' statement  */
#line 308 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, ITERATOR, false, INTEGER, NULL, NULL);
			(yyval.expr)->data.generate.array = (yyvsp[-2].expr);
			if (!(yyvsp[-2].expr)->data.variable.index || (yyvsp[-2].expr)->data.variable.index->op != DYNAMIC)
				exerror("simple index variable expected");
			(yyval.expr)->data.generate.index = (yyvsp[-2].expr)->data.variable.index->data.variable.symbol;
			if ((yyvsp[-2].expr)->op == ID && (yyval.expr)->data.generate.index->type != INTEGER)
				exerror("integer index variable expected");
			exfreenode(expr.program, (yyvsp[-2].expr)->data.variable.index);
			(yyvsp[-2].expr)->data.variable.index = 0;
			(yyval.expr)->data.generate.statement = (yyvsp[0].expr);
		}
#line 1795 "exparse.c"
    break;

  case 17: /* statement: UNSET '(' DYNAMIC ')'  */
#line 321 "../../lib/expr/exparse.y"
                {
			if ((yyvsp[-1].id)->local == NULL)
              			exerror("cannot apply unset to non-array %s", (yyvsp[-1].id)->name);
			(yyval.expr) = exnewnode(expr.program, UNSET, false, INTEGER, NULL, NULL);
			(yyval.expr)->data.variable.symbol = (yyvsp[-1].id);
			(yyval.expr)->data.variable.index = NULL;
		}
#line 1807 "exparse.c"
    break;

  case 18: /* statement: UNSET '(' DYNAMIC ',' expr ')'  */
#line 329 "../../lib/expr/exparse.y"
                {
			if ((yyvsp[-3].id)->local == NULL)
              			exerror("cannot apply unset to non-array %s", (yyvsp[-3].id)->name);
			if (((yyvsp[-3].id)->index_type > 0) && ((yyvsp[-1].expr)->type != (yyvsp[-3].id)->index_type))
            		    exerror("%s indices must have type %s, not %s", 
				(yyvsp[-3].id)->name, extypename(expr.program, (yyvsp[-3].id)->index_type),extypename(expr.program, (yyvsp[-1].expr)->type));
			(yyval.expr) = exnewnode(expr.program, UNSET, false, INTEGER, NULL, NULL);
			(yyval.expr)->data.variable.symbol = (yyvsp[-3].id);
			(yyval.expr)->data.variable.index = (yyvsp[-1].expr);
		}
#line 1822 "exparse.c"
    break;

  case 19: /* statement: WHILE '(' expr ')' statement  */
#line 340 "../../lib/expr/exparse.y"
                {
			if (exisAssign ((yyvsp[-2].expr)))
				exwarn ("assignment used as boolean in while statement");
			if ((yyvsp[-2].expr)->type == STRING)
				(yyvsp[-2].expr) = exnewnode(expr.program, S2B, true, INTEGER, (yyvsp[-2].expr), NULL);
			else if (!INTEGRAL((yyvsp[-2].expr)->type))
				(yyvsp[-2].expr) = excast(expr.program, (yyvsp[-2].expr), INTEGER, NULL, 0);
			(yyval.expr) = exnewnode(expr.program, (yyvsp[-4].id)->index, true, INTEGER, (yyvsp[-2].expr), exnewnode(expr.program, ';', true, 0, NULL, (yyvsp[0].expr)));
		}
#line 1836 "exparse.c"
    break;

  case 20: /* $@3: %empty  */
#line 349 "../../lib/expr/exparse.y"
                                        {expr.declare=(yyvsp[0].expr)->type;}
#line 1842 "exparse.c"
    break;

  case 21: /* statement: SWITCH '(' expr $@3 ')' '{' switch_list '}'  */
#line 350 "../../lib/expr/exparse.y"
                {
			Switch_t*	sw = expr.swstate;

			(yyval.expr) = exnewnode(expr.program, (yyvsp[-7].id)->index, true, INTEGER, (yyvsp[-5].expr), exnewnode(expr.program, DEFAULT, true, 0, sw->defcase, sw->firstcase));
			expr.swstate = expr.swstate->prev;
			free(sw->base);
			free(sw);
			expr.declare = 0;
		}
#line 1856 "exparse.c"
    break;

  case 22: /* statement: BREAK expr_opt ';'  */
#line 360 "../../lib/expr/exparse.y"
                {
		loopop:
			if (!(yyvsp[-1].expr))
			{
				(yyvsp[-1].expr) = exnewnode(expr.program, CONSTANT, false, INTEGER, NULL, NULL);
				(yyvsp[-1].expr)->data.constant.value.integer = 1;
			}
			else if (!INTEGRAL((yyvsp[-1].expr)->type))
				(yyvsp[-1].expr) = excast(expr.program, (yyvsp[-1].expr), INTEGER, NULL, 0);
			(yyval.expr) = exnewnode(expr.program, (yyvsp[-2].id)->index, true, INTEGER, (yyvsp[-1].expr), NULL);
		}
#line 1872 "exparse.c"
    break;

  case 23: /* statement: CONTINUE expr_opt ';'  */
#line 372 "../../lib/expr/exparse.y"
                {
			goto loopop;
		}
#line 1880 "exparse.c"
    break;

  case 24: /* statement: RETURN expr_opt ';'  */
#line 376 "../../lib/expr/exparse.y"
                {
			if ((yyvsp[-1].expr))
			{
				if (expr.procedure && !expr.procedure->type)
					exerror("return in void function");
				(yyvsp[-1].expr) = excast(expr.program, (yyvsp[-1].expr), expr.procedure ? expr.procedure->type : INTEGER, NULL, 0);
			}
			(yyval.expr) = exnewnode(expr.program, RETURN, true, (yyvsp[-1].expr) ? (yyvsp[-1].expr)->type : 0, (yyvsp[-1].expr), NULL);
		}
#line 1894 "exparse.c"
    break;

  case 25: /* switch_list: %empty  */
#line 388 "../../lib/expr/exparse.y"
                {
			Switch_t*		sw;

			if (!(sw = calloc(1, sizeof(Switch_t)))) {
				exnospace();
			} else {
				expr.swstate = sw;
				sw->type = expr.declare;
				size_t n = 8;
				if (!(sw->base = calloc(n, sizeof(Extype_t*)))) {
					exnospace();
					n = 0;
				}
				sw->cap = n;
			}
		}
#line 1915 "exparse.c"
    break;

  case 27: /* switch_item: case_list statement_list  */
#line 408 "../../lib/expr/exparse.y"
                {
			Switch_t*	sw = expr.swstate;

			(yyval.expr) = exnewnode(expr.program, CASE, true, 0, (yyvsp[0].expr), NULL);
			if (sw->cur > 0)
			{
				if (sw->lastcase)
					sw->lastcase->data.select.next = (yyval.expr);
				else
					sw->firstcase = (yyval.expr);
				sw->lastcase = (yyval.expr);
				const size_t n = sw->cap;
				sw->cur = 0;
				(yyval.expr)->data.select.constant = gv_arena_alloc(&expr.program->vm,
				                                          alignof(Extype_t *),
				                                          (n + 1) * sizeof(Extype_t*));
				memcpy((yyval.expr)->data.select.constant, sw->base, n * sizeof(Extype_t*));
			}
			else
				(yyval.expr)->data.select.constant = 0;
			if (sw->def)
			{
				sw->def = 0;
				if (sw->defcase)
					exerror("duplicate default in switch");
				else
					sw->defcase = (yyvsp[0].expr);
			}
		}
#line 1949 "exparse.c"
    break;

  case 30: /* case_item: CASE constant ':'  */
#line 444 "../../lib/expr/exparse.y"
                {
			if (expr.swstate->cur >= expr.swstate->cap)
			{
				size_t n = expr.swstate->cap;
				if (!(expr.swstate->base = realloc(expr.swstate->base, sizeof(Extype_t*) * 2 * n)))
				{
					exerror("too many case labels for switch");
					n = 0;
				}
				expr.swstate->cap = 2 * n;
			}
			if (expr.swstate->base != NULL)
			{
				(yyvsp[-1].expr) = excast(expr.program, (yyvsp[-1].expr), expr.swstate->type, NULL, 0);
				expr.swstate->base[expr.swstate->cur++] = &(yyvsp[-1].expr)->data.constant.value;
			}
		}
#line 1971 "exparse.c"
    break;

  case 31: /* case_item: DEFAULT ':'  */
#line 462 "../../lib/expr/exparse.y"
                {
			expr.swstate->def = 1;
		}
#line 1979 "exparse.c"
    break;

  case 33: /* dcl_list: dcl_list ',' dcl_item  */
#line 469 "../../lib/expr/exparse.y"
                {
			if ((yyvsp[0].expr))
				(yyval.expr) = (yyvsp[-2].expr) ? exnewnode(expr.program, ',', true, (yyvsp[0].expr)->type, (yyvsp[-2].expr), (yyvsp[0].expr)) : (yyvsp[0].expr);
		}
#line 1988 "exparse.c"
    break;

  case 34: /* $@4: %empty  */
#line 475 "../../lib/expr/exparse.y"
                                 {checkName ((yyvsp[0].id)); expr.id=(yyvsp[0].id);}
#line 1994 "exparse.c"
    break;

  case 35: /* dcl_item: dcl_name $@4 array initialize  */
#line 476 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = 0;
			if (!(yyvsp[-3].id)->type || expr.declare)
				(yyvsp[-3].id)->type = expr.declare;
			if ((yyvsp[0].expr) && (yyvsp[0].expr)->op == PROCEDURE)
			{
				(yyvsp[-3].id)->lex = PROCEDURE;
				(yyvsp[-3].id)->type = (yyvsp[0].expr)->type;
				(yyvsp[-3].id)->value = (yyvsp[0].expr);
			}
			else
			{
				if ((yyvsp[-3].id)->type == 0) {
					exerror("%s: a variable cannot be void typed", (yyvsp[-3].id)->name);
				}
				(yyvsp[-3].id)->lex = DYNAMIC;
				(yyvsp[-3].id)->value = exnewnode(expr.program, 0, false, 0, NULL, NULL);
				if ((yyvsp[-1].integer) && (yyvsp[-3].id)->local == NULL)
				{
					static Dtdisc_t disc_key = {
						.key = offsetof(Exassoc_t, key),
						.size = sizeof(Extype_t),
						.comparf = cmpKey,
					};
					static Dtdisc_t disc_name = {.key = offsetof(Exassoc_t, name)};
					Dtdisc_t *const disc = (yyvsp[-1].integer) == INTEGER ? &disc_key : &disc_name;
					if (!((yyvsp[-3].id)->local = dtopen(disc, Dtoset)))
						exerror("%s: cannot initialize associative array", (yyvsp[-3].id)->name);
					(yyvsp[-3].id)->index_type = (yyvsp[-1].integer); /* -1 indicates no typechecking */
				}
				if ((yyvsp[0].expr))
				{
					if ((yyvsp[0].expr)->type != (yyvsp[-3].id)->type)
					{
						(yyvsp[0].expr)->type = (yyvsp[-3].id)->type;
						(yyvsp[0].expr)->data.operand.right = excast(expr.program, (yyvsp[0].expr)->data.operand.right, (yyvsp[-3].id)->type, NULL, 0);
					}
					(yyvsp[0].expr)->data.operand.left = exnewnode(expr.program, DYNAMIC, false, (yyvsp[-3].id)->type, NULL, NULL);
					(yyvsp[0].expr)->data.operand.left->data.variable.symbol = (yyvsp[-3].id);
					(yyval.expr) = (yyvsp[0].expr);
				}
				else if (!(yyvsp[-1].integer))
					(yyvsp[-3].id)->value->data.value = exzero((yyvsp[-3].id)->type);
			}
		}
#line 2044 "exparse.c"
    break;

  case 42: /* else_opt: %empty  */
#line 534 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = 0;
		}
#line 2052 "exparse.c"
    break;

  case 43: /* else_opt: ELSE statement  */
#line 538 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = (yyvsp[0].expr);
		}
#line 2060 "exparse.c"
    break;

  case 44: /* expr_opt: %empty  */
#line 544 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = 0;
		}
#line 2068 "exparse.c"
    break;

  case 46: /* expr: '(' expr ')'  */
#line 551 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = (yyvsp[-1].expr);
		}
#line 2076 "exparse.c"
    break;

  case 47: /* expr: '(' DECLARE ')' expr  */
#line 555 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = ((yyvsp[0].expr)->type == (yyvsp[-2].id)->type) ? (yyvsp[0].expr) : excast(expr.program, (yyvsp[0].expr), (yyvsp[-2].id)->type, NULL, 0);
		}
#line 2084 "exparse.c"
    break;

  case 48: /* expr: expr '<' expr  */
#line 559 "../../lib/expr/exparse.y"
                {
			long rel;

		relational:
			rel = INTEGER;
			goto coerce;
		binary:
			rel = 0;
		coerce:
			if (!(yyvsp[-2].expr)->type)
			{
				if (!(yyvsp[0].expr)->type)
					(yyvsp[-2].expr)->type = (yyvsp[0].expr)->type = rel ? STRING : INTEGER;
				else
					(yyvsp[-2].expr)->type = (yyvsp[0].expr)->type;
			}
			else if (!(yyvsp[0].expr)->type)
				(yyvsp[0].expr)->type = (yyvsp[-2].expr)->type;
			if ((yyvsp[-2].expr)->type != (yyvsp[0].expr)->type)
			{
				if ((yyvsp[-2].expr)->type == STRING)
					(yyvsp[-2].expr) = excast(expr.program, (yyvsp[-2].expr), (yyvsp[0].expr)->type, (yyvsp[0].expr), 0);
				else if ((yyvsp[0].expr)->type == STRING)
					(yyvsp[0].expr) = excast(expr.program, (yyvsp[0].expr), (yyvsp[-2].expr)->type, (yyvsp[-2].expr), 0);
				else if ((yyvsp[-2].expr)->type == FLOATING)
					(yyvsp[0].expr) = excast(expr.program, (yyvsp[0].expr), FLOATING, (yyvsp[-2].expr), 0);
				else if ((yyvsp[0].expr)->type == FLOATING)
					(yyvsp[-2].expr) = excast(expr.program, (yyvsp[-2].expr), FLOATING, (yyvsp[0].expr), 0);
			}
			if (!rel)
				rel = ((yyvsp[-2].expr)->type == STRING) ? STRING : (((yyvsp[-2].expr)->type == UNSIGNED) ? UNSIGNED : (yyvsp[0].expr)->type);
			(yyval.expr) = exnewnode(expr.program, (yyvsp[-1].op), true, rel, (yyvsp[-2].expr), (yyvsp[0].expr));
			if (!expr.program->errors && (yyvsp[-2].expr)->op == CONSTANT && (yyvsp[0].expr)->op == CONSTANT)
			{
				(yyval.expr)->data.constant.value = exeval(expr.program, (yyval.expr), NULL);
				/* If a constant string, re-allocate from program heap. This is because the
				 * value was constructed from string operators, which create a value in the 
				 * temporary heap, which is cleared when exeval is called again. 
				 */
				if ((yyval.expr)->type == STRING) {
					(yyval.expr)->data.constant.value.string =
						gv_arena_strdup(&expr.program->vm, (yyval.expr)->data.constant.value.string);
				}
				(yyval.expr)->binary = false;
				(yyval.expr)->op = CONSTANT;
				exfreenode(expr.program, (yyvsp[-2].expr));
				exfreenode(expr.program, (yyvsp[0].expr));
			}
			else if (!BUILTIN((yyvsp[-2].expr)->type) || !BUILTIN((yyvsp[0].expr)->type)) {
				checkBinary(expr.program, (yyvsp[-2].expr), (yyval.expr), (yyvsp[0].expr));
			}
		}
#line 2141 "exparse.c"
    break;

  case 49: /* expr: expr '-' expr  */
#line 612 "../../lib/expr/exparse.y"
                {
			goto binary;
		}
#line 2149 "exparse.c"
    break;

  case 50: /* expr: expr '*' expr  */
#line 616 "../../lib/expr/exparse.y"
                {
			goto binary;
		}
#line 2157 "exparse.c"
    break;

  case 51: /* expr: expr '/' expr  */
#line 620 "../../lib/expr/exparse.y"
                {
			goto binary;
		}
#line 2165 "exparse.c"
    break;

  case 52: /* expr: expr '%' expr  */
#line 624 "../../lib/expr/exparse.y"
                {
			goto binary;
		}
#line 2173 "exparse.c"
    break;

  case 53: /* expr: expr LSH expr  */
#line 628 "../../lib/expr/exparse.y"
                {
			goto binary;
		}
#line 2181 "exparse.c"
    break;

  case 54: /* expr: expr RSH expr  */
#line 632 "../../lib/expr/exparse.y"
                {
			goto binary;
		}
#line 2189 "exparse.c"
    break;

  case 55: /* expr: expr '>' expr  */
#line 636 "../../lib/expr/exparse.y"
                {
			goto relational;
		}
#line 2197 "exparse.c"
    break;

  case 56: /* expr: expr LE expr  */
#line 640 "../../lib/expr/exparse.y"
                {
			goto relational;
		}
#line 2205 "exparse.c"
    break;

  case 57: /* expr: expr GE expr  */
#line 644 "../../lib/expr/exparse.y"
                {
			goto relational;
		}
#line 2213 "exparse.c"
    break;

  case 58: /* expr: expr EQ expr  */
#line 648 "../../lib/expr/exparse.y"
                {
			goto relational;
		}
#line 2221 "exparse.c"
    break;

  case 59: /* expr: expr NE expr  */
#line 652 "../../lib/expr/exparse.y"
                {
			goto relational;
		}
#line 2229 "exparse.c"
    break;

  case 60: /* expr: expr '&' expr  */
#line 656 "../../lib/expr/exparse.y"
                {
			goto binary;
		}
#line 2237 "exparse.c"
    break;

  case 61: /* expr: expr '|' expr  */
#line 660 "../../lib/expr/exparse.y"
                {
			goto binary;
		}
#line 2245 "exparse.c"
    break;

  case 62: /* expr: expr '^' expr  */
#line 664 "../../lib/expr/exparse.y"
                {
			goto binary;
		}
#line 2253 "exparse.c"
    break;

  case 63: /* expr: expr '+' expr  */
#line 668 "../../lib/expr/exparse.y"
                {
			goto binary;
		}
#line 2261 "exparse.c"
    break;

  case 64: /* expr: expr AND expr  */
#line 672 "../../lib/expr/exparse.y"
                {
		logical:
			if ((yyvsp[-2].expr)->type == STRING)
				(yyvsp[-2].expr) = exnewnode(expr.program, S2B, true, INTEGER, (yyvsp[-2].expr), NULL);
			else if (!BUILTIN((yyvsp[-2].expr)->type))
				(yyvsp[-2].expr) = excast(expr.program, (yyvsp[-2].expr), INTEGER, NULL, 0);
			if ((yyvsp[0].expr)->type == STRING)
				(yyvsp[0].expr) = exnewnode(expr.program, S2B, true, INTEGER, (yyvsp[0].expr), NULL);
			else if (!BUILTIN((yyvsp[0].expr)->type))
				(yyvsp[0].expr) = excast(expr.program, (yyvsp[0].expr), INTEGER, NULL, 0);
			goto binary;
		}
#line 2278 "exparse.c"
    break;

  case 65: /* expr: expr OR expr  */
#line 685 "../../lib/expr/exparse.y"
                {
			goto logical;
		}
#line 2286 "exparse.c"
    break;

  case 66: /* expr: expr ',' expr  */
#line 689 "../../lib/expr/exparse.y"
                {
			if ((yyvsp[-2].expr)->op == CONSTANT)
			{
				exfreenode(expr.program, (yyvsp[-2].expr));
				(yyval.expr) = (yyvsp[0].expr);
			}
			else
				(yyval.expr) = exnewnode(expr.program, ',', true, (yyvsp[0].expr)->type, (yyvsp[-2].expr), (yyvsp[0].expr));
		}
#line 2300 "exparse.c"
    break;

  case 67: /* $@5: %empty  */
#line 698 "../../lib/expr/exparse.y"
                                 {expr.nolabel=1;}
#line 2306 "exparse.c"
    break;

  case 68: /* $@6: %empty  */
#line 698 "../../lib/expr/exparse.y"
                                                            {expr.nolabel=0;}
#line 2312 "exparse.c"
    break;

  case 69: /* expr: expr '?' $@5 expr ':' $@6 expr  */
#line 699 "../../lib/expr/exparse.y"
                {
			if (!(yyvsp[-3].expr)->type)
			{
				if (!(yyvsp[0].expr)->type)
					(yyvsp[-3].expr)->type = (yyvsp[0].expr)->type = INTEGER;
				else
					(yyvsp[-3].expr)->type = (yyvsp[0].expr)->type;
			}
			else if (!(yyvsp[0].expr)->type)
				(yyvsp[0].expr)->type = (yyvsp[-3].expr)->type;
			if ((yyvsp[-6].expr)->type == STRING)
				(yyvsp[-6].expr) = exnewnode(expr.program, S2B, true, INTEGER, (yyvsp[-6].expr), NULL);
			else if (!INTEGRAL((yyvsp[-6].expr)->type))
				(yyvsp[-6].expr) = excast(expr.program, (yyvsp[-6].expr), INTEGER, NULL, 0);
			if ((yyvsp[-3].expr)->type != (yyvsp[0].expr)->type)
			{
				if ((yyvsp[-3].expr)->type == STRING || (yyvsp[0].expr)->type == STRING)
					exerror("if statement string type mismatch");
				else if ((yyvsp[-3].expr)->type == FLOATING)
					(yyvsp[0].expr) = excast(expr.program, (yyvsp[0].expr), FLOATING, NULL, 0);
				else if ((yyvsp[0].expr)->type == FLOATING)
					(yyvsp[-3].expr) = excast(expr.program, (yyvsp[-3].expr), FLOATING, NULL, 0);
			}
			if ((yyvsp[-6].expr)->op == CONSTANT)
			{
				if ((yyvsp[-6].expr)->data.constant.value.integer)
				{
					(yyval.expr) = (yyvsp[-3].expr);
					exfreenode(expr.program, (yyvsp[0].expr));
				}
				else
				{
					(yyval.expr) = (yyvsp[0].expr);
					exfreenode(expr.program, (yyvsp[-3].expr));
				}
				exfreenode(expr.program, (yyvsp[-6].expr));
			}
			else
				(yyval.expr) = exnewnode(expr.program, '?', true, (yyvsp[-3].expr)->type, (yyvsp[-6].expr), exnewnode(expr.program, ':', true, (yyvsp[-3].expr)->type, (yyvsp[-3].expr), (yyvsp[0].expr)));
		}
#line 2357 "exparse.c"
    break;

  case 70: /* expr: '!' expr  */
#line 740 "../../lib/expr/exparse.y"
                {
		iunary:
			if ((yyvsp[0].expr)->type == STRING)
				(yyvsp[0].expr) = exnewnode(expr.program, S2B, true, INTEGER, (yyvsp[0].expr), NULL);
			else if (!INTEGRAL((yyvsp[0].expr)->type))
				(yyvsp[0].expr) = excast(expr.program, (yyvsp[0].expr), INTEGER, NULL, 0);
		unary:
			(yyval.expr) = exnewnode(expr.program, (yyvsp[-1].op), true, (yyvsp[0].expr)->type == UNSIGNED ? INTEGER : (yyvsp[0].expr)->type, (yyvsp[0].expr), NULL);
			if ((yyvsp[0].expr)->op == CONSTANT)
			{
				(yyval.expr)->data.constant.value = exeval(expr.program, (yyval.expr), NULL);
				(yyval.expr)->binary = false;
				(yyval.expr)->op = CONSTANT;
				exfreenode(expr.program, (yyvsp[0].expr));
			}
			else if (!BUILTIN((yyvsp[0].expr)->type)) {
				checkBinary(expr.program, (yyvsp[0].expr), (yyval.expr), 0);
			}
		}
#line 2381 "exparse.c"
    break;

  case 71: /* expr: '#' DYNAMIC  */
#line 760 "../../lib/expr/exparse.y"
                {
			if ((yyvsp[0].id)->local == NULL)
              			exerror("cannot apply '#' operator to non-array %s", (yyvsp[0].id)->name);
			(yyval.expr) = exnewnode(expr.program, '#', false, INTEGER, NULL, NULL);
			(yyval.expr)->data.variable.symbol = (yyvsp[0].id);
		}
#line 2392 "exparse.c"
    break;

  case 72: /* expr: '#' ARRAY  */
#line 767 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, '#', false, INTEGER, NULL, NULL);
			(yyval.expr)->data.variable.symbol = (yyvsp[0].id);
		}
#line 2401 "exparse.c"
    break;

  case 73: /* expr: '~' expr  */
#line 772 "../../lib/expr/exparse.y"
                {
			goto iunary;
		}
#line 2409 "exparse.c"
    break;

  case 74: /* expr: '-' expr  */
#line 776 "../../lib/expr/exparse.y"
                {
			goto unary;
		}
#line 2417 "exparse.c"
    break;

  case 75: /* expr: '+' expr  */
#line 780 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = (yyvsp[0].expr);
		}
#line 2425 "exparse.c"
    break;

  case 76: /* expr: '&' variable  */
#line 784 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, ADDRESS, false, T((yyvsp[0].expr)->type), (yyvsp[0].expr), NULL);
		}
#line 2433 "exparse.c"
    break;

  case 77: /* expr: ARRAY '[' args ']'  */
#line 788 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, ARRAY, true, T((yyvsp[-3].id)->type), call(0, (yyvsp[-3].id), (yyvsp[-1].expr)), (yyvsp[-1].expr));
		}
#line 2441 "exparse.c"
    break;

  case 78: /* expr: FUNCTION '(' args ')'  */
#line 792 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, FUNCTION, true, T((yyvsp[-3].id)->type), call(0, (yyvsp[-3].id), (yyvsp[-1].expr)), (yyvsp[-1].expr));
		}
#line 2449 "exparse.c"
    break;

  case 79: /* expr: GSUB '(' args ')'  */
#line 796 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewsub (expr.program, (yyvsp[-1].expr), GSUB);
		}
#line 2457 "exparse.c"
    break;

  case 80: /* expr: SUB '(' args ')'  */
#line 800 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewsub (expr.program, (yyvsp[-1].expr), SUB);
		}
#line 2465 "exparse.c"
    break;

  case 81: /* expr: SUBSTR '(' args ')'  */
#line 804 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewsubstr (expr.program, (yyvsp[-1].expr));
		}
#line 2473 "exparse.c"
    break;

  case 82: /* expr: splitop '(' expr ',' DYNAMIC ')'  */
#line 808 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewsplit (expr.program, (yyvsp[-5].id)->index, (yyvsp[-1].id), (yyvsp[-3].expr), NULL);
		}
#line 2481 "exparse.c"
    break;

  case 83: /* expr: splitop '(' expr ',' DYNAMIC ',' expr ')'  */
#line 812 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewsplit (expr.program, (yyvsp[-7].id)->index, (yyvsp[-3].id), (yyvsp[-5].expr), (yyvsp[-1].expr));
		}
#line 2489 "exparse.c"
    break;

  case 84: /* expr: EXIT '(' expr ')'  */
#line 816 "../../lib/expr/exparse.y"
                {
			if (!INTEGRAL((yyvsp[-1].expr)->type))
				(yyvsp[-1].expr) = excast(expr.program, (yyvsp[-1].expr), INTEGER, NULL, 0);
			(yyval.expr) = exnewnode(expr.program, EXIT, true, INTEGER, (yyvsp[-1].expr), NULL);
		}
#line 2499 "exparse.c"
    break;

  case 85: /* expr: RAND '(' ')'  */
#line 822 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, RAND, false, FLOATING, NULL, NULL);
		}
#line 2507 "exparse.c"
    break;

  case 86: /* expr: SRAND '(' ')'  */
#line 826 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, SRAND, false, INTEGER, NULL, NULL);
		}
#line 2515 "exparse.c"
    break;

  case 87: /* expr: SRAND '(' expr ')'  */
#line 830 "../../lib/expr/exparse.y"
                {
			if (!INTEGRAL((yyvsp[-1].expr)->type))
				(yyvsp[-1].expr) = excast(expr.program, (yyvsp[-1].expr), INTEGER, NULL, 0);
			(yyval.expr) = exnewnode(expr.program, SRAND, true, INTEGER, (yyvsp[-1].expr), NULL);
		}
#line 2525 "exparse.c"
    break;

  case 88: /* expr: PROCEDURE '(' args ')'  */
#line 836 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, CALL, true, (yyvsp[-3].id)->type, NULL, (yyvsp[-1].expr));
			(yyval.expr)->data.call.procedure = (yyvsp[-3].id);
		}
#line 2534 "exparse.c"
    break;

  case 89: /* expr: PRINT '(' args ')'  */
#line 841 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exprint(expr.program, (yyvsp[-3].id), (yyvsp[-1].expr));
		}
#line 2542 "exparse.c"
    break;

  case 90: /* expr: print '(' args ')'  */
#line 845 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, (yyvsp[-3].id)->index, false, (yyvsp[-3].id)->type, NULL, NULL);
			if ((yyvsp[-1].expr) && (yyvsp[-1].expr)->data.operand.left->type == INTEGER)
			{
				(yyval.expr)->data.print.descriptor = (yyvsp[-1].expr)->data.operand.left;
				(yyvsp[-1].expr) = (yyvsp[-1].expr)->data.operand.right;
			}
			else 
				switch ((yyvsp[-3].id)->index)
				{
				case QUERY:
					(yyval.expr)->data.print.descriptor = exnewnode(expr.program, CONSTANT, false, INTEGER, NULL, NULL);
					(yyval.expr)->data.print.descriptor->data.constant.value.integer = 2;
					break;
				case PRINTF:
					(yyval.expr)->data.print.descriptor = exnewnode(expr.program, CONSTANT, false, INTEGER, NULL, NULL);
					(yyval.expr)->data.print.descriptor->data.constant.value.integer = 1;
					break;
				case SPRINTF:
					(yyval.expr)->data.print.descriptor = 0;
					break;
				}
			(yyval.expr)->data.print.args = preprint((yyvsp[-1].expr));
		}
#line 2571 "exparse.c"
    break;

  case 91: /* expr: scan '(' args ')'  */
#line 870 "../../lib/expr/exparse.y"
                {
			Exnode_t*	x;

			(yyval.expr) = exnewnode(expr.program, (yyvsp[-3].id)->index, false, (yyvsp[-3].id)->type, NULL, NULL);
			if ((yyvsp[-1].expr) && (yyvsp[-1].expr)->data.operand.left->type == INTEGER)
			{
				(yyval.expr)->data.scan.descriptor = (yyvsp[-1].expr)->data.operand.left;
				(yyvsp[-1].expr) = (yyvsp[-1].expr)->data.operand.right;
			}
			else 
				switch ((yyvsp[-3].id)->index)
				{
				case SCANF:
					(yyval.expr)->data.scan.descriptor = 0;
					break;
				case SSCANF:
					if ((yyvsp[-1].expr) && (yyvsp[-1].expr)->data.operand.left->type == STRING)
					{
						(yyval.expr)->data.scan.descriptor = (yyvsp[-1].expr)->data.operand.left;
						(yyvsp[-1].expr) = (yyvsp[-1].expr)->data.operand.right;
					}
					else
						exerror("%s: string argument expected", (yyvsp[-3].id)->name);
					break;
				}
			if (!(yyvsp[-1].expr) || !(yyvsp[-1].expr)->data.operand.left || (yyvsp[-1].expr)->data.operand.left->type != STRING)
				exerror("%s: format argument expected", (yyvsp[-3].id)->name);
			(yyval.expr)->data.scan.format = (yyvsp[-1].expr)->data.operand.left;
			for (x = (yyval.expr)->data.scan.args = (yyvsp[-1].expr)->data.operand.right; x; x = x->data.operand.right)
			{
				if (x->data.operand.left->op != ADDRESS)
					exerror("%s: address argument expected", (yyvsp[-3].id)->name);
				x->data.operand.left = x->data.operand.left->data.operand.left;
			}
		}
#line 2611 "exparse.c"
    break;

  case 92: /* expr: variable assign  */
#line 906 "../../lib/expr/exparse.y"
                {
			if ((yyvsp[0].expr))
			{
				if ((yyvsp[-1].expr)->op == ID && !expr.program->disc->setf)
					exerror("%s: variable assignment not supported", (yyvsp[-1].expr)->data.variable.symbol->name);
				else
				{
					if (!(yyvsp[-1].expr)->type)
						(yyvsp[-1].expr)->type = (yyvsp[0].expr)->type;
					else if ((yyvsp[0].expr)->type != (yyvsp[-1].expr)->type)
					{
						(yyvsp[0].expr)->type = (yyvsp[-1].expr)->type;
						(yyvsp[0].expr)->data.operand.right = excast(expr.program, (yyvsp[0].expr)->data.operand.right, (yyvsp[-1].expr)->type, NULL, 0);
					}
					(yyvsp[0].expr)->data.operand.left = (yyvsp[-1].expr);
					(yyval.expr) = (yyvsp[0].expr);
				}
			}
		}
#line 2635 "exparse.c"
    break;

  case 93: /* expr: INC variable  */
#line 926 "../../lib/expr/exparse.y"
                {
		pre:
			if ((yyvsp[0].expr)->type == STRING)
				exerror("++ and -- invalid for string variables");
			(yyval.expr) = exnewnode(expr.program, (yyvsp[-1].op), false, (yyvsp[0].expr)->type, (yyvsp[0].expr), NULL);
			(yyval.expr)->subop = PRE;
		}
#line 2647 "exparse.c"
    break;

  case 94: /* expr: variable INC  */
#line 934 "../../lib/expr/exparse.y"
                {
		pos:
			if ((yyvsp[-1].expr)->type == STRING)
				exerror("++ and -- invalid for string variables");
			(yyval.expr) = exnewnode(expr.program, (yyvsp[0].op), false, (yyvsp[-1].expr)->type, (yyvsp[-1].expr), NULL);
			(yyval.expr)->subop = POS;
		}
#line 2659 "exparse.c"
    break;

  case 95: /* expr: expr IN_OP DYNAMIC  */
#line 942 "../../lib/expr/exparse.y"
                {
			if ((yyvsp[0].id)->local == NULL)
              			exerror("cannot apply IN to non-array %s", (yyvsp[0].id)->name);
			if ((yyvsp[0].id)->index_type > 0 && (yyvsp[-2].expr)->type != (yyvsp[0].id)->index_type)
            		    exerror("%s indices must have type %s, not %s", 
				(yyvsp[0].id)->name, extypename(expr.program, (yyvsp[0].id)->index_type),extypename(expr.program, (yyvsp[-2].expr)->type));
			(yyval.expr) = exnewnode(expr.program, IN_OP, false, INTEGER, NULL, NULL);
			(yyval.expr)->data.variable.symbol = (yyvsp[0].id);
			(yyval.expr)->data.variable.index = (yyvsp[-2].expr);
		}
#line 2674 "exparse.c"
    break;

  case 96: /* expr: expr IN_OP ARRAY  */
#line 953 "../../lib/expr/exparse.y"
                {
			if ((yyvsp[0].id)->index_type > 0 && (yyvsp[-2].expr)->type != (yyvsp[0].id)->index_type)
            		    exerror("%s indices must have type %s, not %s",
				(yyvsp[0].id)->name, extypename(expr.program, (yyvsp[0].id)->index_type),extypename(expr.program, (yyvsp[-2].expr)->type));
			(yyval.expr) = exnewnode(expr.program, IN_OP, false, INTEGER, NULL, NULL);
			(yyval.expr)->data.variable.symbol = (yyvsp[0].id);
			(yyval.expr)->data.variable.index = (yyvsp[-2].expr);
		}
#line 2687 "exparse.c"
    break;

  case 97: /* expr: DEC variable  */
#line 962 "../../lib/expr/exparse.y"
                {
			goto pre;
		}
#line 2695 "exparse.c"
    break;

  case 98: /* expr: variable DEC  */
#line 966 "../../lib/expr/exparse.y"
                {
			goto pos;
		}
#line 2703 "exparse.c"
    break;

  case 102: /* constant: CONSTANT  */
#line 976 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, CONSTANT, false, (yyvsp[0].id)->type, NULL, NULL);
			if (!expr.program->disc->reff)
				exerror("%s: identifier references not supported", (yyvsp[0].id)->name);
			else
				(yyval.expr)->data.constant.value = expr.program->disc->reff(expr.program, (yyval.expr), (yyvsp[0].id), NULL);
		}
#line 2715 "exparse.c"
    break;

  case 103: /* constant: FLOATING  */
#line 984 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, CONSTANT, false, FLOATING, NULL, NULL);
			(yyval.expr)->data.constant.value.floating = (yyvsp[0].floating);
		}
#line 2724 "exparse.c"
    break;

  case 104: /* constant: INTEGER  */
#line 989 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, CONSTANT, false, INTEGER, NULL, NULL);
			(yyval.expr)->data.constant.value.integer = (yyvsp[0].integer);
		}
#line 2733 "exparse.c"
    break;

  case 105: /* constant: STRING  */
#line 994 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, CONSTANT, false, STRING, NULL, NULL);
			(yyval.expr)->data.constant.value.string = (yyvsp[0].string);
		}
#line 2742 "exparse.c"
    break;

  case 106: /* constant: UNSIGNED  */
#line 999 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, CONSTANT, false, UNSIGNED, NULL, NULL);
			(yyval.expr)->data.constant.value.integer = (yyvsp[0].integer);
		}
#line 2751 "exparse.c"
    break;

  case 112: /* variable: ID members  */
#line 1015 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = makeVar(expr.program, (yyvsp[-1].id), 0, 0, (yyvsp[0].reference));
		}
#line 2759 "exparse.c"
    break;

  case 113: /* variable: DYNAMIC index members  */
#line 1019 "../../lib/expr/exparse.y"
                {
			Exnode_t *n = exnewnode(expr.program, DYNAMIC, false, (yyvsp[-2].id)->type, NULL, NULL);
			n->data.variable.symbol = (yyvsp[-2].id);
			n->data.variable.reference = 0;
			if (((n->data.variable.index = (yyvsp[-1].expr)) == 0) != ((yyvsp[-2].id)->local == NULL))
				exerror("%s: is%s an array", (yyvsp[-2].id)->name, (yyvsp[-2].id)->local != NULL ? "" : " not");
			if ((yyvsp[-2].id)->local != NULL && (yyvsp[-2].id)->index_type > 0) {
				if ((yyvsp[-1].expr)->type != (yyvsp[-2].id)->index_type)
					exerror("%s: indices must have type %s, not %s", 
						(yyvsp[-2].id)->name, extypename(expr.program, (yyvsp[-2].id)->index_type),extypename(expr.program, (yyvsp[-1].expr)->type));
			}
			if ((yyvsp[0].reference)) {
				n->data.variable.dyna = exnewnode(expr.program, 0, false, 0, NULL, NULL);
				(yyval.expr) = makeVar(expr.program, (yyvsp[-2].id), (yyvsp[-1].expr), n, (yyvsp[0].reference));
			}
			else (yyval.expr) = n;
		}
#line 2781 "exparse.c"
    break;

  case 114: /* variable: NAME  */
#line 1037 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, ID, false, STRING, NULL, NULL);
			(yyval.expr)->data.variable.symbol = (yyvsp[0].id);
			(yyval.expr)->data.variable.reference = 0;
			(yyval.expr)->data.variable.index = 0;
			(yyval.expr)->data.variable.dyna = 0;
			if (!(expr.program->disc->flags & EX_UNDECLARED))
				exerror("unknown identifier");
		}
#line 2795 "exparse.c"
    break;

  case 115: /* array: %empty  */
#line 1049 "../../lib/expr/exparse.y"
                {
			(yyval.integer) = 0;
		}
#line 2803 "exparse.c"
    break;

  case 116: /* array: '[' ']'  */
#line 1053 "../../lib/expr/exparse.y"
                {
			(yyval.integer) = -1;
		}
#line 2811 "exparse.c"
    break;

  case 117: /* array: '[' DECLARE ']'  */
#line 1057 "../../lib/expr/exparse.y"
                {
			/* If DECLARE is VOID, its type is 0, so this acts like
			 * the empty case.
			 */
			if (INTEGRAL((yyvsp[-1].id)->type))
				(yyval.integer) = INTEGER;
			else
				(yyval.integer) = (yyvsp[-1].id)->type;
				
		}
#line 2826 "exparse.c"
    break;

  case 118: /* index: %empty  */
#line 1070 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = 0;
		}
#line 2834 "exparse.c"
    break;

  case 119: /* index: '[' expr ']'  */
#line 1074 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = (yyvsp[-1].expr);
		}
#line 2842 "exparse.c"
    break;

  case 120: /* args: %empty  */
#line 1080 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = 0;
		}
#line 2850 "exparse.c"
    break;

  case 121: /* args: arg_list  */
#line 1084 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = (yyvsp[0].expr)->data.operand.left;
			(yyvsp[0].expr)->data.operand.left = (yyvsp[0].expr)->data.operand.right = 0;
			exfreenode(expr.program, (yyvsp[0].expr));
		}
#line 2860 "exparse.c"
    break;

  case 122: /* arg_list: expr  */
#line 1092 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, ',', true, 0, exnewnode(expr.program, ',', true, (yyvsp[0].expr)->type, (yyvsp[0].expr), NULL), NULL);
			(yyval.expr)->data.operand.right = (yyval.expr)->data.operand.left;
		}
#line 2869 "exparse.c"
    break;

  case 123: /* arg_list: arg_list ',' expr  */
#line 1097 "../../lib/expr/exparse.y"
                {
			(yyvsp[-2].expr)->data.operand.right = (yyvsp[-2].expr)->data.operand.right->data.operand.right = exnewnode(expr.program, ',', true, (yyvsp[-2].expr)->type, (yyvsp[0].expr), NULL);
		}
#line 2877 "exparse.c"
    break;

  case 124: /* formals: %empty  */
#line 1103 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = 0;
		}
#line 2885 "exparse.c"
    break;

  case 125: /* formals: DECLARE  */
#line 1107 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = 0;
			if ((yyvsp[0].id)->type)
				exerror("(void) expected");
		}
#line 2895 "exparse.c"
    break;

  case 127: /* formal_list: formal_item  */
#line 1116 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, ',', true, (yyvsp[0].expr)->type, (yyvsp[0].expr), NULL);
		}
#line 2903 "exparse.c"
    break;

  case 128: /* formal_list: formal_list ',' formal_item  */
#line 1120 "../../lib/expr/exparse.y"
                {
			Exnode_t*	x;
			Exnode_t*	y;

			(yyval.expr) = (yyvsp[-2].expr);
			for (x = (yyvsp[-2].expr); (y = x->data.operand.right); x = y);
			x->data.operand.right = exnewnode(expr.program, ',', true, (yyvsp[0].expr)->type, (yyvsp[0].expr), NULL);
		}
#line 2916 "exparse.c"
    break;

  case 129: /* $@7: %empty  */
#line 1130 "../../lib/expr/exparse.y"
                                {expr.declare=(yyvsp[0].id)->type;}
#line 2922 "exparse.c"
    break;

  case 130: /* formal_item: DECLARE $@7 name  */
#line 1131 "../../lib/expr/exparse.y"
                {
			if ((yyvsp[-2].id)->type == 0) {
				exerror("%s: parameters to functions cannot be void typed", (yyvsp[0].id)->name);
			}
			(yyval.expr) = exnewnode(expr.program, ID, false, (yyvsp[-2].id)->type, NULL, NULL);
			(yyval.expr)->data.variable.symbol = (yyvsp[0].id);
			(yyvsp[0].id)->lex = DYNAMIC;
			(yyvsp[0].id)->type = (yyvsp[-2].id)->type;
			(yyvsp[0].id)->value = exnewnode(expr.program, 0, false, 0, NULL, NULL);
			expr.procedure->data.procedure.arity++;
			expr.declare = 0;
		}
#line 2939 "exparse.c"
    break;

  case 131: /* members: %empty  */
#line 1146 "../../lib/expr/exparse.y"
                {
			(yyval.reference) = expr.refs = 0;
		}
#line 2947 "exparse.c"
    break;

  case 132: /* members: member  */
#line 1150 "../../lib/expr/exparse.y"
                {
			Exref_t*	r;

			r = ARENA_NEW(&expr.program->vm, Exref_t);
			r->symbol = (yyvsp[0].id);
			expr.refs = r;
			r->next = 0;
			r->index = 0;
			(yyval.reference) = expr.refs;
		}
#line 2962 "exparse.c"
    break;

  case 133: /* members: '.' ID member  */
#line 1161 "../../lib/expr/exparse.y"
                {
			Exref_t*	r;
			Exref_t*	l;

			r = ARENA_NEW(&expr.program->vm, Exref_t);
			r->symbol = (yyvsp[0].id);
			r->index = 0;
			r->next = 0;
			l = ARENA_NEW(&expr.program->vm, Exref_t);
			l->symbol = (yyvsp[-1].id);
			l->index = 0;
			l->next = r;
			expr.refs = l;
			(yyval.reference) = expr.refs;
		}
#line 2982 "exparse.c"
    break;

  case 134: /* member: '.' ID  */
#line 1179 "../../lib/expr/exparse.y"
                {
			(yyval.id) = (yyvsp[0].id);
		}
#line 2990 "exparse.c"
    break;

  case 135: /* member: '.' NAME  */
#line 1183 "../../lib/expr/exparse.y"
                {
			(yyval.id) = (yyvsp[0].id);
		}
#line 2998 "exparse.c"
    break;

  case 136: /* assign: %empty  */
#line 1188 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = 0;
		}
#line 3006 "exparse.c"
    break;

  case 137: /* assign: '=' expr  */
#line 1192 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = exnewnode(expr.program, '=', true, (yyvsp[0].expr)->type, NULL, (yyvsp[0].expr));
			(yyval.expr)->subop = (yyvsp[-1].op);
		}
#line 3015 "exparse.c"
    break;

  case 139: /* $@8: %empty  */
#line 1199 "../../lib/expr/exparse.y"
                            {
				if (expr.procedure)
					exerror("%s: nested function definitions not supported", expr.id->name);
				expr.procedure = exnewnode(expr.program, PROCEDURE, true, expr.declare, NULL, NULL);
				if (!streq(expr.id->name, "begin"))
				{
					static Dtdisc_t disc = {.key = offsetof(Exid_t, name)};
					if (!(expr.procedure->data.procedure.frame = dtopen(&disc, Dtset)) || !dtview(expr.procedure->data.procedure.frame, expr.program->symbols))
						exnospace();
					expr.program->symbols = expr.program->frame = expr.procedure->data.procedure.frame;
				}
				expr.declare = 0;
			}
#line 3033 "exparse.c"
    break;

  case 140: /* $@9: %empty  */
#line 1211 "../../lib/expr/exparse.y"
                                  {
				expr.id->lex = PROCEDURE;
				expr.id->type = expr.procedure->type;
				expr.declare = 0;
			}
#line 3043 "exparse.c"
    break;

  case 141: /* initialize: '(' $@8 formals $@9 ')' '{' statement_list '}'  */
#line 1216 "../../lib/expr/exparse.y"
                {
			(yyval.expr) = expr.procedure;
			expr.procedure = NULL;
			if (expr.program->frame)
			{
				expr.program->symbols = expr.program->frame->view;
				dtview(expr.program->frame, NULL);
				expr.program->frame = NULL;
			}
			// dictionary of locals no longer required, now that we have parsed the body
			(void)dtclose((yyval.expr)->data.procedure.frame);
			(yyval.expr)->data.procedure.frame = NULL;
			(yyval.expr)->data.procedure.args = (yyvsp[-5].expr);
			(yyval.expr)->data.procedure.body = excast(expr.program, (yyvsp[-1].expr), (yyval.expr)->type, NULL, 0);

			/*
			 * NOTE: procedure definition was slipped into the
			 *	 declaration initializer statement production,
			 *	 therefore requiring the statement terminator
			 */

			exunlex(expr.program, ';');
		}
#line 3071 "exparse.c"
    break;


#line 3075 "exparse.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == EX_EMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      yyerror (YY_("syntax error"));
    }

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= EX_EOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == EX_EOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = EX_EMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;
  ++yynerrs;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturnlab;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturnlab;


/*-----------------------------------------------------------.
| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
`-----------------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturnlab;


/*----------------------------------------------------------.
| yyreturnlab -- parsing is finished, clean up and return.  |
`----------------------------------------------------------*/
yyreturnlab:
  if (yychar != EX_EMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif

  return yyresult;
}

#line 1241 "../../lib/expr/exparse.y"


const char *exop(size_t index) {

  /* yytname is generated by the %token-table directive */

  /* find the index of MINTOKEN */
  size_t minid;
  for (minid = 0; yytname[minid] != NULL; ++minid) {
    if (strcmp(yytname[minid], "MINTOKEN") == 0) {
      break;
    }
  }

  assert(yytname[minid] != NULL
    && "failed to find MINTOKEN; incorrect token list in exparse.y?");

  /* find the requested token */
  {
    size_t i, j;
    for (i = j = minid; yytname[i] != NULL; ++i) {

      /* if this token is not a word, skip it */
      {
        size_t k;
        for (k = 0; yytname[i][k] != '\0'; ++k) {
          if (yytname[i][k] != '_' && !gv_isalnum(yytname[i][k])) {
            break;
          }
        }
        if (yytname[i][k] != '\0') {
          continue;
        }
      }

      if (j == index + minid) {
        return yytname[i];
      }
      ++j;
    }
  }

  /* failed to find the requested token */
  return NULL;
}

void ex_error(const char *message) {
  exerror("%s", message);
}

#include <expr/exgram.h>
