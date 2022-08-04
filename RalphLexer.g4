lexer grammar RalphLexer;

// LEXER
// src/main/scala/org/alephium/protocol/vm/lang/Lexer.scala
// Keywords
IMPORT                 : 'import';
PACKAGE                : 'package';
FN                     : 'fn';
PUB                    : 'pub';
PAYABLE                : 'payable';
RETURN                 : 'return' -> mode(NLSEMI);

INTERFACE              : 'Interface';
STRUCT                 : 'struct';
ENUM                   : 'enum';
TXSCRIPT               : 'TxScript';
TXCONTRACT             : 'TxContract';
CONTRACT               : 'Contract';
ASSETSCRIPT            : 'AssetScript';

IF                     : 'if';
ELSE                   : 'else';
FOR                    : 'for';
WHILE                  : 'while';
BREAK                  : 'break' -> mode(NLSEMI);
CONTINUE               : 'continue' -> mode(NLSEMI);
DEFAULT                : 'default';
GOTO                   : 'goto';
SWITCH                 : 'switch';
CASE                   : 'case';
TYPE                   : 'type';

LET                    : 'let';
CONST                  : 'const';
MUT                    : 'mut';

//TRUE                   :'true';
//FALSE                  :'false';
ALPH                   :'alph';

EXTENDS                :'extends';
ABSTRACT               :'Abstract';
IMPLEMENTS             :'implements';
EVENT                  :'event';
EVMIT                  :'emit';

//@using|using
USING                  :'using';
AT                     :'@';
//type
BOOL                   :'Bool';
I256                   :'I256';
U256                   :'U256';
BYTEVEC                :'ByteVec';
ADDRESS                :'Address';

//->
RETURNBACK             :'->';


IDENTIFIER             : LETTER (LETTER | UNICODE_DIGIT)* -> mode(NLSEMI);

// Punctuation

L_PAREN                : '(';
R_PAREN                : ')' -> mode(NLSEMI);
L_CURLY                : '{';
R_CURLY                : '}' -> mode(NLSEMI);
L_BRACKET              : '[';
R_BRACKET              : ']' -> mode(NLSEMI);
ASSIGN                 : '=';
COMMA                  : ',';
SEMI                   : ';';
COLON                  : ':';
DOT                    : '.';
PLUS_PLUS              : '++' -> mode(NLSEMI);
MINUS_MINUS            : '--' -> mode(NLSEMI);
DECLARE_ASSIGN         : ':=';
ELLIPSIS               : '...';



//def opByteVecAdd[Unknown: P]: P[Operator] = P("++").map(_ => Concat)
//def opAdd[Unknown: P]: P[Operator]        = P("+").map(_ => Add)
//def opSub[Unknown: P]: P[Operator]        = P("-").map(_ => Sub)
//def opMul[Unknown: P]: P[Operator]        = P("*").map(_ => Mul)
//def opDiv[Unknown: P]: P[Operator]        = P("/").map(_ => Div)
//def opMod[Unknown: P]: P[Operator]        = P("%").map(_ => Mod)
//def opModAdd[Unknown: P]: P[Operator]     = P("⊕" | "`+`").map(_ => ModAdd)
//def opModSub[Unknown: P]: P[Operator]     = P("⊖" | "`-`").map(_ => ModSub)
//def opModMul[Unknown: P]: P[Operator]     = P("⊗" | "`*`").map(_ => ModMul)
//def opSHL[Unknown: P]: P[Operator]        = P("<<").map(_ => SHL)
//def opSHR[Unknown: P]: P[Operator]        = P(">>").map(_ => SHR)
//def opBitAnd[Unknown: P]: P[Operator]     = P("&").map(_ => BitAnd)
//def opXor[Unknown: P]: P[Operator]        = P("^").map(_ => Xor)
//def opBitOr[Unknown: P]: P[Operator]      = P("|").map(_ => BitOr)
//def opEq[Unknown: P]: P[TestOperator]     = P("==").map(_ => Eq)
//def opNe[Unknown: P]: P[TestOperator]     = P("!=").map(_ => Ne)
//def opLt[Unknown: P]: P[TestOperator]     = P("<").map(_ => Lt)
//def opLe[Unknown: P]: P[TestOperator]     = P("<=").map(_ => Le)
//def opGt[Unknown: P]: P[TestOperator]     = P(">").map(_ => Gt)
//def opGe[Unknown: P]: P[TestOperator]     = P(">=").map(_ => Ge)
//def opAnd[Unknown: P]: P[LogicalOperator] = P("&&").map(_ => And)
//def opOr[Unknown: P]: P[LogicalOperator]  = P("||").map(_ => Or)
//def opNot[Unknown: P]: P[LogicalOperator] = P("!").map(_ => Not)


// Logical

LOGICAL_OR             : '||';
LOGICAL_AND            : '&&';

// Relation operators

EQUALS                 : '==';
NOT_EQUALS             : '!=';
LESS                   : '<';
LESS_OR_EQUALS         : '<=';
GREATER                : '>';
GREATER_OR_EQUALS      : '>=';

// Arithmetic operators

OR                     : '|';
DIV                    : '/';
MOD                    : '%';
LSHIFT                 : '<<';
RSHIFT                 : '>>';
BIT_CLEAR              : '&^';

// Unary operators

EXCLAMATION            : '!';

// Mixed operators

PLUS                   : '+';
MINUS                  : '-';
CARET                  : '^';
STAR                   : '*';
AMPERSAND              : '&';
RECEIVE                : '<-';

// Number literals

DECIMAL_LIT            : ('0' | [1-9] ('_'? [0-9])*) -> mode(NLSEMI);
BINARY_LIT             : '0' [bB] ('_'? BIN_DIGIT)+ -> mode(NLSEMI);
OCTAL_LIT              : '0' [oO]? ('_'? OCTAL_DIGIT)+ -> mode(NLSEMI);
HEX_LIT                : '0' [xX]  ('_'? HEX_DIGIT)+ -> mode(NLSEMI);


FLOAT_LIT : (DECIMAL_FLOAT_LIT | HEX_FLOAT_LIT) -> mode(NLSEMI);

DECIMAL_FLOAT_LIT      : DECIMALS ('.' DECIMALS? EXPONENT? | EXPONENT)
                       | '.' DECIMALS EXPONENT?
                       ;

HEX_FLOAT_LIT          : '0' [xX] HEX_MANTISSA HEX_EXPONENT
                       ;

fragment HEX_MANTISSA  : ('_'? HEX_DIGIT)+ ('.' ( '_'? HEX_DIGIT )*)?
                       | '.' HEX_DIGIT ('_'? HEX_DIGIT)*;

fragment HEX_EXPONENT  : [pP] [+-]? DECIMALS;


IMAGINARY_LIT          : (DECIMAL_LIT | BINARY_LIT |  OCTAL_LIT | HEX_LIT | FLOAT_LIT) 'i' -> mode(NLSEMI);

// Rune literals

fragment RUNE               : '\'' (UNICODE_VALUE | BYTE_VALUE) '\'';//: '\'' (~[\n\\] | ESCAPED_VALUE) '\'';

RUNE_LIT                : RUNE -> mode(NLSEMI);



BYTE_VALUE : OCTAL_BYTE_VALUE | HEX_BYTE_VALUE;

OCTAL_BYTE_VALUE: '\\' OCTAL_DIGIT OCTAL_DIGIT OCTAL_DIGIT;

HEX_BYTE_VALUE: '\\' 'x'  HEX_DIGIT HEX_DIGIT;

LITTLE_U_VALUE: '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT;

BIG_U_VALUE: '\\' 'U' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT;

// String literals

RAW_STRING_LIT         : '`' ~'`'*                      '`' -> mode(NLSEMI);
INTERPRETED_STRING_LIT : '"' (~["\\] | ESCAPED_VALUE)*  '"' -> mode(NLSEMI);
// Hidden tokens
WS                     : [ \t]+             -> channel(HIDDEN);
COMMENT                : '/*' .*? '*/'      -> channel(HIDDEN);
TERMINATOR             : [\r\n]+            -> channel(HIDDEN);
LINE_COMMENT           : '//' ~[\r\n]*      -> channel(HIDDEN);

fragment UNICODE_VALUE: ~[\r\n'] | LITTLE_U_VALUE | BIG_U_VALUE | ESCAPED_VALUE;
// Fragments
fragment ESCAPED_VALUE
    : '\\' ('u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
           | 'U' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
           | [abfnrtv\\'"]
           | OCTAL_DIGIT OCTAL_DIGIT OCTAL_DIGIT
           | 'x' HEX_DIGIT HEX_DIGIT)
    ;
fragment DECIMALS
    : [0-9] ('_'? [0-9])*
    ;
fragment OCTAL_DIGIT
    : [0-7]
    ;
fragment HEX_DIGIT
    : [0-9a-fA-F]
    ;
fragment BIN_DIGIT
    : [01]
    ;
fragment EXPONENT
    : [eE] [+-]? DECIMALS
    ;
fragment LETTER
    : UNICODE_LETTER
    | '_'
    ;
fragment UNICODE_DIGIT
    : [\p{Nd}]
    ;
fragment UNICODE_LETTER
    : [\p{L}]
    ;
mode NLSEMI;
// Treat whitespace as normal
WS_NLSEMI                     : [ \t]+             -> channel(HIDDEN);
// Ignore any comments that only span one line
COMMENT_NLSEMI                : '/*' ~[\r\n]*? '*/'      -> channel(HIDDEN);
LINE_COMMENT_NLSEMI : '//' ~[\r\n]*      -> channel(HIDDEN);
// Emit an EOS token for any newlines, semicolon, multiline comments or the EOF and
//return to normal lexing
EOS:              ([\r\n]+ | ';' | '/*' .*? '*/' | EOF)            -> mode(DEFAULT_MODE);
// Did not find an EOS, so go back to normal lexing
OTHER: -> mode(DEFAULT_MODE), channel(HIDDEN);
