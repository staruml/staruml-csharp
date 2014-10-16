
%token ABSTRACT AS BASE BOOL BREAK BYTE CASE CATCH CHAR CHECKED CLASS CONST CONTINUE DECIMAL DEFAULT DELEGATE DO DOUBLE ELSE ENUM EVENT EXPLICIT EXTERN FALSE FINALLY FIXED FLOAT FOR FOREACH GOTO IF IMPLICIT IN INT INTERFACE INTERNAL IS LOCK LONG NAMESPACE NEW NULL OBJECT OPERATOR OUT OVERRIDE PARAMS PRIVATE PROTECTED PUBLIC READONLY REF RETURN SBYTE SEALED SHORT SIZEOF STACKALLOC STATIC STRING STRUCT SWITCH THIS THROW TRUE TRY TYPEOF UINT ULONG UNCHECKED UNSAFE USHORT USING VIRTUAL VOID VOLATILE WHILE 

%token Unicode_escape_sequence

%token REAL_LITERAL
%token INTEGER_LITERAL   
%token CHARACTER_LITERAL

%token OPEN_BRACE CLOSE_BRACE OPEN_BRACKET CLOSE_BRACKET OPEN_PARENS CLOSE_PARENS DOT COMMA COLON SEMICOLON PLUS MINUS STAR DIV PERCENT AMP BITWISE_OR CARET BANG TILDE ASSIGNMENT LT GT INTERR DOUBLE_COLON OP_COALESCING OP_INC OP_DEC OP_AND OP_OR OP_PTR OP_EQ OP_NE OP_LE OP_GE OP_ADD_ASSIGNMENT OP_SUB_ASSIGNMENT OP_MULT_ASSIGNMENT OP_DIV_ASSIGNMENT OP_MOD_ASSIGNMENT OP_AND_ASSIGNMENT OP_OR_ASSIGNMENT OP_XOR_ASSIGNMENT OP_LEFT_SHIFT OP_LEFT_SHIFT_ASSIGNMENT RIGHT_SHIFT RIGHT_SHIFT_ASSIGNMENT

%token IDENTIFIER 

%token EOF 

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
    :   e 
    |   es e 
    ;
    

e  
    :   IF             
        { 
            console.log('IF');
        }
    
    |   REAL_LITERAL             
        { 
            console.log('REAL_LITERAL: '+$1);
        }    
    |   INTEGER_LITERAL             
        { 
            console.log('INTEGER_LITERAL: '+$1);
        }
    |   CHARACTER_LITERAL             
        { 
            console.log('CHARACTER_LITERAL: '+$1);
        }
    |   Unicode_escape_sequence             
        { 
            console.log('Unicode_escape_sequence: '+$1);
        }    
    |   OPEN_BRACE             
        { 
            console.log('OPEN_BRACE');
        }     
    |   DOT             
        { 
            console.log('DOT');
        } 
    |   IDENTIFIER             
        { 
            console.log('IDENTIFIER: '+$1);
        }    
    |   %empty             
        { 
            console.log('EMPTY');
        }
    ;