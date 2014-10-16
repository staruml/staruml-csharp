
%token TEST_TOKEN 
 

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
    :   TEST_TOKEN     
        {
            $$="3";
            console.log('TEST_TOKEN');
        }
    |   %empty             
        {
            $$="2";
            console.log('EMPTY');
        }
    ;