#!/usr/bin/perl -w

use strict;
use Gtk2 '-init';
use Cairo;

# 输入一个图片文件作参数，如果无效，使用缺省图片。
my $file=$ARGV[0]//'/tmp/weather.png';
#my $file=$ARGV[0]//'/home/eexp/图片/tea.png';
#my $file=$ARGV[0]//'/home/eexp/图片/120px-Former_Ubuntu_logo.svg.png';
# 如果文件不存在，就退出。
die "no pic" if ! -e $file;
# 创建新窗口
my $window = Gtk2::Window->new();
# 设置无边框
$window->set_decorated(0);
# 窗口缺省没有鼠标事件，增加事件。否则下面的button信号不能连接。
$window->add_events("GDK_BUTTON_PRESS_MASK");
# 设置窗口置顶
$window->set_keep_above(1);
# 窗口删除事件可以省略，由鼠标右键代替。
#$window->signal_connect('delete-event', sub{exit;});
# 连接重画/鼠标/键盘事件
$window->signal_connect('expose_event', \&expose);
$window->signal_connect('button_press_event',\&mouse);
$window->signal_connect('key-release-event',\&key);
# 设置窗口在屏幕的位置
$window->move(200,200);
# 读入图片，建立cairo的图片映像
my $img = Cairo::ImageSurface->create_from_png ($file);
# 根据图片的尺寸，设置窗口的大小
$window->set_size_request($img->get_width(),$img->get_height());
# 设置cairo渲染效果的列表和循环的初值。
my @effect=('source','xor');
#my @effect=('clear', 'source', 'over', 'in', 'out', 'atop', 'dest', 'dest-over', 'dest-in', 'dest-out', 'dest-atop', 'xor', 'add', 'saturate');
my $loop=0;
# 设置通用的定时器和回调函数
Glib::Timeout->add_seconds(1,\&time);
my $second=0;
# 设置颜色为rgba，才可以透明显示。
$window->set_colormap($window->get_screen->get_rgba_colormap());
# 显示窗口，启动Gtk主循环。
$window->show_all();
Gtk2->main;

# 窗口重画函数。任何改变窗口显示的时候，触发。
sub expose {
	# 读入回调函数的参数。
	my($widget, $event) = @_;
	# 在窗口可画区域，产生cairo画笔。
	my $cr = Gtk2::Gdk::Cairo::Context->create($widget->window);
	# 设置画笔的叠加效果。此效果为查表循环改变的。
	$cr->set_operator($effect[$loop]);
	# 把图片放到0坐标
	$cr->set_source_surface($img,0,0);
	# 开始画笔。
	$cr->paint;

	# 选择字体/大小/颜色。覆盖模式。坐标。显示当前的叠加效果名称。
	$cr->select_font_face("Amerika Sans",'normal','bold');
	$cr->set_font_size(20);
	$cr->set_source_rgba(0,0,70,0.9);
	$cr->set_operator('over');
	$cr->move_to(0,20);
	$cr->show_text($effect[$loop]);
	# 奇怪的print。不写就不画上面的文字。第一次碰到这情况。
	print "";
#        print "expose:render cairo at ".join("-",$window->get_position).". use effect \"$effect[$loop]\"\n";
}

# 按键。立刻换下一种叠加效果，并重画。
sub key{
	my($widget, $event) = @_;
	$loop++; if ($loop>=@effect){$loop=0;}
	$window->queue_draw();
}

# 鼠标。可拖到透明图片。中/右键退出。
sub mouse{
	my ($widget, $event) = @_;
#        print "<- $event->button\n";
	if($event->button eq 1){
		$window->begin_move_drag($event->button,$event->x_root,$event->y_root,$event->time);
	}
	else {exit;}
}

# 定时。3秒自动切换叠加效果。
sub time{
	$second++;
	if ($second%3==0){
		$loop++; if ($loop>=@effect){$loop=0;}
		$window->queue_draw() ;
	}
	# 返回1，表示继续定时器。
	return 1;
}
