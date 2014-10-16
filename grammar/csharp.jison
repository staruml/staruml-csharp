
%token ABSTRACT AS BASE BOOL BREAK BYTE CASE CATCH CHAR CHECKED CLASS CONST CONTINUE DECIMAL DEFAULT DELEGATE DO DOUBLE ELSE ENUM EVENT EXPLICIT EXTERN FALSE FINALLY FIXED FLOAT FOR FOREACH GOTO IF IMPLICIT IN INT INTERFACE INTERNAL IS LOCK LONG NAMESPACE NEW NULL OBJECT OPERATOR OUT OVERRIDE PARAMS PRIVATE PROTECTED PUBLIC READONLY REF RETURN SBYTE SEALED SHORT SIZEOF STACKALLOC STATIC STRING STRUCT SWITCH THIS THROW TRUE TRY TYPEOF UINT ULONG UNCHECKED UNSAFE USHORT USING VIRTUAL VOID VOLATILE WHILE 

%token Unicode_escape_sequence

%token INTEGER_LITERAL   

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
    |   Unicode_escape_sequence             
        { 
            console.log('Unicode_escape_sequence: '+$1);
        }
        
    |   INTEGER_LITERAL             
        { 
            console.log('INTEGER_LITERAL: '+$1);
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