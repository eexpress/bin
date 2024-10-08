# cd ~/.config/fish/
# ln -sf ~/bin/config/config.fish .
# cd functions/
# git clone https://github.com/oh-my-fish/theme-agnoster
# chsh -s /bin/fish

if status is-interactive		#交互式
    # Commands to run in interactive sessions can go here
    set -x PATH $HOME/bin $HOME/.local/bin $PATH
    set -x CDPATH ~ ~/bin ~/project ~/.config ~/.local/share/gnome-shell/extensions/
	# source $HOME/.config/fish/functions/theme-agnoster/functions/fish_prompt.fish
	#set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'"	# bat --list-themes
	#set -Ux MANPAGER "less"
	set -x MANPAGER "bat -l man"
	# set -x PERL_UNICODE AS
	function fish_prompt
	    # ~/bin/prompt.pl (prompt_pwd)  # 缩短的工作路径
	    /home/eexpss/bin/prompt.pl (pwd)    # for root
	end
    function fish_greeting
        echo (set_color green; date +%F). fish. \
        (echo $USER@$hostname; set_color normal)
    end
    abbr -a bb "cd ~/bin/; git st"
    abbr -a ff sudo flatpak
    
	##-------- LS假名 --------
	# alias 命令，实际上是 function 的语法糖
	alias l='/bin/ls --color=always'
	alias la='l -A'
	alias lt='l -oAh  --time-style=iso -t'		# mtime
	alias ls='lt -S'		# size
	##-------- ALIAS --------
	alias cn='set -x LC_ALL zh_CN.UTF-8'
	alias en='set -x LC_ALL C'
    alias poff='gsettings set org.gnome.system.proxy mode "none"'
	alias pl='perl -pE'
	#-E like -e, BUT enables all features; -p EXCUTE while (<>) THEN print.
	alias ps='/usr/bin/ps -u $(id -un) -o pid,command'
	alias pg='pgrep -af'

	alias k='pkill -9 -f'
	alias g='grep --color=always -Pi 2>/dev/null'
	alias e='/usr/bin/micro $argv; or /usr/bin/gnome-text-editor'
	alias s='/usr/bin/bat'
	alias say='~/.local/bin/edge-playback -v zh-CN-XiaoyiNeural -t'
	alias i='df -hT|grep -P \'(可用|/(|home|boot)$)\';
	echo -e "\n内存---------------";free -h|cut -b -50;
	echo -e "\n温度---------------";sensors|grep Core'
	
	##-------- 包管理 --------
	test $USER = "root" && set sudostr "" || set sudostr "sudo"

	if test -x "/usr/bin/dnf"
		alias pi="$sudostr dnf install"
		alias pr="$sudostr dnf remove"
		alias pu="$sudostr dnf update"
		alias pf='dnf search -C'
		alias pfi='rpm -q --all | grep -P'	# 搜索已安装的包。
		alias pfile='rpm -q --file $argv; or dnf provides'		# 查找文件所属的包
		alias pinfo='rpm -q --info $argv; or dnf info'	# 包信息
		alias plist='rpm -q --list $argv; or dnf repoquery --list'	# 包的文件列表。
		# alias pneed='rpm -q --whatrequires'	# 被哪个包需要
	else								# apt
		alias pi="$sudostr apt install"
		alias pr="$sudostr apt remove"
		alias pu="$sudostr apt update && $sudostr apt upgrade"
		alias pf='apt list'			# 搜索包名
		alias pf0='apt search'		# 搜索描述，参数是AND关系。
		alias pfi='apt list --installed'		# 搜索已安装的包。
		alias pfile='dpkg -S'		# 查找文件所属的包
		alias pinfo='apt show'
		alias plist='dpkg -L'		# 列出包的文件
		alias pneed='apt-cache depends'		# 查看依赖的包
	end
	
	# alias fk="$sudostr flatpak"		# 没有补全了。。。。。

end

# 非交互式 shell 会话可能由脚本、cron job 或其他自动化任务启动

