#!/usr/bin/env gimp-script-fu-interpreter-3.0
(script-fu-use-v3)

; 此文件放入“~/.config/GIMP/3.2/scripts”路径。
; 在《滤镜》菜单下面新增一个《◀用选区画边框▶》的子菜单。
; 随意画出组合的选区，此功能是将选区变成前景色的边框，宽度由菜单决定，为3/6/9点宽度。

; 3像素边框 使用当前前景色
(define (script-fu-border-w3 img drw)
  (gimp-selection-border img 3)
  (gimp-drawable-edit-fill drw FILL-FOREGROUND)
)
(script-fu-register
 "script-fu-border-w3"
 "3px 边框"
 "使用当前前景色绘制3px边框，保留选区"
 "" "" "2026"
 ""
 SF-IMAGE    "图像"    0
 SF-DRAWABLE "图层"    0)
(script-fu-menu-register "script-fu-border-w3" "<Image>/Filters/◀用选区画边框▶")

; 6像素边框 使用当前前景色
(define (script-fu-border-w6 img drw)
  (gimp-selection-border img 6)
  (gimp-drawable-edit-fill drw FILL-FOREGROUND)
)
(script-fu-register
 "script-fu-border-w6"
 "6px 边框"
 "使用当前前景色绘制6px边框，保留选区"
 "" "" "2026"
 ""
 SF-IMAGE    "图像"    0
 SF-DRAWABLE "图层"    0)
(script-fu-menu-register "script-fu-border-w6" "<Image>/Filters/◀用选区画边框▶")

; 9像素边框 使用当前前景色
(define (script-fu-border-w9 img drw)
  (gimp-selection-border img 9)
  (gimp-drawable-edit-fill drw FILL-FOREGROUND)
)
(script-fu-register
 "script-fu-border-w9"
 "9px 边框"
 "使用当前前景色绘制9px边框，保留选区"
 "" "" "2026"
 ""
 SF-IMAGE    "图像"    0
 SF-DRAWABLE "图层"    0)
(script-fu-menu-register "script-fu-border-w9" "<Image>/Filters/◀用选区画边框▶")

