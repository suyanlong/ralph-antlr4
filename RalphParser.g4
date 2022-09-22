parser grammar RalphParser;

options
{
   tokenVocab = RalphLexer;
}

sourceFile:  (importDecl eos)* (declaration eos)* EOF;

//import------------------------------------------------------
importDecl: IMPORT (string_ | L_PAREN (string_ eos)* R_PAREN);

//import------------------------------------------------------

declaration: constDecl | typeDecl | letDecl;

identifierList: IDENTIFIER (COMMA IDENTIFIER)*;

//let--------------------------------------------------------
constDecl: CONST L_PAREN? identifierList R_PAREN? ASSIGN expressionList;

letDecl: LET MUT? L_PAREN? identifierList R_PAREN? ASSIGN expressionList;

//let--------------------------------------------------------


//expression--------------------------------------------------------
expression:
	primaryExpr
	|(SUB | NOT) expression
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
	| expression (
		EQ
		| NQ
		| LT
		| LE
		| GT
		| GE
	) expression
	| expression (AND | OR) expression;

expressionList: expression (COMMA expression)*;

arrayExpr: L_BRACKET expression R_BRACKET;

methodExpr: IDENTIFIER L_PAREN expressionList R_PAREN;

primaryExpr
	: basicLit
	| arrayExpr
	| methodExpr
	;

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

arrayType: L_BRACKET typeDecl SEMI arrayLength R_BRACKET;
arrayLength: expression;

typeDecl:  primitiveType | arrayType | typeStruct;

result
	: L_PAREN R_PAREN
    | typeDecl
    | L_PAREN (typeDecl (COMMA typeDecl)* COMMA?)? R_PAREN
    ;

parameterDecl: IDENTIFIER COLON typeDecl;

// Function declarations
methodDecl
	:  (annotation EOS)? PUB? FN PAYABLE? IDENTIFIER L_PAREN (parameterDecl (COMMA parameterDecl)*)? R_PAREN (R_ARROW result)? block?
	;

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


fieldDecl: LET? MUT? IDENTIFIER COLON typeDecl;

string_: RAW_STRING_LIT | INTERPRETED_STRING_LIT;

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
    : (AT USING L_PAREN (assignParamList | expressionList) R_PAREN)?
    ;

assignParamList
    : assign (COMMA assign)*
    ;

assign
    : IDENTIFIER ASSIGN expression
    ;

//type--------------------------------------------------------


//stmt--------------------------------------------------------

block: L_CURLY statementList? R_CURLY;

statementList: ((SEMI? | EOS?) statement eos)+;

statement:
	declaration
	| simpleStmt
	| returnStmt
	| block
	| ifStmt
	| whileStmt
	// | breakStmt
	// | continueStmt
	// | forStmt
	;

simpleStmt
	: emptyStmt
	| expressionStmt
	| eventEmit
	;

expressionStmt: expression;

emptyStmt: EOS | SEMI;

returnStmt: RETURN expressionList?;

// breakStmt: BREAK IDENTIFIER?;å
// continueStmt: CONTINUE IDENTIFIER?;
// forStmt: FOR (expression?) block;

ifStmt: IF (expression) block (ELSE (ifStmt | block))?;

whileStmt: WHILE (expression?) block;

//stmt--------------------------------------------------------


//other--------------------------------------------------------
eos:
	SEMI
	| EOF
	| EOS
	;

//other--------------------------------------------------------
