---
title: 深入理解xmodmap
date: 2016-11-08 20:29:11
tags:
- xmodmap
---
买了一个61键位的键盘。少了home/end这些，至少浏览器需要。
重新认真看下keymaps的manpage。才发现必须深入理解下面这行。

```
keycode keynumber = keysym keysym keysym...
```

> - **man keymaps : **
> 键盘驱动程序支持8个修饰键，它们是 (任意顺序) Shift, AltGr, Control, Alt, ShiftL, ShiftR, CtrlL 和 CtrlR。

> AltGr键是在某些非美式键盘布局右侧的键。AltGr等效于Ctrl+Alt组合键

> - **man xmodmap : **
> Up to eight keysyms may be attached to a key, **however the  last  four are  not  used in any major X server implementation.**  The first keysym is used when no modifier key is  pressed  in conjunction  with  this  key,  the second with Shift, the third when the Mode_switch key is used with this key  and the  fourth  when both the Mode_switch and Shift keys are used.

难怪设置多余4个的无效。
```
▶ xmodmap -e 'keycode 43 = h H h Home h H H Home Home'
▶ xmodmap -pke|g '\<43'
36   :keycode  43 = h H h Home h H H Home
```

正确的理解如下。

|键值|-|shift|Mode_switch|Mode_switch+Shift|
|----|:-----:|:----:|:----:|:----:|
|keycode 43 = |h |H |Home |H |

接着找**Mode_switch**。用xev看下，左右ctrl键值为 _37_ 和 _105_。键盘上 Ctrl_R 本来就是Fn的组合键了，无法设置。下面这样就把 _ctrl-L + h_ 设置成Home了。_后遗症就是左ctrl不再是control功能了_。
```
▶ xmodmap -pke|g '\<37'
  30   :keycode  37 = Control_L NoSymbol Control_L
▶ xmodmap -e "keycode 37 = Mode_switch Mode_switch"
▶ xmodmap -e 'keycode 43 = h H Home H'
```
改成 _Shift+光标键_ (第2列)，结果shift也一起被算进去了，相当于一直按住shift。
```
▶ xmodmap -pke|g '\<Left'
106   :keycode 113 = Left NoSymbol Left
▶ xmodmap -e "keycode 111 = Up Prior Up"
▶ xmodmap -e "keycode 116 = Down Next Down"
▶ xmodmap -e "keycode 113 = Left Home Left"
▶ xmodmap -e "keycode 114 = Right End Right"
```
只能把 Shift_R (0x3e) 搞成 Mode_switch (第3列)。这样要输入~号，只能 _Fn + Shift-L + Esc_ 了。哎。
```
▶ cat .Xmodmap
keycode 0x3e = Mode_switch Mode_switch
keycode 111 = Up NoSymbol Prior Up
keycode 116 = Down NoSymbol Next Down
keycode 113 = Left NoSymbol Home Left
keycode 114 = Right NoSymbol End Right

```
现在发现这些小键盘，还真是太折腾了。太多3键组合累死人。
