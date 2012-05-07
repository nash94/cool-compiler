/*
%%
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>
#include <math.h>
/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

%}

/*
 * Define names for regular expressions here.
 */
DARROW          =>
ASSIGNMENT      <-

CLASS_REG       class|CLASS
ELSE_REG        else|ELSE 
FI_REG          fi|FI
IF_REG          if|IF
IN_REG          in|IN
INHERITS_REG    inherits|INHERITS
LET_REG         let|LET
LOOP_REG        loop|LOOP
POOL_REG        pool|POOL
THEN_REG        then|THEN
WHILE_REG       while|WHILE
CASE_REG        case|CASE
ESAC_REG        esac|ESAC
OF_REG          of|OF
NEW_REG         new|NEW
ISVOID_REG      isvoid|ISVOID
TRUE_REG        t(rue|RUE)" "
FALSE_REG       f(alse|ALSE)" "

STRING          ["]([^"]*)["]
DIGIT           [0-9]+

TYPE_ID         [A-Z][a-zA-Z_]+
OBJECT_ID       [a-z][a-zA-Z_]+

PLUS_OP         "+"
MINUS_OP        "-"
MULT_OP         "*"
DIV_OP          "/"

OPEN_PARA       [\(]
CLOSE_PARA      [\)]
OPEN_CURLY      [\{]
CLOSE_CURLY     [\}]
OPEN_BRACKET    [\[]
CLOSE_BRACKET   [\]]

SEMICOLON       [;]+
METHOD_ACCESS   "."
LESS            [<]+
GREATER         [>]+
COLON           [:]+

WHITE_SPACE     [ \t\f\r\v]+
NEW_LINE        [\n]
%%
 /*
  *  Nested comments
  */

 /*
  *  The multiple-character operators.
  */
{DARROW}		{ return (DARROW); }
{ASSIGNMENT}    { return (ASSIGN); }

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */
{CLASS_REG}     { return (CLASS); }
{ELSE_REG}      { return (ELSE); }
{FI_REG}        { return (FI); }
{IF_REG}        { return (IF); }
{IN_REG}        { return (IN); }
{INHERITS_REG}  { return (INHERITS); }
{LET_REG}       { return (LET); }
{LOOP_REG}      { return (LOOP); }
{POOL_REG}      { return (POOL); }
{THEN_REG}      { return (THEN); }
{WHILE_REG}     { return (WHILE); }
{CASE_REG}      { return (CASE); }
{ESAC_REG}      { return (ESAC); }
{OF_REG}        { return (OF); }
{NEW_REG}       { return (NEW); }
{ISVOID_REG}    { return (ISVOID); } 

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */

{TYPE_ID}       { cool_yylval.symbol = inttable.add_string(yytext);
                  return (TYPEID);
                }

{OBJECT_ID}     { cool_yylval.symbol = inttable.add_string(yytext);
                  return (OBJECTID);
                }

{STRING}        { cool_yylval.symbol = inttable.add_string(yytext);
                  return(STR_CONST);
                }

{DIGIT}         { cool_yylval.symbol = inttable.add_string(yytext); 
                  return (INT_CONST); 
                }

{PLUS_OP}       { return(43); }
{MINUS_OP}      { return(45); }
{MULT_OP}       { return(42); }
{DIV_OP}        { return(47); }


{SEMICOLON}     { return(59); }
{OPEN_PARA}     { return(40); }
{CLOSE_PARA}    { return(41); }
{OPEN_CURLY}    { return(123);}
{CLOSE_CURLY}   { return(125);}
{OPEN_BRACKET}  { return(91); }
{CLOSE_BRACKET} { return(93); }
{COLON}         { return(58); }         
{METHOD_ACCESS} { return(46); }
{GREATER}       { return(62); }
{LESS}          { return(60); }

{WHITE_SPACE}
{NEW_LINE}      { curr_lineno++; }
.               { return(ERROR); }
