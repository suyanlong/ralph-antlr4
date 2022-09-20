parser grammar RalphParser;

options
{
   tokenVocab = RalphLexer;
}

sourceFile:  (importDecl eos)* (declaration eos)* EOF;

//import------------------------------------------------------
importDecl:
	IMPORT (importSpec | L_PAREN (importSpec eos)* R_PAREN);

importSpec: alias = (DOT | IDENTIFIER)? importPath;

importPath: string_;

//import------------------------------------------------------

declaration: constDecl | typeDecl | letDecl;
identifierList: IDENTIFIER (COMMA IDENTIFIER)*;

//let--------------------------------------------------------
constDecl: CONST (constSpec | L_PAREN (constSpec eos)* R_PAREN);

constSpec: identifierList (type_? ASSIGN expressionList)?;

letDecl: LET MUT? (letSpec | L_PAREN (letSpec eos)* R_PAREN);

letSpec:
	identifierList (
		type_ (ASSIGN expressionList)?
		| ASSIGN expressionList
	);

//let--------------------------------------------------------


//expression--------------------------------------------------------
expression:
	primaryExpr
	| unary_op = (
		SUB | NOT
	) expression
	| expression (
        CONCAT
        | ADD
        | SUB
        | MUL
        | DIV
        | MOD
        | MODADD
        | MODSUB
        | MODMUL
        | SHL
        | SHR
        | BITAND
        | XOR
		| BITOR
	) expression
	| expression rel_op = (
		EQ
		| NQ
		| LT
		| LE
		| GT
		| GE
	) expression
	| expression (AND | OR)expression;

expressionList: expression (COMMA expression)*;

primaryExpr
	: basicLit
	| primaryExpr (
		(DOT IDENTIFIER)
		| index
		| arguments
	);

//expression--------------------------------------------------------

//type--------------------------------------------------------

primitiveType
    : BOOL
    | I256
    | BYTE
    | U256
    | BYTEVEC
    | ADDRESS
    ;

arrayType: L_BRACKET elementType ';' arrayLength R_BRACKET;

arrayLength: expression;

elementType: type_;

// 数组字面量：[1,2,3,4]
// 地址字面量：#"asdad"
//  

typeDecl: TYPE (typeSpec | L_PAREN (typeSpec eos)* R_PAREN);

typeSpec: IDENTIFIER ASSIGN? type_;

typeList: (type_) (COMMA (type_))*;

type_:  typeBasic | typeStruct;

typeBasic
    : primitiveType  
	| arrayType
	;

signature: parameters ( R_ARROW result)?;

result
	: L_PAREN R_PAREN
    | type_
    | L_PAREN (type_ (COMMA type_)* COMMA?)? R_PAREN
    ;

parameters:
	L_PAREN (parameterDecl (COMMA parameterDecl)* COMMA?)? R_PAREN;

parameterDecl: identifierList? type_;

basicLit
	: integer
	| string_
	;

integer
	: DECIMAL_LIT
	| BINARY_LIT
	| OCTAL_LIT
	| HEX_LIT
	| IMAGINARY_LIT
	| RUNE_LIT
    ;


fieldDecl: LET? MUT? identifierList COLON type_;

string_: RAW_STRING_LIT | INTERPRETED_STRING_LIT;

index: L_BRACKET expression R_BRACKET;

arguments
	: L_PAREN ( ( expressionList ) COMMA? )? R_PAREN
	;

// Function declarations
methodDecl
	:  (annotation EOS)? PUB? FN PAYABLE? IDENTIFIER signature block?
	;

typeStruct: typeStructHeader typeStructBody; 

typeParam
	: STRUCT
	| ENUM
	| INTERFACE
	| TXSCRIPT
	| TXCONTRACT
	| CONTRACT
	| ASSETSCRIPT
	; 

typeStructHeader
	: typeParam IDENTIFIER ('<' (fieldDecl eos)* '>')? (L_PAREN (fieldDecl eos)* R_PAREN)? ((EXTENDS | IMPLEMENTS) IDENTIFIER (L_PAREN (fieldDecl eos)* R_PAREN)?)?
	;

typeStructBody
	: L_CURLY ((fieldDecl | eventEmit | methodDecl) eos)* R_CURLY 
	;

eventEmit
	: EVENT IDENTIFIER (L_PAREN (fieldDecl eos)* R_PAREN)?
	| EVMIT IDENTIFIER (L_PAREN expressionList R_PAREN)?
	;	


//  [@using(preapprovedAssets = <Bool>, assetsInContract = <Bool>)]
annotation
    : (AT USING L_PAREN varAssignParamList R_PAREN)?
    ;

varAssignParamList
    : assign (','assign)*
    ;

assign
    : (IDENTIFIER | varParamList) ASSIGN expressionStmt
    ;

varParamList
    : L_PAREN IDENTIFIER (',' IDENTIFIER)* R_PAREN
    ;


//type--------------------------------------------------------


//stmt--------------------------------------------------------

block: L_CURLY statementList? R_CURLY;

statementList: ((SEMI? | EOS?) statement eos)+;

statement:
	declaration
	| simpleStmt
	| returnStmt
	| breakStmt
	| continueStmt
	| block
	| ifStmt
	| forStmt
	| whileStmt
	;

simpleStmt
	: emptyStmt
	| expressionStmt
	| eventEmit
	;

expressionStmt: expression;

emptyStmt: EOS | SEMI;

returnStmt: RETURN expressionList?;

breakStmt: BREAK IDENTIFIER?;

continueStmt: CONTINUE IDENTIFIER?;

ifStmt:
	IF ( expression
			| eos expression
			| simpleStmt eos expression
			) block (
		ELSE (ifStmt | block)
	)?;

forStmt: FOR (expression?) block;

whileStmt: WHILE (expression?) block;

//stmt--------------------------------------------------------


//other--------------------------------------------------------
eos:
	SEMI
	| EOF
	| EOS
	;

//other--------------------------------------------------------
