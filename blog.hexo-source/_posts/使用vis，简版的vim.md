---
title: 使用vis，简版的vim
date: 2016-11-02 10:17:58
tags:
- vis
- vim
---
```
▶ git clone https://github.com/martanne/vis
▶ cd vis
编译需要安装这两个库。
▶ ai libcurses-ocaml-dev libtermkey-dev
▶ ./configure && make && sudo make install

语法高亮需要Lpeg支持，就是Lua的PEG。安装了lua-lpeg。
▶ mkdir ~/.config/vis/
▶ cp visrc.lua ~/.config/vis/
```

```
▶ cat $VIS_PATH/visrc.lua
-- load standard vis module, providing parts of the Lua API
require('vis')

vis.events.start = function()
	-- Your global configuration options e.g.
	-- vis:command('map! normal j gj')
end

vis.events.win_open = function(win)
	-- enable syntax highlighting for known file types
	vis.filetype_detect(win)

	-- Your per window configuration options e.g.
	vis:command('set number')
end
```
可是没有语法高亮，也没有行号，似乎没读取配置文件。