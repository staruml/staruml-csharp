%token UNICODE_CLASS_Zs UNICODE_CLASS_Lu UNICODE_CLASS_Ll UNICODE_CLASS_Lt UNICODE_CLASS_Lm UNICODE_CLASS_Lo
%token UNICODE_CLASS_Nl UNICODE_CLASS_Mn UNICODE_CLASS_Mc UNICODE_CLASS_Cf UNICODE_CLASS_Pc UNICODE_CLASS_Nd
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
    :   UNICODE_CLASS_Nd    
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