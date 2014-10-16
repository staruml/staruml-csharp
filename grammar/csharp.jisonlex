%lex
%options flex

TEST_TOKEN                      'k'


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
        
%%      
        
{WHITESPACE}                    {console.log('WHITESPACE');}
{NEW_LINE_CHARACTER}            {console.log('NEW_LINE_CHARACTER');}
        
{SINGLE_LINE_COMMENT}           {console.log('SINGLE_LINE_COMMENT');}
{DELIMITED_COMMENT}             {console.log('DELIMITED_COMMENT');}

{SINGLE_LINE_DOC_COMMENT}       {console.log('SINGLE_LINE_DOC_COMMENT');}
{DELIMITED_DOC_COMMENT}         {console.log('DELIMITED_DOC_COMMENT');}
{NEW_LINE}                      {console.log('NEW_LINE');}

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


{TEST_TOKEN}                    return 'TEST_TOKEN';
        
        
<<EOF>>                         return 'EOF';
 
    
  