parser grammar RalphParser;

options
{
   tokenVocab = RalphLexer;
}


sourceFile:
	(importDecl eos)* (
		(functionDecl | methodDecl | declaration) eos
	)* EOF;

importDecl:
	IMPORT (importSpec | L_PAREN (importSpec eos)* R_PAREN);

importSpec: alias = (DOT | IDENTIFIER)? importPath;

importPath: string_;

declaration: constDecl | typeDecl | varDecl;

constDecl: CONST (constSpec | L_PAREN (constSpec eos)* R_PAREN);

constSpec: identifierList (type_? ASSIGN expressionList)?;

identifierList: IDENTIFIER (COMMA IDENTIFIER)*;

expressionList: expression (COMMA expression)*;

typeDecl: TYPE (typeSpec | L_PAREN (typeSpec eos)* R_PAREN);

typeSpec: IDENTIFIER ASSIGN? type_;

// Function declarations

functionDecl: FN IDENTIFIER (signature block?);

methodDecl: FN IDENTIFIER ( signature block?);

varDecl: VAR (varSpec | L_PAREN (varSpec eos)* R_PAREN);

varSpec:
	identifierList (
		type_ (ASSIGN expressionList)?
		| ASSIGN expressionList
	);

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

simpleStmt:
	| incDecStmt
	| assignment
	| expressionStmt
	| shortVarDecl;

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

typeList: (type_ | NIL_LIT) (COMMA (type_ | NIL_LIT))*;

type_: typeName | typeLit | L_PAREN type_ R_PAREN;

typeName: qualifiedIdent | IDENTIFIER;

typeLit:
	arrayType
	| structType
	| functionType
	| interfaceType
	| sliceType
	;

arrayType: L_BRACKET arrayLength R_BRACKET elementType;

arrayLength: expression;

elementType: type_;

interfaceType:
	INTERFACE L_CURLY ((methodSpec | typeName) eos)* R_CURLY;

sliceType: L_BRACKET R_BRACKET elementType;

methodSpec:
	IDENTIFIER parameters result
	| IDENTIFIER parameters;

functionType: FN signature;

signature:
	parameters result
	| parameters;

result: parameters | type_;

parameters:
	L_PAREN (parameterDecl (COMMA parameterDecl)* COMMA?)? R_PAREN;

parameterDecl: identifierList? ELLIPSIS? type_;

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

primaryExpr:
	operand
	| conversion
	| methodExpr
	| primaryExpr (
		(DOT IDENTIFIER)
		| index
		| slice_
		| arguments
	);


conversion: nonNamedType L_PAREN expression COMMA? R_PAREN;

nonNamedType: typeLit | L_PAREN nonNamedType R_PAREN;

operand: literal | operandName | L_PAREN expression R_PAREN;

literal: basicLit | compositeLit | functionLit;

basicLit:
	NIL_LIT
	| integer
	| string_
	;

integer:
	DECIMAL_LIT
	| BINARY_LIT
	| OCTAL_LIT
	| HEX_LIT
	| IMAGINARY_LIT
	| RUNE_LIT;

operandName: IDENTIFIER;

qualifiedIdent: IDENTIFIER DOT IDENTIFIER;

compositeLit: literalType literalValue;

literalType:
	structType
	| arrayType
	| L_BRACKET ELLIPSIS R_BRACKET elementType
	| sliceType
	| typeName;

literalValue: L_CURLY (elementList COMMA?)? R_CURLY;

elementList: keyedElement (COMMA keyedElement)*;

keyedElement: (key COLON)? element;

key: expression | literalValue;

element: expression | literalValue;

structType: STRUCT L_CURLY (fieldDecl eos)* R_CURLY;

fieldDecl: identifierList type_;

string_: RAW_STRING_LIT | INTERPRETED_STRING_LIT;

functionLit: FN signature block; // function

index: L_BRACKET expression R_BRACKET;

slice_:
	L_BRACKET (
		expression? COLON expression?
		| expression? COLON expression COLON expression
	) R_BRACKET;

arguments:
	L_PAREN (
		(expressionList | nonNamedType (COMMA expressionList)?) ELLIPSIS? COMMA?
	)? R_PAREN;

methodExpr: nonNamedType DOT IDENTIFIER;

//----------------------------------------------------------------------------------------------------------------
//  [@using(preapprovedAssets = <Bool>, assetsInContract = <Bool>)]
annotation
    : ('@' USING '('  ')')?
    ;

typeType
    : primitiveType  
	| structType
	| interfaceType
	| txScriptType
	| assetScriptType
	| txContractType
	| contractType
    ;

structType
	:
	;

interfaceType
	:
	;

txScriptType
	:
	;

assetScriptType
	:
	;

txContractType
	:
	;

contractType
	:
	;
		

primitiveType
    : BOOL
    | I256
    | BYTE
    | U256
    | BYTEVEC
    | ADDRESS
    ;

typeArgument
    : typeType
    | (EXTENDS  typeType)?
    ;

typeArguments
    : '<' typeArgument (',' typeArgument)* '>'
    ;

eos:
	SEMI
	| EOF
	| EOS
	| {this.closingBracket()}?
	;

