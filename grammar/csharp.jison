
%token IDENTIFIER 

%token ABSTRACT AS BASE BOOL BREAK BYTE CASE CATCH CHAR CHECKED CLASS CONST CONTINUE DECIMAL DEFAULT DELEGATE DO DOUBLE ELSE ENUM EVENT EXPLICIT EXTERN FALSE FINALLY FIXED FLOAT FOR FOREACH GOTO IF IMPLICIT IN INT INTERFACE INTERNAL IS LOCK LONG NAMESPACE NEW NULL OBJECT OPERATOR OUT OVERRIDE PARAMS PRIVATE PROTECTED PUBLIC READONLY REF RETURN SBYTE SEALED SHORT SIZEOF STACKALLOC STATIC STRING STRUCT SWITCH THIS THROW TRUE TRY TYPEOF UINT ULONG UNCHECKED UNSAFE USHORT USING VIRTUAL VOID VOLATILE WHILE 


%token REAL_LITERAL
%token INTEGER_LITERAL   
%token STRING_LITERAL
%token CHARACTER_LITERAL

%token OPEN_BRACE CLOSE_BRACE OPEN_BRACKET CLOSE_BRACKET OPEN_PARENS CLOSE_PARENS DOT COMMA COLON SEMICOLON PLUS MINUS STAR DIV PERCENT AMP BITWISE_OR CARET BANG TILDE ASSIGN LT GT INTERR DOUBLE_COLON OP_COALESCING OP_INC OP_DEC OP_AND OP_OR OP_PTR OP_EQ OP_NE OP_LE OP_GE OP_ADD_ASSIGNMENT OP_SUB_ASSIGNMENT OP_MULT_ASSIGNMENT OP_DIV_ASSIGNMENT OP_MOD_ASSIGNMENT OP_AND_ASSIGNMENT OP_OR_ASSIGNMENT OP_XOR_ASSIGNMENT OP_LEFT_SHIFT OP_LEFT_SHIFT_ASSIGNMENT RIGHT_SHIFT RIGHT_SHIFT_ASSIGNMENT


%token EOF 
 
%left OP_LEFT_SHIFT 

%left PERCENT
%left STAR DIV
%left PLUS MINUS 
 
%right ASSIGN OP_ADD_ASSIGNMENT OP_SUB_ASSIGNMENT OP_MULT_ASSIGNMENT OP_DIV_ASSIGNMENT OP_MOD_ASSIGNMENT OP_AND_ASSIGNMENT OP_OR_ASSIGNMENT OP_XOR_ASSIGNMENT OP_LEFT_SHIFT_ASSIGNMENT  RIGHT_SHIFT_ASSIGNMENT


%start compilationUnit

%%
compilationUnit
    : es EOF
        {   
            return {
                "node": "CompilationUnit1",
                "unicode": "1231"
            };
        }
    
    ;
 
 
es
    :   es e 
    |    e 
    ;
    

e  
    :   block             
        { 
            console.log('block '+$1);
        } 
    |   %empty             
        { 
            console.log('EMPTY');
        }
    ;
    

/* Boolearn Literals */
BOOLEAN_LITERAL
    :   TRUE
    |   FALSE
    ;
    

literal 
    :   BOOLEAN_LITERAL
    |   REAL_LITERAL
    |   INTEGER_LITERAL
    |   STRING_LITERAL
    |   CHARACTER_LITERAL
    |   NULL
    ;
 
/* C.2.1 Basic concepts */

namespace-name
    :   namespace-or-type-name
    ;
    
type-name
    :   namespace-or-type-name
    ;
    
namespace-or-type-name
    :   IDENTIFIER
    |   namespace-or-type-name DOT IDENTIFIER
    ;


/* C.2.2 Types */

type 
    :   value-type
    |   reference-type
    ;
    
value-type
    :   struct-type
    |   enum-type
    ;

struct-type
    :   type-name
    |   simple-type
    ;
    
simple-type
    :   numeric-type
    |   BOOL
    ;
    
numeric-type
    :    integral-type
    |    floating-point-type
    |    DECIMAL
    ;
    
integral-type
    :   SBYTE
    |   BYTE
    |   SHORT
    |   USHORT
    |   INT
    |   UINT
    |   LONG
    |   ULONG
    |   CHAR
    ;
    
floating-point-type
    :   FLOAT
    |   DOUBLE
    ;
    
enum-type
    :   type-name
    ;
    
reference-type
    :   class-type
    |   interface-type
    |   array-type
    |   delegate-type
    ;
    
class-type
    :   type-name
    |   OBJECT
    |   STRING
    ;
    
interface-type
    :   type-name
    ;
    
array-type
    :   non-array-type  rank-specifiers
    ;
    
non-array-type
    :   type
    ;
    
rank-specifiers
    :   rank-specifier
    |   rank-specifiers  rank-specifier
    ;
    
rank-specifier
    :   OPEN_BRACKET  CLOSE_BRACKET
    |   OPEN_BRACKET  dim-separators  CLOSE_BRACKET
    ;
    
dim-separators
    :   COMMA
    |   dim-separators  COMMA
    ;

delegate-type
    :   type-name
    ;


/* C.2.3 Variables */
variable-reference
    :   expression
    ;
    

/* C.2.4 Expressions */
argument-list
    :   argument
    |   argument-list   COMMA   argument
    ;
    
argument
    :   expression
    |   REF  variable-reference
    |   OUT  variable-reference
    ;
    
primary-expression
    :   primary-no-array-creation-expression
    |   array-creation-expression
    ;

primary-no-array-creation-expression
    :   literal
    |   simple-name
    |   parenthesized-expression
    |   member-access
    |   invocation-expression
    |   element-access
    |   this-access
    |   base-access
    |   post-increment-expression
    |   post-decrement-expression
    |   object-creation-expression
    |   delegate-creation-expression
    |   typeof-expression
    |   sizeof-expression
    |   checked-expression
    |   unchecked-expression
    ;
    
simple-name
    :   IDENTIFIER
    ;
    
parenthesized-expression
    :   OPEN_PARENS   expression   CLOSE_PARENS
    ;

member-access
    :   primary-expression   DOT   IDENTIFIER
    |   predefined-type   DOT   IDENTIFIER
    ;

predefined-type
    :   BOOL
    |   BYTE
    |   CHAR
    |   DECIMAL
    |   DOUBLE
    |   FLOAT
    |   INT
    |   LONG
    |   OBJECT
    |   SBYTE
    |   SHORT
    |   STRING
    |   UINT
    |   ULONG
    |   USHORT
    ; 

invocation-expression
    :   primary-expression   OPEN_PARENS   CLOSE_PARENS
    |   primary-expression   OPEN_PARENS   argument-list   CLOSE_PARENS
    ;
    
element-access
    :   primary-no-array-creation-expression   OPEN_BRACKET   expression-list   CLOSE_BRACKET
    ;

expression-list
    :   expression
    |   expression-list   COMMA   expression
    ;

this-access
    :   THIS
    ;
    
base-access
    :   base   DOT   IDENTIFIER
    |   base   OPEN_BRACKET   expression-list   CLOSE_BRACKET
    ;
    
post-increment-expression
    :   primary-expression   OP_INC
    ;

post-decrement-expression
    :   primary-expression   OP_DEC
    ;
    
object-creation-expression
    :   NEW   type   OPEN_PARENS   CLOSE_PARENS
    |   NEW   type   OPEN_PARENS   argument-list   CLOSE_PARENS
    ;

array-creation-expression
    :   NEW   non-array-type   OPEN_BRACKET   expression-list   CLOSE_BRACKET   
    |   NEW   non-array-type   OPEN_BRACKET   expression-list   CLOSE_BRACKET   rank-specifiers   
    |   NEW   non-array-type   OPEN_BRACKET   expression-list   CLOSE_BRACKET   array-initializer
    |   NEW   non-array-type   OPEN_BRACKET   expression-list   CLOSE_BRACKET   rank-specifiers   array-initializer
    |   NEW   array-type   array-initializer
    ;
    
delegate-creation-expression
    :   NEW   delegate-type   OPEN_PARENS   expression   CLOSE_PARENS
    ;
    
typeof-expression
    :   TYPEOF   OPEN_PARENS   type   CLOSE_PARENS
    |   TYPEOF   OPEN_PARENS   VOID   CLOSE_PARENS
    ;

checked-expression
    :   CHECKED   OPEN_PARENS   expression   CLOSE_PARENS
    ;

unchecked-expression
    :   UNCHECKED   OPEN_PARENS   expression   CLOSE_PARENS
    ;

unary-expression
    :   primary-expression
    |   PLUS    unary-expression
    |   MINUS   unary-expression
    |   BANG    unary-expression
    |   TILDE   unary-expression
    |   STAR    unary-expression
    |   pre-increment-expression
    |   pre-decrement-expression
    |   cast-expression
    ;

pre-increment-expression
    :   OP_INC   unary-expression
    ;

pre-decrement-expression
    :   OP_DEC   unary-expression
    ;

cast-expression
    :   OPEN_PARENS   type   CLOSE_PARENS   unary-expression
    ;

multiplicative-expression
    :   unary-expression
    |   multiplicative-expression   STAR        unary-expression
    |   multiplicative-expression   DIV         unary-expression
    |   multiplicative-expression   PERCENT     unary-expression
    ;
    
additive-expression
    :   multiplicative-expression
    |   additive-expression   PLUS   multiplicative-expression
    |   additive-expression   MINUS   multiplicative-expression
    ;

shift-expression
    :   additive-expression 
    |   shift-expression   OP_LEFT_SHIFT   additive-expression
    |   shift-expression   RIGHT_SHIFT   additive-expression
    ;

relational-expression
    :   shift-expression
    |   relational-expression   LT      shift-expression
    |   relational-expression   GT      shift-expression
    |   relational-expression   OP_LE   shift-expression
    |   relational-expression   OP_GE   shift-expression
    |   relational-expression   IS      type
    |   relational-expression   AS      type
    ;

equality-expression
    :   relational-expression
    |   equality-expression   OP_EQ   relational-expression
    |   equality-expression   OP_NE   relational-expression
    ;

and-expression
    :   equality-expression
    |   and-expression   AMP   equality-expression
    ;

exclusive-or-expression
    :   and-expression
    |   exclusive-or-expression   CARET   and-expression
    ;

inclusive-or-expression
    :   exclusive-or-expression
    |   inclusive-or-expression   BITWISE_OR   exclusive-or-expression
    ;

conditional-and-expression
    :   inclusive-or-expression
    |   conditional-and-expression   OP_AND   inclusive-or-expression
    ;

conditional-or-expression
    :   conditional-and-expression
    |   conditional-or-expression   OP_OR   conditional-and-expression
    ;

conditional-expression
    :   conditional-or-expression
    |   conditional-or-expression   INTERR   expression   COLON   expression
    ;
    
assignment
    :   unary-expression   assignment-operator   expression
    ;
    
assignment-operator
    :   ASSIGN
    |   OP_ADD_ASSIGNMENT
    |   OP_SUB_ASSIGNMENT
    |   OP_MULT_ASSIGNMENT
    |   OP_DIV_ASSIGNMENT
    |   OP_MOD_ASSIGNMENT
    |   OP_AND_ASSIGNMENT
    |   OP_OR_ASSIGNMENT
    |   OP_XOR_ASSIGNMENT
    |   OP_LEFT_SHIFT_ASSIGNMENT
    |   RIGHT_SHIFT_ASSIGNMENT
    ;
    
expression
    :   conditional-expression
    |   assignment
    ;
    
constant-expression
    :   expression
    ;
    
boolean-expression
    :   expression
    ;



/* C.2.5 Statements */
statement
    :   labeled-statement
    |   declaration-statement
    |   embedded-statement
    ;

embedded-statement
    :   block
    |   empty-statement
    |   expression-statement
    |   selection-statement
    |   iteration-statement
    |   jump-statement
    |   try-statement
    |   checked-statement
    |   unchecked-statement
    |   lock-statement
    |   using-statement
    ;
    
block
    :   OPEN_BRACE   CLOSE_BRACE
    |   OPEN_BRACE   statement-list   CLOSE_BRACE
    ;

statement-list
    :   statement
    |   statement-list   statement
    ;

empty-statement
    :   SEMICOLON
    ;

labeled-statement
    :   IDENTIFIER   COLON   statement
    ;

declaration-statement
    :   local-variable-declaration   SEMICOLON
    |   local-constant-declaration   SEMICOLON
    ;
    
local-variable-declaration
    :   type   local-variable-declarators
    ;

local-variable-declarators
    :   local-variable-declarator
    |   local-variable-declarators   COMMA   local-variable-declarator
    ;
    
local-variable
    :   %empty 
    |   IDENTIFIER  
    ;
    
local-variable-declarator
    :   local-variable
    |   local-variable   ASSIGN   local-variable-initializer
    ;
    
local-variable-initializer
    :   expression
    |   array-initializer
    ;

local-constant-declaration
    :   CONST   type   constant-declarators
    ;
    
constant-declarators
    :   constant-declarator
    |   constant-declarators   COMMA   constant-declarator
    ;
    
constant-declarator
    :   IDENTIFIER   ASSIGN   constant-expression
    ;
    
expression-statement
    :   statement-expression   SEMICOLON
    ;
    
statement-expression
    :   invocation-expression
    |   object-creation-expression
    |   assignment
    |   post-increment-expression
    |   post-decrement-expression
    |   pre-increment-expression
    |   pre-decrement-expression
    ;
    
selection-statement
    :   if-statement
    |   switch-statement
    ;
    
if-statement
    :   IF   OPEN_PARENS   boolean-expression   CLOSE_PARENS   embedded-statement
    |   IF   OPEN_PARENS   boolean-expression   CLOSE_PARENS   embedded-statement   ELSE   embedded-statement
    ;
    
boolean-expression
    :   expression
    ;

switch-statement
    :   SWITCH   OPEN_PARENS   expression   CLOSE_PARENS   switch-block
    ;
    
switch-block
    :   OPEN_BRACE   CLOSE_BRACE
    |   OPEN_BRACE   switch-sections   CLOSE_BRACE
    ;

switch-sections
    :   switch-section
    |   switch-sections   switch-section
    ;
    
switch-section
    :   switch-labels   statement-list
    ;
    
switch-labels
    :   switch-label
    |   switch-labels   switch-label
    ;
    
switch-label
    :   CASE   constant-expression   COLON
    |   DEFAULT   COLON
    ;

iteration-statement
    :   while-statement
    |   do-statement
    |   for-statement
    |   foreach-statement
    ;
    
while-statement
    :   WHILE   OPEN_PARENS   boolean-expression   CLOSE_PARENS   embedded-statement
    ;
    
do-statement
    :   DO   embedded-statement   WHILE   OPEN_PARENS   boolean-expression   CLOSE_PARENS   SEMICOLON
    ;

for-statement
    :   FOR   OPEN_PARENS   SEMICOLON   SEMICOLON   CLOSE_PARENS   embedded-statement
    |   FOR   OPEN_PARENS   for-initializer   SEMICOLON   SEMICOLON   CLOSE_PARENS   embedded-statement
    |   FOR   OPEN_PARENS   SEMICOLON   for-condition   SEMICOLON   CLOSE_PARENS   embedded-statement
    |   FOR   OPEN_PARENS   SEMICOLON   SEMICOLON   for-iterator   CLOSE_PARENS   embedded-statement
    |   FOR   OPEN_PARENS   for-initializer   SEMICOLON   for-condition   SEMICOLON   CLOSE_PARENS   embedded-statement
    |   FOR   OPEN_PARENS   for-initializer   SEMICOLON   SEMICOLON   for-iterator   CLOSE_PARENS   embedded-statement
    |   FOR   OPEN_PARENS   SEMICOLON   for-condition   SEMICOLON   for-iterator   CLOSE_PARENS   embedded-statement
    |   FOR   OPEN_PARENS   for-initializer   SEMICOLON   for-condition   SEMICOLON   for-iterator   CLOSE_PARENS   embedded-statement
    ;

for-initializer
    :   local-variable-declaration
    |   statement-expression-list
    ;

for-condition
    :   boolean-expression
    ;
    
for-iterator
    :   statement-expression-list
    ;
    
statement-expression-list
    :   statement-expression
    |   statement-expression-list   COMMA   statement-expression
    ;

foreach-statement
    :   FOREACH   OPEN_PARENS   type   IDENTIFIER   IN   expression   CLOSE_PARENS   embedded-statement
    ;
    
jump-statement
    :   break-statement
    |   continue-statement
    |   goto-statement
    |   return-statement
    |   throw-statement
    ;
    
break-statement
    :   BREAK   SEMICOLON
    ;

continue-statement
    :   CONTINUE   SEMICOLON
    ;

goto-statement
    :   GOTO   IDENTIFIER   SEMICOLON
    |   GOTO   CASE   constant-expression   SEMICOLON
    |   GOTO   DEFAULT   SEMICOLON
    ;
    
return-statement
    :   RETURN   SEMICOLON
    |   RETURN   expression   SEMICOLON
    ;

throw-statement
    :   THROW   SEMICOLON
    |   THROW   expression   SEMICOLON
    ;
    
try-statement
    :   TRY   block   catch-clauses
    |   TRY   block   finally-clause
    |   TRY   block   catch-clauses   finally-clause
    ;

catch-clauses
    :   specific-catch-clauses
    |   general-catch-clause
    |   specific-catch-clauses   general-catch-clause
    ;

specific-catch-clauses
    :   specific-catch-clause
    |   specific-catch-clauses   specific-catch-clause
    ;

specific-catch-clause
    :   CATCH   OPEN_PARENS   class-type   CLOSE_PARENS   block
    |   CATCH   OPEN_PARENS   class-type   IDENTIFIER   CLOSE_PARENS   block
    ;
    
general-catch-clause
    :   CATCH   block
    ;
    
finally-clause
    :   FINALLY   block
    ;
    
checked-statement
    :   CHECKED   block
    ;
    
unchecked-statement
    :   UNCHECKED   block
    ;
    
lock-statement
    :   LOCK   OPEN_PARENS   expression   CLOSE_PARENS   embedded-statement
    ;
    
using-statement
    :   USING   OPEN_PARENS    resource-acquisition   CLOSE_PARENS    embedded-statement
    ;
    
resource-acquisition
    :   local-variable-declaration
    |   expression
    ;

 
 
/* C.2.9 Arrays */
 
array-initializer
    :   OPEN_BRACE   CLOSE_BRACE
    |   OPEN_BRACE   variable-initializer-list   CLOSE_BRACE
    |   OPEN_BRACE   variable-initializer-list   COMMA   CLOSE_BRACE
    ;

variable-initializer-list
    :   variable-initializer
    |   variable-initializer-list   COMMA   variable-initializer
    ;

variable-initializer
    :   expression
    |   array-initializer
    ;



















































































