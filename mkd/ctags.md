# ctags

## 常用写法
```
ctags -R --c++-kinds=+p --fields=+iaS --extra=+q
```
## 参数说明
> +p 打开了函数原型的声明。

## 查看各语言支持的语法元素
```
⭕ ctags --list-kinds=c++
c  classes
d  macro definitions
e  enumerators (values inside an enumeration)
f  function definitions
g  enumeration names
l  local variables [off]
m  class, struct, and union members
n  namespaces
p  function prototypes [off]
s  structure names
t  typedefs
u  union names
v  variable definitions
x  external and forward variable declarations [off]
```
## 显示格式（--fields）

- i 表示如果有继承，要标明父类；
- a 表示如果是类的成员，要标明其access属性（即是public的还是private的）；
- S 表示如果是函数，要标明函数的signature；
- K 表示要显示语法元素类型的全称；
- z 表示在显示语法元素的类型时，使用格式kind:type。

## 记录类的全名 --extra=+q
> 避免不同类但同名的函数，导致的混淆。

## 排除目录或者文件
> --exclude=xx.yy

## 查看语言和扩展名
```
⭕ ctags --list-maps|g '^C'
C        *.c
C++      *.c++ *.cc *.cp *.cpp *.cxx *.h *.h++ *.hh *.hp *.hpp *.hxx *.C *.H
C#       *.cs
Cobol    *.cbl *.cob *.CBL *.COB
CSS      *.css
```

> ctags 目前只被vim官方支持。gedit似乎用不上。


