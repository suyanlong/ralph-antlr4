lexer grammar RalphLexer;

// LEXER
// src/main/scala/org/alephium/protocol/vm/lang/Lexer.scala
// Keywords
IMPORT                 : 'import';
FN                     : 'fn';
PUB                    : 'pub';
PAYABLE                : 'payable';
RETURN                 : 'return';

INTERFACE              : 'Interface';
STRUCT                 : 'struct';
ENUM                   : 'enum';
TxScript               : 'TxScript';
TxContract             : 'TxContract';
Contract               : 'Contract';
AssetScript            : 'AssetScript';

IF                     : 'if';
ELSE                   : 'else';
FOR                    : 'for';
WHILE                  : 'while';
BREAK				   : 'break';
CONTINUE			   : 'continue';

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

USING                  :'using';
//@using|using

//type
BOOL                   :'Bool';
I256                   :'I256';
U256                   :'U256';
BYTEVEC                :'ByteVec';
ADDRESS                :'Address';


//--------------------------------------------------------------------------------------------------




//--------------------------------------------------------------------------------------------------
// §3.11 Separators

LPAREN : '(';
RPAREN : ')';
LBRACE : '{';
RBRACE : '}';
LBRACK : '[';
RBRACK : ']';
SEMI : ';';
COMMA : ',';
DOT : '.';
ELLIPSIS : '...';
AT : '@';
COLONCOLON : '::';

POUND: '#';

// §3.12 Operators
// Operator

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

ASSIGN : '=';
GT : '>';
LT : '<';
BANG : '!';
TILDE : '~';
QUESTION : '?';
COLON : ':';
ARROW : '->';
EQUAL : '==';
LE : '<=';
GE : '>=';
NOTEQUAL : '!=';
AND : '&&';
OR : '||';
INC : '++';
DEC : '--';
ADD : '+';
SUB : '-';
MUL : '*';
DIV : '/';
BITAND : '&';
BITOR : '|';
CARET : '^';
MOD : '%';
//LSHIFT : '<<';
//RSHIFT : '>>';
//URSHIFT : '>>>';

ADD_ASSIGN : '+=';
SUB_ASSIGN : '-=';
MUL_ASSIGN : '*=';
DIV_ASSIGN : '/=';
AND_ASSIGN : '&=';
OR_ASSIGN : '|=';
XOR_ASSIGN : '^=';
MOD_ASSIGN : '%=';
LSHIFT_ASSIGN : '<<=';
RSHIFT_ASSIGN : '>>=';
URSHIFT_ASSIGN : '>>>=';


//--------------------------------------------------------------------------------------------------


// §3.10.1 Integer Literals

IntegerLiteral
	:	DecimalIntegerLiteral
	|	HexIntegerLiteral
	|	OctalIntegerLiteral
	|	BinaryIntegerLiteral
	;

fragment
DecimalIntegerLiteral
	:	DecimalNumeral IntegerTypeSuffix?
	;

fragment
HexIntegerLiteral
	:	HexNumeral IntegerTypeSuffix?
	;

fragment
OctalIntegerLiteral
	:	OctalNumeral IntegerTypeSuffix?
	;

fragment
BinaryIntegerLiteral
	:	BinaryNumeral IntegerTypeSuffix?
	;

fragment
IntegerTypeSuffix
	:	[lL]
	;

fragment
DecimalNumeral
	:	'0'
	|	NonZeroDigit (Digits? | Underscores Digits)
	;

fragment
Digits
	:	Digit (DigitsAndUnderscores? Digit)?
	;

fragment
Digit
	:	'0'
	|	NonZeroDigit
	;

fragment
NonZeroDigit
	:	[1-9]
	;

fragment
DigitsAndUnderscores
	:	DigitOrUnderscore+
	;

fragment
DigitOrUnderscore
	:	Digit
	|	'_'
	;

fragment
Underscores
	:	'_'+
	;

fragment
HexNumeral
	:	'0' [xX] HexDigits
	;

fragment
HexDigits
	:	HexDigit (HexDigitsAndUnderscores? HexDigit)?
	;

fragment
HexDigit
	:	[0-9a-fA-F]
	;

fragment
HexDigitsAndUnderscores
	:	HexDigitOrUnderscore+
	;

fragment
HexDigitOrUnderscore
	:	HexDigit
	|	'_'
	;

fragment
OctalNumeral
	:	'0' Underscores? OctalDigits
	;

fragment
OctalDigits
	:	OctalDigit (OctalDigitsAndUnderscores? OctalDigit)?
	;

fragment
OctalDigit
	:	[0-7]
	;

fragment
OctalDigitsAndUnderscores
	:	OctalDigitOrUnderscore+
	;

fragment
OctalDigitOrUnderscore
	:	OctalDigit
	|	'_'
	;

fragment
BinaryNumeral
	:	'0' [bB] BinaryDigits
	;

fragment
BinaryDigits
	:	BinaryDigit (BinaryDigitsAndUnderscores? BinaryDigit)?
	;

fragment
BinaryDigit
	:	[01]
	;

fragment
BinaryDigitsAndUnderscores
	:	BinaryDigitOrUnderscore+
	;

fragment
BinaryDigitOrUnderscore
	:	BinaryDigit
	|	'_'
	;

// §3.10.2 Floating-Point Literals

FloatingPointLiteral
	:	DecimalFloatingPointLiteral
	|	HexadecimalFloatingPointLiteral
	;

fragment
DecimalFloatingPointLiteral
	:	Digits '.' Digits? ExponentPart? FloatTypeSuffix?
	|	'.' Digits ExponentPart? FloatTypeSuffix?
	|	Digits ExponentPart FloatTypeSuffix?
	|	Digits FloatTypeSuffix
	;

fragment
ExponentPart
	:	ExponentIndicator SignedInteger
	;

fragment
ExponentIndicator
	:	[eE]
	;

fragment
SignedInteger
	:	Sign? Digits
	;

fragment
Sign
	:	[+-]
	;

fragment
FloatTypeSuffix
	:	[fFdD]
	;

fragment
HexadecimalFloatingPointLiteral
	:	HexSignificand BinaryExponent FloatTypeSuffix?
	;

fragment
HexSignificand
	:	HexNumeral '.'?
	|	'0' [xX] HexDigits? '.' HexDigits
	;

fragment
BinaryExponent
	:	BinaryExponentIndicator SignedInteger
	;

fragment
BinaryExponentIndicator
	:	[pP]
	;

// §3.10.3 Boolean Literals

BooleanLiteral
	:	'true'
	|	'false'
	;

// §3.10.4 Character Literals

CharacterLiteral
	:	'\'' SingleCharacter '\''
	|	'\'' EscapeSequence '\''
	;

fragment
SingleCharacter
	:	~['\\\r\n]
	;

// §3.10.5 String Literals
StringLiteral
	:	'"' StringCharacters? '"'
	;
fragment
StringCharacters
	:	StringCharacter+
	;
fragment
StringCharacter
	:	~["\\\r\n]
	|	EscapeSequence
	;
// §3.10.6 Escape Sequences for Character and String Literals
fragment
EscapeSequence
	:	'\\' [btnfr"'\\]
	|	OctalEscape
    |   UnicodeEscape // This is not in the spec but prevents having to preprocess the input
	;

fragment
OctalEscape
	:	'\\' OctalDigit
	|	'\\' OctalDigit OctalDigit
	|	'\\' ZeroToThree OctalDigit OctalDigit
	;

fragment
ZeroToThree
	:	[0-3]
	;

// This is not in the spec but prevents having to preprocess the input
fragment
UnicodeEscape
    :   '\\' 'u'+ HexDigit HexDigit HexDigit HexDigit
    ;

// §3.10.7 The Null Literal

NullLiteral
	:	'null'
	;

// §3.8 Identifiers (must appear after all keywords in the grammar)

Identifier
	:	RalphLetter RalphLetterOrDigit*
	;

fragment
RalphLetter
	:	[a-zA-Z$_] // these are the "Ralph letters" below 0x7F
	|	// covers all characters above 0x7F which are not a surrogate
		~[\u0000-\u007F\uD800-\uDBFF]
		{ Check1() }?
	|	// covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
		[\uD800-\uDBFF] [\uDC00-\uDFFF]
		{ Check2() }?
	;

fragment
RalphLetterOrDigit
	:	[a-zA-Z0-9$_] // these are the "Ralph letters or digits" below 0x7F
	|	// covers all characters above 0x7F which are not a surrogate
		~[\u0000-\u007F\uD800-\uDBFF]
		{ Check3() }?
	|	// covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
		[\uD800-\uDBFF] [\uDC00-\uDFFF]
		{ Check4() }?
	;

//
// Whitespace and comments
//

WS  :  [ \t\r\n\u000C]+ -> skip
    ;

COMMENT
    :   '/*' .*? '*/' -> channel(HIDDEN)
    ;

LINE_COMMENT
    :   '//' ~[\r\n]* -> channel(HIDDEN)
    ;
