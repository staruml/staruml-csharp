
%token ABSTRACT AS BASE BOOL BREAK BYTE CASE CATCH CHAR CHECKED CLASS CONST CONTINUE DECIMAL DEFAULT DELEGATE DO DOUBLE ELSE ENUM EVENT EXPLICIT EXTERN FALSE FINALLY FIXED FLOAT FOR FOREACH GOTO IF IMPLICIT IN INT INTERFACE INTERNAL IS LOCK LONG NAMESPACE NEW NULL OBJECT OPERATOR OUT OVERRIDE PARAMS PRIVATE PROTECTED PUBLIC READONLY REF RETURN SBYTE SEALED SHORT SIZEOF STACKALLOC STATIC STRING STRUCT SWITCH THIS THROW TRUE TRY TYPEOF UINT ULONG UNCHECKED UNSAFE USHORT USING VIRTUAL VOID VOLATILE WHILE 

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
        {console.log('e');}
    |   es e
        {console.log('es e');}
    ;
    

e  
    :   IF             
        { 
            console.log('IF');
        }
    |   IDENTIFIER             
        { 
            console.log('IDENTIFIER');
        }
    |   %empty             
        { 
            console.log('EMPTY');
        }
    ;