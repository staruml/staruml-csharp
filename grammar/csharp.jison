
%token IDENTIFIER 

%token ABSTRACT AS BASE BOOL BREAK BYTE CASE CATCH CHAR CHECKED CLASS CONST CONTINUE DECIMAL DEFAULT DELEGATE DO DOUBLE ELSE ENUM EVENT EXPLICIT EXTERN FALSE FINALLY FIXED FLOAT FOR FOREACH GOTO IF IMPLICIT IN INT INTERFACE INTERNAL IS LOCK LONG NAMESPACE NEW NULL OBJECT OPERATOR OUT OVERRIDE PARAMS PRIVATE PROTECTED PUBLIC READONLY REF RETURN SBYTE SEALED SHORT SIZEOF STACKALLOC STATIC STRING STRUCT SWITCH THIS THROW TRUE TRY TYPEOF UINT ULONG UNCHECKED UNSAFE USHORT USING VIRTUAL VOID VOLATILE WHILE 

%token ASSEMBLY MODULE FIELD METHOD PARAM PROPERTY TYPE

%token GET SET

%token ADD REMOVE

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
    : compilation-unit EOF
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
    :  expression
        {
            console.log('expression '+$1);
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
    :   namespace-or-type-name DOT IDENTIFIER
    |   IDENTIFIER
    ;


/* C.2.2 Types */

type 
    :   non-array-type
    |   array-type  
    ;

non-array-type
    :   type-name
    |   SBYTE
    |   BYTE
    |   SHORT
    |   USHORT
    |   INT
    |   UINT
    |   LONG
    |   ULONG
    |   CHAR
    |   FLOAT
    |   DOUBLE
    |   DECIMAL
    |   BOOL 
    |   OBJECT
    |   STRING  
    |   VOID 
    ;
    
array-type
    :   type  rank-specifiers
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
    |   cast-expression
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
    |   simple-name
    ;
    
simple-name
    :   IDENTIFIER
    ;
    
parenthesized-expression
    :   OPEN_PARENS   expression   CLOSE_PARENS
    {
        console.log('parentthisized '+$2);
    }
    ;

member-access
    :   primary-expression   DOT   IDENTIFIER
    |   type   DOT   IDENTIFIER
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
    :   BASE   DOT   IDENTIFIER
    |   BASE   OPEN_BRACKET   expression-list   CLOSE_BRACKET
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
    :   NEW   type   OPEN_PARENS   expression   CLOSE_PARENS
    ;
    
typeof-expression
    :   TYPEOF   OPEN_PARENS   type   CLOSE_PARENS
    ;

checked-expression
    :   CHECKED   OPEN_PARENS   expression   CLOSE_PARENS
    ;

unchecked-expression
    :   UNCHECKED   OPEN_PARENS   expression   CLOSE_PARENS
    ;

unary-expression
    :   cast-expression
    |   PLUS    unary-expression
    |   MINUS   unary-expression
    |   BANG    unary-expression
    |   TILDE   unary-expression
    |   STAR    unary-expression
    |   pre-increment-expression
    |   pre-decrement-expression
    |   primary-expression
    ;

pre-increment-expression
    :   OP_INC   unary-expression
    ;

pre-decrement-expression
    :   OP_DEC   unary-expression
    ;

cast-expression
    :   OPEN_PARENS   expression   CLOSE_PARENS   unary-expression
    {
        console.log('cast_ex');
    }
    |   OPEN_PARENS   type   CLOSE_PARENS   unary-expression
    {
        console.log('cast');
    }
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
    |   statement-expression SEMICOLON
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
    :   primary-expression   local-variable-declarators
    |   type   local-variable-declarators
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
    :   IDENTIFIER
    |   IDENTIFIER   ASSIGN   local-variable-initializer
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
    :   CATCH   OPEN_PARENS   type   CLOSE_PARENS   block
    |   CATCH   OPEN_PARENS   type   IDENTIFIER   CLOSE_PARENS   block
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



/* C.2.13 Attributes */
global-attributes
    :   global-attribute-sections
    ;
    
global-attribute-sections
    :   global-attribute-section
    |   global-attribute-sections global-attribute-section
    ;
    
global-attribute-section
    :   OPEN_BRACKET   global-attribute-target-specifier   attribute-list   CLOSE_BRACKET
    |   OPEN_BRACKET   global-attribute-target-specifier   attribute-list   COMMA   CLOSE_BRACKET
    ;
    
global-attribute-target-specifier
    :   global-attribute-target   COLON
    ;

global-attribute-target
    :   ASSEMBLY
    |   MODULE
    ;
    
attributes
    :   attribute-sections
    ;

attribute-sections
    :   attribute-section
    |   attribute-sections   attribute-section
    ;
    
attribute-section
    :   OPEN_BRACKET   attribute-list   CLOSE_BRACKET
    |   OPEN_BRACKET   attribute-list   COMMA   CLOSE_BRACKET
    |   OPEN_BRACKET   attribute-target-specifier   attribute-list   CLOSE_BRACKET
    |   OPEN_BRACKET   attribute-target-specifier   attribute-list   COMMA   CLOSE_BRACKET
    ;

attribute-target-specifier
    :   attribute-target   COLON
    ;

attribute-target
    :   FIELD
    |   EVENT
    |   METHOD
    |   PARAM
    |   PROPERTY
    |   RETURN
    |   TYPE
    ;
    
attribute-list
    :   attribute
    |   attribute-list   COMMA   attribute
    ;

attribute
    :   attribute-name  
    |   attribute-name   attribute-arguments   
    ;

attribute-name
    :   type-name
    ;
    
attribute-arguments
    :   OPEN_PARENS   CLOSE_PARENS
    |   OPEN_PARENS   positional-argument-list   CLOSE_PARENS
    |   OPEN_PARENS   positional-argument-list   COMMA   named-argument-list   CLOSE_PARENS
    |   OPEN_PARENS   named-argument-list   CLOSE_PARENS
    ;
    
positional-argument-list
    :   positional-argument
    |   positional-argument-list   COMMA   positional-argument
    ;

positional-argument
    :   attribute-argument-expression
    ;

named-argument-list
    :   named-argument
    |   named-argument-list   COMMA   named-argument
    ;
    
named-argument
    :   IDENTIFIER   ASSIGN   attribute-argument-expression
    ;
    
attribute-argument-expression
    :   expression
    ;




 

/* C.2.12 Delegates */

delegate-declaration
    :   DELEGATE   type   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS   SEMICOLON
    |   attributes   DELEGATE   type   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS   SEMICOLON
    |   modifiers   DELEGATE   type   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS   SEMICOLON
    |   DELEGATE   type   IDENTIFIER   OPEN_PARENS   formal-parameter-list   CLOSE_PARENS   SEMICOLON
    |   modifiers   DELEGATE   type   IDENTIFIER   OPEN_PARENS   formal-parameter-list   CLOSE_PARENS   SEMICOLON
    |   attributes   DELEGATE   type   IDENTIFIER   OPEN_PARENS   formal-parameter-list   CLOSE_PARENS   SEMICOLON
    |   attributes   modifiers   DELEGATE   type   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS   SEMICOLON
    |   attributes   modifiers   DELEGATE   type   IDENTIFIER   OPEN_PARENS   formal-parameter-list   CLOSE_PARENS   SEMICOLON
    ;
    
 

/* C.2.11 Enums */
enum-declaration
    :   ENUM   IDENTIFIER   enum-body
    |   attributes   ENUM   IDENTIFIER   enum-body 
    |   modifiers   ENUM   IDENTIFIER   enum-body
    |   ENUM   IDENTIFIER   enum-base   enum-body   
    |   ENUM   IDENTIFIER   enum-body   SEMICOLON
    |   attributes   modifiers   ENUM   IDENTIFIER   enum-body
    |   attributes   ENUM   IDENTIFIER   enum-base   enum-body
    |   attributes   ENUM   IDENTIFIER   enum-body   SEMICOLON
    |   modifiers   ENUM   IDENTIFIER   enum-base   enum-body   
    |   modifiers   ENUM   IDENTIFIER   enum-body   SEMICOLON
    |   ENUM   IDENTIFIER   enum-base   enum-body   SEMICOLON
    |   modifiers   ENUM   IDENTIFIER   enum-base   enum-body   SEMICOLON
    |   attributes   ENUM   IDENTIFIER   enum-base   enum-body   SEMICOLON
    |   attributes   modifiers   ENUM   IDENTIFIER   enum-body   SEMICOLON
    |   attributes   modifiers   ENUM   IDENTIFIER   enum-base   enum-body  
    |   attributes   modifiers   ENUM   IDENTIFIER   enum-base   enum-body   SEMICOLON
    ;
    

enum-base
    :   COLON   type
    ;
    
enum-body
    :   OPEN_BRACE   CLOSE_BRACE
    |   OPEN_BRACE   enum-member-declarations   CLOSE_BRACE
    |   OPEN_BRACE   enum-member-declarations   COMMA   CLOSE_BRACE
    ;

enum-modifiers
    :   enum-modifier
    |   enum-modifiers   enum-modifier
    ;
    
enum-modifier
    :   NEW
    |   PUBLIC
    |   PROTECTED
    |   INTERNAL
    |   PRIVATE
    ;
    
enum-member-declarations
    :   enum-member-declaration
    |   enum-member-declarations   COMMA   enum-member-declaration
    ;
    
enum-member-declaration
    :   IDENTIFIER
    |   attributes   IDENTIFIER
    |   IDENTIFIER   ASSIGN   constant-expression
    |   attributes   IDENTIFIER   ASSIGN   constant-expression
    ;


/* C.2.10 Interfaces */
interface-declaration
    :   INTERFACE   IDENTIFIER   interface-body
    |   attributes   INTERFACE   IDENTIFIER   interface-body 
    |   modifiers   INTERFACE   IDENTIFIER   interface-body
    |   INTERFACE   IDENTIFIER   interface-base   interface-body   
    |   INTERFACE   IDENTIFIER   interface-body   SEMICOLON
    |   attributes   modifiers   INTERFACE   IDENTIFIER   interface-body
    |   attributes   INTERFACE   IDENTIFIER   interface-base   interface-body
    |   attributes   INTERFACE   IDENTIFIER   interface-body   SEMICOLON
    |   modifiers   INTERFACE   IDENTIFIER   interface-base   interface-body   
    |   modifiers   INTERFACE   IDENTIFIER   interface-body   SEMICOLON
    |   INTERFACE   IDENTIFIER   interface-base   interface-body   SEMICOLON
    |   modifiers   INTERFACE   IDENTIFIER   interface-base   interface-body   SEMICOLON
    |   attributes   INTERFACE   IDENTIFIER   interface-base   interface-body   SEMICOLON
    |   attributes   modifiers   INTERFACE   IDENTIFIER   interface-body   SEMICOLON
    |   attributes   modifiers   INTERFACE   IDENTIFIER   interface-base   interface-body  
    |   attributes   modifiers   INTERFACE   IDENTIFIER   interface-base   interface-body   SEMICOLON
    ;
 
interface-base
    :   interface-type-list
    ;
    
interface-body
    :   OPEN_BRACE   CLOSE_BRACE
    |   OPEN_BRACE   interface-member-declarations   CLOSE_BRACE
    ;
    
interface-member-declarations
    :   interface-member-declaration
    |   interface-member-declarations   interface-member-declaration
    ;

interface-member-declaration
    :   interface-method-declaration
    |   interface-property-declaration
    |   interface-event-declaration
    |   interface-indexer-declaration
    ;
    
interface-method-declaration
    :   type   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS   SEMICOLON
    |   attributes   type   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS   SEMICOLON
    |   NEW   type   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS   SEMICOLON
    |   type   IDENTIFIER   OPEN_PARENS   formal-parameter-list   CLOSE_PARENS   SEMICOLON
    |   NEW   type   IDENTIFIER   OPEN_PARENS   formal-parameter-list   CLOSE_PARENS   SEMICOLON
    |   attributes   type   IDENTIFIER   OPEN_PARENS   formal-parameter-list   CLOSE_PARENS   SEMICOLON
    |   attributes   NEW   type   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS   SEMICOLON
    |   attributes   NEW   type   IDENTIFIER   OPEN_PARENS   formal-parameter-list   CLOSE_PARENS   SEMICOLON
    ;

interface-property-declaration
    :   type   IDENTIFIER   OPEN_BRACE   interface-accessors   CLOSE_BRACE
    |   attributes   type   IDENTIFIER   OPEN_BRACE   interface-accessors   CLOSE_BRACE
    |   NEW   type   IDENTIFIER   OPEN_BRACE   interface-accessors   CLOSE_BRACE
    |   attributes   NEW   type   IDENTIFIER   OPEN_BRACE   interface-accessors   CLOSE_BRACE
    ;
    
interface-accessors
    :   GET   SEMICOLON
    |   attributes   GET   SEMICOLON
    |   SET   SEMICOLON
    |   attributes   SET   SEMICOLON
    |   GET   SEMICOLON   SET   SEMICOLON
    |   attributes   GET   SEMICOLON   SET   SEMICOLON
    |   GET   SEMICOLON   attributes   SET   SEMICOLON
    |   attributes   GET   SEMICOLON   attributes   SET   SEMICOLON
    |   SET   SEMICOLON   GET   SEMICOLON
    |   attributes   SET   SEMICOLON   GET   SEMICOLON
    |   SET   SEMICOLON   attributes   GET   SEMICOLON
    |   attributes   SET   SEMICOLON   attributes   GET   SEMICOLON
    ;
    
interface-event-declaration
    :   EVENT   type   IDENTIFIER   SEMICOLON
    |   attributes   EVENT   type   IDENTIFIER   SEMICOLON
    |   NEW   EVENT   type   IDENTIFIER   SEMICOLON
    |   attributes   NEW   EVENT   type   IDENTIFIER   SEMICOLON
    ;

interface-indexer-declaration
    :   type   THIS   OPEN_BRACKET   formal-parameter-list   CLOSE_BRACKET   OPEN_BRACE   interface-accessors   CLOSE_BRACE
    |   attributes   type   THIS   OPEN_BRACKET   formal-parameter-list   CLOSE_BRACKET   OPEN_BRACE   interface-accessors   CLOSE_BRACE
    |   NEW   type   THIS   OPEN_BRACKET   formal-parameter-list   CLOSE_BRACKET   OPEN_BRACE   interface-accessors   CLOSE_BRACE
    |   attributes   NEW   type   THIS   OPEN_BRACKET   formal-parameter-list   CLOSE_BRACKET   OPEN_BRACE   interface-accessors   CLOSE_BRACE
    ;


/* C.2.8 Structs */
struct-declaration 
    :   STRUCT   IDENTIFIER   struct-body
    |   attributes   STRUCT   IDENTIFIER   struct-body 
    |   modifiers   STRUCT   IDENTIFIER   struct-body
    |   STRUCT   IDENTIFIER   struct-interfaces   struct-body   
    |   STRUCT   IDENTIFIER   struct-body   SEMICOLON
    |   attributes   modifiers   STRUCT   IDENTIFIER   struct-body
    |   attributes   STRUCT   IDENTIFIER   struct-interfaces   struct-body
    |   attributes   STRUCT   IDENTIFIER   struct-body   SEMICOLON
    |   modifiers   STRUCT   IDENTIFIER   struct-interfaces   interface-body   
    |   modifiers   STRUCT   IDENTIFIER   struct-body   SEMICOLON
    |   STRUCT   IDENTIFIER   struct-interfaces   struct-body   SEMICOLON
    |   modifiers   STRUCT   IDENTIFIER   struct-interfaces   struct-body   SEMICOLON
    |   attributes   STRUCT   IDENTIFIER   struct-interfaces   struct-body   SEMICOLON
    |   attributes   modifiers   STRUCT   IDENTIFIER   struct-body   SEMICOLON
    |   attributes   modifiers   STRUCT   IDENTIFIER   struct-interfaces   struct-body  
    |   attributes   modifiers   STRUCT   IDENTIFIER   struct-interfaces   struct-body   SEMICOLON 
    ;
 
struct-interfaces
    :   COLON   interface-type-list
    ;

struct-body
    :   OPEN_BRACE   CLOSE_BRACE
    |   OPEN_BRACE   struct-member-declarations   CLOSE_BRACE
    ;

struct-member-declarations
    :   struct-member-declaration
    |   struct-member-declarations   struct-member-declaration
    ;
    
struct-member-declaration
    :   constant-declaration
    |   field-declaration
    |   method-declaration
    |   property-declaration
    |   event-declaration
    |   indexer-declaration
    |   operator-declaration
    |   constructor-declaration
    |   static-constructor-declaration
    |   type-declaration
    ;



/* C.2.6 Namespaces */
compilation-unit
    :   %empty
    |   using-directives 
    |   global-attributes 
    |   namespace-member-declarations
    |   global-attributes   namespace-member-declarations
    |   using-directives   namespace-member-declarations
    |   using-directives   global-attributes
    |   using-directives   global-attributes   namespace-member-declarations
    ;

namespace-declaration
    :   NAMESPACE   namespace-or-type-name   namespace-body 
    |   NAMESPACE   namespace-or-type-name   namespace-body   SEMICOLON
    ;
 

namespace-body
    :   OPEN_BRACE   CLOSE_BRACE
    |   OPEN_BRACE   using-directives   CLOSE_BRACE
    |   OPEN_BRACE   namespace-member-declarations   CLOSE_BRACE
    |   OPEN_BRACE   using-directives   namespace-member-declarations   CLOSE_BRACE
    ;

using-directives
    :   using-directive
    |   using-directives   using-directive
    ;

using-directive
    :   using-alias-directive
    |   using-namespace-directive
    ;

using-alias-directive
    :   USING   IDENTIFIER   ASSIGN   namespace-or-type-name   SEMICOLON
    ;

using-namespace-directive
    :   USING   namespace-name   SEMICOLON
    ;

namespace-member-declarations
    :   namespace-member-declaration
    |   namespace-member-declarations   namespace-member-declaration
    ;
    
namespace-member-declaration
    :   namespace-declaration
    |   type-declaration
    ;

type-declaration
    :   class-declaration
    |   struct-declaration
    |   interface-declaration
    |   enum-declaration
    |   delegate-declaration
    ;


/* Modifier */ 

 
modifier
    :   enum-modifier
    |   class-modifier
    |   field-modifier
    |   method-modifier
    ;

modifiers
    :   modifier
    |   modifiers   modifier
    ;

/* C.2.7 Classes */
class-declaration 
    :   CLASS   IDENTIFIER   class-body
    |   attributes   CLASS   IDENTIFIER   class-body 
    |   modifiers   CLASS   IDENTIFIER   class-body
    |   CLASS   IDENTIFIER   class-base   class-body   
    |   CLASS   IDENTIFIER   class-body   SEMICOLON
    |   attributes   modifiers   CLASS   IDENTIFIER   class-body
    |   attributes   CLASS   IDENTIFIER   class-base   class-body
    |   attributes   CLASS   IDENTIFIER   class-body   SEMICOLON
    |   modifiers   CLASS   IDENTIFIER   class-base   class-body   
    |   modifiers   CLASS   IDENTIFIER   class-body   SEMICOLON
    |   CLASS   IDENTIFIER   class-base   class-body   SEMICOLON
    |   modifiers   CLASS   IDENTIFIER   class-base   class-body   SEMICOLON
    |   attributes   CLASS   IDENTIFIER   class-base   class-body   SEMICOLON
    |   attributes   modifiers   CLASS   IDENTIFIER   class-body   SEMICOLON
    |   attributes   modifiers   CLASS   IDENTIFIER   class-base   class-body  
    |   attributes   modifiers   CLASS   IDENTIFIER   class-base   class-body   SEMICOLON
    ;
    
class-modifiers
    :   class-modifier
    |   class-modifiers   class-modifier
    ;
    
class-modifier
    :   enum-modifier
    |   ABSTRACT
    |   SEALED
    ;
 

class-base
    :   COLON   type
    |   COLON   interface-type-list
    |   COLON   type   COMMA   interface-type-list
    ;

interface-type-list
    :   type
    |   interface-type-list   COMMA   type
    ;

class-body
    :   OPEN_BRACE   CLOSE_BRACE
    |   OPEN_BRACE   class-member-declarations   CLOSE_BRACE
    ;

class-member-declarations
    :   class-member-declaration
    |   class-member-declarations   class-member-declaration
    ;

class-member-declaration
    :   constant-declaration
    |   method-declaration
    |   field-declaration 
    |   property-declaration
    |   event-declaration
    |   indexer-declaration
    |   operator-declaration
    |   constructor-declaration
    |   static-constructor-declaration
    |   destructor-declaration
    |   type-declaration
    ;


constant-declaration
    :   CONST   type   constant-declarators   SEMICOLON
    |   attributes   CONST   type   constant-declarators   SEMICOLON
    |   modifiers   CONST   type   constant-declarators   SEMICOLON
    |   attributes   modifiers   CONST   type   constant-declarators   SEMICOLON
    ;
 
constant-declarators
    :   constant-declarator
    |   constant-declarators   COMMA   constant-declarator
    ;

constant-declarator
    :   IDENTIFIER   ASSIGN   constant-expression
    ;

field-declaration
    :   type    member-name   SEMICOLON
    |   attributes   type    member-name   SEMICOLON
    |   modifiers   type    member-name   SEMICOLON
    |   attributes    modifiers   type    member-name   SEMICOLON
    ;
     

field-modifiers
    :   field-modifier
    |   field-modifiers   field-modifier
    ;

field-modifier
    :   enum-modifier
    |   STATIC
    |   READONLY
    |   VOLATILE
    ;
    
    
variable-declarators
    :   variable-declarator
    |   variable-declarators   COMMA   variable-declarator
    ;

variable-declarator
    :   IDENTIFIER
    |   IDENTIFIER   ASSIGN   variable-initializer
    ;

variable-initializer
    :   expression
    |   array-initializer
    ;


method-declaration
    :   method-header   block
    |   method-header   SEMICOLON
    ;

method-header  
    :   type   member-name   OPEN_PARENS   CLOSE_PARENS   
    |   attributes   type   member-name   OPEN_PARENS   CLOSE_PARENS   
    |   modifiers   type   member-name   OPEN_PARENS   CLOSE_PARENS    
    |   type   member-name   OPEN_PARENS   formal-parameter-list   CLOSE_PARENS    
    |   modifiers   type   member-name   OPEN_PARENS   formal-parameter-list   CLOSE_PARENS    
    |   attributes   type   member-name   OPEN_PARENS   formal-parameter-list   CLOSE_PARENS   
    |   attributes   modifiers   type   member-name   OPEN_PARENS   CLOSE_PARENS    
    |   attributes   modifiers   type   member-name   OPEN_PARENS   formal-parameter-list   CLOSE_PARENS 
    ;
     
    
method-modifier
    :   enum-modifier 
    |   STATIC  
    |   VIRTUAL  
    |   SEALED  
    |   OVERRIDE  
    |   ABSTRACT  
    |   EXTERN  
    ;


member-name
    :   variable-declarators
    |   type-name   DOT   IDENTIFIER
    ;

    

method-body
    :   block
    |   SEMICOLON
    ;

formal-parameter-list
    :   fixed-parameters
    |   fixed-parameters   COMMA   parameter-array
    |   parameter-array
    ;

fixed-parameters
    :   fixed-parameter
    |   fixed-parameters   COMMA   fixed-parameter
    ;

fixed-parameter
    :   type   IDENTIFIER
    |   attributes   type   IDENTIFIER
    |   parameter-modifier   type   IDENTIFIER
    |   attributes   parameter-modifier   type   IDENTIFIER
    ;

parameter-modifier
    :   REF
    |   OUT
    ;

parameter-array
    :   PARAMS   array-type   IDENTIFIER
    |   attributes   PARAMS   array-type   IDENTIFIER
    ;




property-declaration
    :   type   member-name   OPEN_BRACE   accessor-declarations   CLOSE_BRACE
    |   attributes   type   member-name   OPEN_BRACE   accessor-declarations   CLOSE_BRACE
    |   modifiers   type   member-name   OPEN_BRACE   accessor-declarations   CLOSE_BRACE
    |   attributes   modifiers   type   member-name   OPEN_BRACE   accessor-declarations   CLOSE_BRACE
    ;

accessor-declarations
    :   get-accessor-declaration 
    |   get-accessor-declaration   set-accessor-declaration
    |   set-accessor-declaration 
    |   set-accessor-declaration   get-accessor-declaration
    ;

get-accessor-declaration
    :   GET   method-body
    |   attributes   GET   method-body
    ;

set-accessor-declaration
    :   SET   method-body
    |   attributes   SET   method-body
    ;



event-declaration
    :   EVENT   type   variable-declarators   SEMICOLON
    |   attributes   EVENT   type   variable-declarators   SEMICOLON
    |   modifiers   EVENT   type   variable-declarators   SEMICOLON
    |   attributes   modifiers   EVENT   type   variable-declarators   SEMICOLON
    |   EVENT   type   member-name   OPEN_BRACE   event-accessor-declarations   CLOSE_BRACE
    |   attributes   EVENT   type   member-name   OPEN_BRACE   event-accessor-declarations   CLOSE_BRACE
    |   modifiers   EVENT   type   member-name   OPEN_BRACE   event-accessor-declarations   CLOSE_BRACE
    |   attributes   modifiers   EVENT   type   member-name   OPEN_BRACE   event-accessor-declarations   CLOSE_BRACE
    ;
 
event-accessor-declarations
    :   add-accessor-declaration   remove-accessor-declaration
    |   remove-accessor-declaration   add-accessor-declaration
    ;

add-accessor-declaration
    :   ADD   block
    |   attributes   ADD   block
    ;

remove-accessor-declaration
    :   REMOVE   block
    |   attributes   REMOVE   block
    ;



indexer-declaration
    :   indexer-declarator   OPEN_BRACE   accessor-declarations   CLOSE_BRACE
    |   attributes   indexer-declarator   OPEN_BRACE   accessor-declarations   CLOSE_BRACE
    |   modifiers   indexer-declarator   OPEN_BRACE   accessor-declarations   CLOSE_BRACE
    |   attributes   modifiers   indexer-declarator   OPEN_BRACE   accessor-declarations   CLOSE_BRACE
    ;

indexer-declarator
    :   type   THIS   OPEN_BRACKET   formal-parameter-list   CLOSE_BRACKET
    |   type   member-name   DOT   THIS   OPEN_BRACKET   formal-parameter-list   CLOSE_BRACKET
    ;



operator-declaration
    :   modifiers   operator-declarator   method-body
    |   attributes   modifiers   operator-declarator   method-body 
    ;

operator-modifiers
    :   operator-modifier
    |   operator-modifiers   operator-modifier
    ;

operator-modifier
    :   PUBLIC
    |   STATIC
    |   EXTERN
    ;

operator-declarator
    :   unary-operator-declarator
    |   binary-operator-declarator
    |   conversion-operator-declarator
    ;

unary-operator-declarator
    :   type   OPERATOR   overloadable-operator   OPEN_PARENS   type   IDENTIFIER   CLOSE_PARENS
    ;

overloadable-operator
    :   overloadable-unary-operator
    |   overloadable-binary-operator
    ;
    

overloadable-unary-operator
    :   OP_INC
    |   OP_DEC
    |   MINUS
    |   BANG
    |   TILDE
    |   PLUS
    |   TRUE
    |   FALSE
    ;
    
binary-operator-declarator
    :   type   OPERATOR   overloadable-operator   OPEN_PARENS   type   IDENTIFIER   COMMA   type   IDENTIFIER   CLOSE_PARENS
    ;

overloadable-binary-operator
    :   PLUS
    |   MINUS
    |   STAR
    |   DIV
    |   PERCENT
    |   AMP
    |   BITWISE_OR
    |   CARET
    |   OP_LEFT_SHIFT
    |   RIGHT_SHIFT
    |   OP_EQ
    |   OP_NE
    |   OP_GE
    |   OP_LE
    |   GT
    |   LT
    ;

conversion-operator-declarator
    :   IMPLICIT   OPERATOR   type   OPEN_PARENS   type   IDENTIFIER   CLOSE_PARENS
    |   EXPLICIT   OPERATOR   type   OPEN_PARENS   type   IDENTIFIER   CLOSE_PARENS
    ;


constructor-declaration
    :   constructor-declarator   method-body
    |   attributes   constructor-declarator   method-body
    |   modifiers   constructor-declarator   method-body
    |   attributes   modifiers   constructor-declarator   method-body
    ;
 
constructor-declarator
    :   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS
    |   IDENTIFIER   OPEN_PARENS   formal-parameter-list   CLOSE_PARENS
    |   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS   constructor-initializer
    |   IDENTIFIER   OPEN_PARENS   formal-parameter-list   CLOSE_PARENS   constructor-initializer
    ;

constructor-initializer
    :   COLON   BASE   OPEN_PARENS   CLOSE_PARENS
    |   COLON   BASE   OPEN_PARENS   argument-list   CLOSE_PARENS
    |   COLON   THIS   OPEN_PARENS   CLOSE_PARENS
    |   COLON   THIS   OPEN_PARENS   argument-list   CLOSE_PARENS
    ;



static-constructor-declaration
    :   static-constructor-modifiers   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS   method-body
    |   attributes   static-constructor-modifiers   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS   method-body
    ;

static-constructor-modifiers
    :   EXTERN STATIC
    |   STATIC EXTERN
    |   STATIC
    ; 
 

destructor-declaration
    :   TILDE   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS    method-body
    |   attributes   TILDE   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS    method-body
    |   EXTERN   TILDE   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS    method-body
    |   attributes   EXTERN   TILDE   IDENTIFIER   OPEN_PARENS   CLOSE_PARENS    method-body
    ;
 


































