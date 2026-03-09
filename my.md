# my
## .l文件解读
%%
%%

Flex文件的结构由两个 `%%` 分隔符分成三个部分，对应的专业名词是：
1. 定义部分（Definition Section） - 第一个 `%%` 之前
    - 包含选项设置（如 `%option`）
    - 定义模式宏（如 `DIGIT [0-9]`）
    - C代码（在 `%{` 和 `%}` 之间）
2. 规则部分（Rules Section） - 两个 `%%` 之间
    - 包含词法规则，格式为：`模式 { 动作代码 }`
    - 例如：`{IDENTIFIER} { printf("%s : ID\n", yytext); return ID; }`
3. 用户代码部分（User Code Section） - 第二个 `%%` 之后
    - 包含主函数和其他辅助函数
    - 例如：`int main(int argc, char argv) { ... }`

这种结构是Flex词法分析器的标准组织方式，便于清晰管理不同类型的代码和规则。
这两种规则在Flex词法分析器中有以下区别：

### 1. 规则形式
- `">=" {printf("%s : GE\n", yytext); return GE; }`：
    - 直接使用字符串字面量作为模式（`">="`）
    - 匹配具体的符号（大于等于运算符）
    - 执行具体的动作（打印输出并返回token类型）

- `{IDENTIFIER} {}`：
    - 使用定义部分中定义的模式宏（`{IDENTIFIER}`）
    - 匹配符合`IDENTIFIER`模式的任意字符串
    - 执行空动作（`{}`），表示匹配后不做任何处理（通常用于跳过或忽略）

### 2. 匹配优先级
- 字符串字面量规则的优先级高于模式宏规则
- 长字符串字面量规则（如`">="`）的优先级高于短字符串字面量规则（如`">"`）

### 3. 应用场景
- 字符串字面量规则：用于匹配固定的关键字、运算符、分隔符等
- 模式宏规则：用于匹配符合特定模式的标识符、字面量等

在你的代码中，`{IDENTIFIER} {}` 可能是一个占位符或临时规则，实际代码中应该会有具体的动作处理。

## Test Case 1
```
int : INT
main : ID
( : LP
) : RP
{ : LC
int : INT
a : ID
, : COMMA
b : ID
; : SEMICOLON
a : ID
= : ASSIGN
10 : INT_LIT
; : SEMICOLON
b : ID
= : ASSIGN
2 : INT_LIT
; : SEMICOLON
return : RETURN
a : ID
+ : ADD
b : ID
; : SEMICOLON
} : RC
```

## Test Case 2
```
int : INT
main : ID
( : LP
) : RP
{ : LC
int : INT
a : ID
, : COMMA
b : ID
; : SEMICOLON
a : ID
= : ASSIGN
0xf : INT_LIT
; : SEMICOLON
b : ID
= : ASSIGN
0xc : INT_LIT
; : SEMICOLON
return : RETURN
a : ID
+ : ADD
b : ID
+ : ADD
075 : INT_LIT
; : SEMICOLON
} : RC
```

## Test Case 3
```
int : INT
main : ID
( : LP
) : RP
{ : LC
float : FLOAT
a : ID
, : COMMA
b : ID
; : SEMICOLON
int : INT
c : ID
= : ASSIGN
Lexical error - line 3 : 085
; : SEMICOLON
a : ID
= : ASSIGN
020e-04f : FLOAT_LIT
; : SEMICOLON
b : ID
= : ASSIGN
getfloat : ID
( : LP
) : RP
; : SEMICOLON
putfloat : ID
( : LP
a : ID
+ : ADD
b : ID
) : RP
; : SEMICOLON
putch : ID
( : LP
10 : INT_LIT
) : RP
; : SEMICOLON
return : RETURN
0 : INT_LIT
; : SEMICOLON
} : RC
```

## Test Case 4
```
int : INT
main : ID
( : LP
) : RP
{ : LC
float : FLOAT
pi : ID
= : ASSIGN
3 : INT_LIT
l14 : ID
; : SEMICOLON
float : FLOAT
r : ID
= : ASSIGN
2f : FLOAT_LIT
; : SEMICOLON
float : FLOAT
area : ID
= : ASSIGN
pi : ID
* : MUL
r : ID
* : MUL
r : ID
; : SEMICOLON
putfloat : ID
( : LP
area : ID
) : RP
; : SEMICOLON
} : RC
```

## Test Case 5
```
int : INT
get : ID
Lexical error - line 1 : _
one : ID
( : LP
int : INT
a : ID
) : RP
{ : LC
return : RETURN
1 : INT_LIT
; : SEMICOLON
} : RC
int : INT
deepWhileBr : ID
( : LP
int : INT
a : ID
, : COMMA
int : INT
b : ID
) : RP
{ : LC
int : INT
c : ID
; : SEMICOLON
c : ID
= : ASSIGN
a : ID
+ : ADD
b : ID
; : SEMICOLON
while : WHILE
( : LP
c : ID
< : LT
75 : INT_LIT
) : RP
{ : LC
int : INT
d : ID
; : SEMICOLON
d : ID
= : ASSIGN
42 : INT_LIT
; : SEMICOLON
if : IF
( : LP
c : ID
< : LT
100 : INT_LIT
) : RP
{ : LC
c : ID
= : ASSIGN
c : ID
+ : ADD
d : ID
; : SEMICOLON
if : IF
( : LP
c : ID
> : GT
99 : INT_LIT
) : RP
{ : LC
int : INT
e : ID
; : SEMICOLON
e : ID
= : ASSIGN
d : ID
* : MUL
2 : INT_LIT
; : SEMICOLON
if : IF
( : LP
get : ID
Lexical error - line 16 : _
one : ID
( : LP
0 : INT_LIT
) : RP
== : EQ
1 : INT_LIT
) : RP
{ : LC
c : ID
= : ASSIGN
e : ID
* : MUL
2 : INT_LIT
; : SEMICOLON
} : RC
} : RC
} : RC
} : RC
return : RETURN
( : LP
c : ID
) : RP
; : SEMICOLON
} : RC
int : INT
main : ID
( : LP
) : RP
{ : LC
int : INT
p : ID
; : SEMICOLON
p : ID
= : ASSIGN
2 : INT_LIT
; : SEMICOLON
p : ID
= : ASSIGN
deepWhileBr : ID
( : LP
p : ID
, : COMMA
p : ID
) : RP
; : SEMICOLON
putint : ID
( : LP
p : ID
) : RP
; : SEMICOLON
return : RETURN
0 : INT_LIT
; : SEMICOLON
} : RC
```
