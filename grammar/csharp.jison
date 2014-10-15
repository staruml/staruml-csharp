
%token WHITESPACE

%token EOF 

%start compilationUnit

%%
compilationUnit
    : e EOF
        {   
            return {
                "node": "CompilationUnit1",
                "unicode": "1231"
            };
        }
    
    ;
 

e 
    :   WHITESPACE    
        {
            $$="3";
            console.log('1123');
        } 
    |   %empty             
        {
            $$="2";
            console.log('123');
        }
    ;