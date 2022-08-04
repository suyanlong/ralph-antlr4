parser grammar RalphParser;

options
{
   tokenVocab = RalphLexer;
}

sourceFile:(importDecl eos)* (declaration eos)* EOF;

//import------------------------------------------------------
importDecl:
	IMPORT (importSpec | L_PAREN (importSpec eos)* R_PAREN);

importSpec: alias = (DOT | IDENTIFIER)? importPath;

importPath: string_;

//import------------------------------------------------------

declaration: constDecl | typeDecl | varDecl;
identifierList: IDENTIFIER (COMMA IDENTIFIER)*;

//var--------------------------------------------------------
constDecl: CONST (constSpec | L_PAREN (constSpec eos)* R_PAREN);

constSpec: identifierList (type_? ASSIGN expressionList)?;

varDecl: LET MUT? (varSpec | L_PAREN (varSpec eos)* R_PAREN);

varSpec:
	identifierList (
		type_ (ASSIGN expressionList)?
		| ASSIGN expressionList
	);

//var--------------------------------------------------------


//expression--------------------------------------------------------

expression:
	primaryExpr
	| unary_op = (
		PLUS
		| MINUS
		| EXCLAMATION
		| CARET
		| STAR
		| AMPERSAND
		| RECEIVE
	) expression
	| expression mul_op = (
		STAR
		| DIV
		| MOD
		| LSHIFT
		| RSHIFT
		| AMPERSAND
		| BIT_CLEAR
	) expression
	| expression add_op = (PLUS | MINUS | OR | CARET) expression
	| expression rel_op = (
		EQUALS
		| NOT_EQUALS
		| LESS
		| LESS_OR_EQUALS
		| GREATER
		| GREATER_OR_EQUALS
	) expression
	| expression LOGICAL_AND expression
	| expression LOGICAL_OR expression;

expressionList: expression (COMMA expression)*;

primaryExpr
	: operand
	| conversion
	| methodExpr
	| primaryExpr (
		(DOT IDENTIFIER)
		| index
		| slice_
		| arguments
	);

conversion: nonNamedType L_PAREN expression COMMA? R_PAREN;

methodExpr: nonNamedType DOT IDENTIFIER;

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

typeDecl: TYPE (typeSpec | L_PAREN (typeSpec eos)* R_PAREN);

typeSpec: IDENTIFIER ASSIGN? type_;

typeList: (type_) (COMMA (type_))*;

type_: typeName | typeLit | L_PAREN type_ R_PAREN | typeStruct;

typeName: qualifiedIdent | IDENTIFIER;

typeLit
    : primitiveType  
	| arrayType
	| functionType
	| sliceType
	;

arrayType: L_BRACKET arrayLength elementType R_BRACKET;

arrayLength: expression;

elementType: type_;

functionType: PUB? FN PAYABLE? signature;

signature: parameters ( '->' result)?;

result
	: L_PAREN R_PAREN
    | type_
    | L_PAREN (type_ (COMMA type_)* COMMA?)? R_PAREN
    ;

parameters:
	L_PAREN (parameterDecl (COMMA parameterDecl)* COMMA?)? R_PAREN;

parameterDecl: identifierList? ELLIPSIS? type_;

nonNamedType: typeLit | L_PAREN nonNamedType R_PAREN;

operand: literal | IDENTIFIER | L_PAREN expression R_PAREN;

literal: basicLit ;

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
	| RUNE_LIT;

qualifiedIdent: IDENTIFIER DOT IDENTIFIER;

fieldDecl: LET? MUT? identifierList COLON type_;

string_: RAW_STRING_LIT | INTERPRETED_STRING_LIT;

index: L_BRACKET expression R_BRACKET;

slice_
	:L_BRACKET (
		  expression? COLON expression?
		| expression? COLON expression COLON expression
	) R_BRACKET;

arguments
	: L_PAREN (
		( expressionList 
		| nonNamedType (COMMA expressionList)?
		) ELLIPSIS? COMMA?
	  )? R_PAREN
	;

// Function declarations
methodDecl
	:  (annotation eos)? PUB? FN PAYABLE? IDENTIFIER signature block?
	;

sliceType: L_BRACKET R_BRACKET elementType;

typeStruct: typeStructHeader structBody; 

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
	: L_CURLY ((fieldDecl | eventEmit | methodDecl | typeName ｜) eos)* R_CURLY 
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

statementList: ((SEMI? | EOS? | {this.closingBracket()}?) statement eos)+;

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
	| incDecStmt
	| assignment
	| expressionStmt
	| shortVarDecl
	| eventEmit
	;

expressionStmt: expression;

incDecStmt: expression (PLUS_PLUS | MINUS_MINUS);

assignment: expressionList assign_op expressionList;

assign_op: (
		PLUS
		| MINUS
		| OR
		| CARET
		| STAR
		| DIV
		| MOD
		| LSHIFT
		| RSHIFT
		| AMPERSAND
		| BIT_CLEAR
	)? ASSIGN;

shortVarDecl: identifierList DECLARE_ASSIGN expressionList;

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
	| {this.closingBracket()}?
	;

//other--------------------------------------------------------
