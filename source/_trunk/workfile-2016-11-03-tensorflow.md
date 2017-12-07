### python import

Python解释器会自动将当前工作目录添加到PYTHONPATH。

absolute import

relative import


from __future__ import division
导入python未来支持的语言特征division(精确除法)，当我们没有在程序中导入该特征时，"/"操作符执行的是截断除法(Truncating Division),当我们导入精确除法之后，"/"执行的是精确除法，如下所示：
---------------------------------------------------------------------------------------------
>>> 3/4
0
>>> from __future__ import division
>>> 3/4
0.75


nested_scopes	2.1.0b1	2.2	PEP 227: Statically Nested Scopes
generators	2.2.0a1	2.3	PEP 255: Simple Generators
division	2.2.0a2	3.0	PEP 238: Changing the Division Operator
absolute_import	2.5.0a1	2.7	PEP 328: Imports: Multi-Line and Absolute/Relative
with_statement	2.5.0a1	2.6	PEP 343: The “with” Statement
print_function	2.6.0a2	3.0	PEP 3105: Make print a function
unicode_literals	2.6.0a2	3.0	PEP 3112: Bytes literals in Pyt

python3 
print(*objects, sep=' ', end='\n', file=sys.stdout, flush=False)

abs(number)，返回数字的绝对值
cmath.sqrt(number)，返回平方根，也可以应用于负数
float(object)，把字符串和数字转换为浮点数
help()，提供交互式帮助
input(prompt)，获取用户输入
int(object)，把字符串和数字转换为整数
math.ceil(number)，返回数的上入整数，返回值的类型为浮点数
math.floor(number)，返回数的下舍整数，返回值的类型为浮点数
math.sqrt(number)，返回平方根不适用于负数
pow(x,y[.z]),返回X的y次幂（有z则对z取模）
repr(object)，返回值的字符串标示形式
round(number[.ndigits])，根据给定的精度对数字进行四舍五入
str(object),把值转换为字符串

(1). %字符：标记转换说明符的开始

(2). 转换标志：-表示左对齐；+表示在转换值之前要加上正负号；“”（空白字符）表示正数之前保留空格；0表示转换值若位数不够则用0填充

(3). 最小字段宽度：转换后的字符串至少应该具有该值指定的宽度。如果是*，则宽度会从值元组中读出。

(4). 点(.)后跟精度值：如果转换的是实数，精度值就表示出现在小数点后的位数。如果转换的是字符串，那么该数字就表示最大字段宽度。如果是*，那么精度将从元组中读出

(5).字符串格式化转换类型

转换类型          含义
d,i                 带符号的十进制整数
o                   不带符号的八进制
u                   不带符号的十进制
x                    不带符号的十六进制（小写）
X                   不带符号的十六进制（大写）
e                   科学计数法表示的浮点数（小写）
E                   科学计数法表示的浮点数（大写）
f,F                 十进制浮点数
g                   如果指数大于-4或者小于精度值则和e相同，其他情况和f相同
G                  如果指数大于-4或者小于精度值则和E相同，其他情况和F相同
C                  单字符（接受整数或者单字符字符串）
r                    字符串（使用repr转换任意python对象)
s                   字符串（使用str转换任意python对象）