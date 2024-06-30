if status is-interactive		#交互式
    # Commands to run in interactive sessions can go here
    set -x PATH $HOME/bin $HOME/.local/bin $PATH
    set -x CDPATH ~ ~/bin ~/project ~/.config ~/.local/share/gnome-shell/extensions/
	source /home/eexpss/.config/fish/functions/theme-agnoster/functions/fish_prompt.fish
	##-------- LS --------
	# alias 命令，实际上是 function 的语法糖
	alias l='/bin/ls --color=always'
	alias la='l -A'
	alias lt='l -oAh  --time-style=iso -t'		# mtime
	alias ls='lt -S'		# size
end

# 非交互式 shell 会话可能由脚本、cron job 或其他自动化任务启动

