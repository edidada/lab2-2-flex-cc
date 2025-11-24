%option noyywrap
%option yylineno

%{
#include <stdio.h>
#include <fstream>      // std::filebuf
#include <iostream>     // std::ios, std::istream, std::cout
#include <string.h>

enum Token {
    INT=258, FLOAT, VOID, CONST, RETURN, IF, ELSE, WHILE, BREAK, CONTINUE,
    LP, RP, LB, RB, LC, RC, COMMA, SEMICOLON, QUESTION, COLON,
    MINUS, NOT, TILDE, ASSIGN, ADD, MUL, DIV, MOD, AND, OR,
    EQ, NE, LT, LE, GT, GE,
    ID, INT_LIT, FLOAT_LIT,
    LEX_ERR
};

// 辅助函数：检查整数字面量是否合法
int is_valid_int_lit(const char* text) {
    int len = strlen(text);

    // 单个0是合法的
    if (len == 1 && text[0] == '0') return 1;

    // 十进制：不能以0开头（除了单个0）
    if (text[0] >= '1' && text[0] <= '9') {
        for (int i = 1; i < len; i++) {
            if (text[i] < '0' || text[i] > '9') return 0;
        }
        return 1;
    }

    // 八进制：以0开头，后面只能跟0-7
    if (text[0] == '0' && len > 1) {
        // 检查是否是十六进制
        if (len > 2 && (text[1] == 'x' || text[1] == 'X')) {
            for (int i = 2; i < len; i++) {
                if (!((text[i] >= '0' && text[i] <= '9') ||
                      (text[i] >= 'a' && text[i] <= 'f') ||
                      (text[i] >= 'A' && text[i] <= 'F'))) return 0;
            }
            return 1;
        }

        // 八进制：只能包含0-7
        for (int i = 1; i < len; i++) {
            if (text[i] < '0' || text[i] > '7') return 0;
        }
        return 1;
    }

    return 0;
}

// 辅助函数：检查浮点数字面量是否合法
int is_valid_float_lit(const char* text) {
    int len = strlen(text);
    int has_dot = 0, has_exp = 0, has_digit = 0;

    for (int i = 0; i < len; i++) {
        char c = text[i];

        if (c >= '0' && c <= '9') {
            has_digit = 1;
            continue;
        }

        if (c == '.') {
            if (has_dot || has_exp) return 0;  // 不能有多个点，点不能在指数后
            has_dot = 1;
            continue;
        }

        if (c == 'e' || c == 'E') {
            if (has_exp || !has_digit) return 0;  // 不能有多个指数，前面必须有数字
            has_exp = 1;
            has_digit = 0;  // 重置，指数后必须有数字

            // 检查可选的符号
            if (i + 1 < len && (text[i+1] == '+' || text[i+1] == '-')) {
                i++;  // 跳过符号
            }
            continue;
        }

        if (c == 'f' || c == 'F') {
            if (i != len - 1) return 0;  // f只能在最后
            continue;
        }

        return 0;  // 非法字符
    }

    return has_digit;  // 必须至少有一个数字
}

%}

DIGIT [0-9]
LETTER [A-Za-z]
HEX_DIGIT [0-9a-fA-F]
OCT_DIGIT [0-7]

DECIMAL_INT (0|[1-9][0-9]*)
OCTAL_INT 0[0-7]*
HEX_INT 0[xX]{HEX_DIGIT}+

INTEGER {DECIMAL_INT}|{OCTAL_INT}|{HEX_INT}

DECIMAL_FLOAT ([0-9]+\.[0-9]*|\.[0-9]+)([eE][-+]?[0-9]+)?[fF]?
EXPONENT_FLOAT [0-9]+[eE][-+]?[0-9]+[fF]?
INTEGER_FLOAT [0-9]+[fF]

FLOATING ({DECIMAL_FLOAT}|{EXPONENT_FLOAT}|{INTEGER_FLOAT})

IDENTIFIER {LETTER}({LETTER}|{DIGIT})*

MultilineComment "/*"([^\*]|(\*)*[^\*/])*(\*)*"*/"
SingleLineComment "//".*$

[ \n] {}
[ \r\t] {}
[ \n\t]+ {}

WHITESPACE [ \t\r\n]

%%

"int" {printf("%s : INT\n", yytext); return INT; }
"float" {printf("%s : FLOAT\n", yytext); return FLOAT; }
"void" {printf("%s : VOID\n", yytext); return VOID; }
"const" {printf("%s : CONST\n", yytext); return CONST; }
"return" {printf("%s : RETURN\n", yytext); ; return RETURN; }
"if" {printf("%s : IF\n", yytext); return IF; }
"else" {printf("%s : ELSE\n", yytext); return ELSE; }

"while" {printf("%s : WHILE\n", yytext); return WHILE; }

"break" {printf("%s : BREAK\n", yytext); return BREAK; }
"continue" {printf("%s : CONTINUE\n", yytext); return CONTINUE; }

"(" {printf("%s : LP\n", yytext); return LP; }
")" {printf("%s : RP\n", yytext); return RP; }
"[" {printf("%s : LB\n", yytext); return LB; }
"]" {printf("%s : RB\n", yytext); return RB; }
"{" {printf("%s : LC\n", yytext); return LC; }
"}" {printf("%s : RC\n", yytext); return RC; }
"," {printf("%s : COMMA\n", yytext); return COMMA; }
";" {printf("%s : SEMICOLON\n", yytext); return SEMICOLON; }
"?" {printf("%s : QUESTION\n", yytext); return QUESTION; }
":" {printf("%s : COLON\n", yytext); return COLON; }
"!" {printf("%s : NOT\n", yytext); return NOT; }
"=" {printf("%s : ASSIGN\n", yytext); return ASSIGN; }
"-" {printf("%s : MINUS\n", yytext); return MINUS; }
"+" {printf("%s : ADD\n", yytext); return ADD; }
"*" {printf("%s : MUL\n", yytext); return MUL; }
"/" {printf("%s : DIV\n", yytext); return DIV; }
"%" {printf("%s : MOD\n", yytext); return MOD; }
"&&" {printf("%s : AND\n", yytext); return AND; }
"||" {printf("%s : OR\n", yytext); return OR; }
"==" {printf("%s : EQ\n", yytext); return EQ; }
"!=" {printf("%s : NE\n", yytext); return NE; }
"<" {printf("%s : LT\n", yytext); return LT; }
"<=" {printf("%s : LE\n", yytext); return LE; }
">" {printf("%s : GT\n", yytext); return GT; }
">=" {printf("%s : GE\n", yytext); return GE; }

{IDENTIFIER} {
    // 检查是否是关键字（flex会自动优先匹配长规则，所以这里只可能是标识符）
    printf("%s : ID\n", yytext);
    return ID;
}

{INTEGER} {
    if (is_valid_int_lit(yytext)) {
        printf("%s : INT_LIT\n", yytext);
        return INT_LIT;
    } else {
        printf("Lexical error - line %d : %s\n", yylineno, yytext);
        return LEX_ERR;
    }
}

{FLOATING} {
    if (is_valid_float_lit(yytext)) {
        printf("%s : FLOAT_LIT\n", yytext);
        return FLOAT_LIT;
    } else {
        printf("Lexical error - line %d : %s\n", yylineno, yytext);
        return LEX_ERR;
    }
}

{MultilineComment} {}
{SingleLineComment} {}

{WHITESPACE}+ { /* 跳过空白字符 */ }

. {
    printf("Lexical error - line %d : %s\n", yylineno, yytext);
    return LEX_ERR;
}

%%

int main(int argc, char** argv) {
    
    if(argc > 1) {
        std::filebuf fb ;
        fb.open(argv[1], std::ios::in);
		std::istream in(&fb);
        FlexLexer* lexer = new yyFlexLexer(&in);    
        int symbol; 
        while( symbol = lexer->yylex()) { };
        fb.close();
    
    } else printf("No source file given!\n"); 

    return 0; 

}
