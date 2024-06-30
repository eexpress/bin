if status is-interactive		#交互式
    # Commands to run in interactive sessions can go here
    set -x PATH $HOME/bin $HOME/.local/bin $PATH
    set -x CDPATH ~ ~/bin ~/project ~/.config ~/.local/share/gnome-shell/extensions/
	source /home/eexpss/.config/fish/functions/theme-agnoster/functions/fish_prompt.fish
	set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'"	# bat --list-themes

	##-------- LS假名 --------
	# alias 命令，实际上是 function 的语法糖
	alias l='/bin/ls --color=always'
	alias la='l -A'
	alias lt='l -oAh  --time-style=iso -t'		# mtime
	alias ls='lt -S'		# size
	##-------- ALIAS --------
	alias cn='set -x LC_ALL zh_CN.UTF-8'
	alias en='set -x LC_ALL C'
	alias pl='perl -pE' #-E like -e, BUT enables all features; -p EXCUTE while (<>) THEN print.
	alias ps='\ps -u `id -un` -o pid,command'
	alias pg='pgrep -af'

	alias k='pkill -9 -f'
	alias g='grep --color=always -Pi 2>/dev/null'
	alias e='/usr/bin/gnome-text-editor'
	alias s='/usr/bin/bat'
	alias say='~/.local/bin/edge-playback -v zh-CN-XiaoyiNeural -t'
	alias i='df -hT -x tmpfs -x devtmpfs;echo -e "\n内存---------------";free -h|cut -b -50;echo -e "\n温度---------------";sensors|grep Core'
	
	##-------- 包管理 --------
	if test $USER = "root"
		set sudostr ""
	else
		set sudostr "sudo"
	end
	alias pi="$sudostr dnf install"
	alias pr="$sudostr dnf remove"
	alias pu="$sudostr dnf update"
	alias pf="dnf search -C"
	alias pfi="dnf list installed -C"
	alias pfile='dnf provides -C'			# 查找文件或命令所属的包(已安装/未安装)
	alias pneed='rpm -q --whatrequires'		# 被哪个包需要
	function pinfo	# 包信息。rpm需要已安装的确切包名；dnf可通配符查未安装的包。
		#rpm -q --info $argv[1] or dnf info -Cy $argv[1]
		rpm -q --info $argv[1]
		test $status -ne 0 && dnf info $argv[1]
	end
	function plist	# 包的文件列表。
		rpm -q --list $argv[1]
		test $status -ne 0 && dnf repoquery --list $argv[1]	#dnf出两次结果。。。。
	end
	alias fk="$sudostr flatpak"		# 没有补全了。。。。。

end

# 非交互式 shell 会话可能由脚本、cron job 或其他自动化任务启动

