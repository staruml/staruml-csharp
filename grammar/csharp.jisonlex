%lex
%options flex
 

/* Documentation Comments */
SINGLE_LINE_DOC_COMMENT         '///'{Input_characters}?   
DELIMITED_DOC_COMMENT           '/**'{Delimited_comment_text}?{Asterisks}'/'  

/* Line Terminators */
NEW_LINE                        [\u000D]|[\u000A]|([\u000D][\u000A])|[\u0085]|[\u2029]
   

/* Comments */
SINGLE_LINE_COMMENT             '//' {Input_characters}?  
Input_characters                {Input_character}+

/* <Any Unicode Character Except A NEW_LINE_CHARACTER> */
Input_character                 [^(\u000D|\u000A|\u0085|\u2028|\u2029|'\n')]
NEW_LINE_CHARACTER              [\u000D]|[\u000A]|[\u0085]|[\u2028]|[\u2029]|'\n'
DELIMITED_COMMENT               '/*'{Delimited_comment_text}?{Asterisks}'/'  
Delimited_comment_text          {Delimited_comment_section}+
Delimited_comment_section       '/'|({Asterisks}?{Not_slash_or_asterisk})
Asterisks                       '*'+
  
/* <Any Unicode Character Except / Or *> */
Not_slash_or_asterisk           [^('/'|'*')]


/* Unicode character classes */  
UNICODE_CLASS_Zs                [\u0020]|[\u00A0]|[\u1680]|[\u180E]|[\u2000]|[\u2001]|[\u2002]|[\u2003]|[\u2004]|[\u2005]|[\u2006]|[\u2008]|[\u2009]|[\u200A]|[\u202F]|[\u3000]|[\u205F] 
UNICODE_CLASS_Lu                [\u0041-\u005A]|[\u00C0-\u00DE]
UNICODE_CLASS_Ll                [\u0061-\u007A]
UNICODE_CLASS_Lt                [\u01C5]|[\u01C8]|[\u01CB]|[\u01F2]
UNICODE_CLASS_Lm                [\u02B0-\u02EE]
UNICODE_CLASS_Lo                [\u01BB]|[\u01C0]|[\u01C1]|[\u01C2]|[\u01C3]|[\u0294]
UNICODE_CLASS_Nl                [\u16EE]|[\u16EF]|[\u16F0]|[\u2160]|[\u2161]|[\u2162]|[\u2163]|[\u2164]|[\u2165]|[\u2166]|[\u2167]|[\u2168]|[\u2169]|[\u216A]|[\u216B]|[\u216C]|[\u216D]|[\u216E]|[\u216F]
UNICODE_CLASS_Mn                [\u0300]|[\u0301]|[\u0302]|[\u0303]|[\u0304]|[\u0305]|[\u0306]|[\u0307]|[\u0308]|[\u0309]|[\u030A]|[\u030B]|[\u030C]|[\u030D]|[\u030E]|[\u030F]|[\u0310]
UNICODE_CLASS_Mc                [\u0903]|[\u093E]|[\u093F]|[\u0940]|[\u0949]|[\u094A]|[\u094B]|[\u094C]
UNICODE_CLASS_Cf                [\u00AD]|[\u0600]|[\u0601]|[\u0602]|[\u0603]|[\u06DD]
UNICODE_CLASS_Pc                [\u005F]|[\u203F]|[\u2040]|[\u2054]|[\uFE33]|[\uFE34]|[\uFE4D]|[\uFE4E]|[\uFE4F]|[\uFF3F]
UNICODE_CLASS_Nd                [\u0030]|[\u0031]|[\u0032]|[\u0033]|[\u0034]|[\u0035]|[\u0036]|[\u0037]|[\u0038]|[\u0039]


/* White space */  
WHITESPACE                      {Whitespace_characters}      
Whitespace_characters           {Whitespace_character}+
Whitespace_character            {UNICODE_CLASS_Zs}|[\u0009]|[\u000B]|[\u000C]|[\s]

/* Unicode Character Escape Sequences */
Unicode_escape_sequence         '\\u' {HEX_DIGIT}{4}|'\\U' {HEX_DIGIT}{8} 


        
/* Identifiers  */
IDENTIFIER                      {Available_identifier}|'@'{Identifier_or_keyword}

/* <An Identifier_or_keyword That Is Not A Keyword> */
Available_identifier            {Identifier_or_keyword}
Identifier_or_keyword           {Identifier_start_character}{Identifier_part_characters}?
Identifier_start_character      {Letter_character}|'_'
Identifier_part_characters      {Identifier_part_character}+
Identifier_part_character       {Letter_character}|{Decimal_digit_character}|{Connecting_character}|{Combining_character}|{Formatting_character}
  
/* <A Unicode Character Of Classes Lu, Ll, Lt, Lm, Lo, Or Nl> */ 
Letter_character                {UNICODE_CLASS_Lu}|{UNICODE_CLASS_Ll}|{UNICODE_CLASS_Lt}|{UNICODE_CLASS_Lm}|{UNICODE_CLASS_Lo}|{UNICODE_CLASS_Nl}

/* <A Unicode Character Of Classes Mn Or Mc> */
Combining_character             {UNICODE_CLASS_Mn}|{UNICODE_CLASS_Mc}

/* <A Unicode Character Of The Class Nd> */
Decimal_digit_character         {UNICODE_CLASS_Nd}

/* <A Unicode Character Of The Class Pc> */
Connecting_character            {UNICODE_CLASS_Pc}

/* <A Unicode Character Of The Class Cf> */ 
Formatting_character            {UNICODE_CLASS_Cf}


/* Real Literals */
REAL_LITERAL                    {Decimal_digits}{DOT}{Decimal_digits}{Exponent_part}?{Real_type_suffix}?|{DOT}{Decimal_digits}{Exponent_part}?{Real_type_suffix}?|{Decimal_digits}{Exponent_part}{Real_type_suffix}?|{Decimal_digits}{Real_type_suffix}
Exponent_part                   'e'{Sign}?{Decimal_digits}|'E'{Sign}?{Decimal_digits}
Sign                            '+'|'-'
Real_type_suffix                'F'|'f'|'D'|'d'|'M'|'m'
DOT                             '.'  



/* Integer Literals */
INTEGER_LITERAL                 {Hexadecimal_integer_literal}|{Decimal_integer_literal}
Decimal_integer_literal         {Decimal_digits}{Integer_type_suffix}?
Decimal_digits                  {DECIMAL_DIGIT}+
DECIMAL_DIGIT                   [0-9]
Integer_type_suffix             'UL'|'Ul'|'uL'|'ul'|'LU'|'Lu'|'lU'|'lu'|'U'|'u'|'L'|'l'
Hexadecimal_integer_literal     ('0x'{Hex_digits}{Integer_type_suffix}?) | ('0X'{Hex_digits}{Integer_type_suffix}?)
Hex_digits                      {HEX_DIGIT}+
HEX_DIGIT                       [0-9a-fA-F] 



        
%%      
        
{WHITESPACE}                    /* skip */
{NEW_LINE_CHARACTER}            /* skip */
        
{SINGLE_LINE_COMMENT}           /* skip */
{DELIMITED_COMMENT}             /* skip */

{SINGLE_LINE_DOC_COMMENT}       /* skip */
{DELIMITED_DOC_COMMENT}         /* skip */
{NEW_LINE}                      /* skip */

/* Keywords */
"abstract"                      return 'ABSTRACT';
"as"                            return 'AS';
"base"                          return 'BASE';
"bool"                          return 'BOOL';
"break"                         return 'BREAK';
"byte"                          return 'BYTE';
"case"                          return 'CASE';
"catch"                         return 'CATCH';
"char"                          return 'CHAR';
"checked"                       return 'CHECKED';
"class"                         return 'CLASS';
"const"                         return 'CONST';
"continue"                      return 'CONTINUE';
"decimal"                       return 'DECIMAL';
"default"                       return 'DEFAULT';
"delegate"                      return 'DELEGATE';
"do"                            return 'DO';
"double"                        return 'DOUBLE';
"else"                          return 'ELSE';
"enum"                          return 'ENUM';
"event"                         return 'EVENT';
"explicit"                      return 'EXPLICIT';
"extern"                        return 'EXTERN';
"false"                         return 'FALSE';
"finally"                       return 'FINALLY';
"fixed"                         return 'FIXED';
"float"                         return 'FLOAT';
"for"                           return 'FOR';
"foreach"                       return 'FOREACH';
"goto"                          return 'GOTO';
"if"                            return 'IF';
"implicit"                      return 'IMPLICIT';
"in"                            return 'IN';
"int"                           return 'INT';
"interface"                     return 'INTERFACE';
"internal"                      return 'INTERNAL';
"is"                            return 'IS';
"lock"                          return 'LOCK';
"long"                          return 'LONG';
"namespace"                     return 'NAMESPACE';
"new"                           return 'NEW';
"null"                          return 'NULL';
"object"                        return 'OBJECT';
"operator"                      return 'OPERATOR';
"out"                           return 'OUT';
"override"                      return 'OVERRIDE';
"params"                        return 'PARAMS';
"private"                       return 'PRIVATE';
"protected"                     return 'PROTECTED';
"public"                        return 'PUBLIC';
"readonly"                      return 'READONLY';
"ref"                           return 'REF';
"return"                        return 'RETURN';
"sbyte"                         return 'SBYTE';
"sealed"                        return 'SEALED';
"short"                         return 'SHORT';
"sizeof"                        return 'SIZEOF';
"stackalloc"                    return 'STACKALLOC';
"static"                        return 'STATIC';
"string"                        return 'STRING';
"struct"                        return 'STRUCT';
"switch"                        return 'SWITCH';
"this"                          return 'THIS';
"throw"                         return 'THROW';
"true"                          return 'TRUE';
"try"                           return 'TRY';
"typeof"                        return 'TYPEOF';
"uint"                          return 'UINT';
"ulong"                         return 'ULONG';
"unchecked"                     return 'UNCHECKED';
"unsafe"                        return 'UNSAFE';
"ushort"                        return 'USHORT';
"using"                         return 'USING';
"virtual"                       return 'VIRTUAL';
"void"                          return 'VOID';
"volatile"                      return 'VOLATILE';
"while"                         return 'WHILE';

{Unicode_escape_sequence}       return 'Unicode_escape_sequence';

{REAL_LITERAL}                  return 'REAL_LITERAL';
{INTEGER_LITERAL}               return 'INTEGER_LITERAL'; 


/* Operators And Punctuators*/
"{"                             return 'OPEN_BRACE';
"}"                             return 'CLOSE_BRACE';
"["                             return 'OPEN_BRACKET';
"]"                             return 'CLOSE_BRACKET';
"("                             return 'OPEN_PARENS';
")"                             return 'CLOSE_PARENS';
{DOT}                           return 'DOT';
","                             return 'COMMA';
":"                             return 'COLON';
";"                             return 'SEMICOLON';
"+"                             return 'PLUS';
"-"                             return 'MINUS';
"*"                             return 'STAR';
"/"                             return 'DIV';
"%"                             return 'PERCENT';
"&"                             return 'AMP';
"|"                             return 'BITWISE_OR';
"^"                             return 'CARET';
"!"                             return 'BANG';
"~"                             return 'TILDE';
"="                             return 'ASSIGNMENT';
"<"                             return 'LT';
">"                             return 'GT';
"?"                             return 'INTERR';
"::"                            return 'DOUBLE_COLON';
"??"                            return 'OP_COALESCING';
"++"                            return 'OP_INC';
"--"                            return 'OP_DEC';
"&&"                            return 'OP_AND';
"||"                            return 'OP_OR';
"->"                            return 'OP_PTR';
"=="                            return 'OP_EQ';
"!="                            return 'OP_NE';
"<="                            return 'OP_LE';
">="                            return 'OP_GE';
"+="                            return 'OP_ADD_ASSIGNMENT';
"-="                            return 'OP_SUB_ASSIGNMENT';
"*="                            return 'OP_MULT_ASSIGNMENT';
"/="                            return 'OP_DIV_ASSIGNMENT';
"%="                            return 'OP_MOD_ASSIGNMENT';
"&="                            return 'OP_AND_ASSIGNMENT';
"|="                            return 'OP_OR_ASSIGNMENT';
"^="                            return 'OP_XOR_ASSIGNMENT';
"<<"                            return 'OP_LEFT_SHIFT';
"<<="                           return 'OP_LEFT_SHIFT_ASSIGNMENT';
">>"                            return 'RIGHT_SHIFT';
">>="                           return 'RIGHT_SHIFT_ASSIGNMENT';


{IDENTIFIER}                    return 'IDENTIFIER';
 
        
<<EOF>>                         return 'EOF';
 
    
  