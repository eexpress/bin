using Gtk;
using GLib.Process;
using Notify;

public StatusIcon trayicon;
public Notification msg;
public Notification vol;
MatchInfo info;
string stdoutstr;

bool check_mouse_is_right(){
	spawn_command_line_sync("xmodmap -pp", out stdoutstr);
	Regex r = /\b1\b\s*\b1\b/; r.match(stdoutstr,0,out info);
	return info.matches();
}

void set_icon_tip(bool right, bool setup){
	if(right){
		trayicon.set_from_stock(Stock.JUSTIFY_RIGHT);
		trayicon.set_tooltip_text ("现在是右手鼠标");
		if(setup) spawn_command_line_async("xmodmap -e 'pointer = 1 2 3'");
	}else{
		trayicon.set_from_stock(Stock.JUSTIFY_LEFT);
		trayicon.set_tooltip_text ("现在是左手鼠标");
		if(setup) spawn_command_line_async("xmodmap -e 'pointer = 3 2 1'");
	}
}

public bool mouse(Gdk.EventButton e){
	switch(e.button){
		case 1:
			msg = new Notification("TrayTool introduce", "鼠标按键说明：\n1：显示说明\n2：退出\n3：交换左右手，比如当前鼠标是右手操作，左手握鼠标，食指按下原来的3键，则交换1/3键，切换成左手设置\n4：加大音量\n5：减小音量", "dialog-information");
			msg.show();break;
		case 2:
			Gtk.main_quit();break;
		case 3:
			set_icon_tip(!check_mouse_is_right(),true);
			break;
	}
	return true;
}

public bool volume(Gdk.EventScroll e){
string cmd="";

	switch (e.direction){
		case Gdk.ScrollDirection.DOWN:	cmd="amixer set Master 5%-";break;
		case Gdk.ScrollDirection.UP:	cmd="amixer set Master 5%+";break;
	}
	try{
	spawn_command_line_sync(cmd, out stdoutstr);
	} catch (SpawnError e){stderr.printf ("%s\n", e.message);}
	Regex r = /\d*%/; r.match(stdoutstr,0,out info);

	vol = new Notification("Volume", "", "audio-volume-medium");
	vol.set_hint("value",int.parse(info.fetch(0)));
	vol.set_hint_string("synchronous","volume");
	vol.show();
	return true;
}

public static int main (string[] args) {
	Gtk.init(ref args);
	trayicon = new StatusIcon.from_stock(Stock.JUSTIFY_LEFT);
	set_icon_tip(check_mouse_is_right(),false);
	trayicon.button_release_event.connect(mouse);
	trayicon.scroll_event.connect(volume);
	trayicon.set_visible(true);
	Notify.init("Tray Icon");
	Gtk.main();
	return 0;
}

