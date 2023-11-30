[build-menu]
FT_00_LB=编译(_C)
FT_00_CM=valac --pkg libadwaita-1 --pkg gtk4 --pkg posix "%f"
FT_00_WD=
FT_01_LB=生成(_B)
FT_01_CM=cd build; ninja
FT_01_WD=
EX_00_LB=执行(_E)
EX_00_CM=./build/"%e"
EX_00_WD=
