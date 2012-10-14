using Gtk;
using GLib.Process;
using Notify;

public StatusIcon trayicon;
public Notification msg;
public Notification vol;
MatchInfo info;
string stdoutstr;
DateTime starttime;
Menu menuSystem;

void create_menuSystem() {
	menuSystem = new Menu();
	var menuAbout = new ImageMenuItem.with_label("Usage");
	menuAbout.set_image(new Gtk.Image.from_stock (Gtk.Stock.EXECUTE, Gtk.IconSize.MENU));
	menuAbout.activate.connect(()=>{
			var now = new DateTime.now_local ();
			if(now.compare(starttime)==-1) return;
			msg = new Notification("TrayTool introduce", "鼠标按键说明：\n1：显示说明，30秒内只显示一次\n2：退出\n3：交换左右手鼠标。比如当前鼠标是右手操作，左手握鼠标，食指按下原来的3键，则交换1/3键，切换成左手设置\n4：（滚轮向上）加大音量\n5：（滚轮向下）减小音量\n---------------\n"+now.to_string(), "dialog-information");
			starttime=now.add_seconds(30);
			msg.show();
			});
	menuSystem.append(menuAbout);
/*    menuAbout.activate.connect(()=>{});*/

	var menuShutdown = new ImageMenuItem.with_label("Shut Dwon");
	menuShutdown.set_image(new Gtk.Image.from_stock (Stock.STOP, Gtk.IconSize.MENU));
	menuShutdown.activate.connect(()=>{
			spawn_command_line_async("dbus-send --system --print-reply  --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop");
			});
	menuSystem.append(menuShutdown);

/*    var menuSuspend = new ImageMenuItem.with_label("Suspend");*/
/*    var menuHibernate = new ImageMenuItem.with_label("Hibernate");*/

	var menuQuit = new ImageMenuItem.from_stock(Stock.QUIT, null);
	menuQuit.activate.connect(Gtk.main_quit);
	menuSystem.append(menuQuit);

	menuSystem.show_all();
}

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
			menu.popup (null, null, null, 1, 0);
/*            trayicon.popup_menu();*/
			break;
		case 2:
			Gtk.main_quit();break;
		case 3:
			set_icon_tip(!check_mouse_is_right(),true);
			break;
	}
	return true;
}

public bool volume(Gdk.EventScroll e){
string str="";
int i;

	switch (e.direction){
		case Gdk.ScrollDirection.DOWN:	str="amixer set Master 5%-";break;
		case Gdk.ScrollDirection.UP:	str="amixer set Master 5%+";break;
	}
	try{
	spawn_command_line_sync(str, out stdoutstr);
	} catch (SpawnError e){stderr.printf ("%s\n", e.message);}
	Regex r = /\d*%/; r.match(stdoutstr,0,out info);
	i=int.parse(info.fetch(0));
	if(i<30) str="low";
	else if(i>70) str="high";
	else str="medium";

	vol = new Notification("Volume", "", "audio-volume-"+str);
	vol.set_hint("value",i);
	vol.set_hint_string("synchronous","volume");
	vol.show();
	return true;
}

public static int main (string[] args) {
	Gtk.init(ref args);
	var now = new DateTime.now_local ();
	starttime=now;
	trayicon = new StatusIcon.from_stock(Stock.JUSTIFY_LEFT);
	set_icon_tip(check_mouse_is_right(),false);
	trayicon.button_release_event.connect(mouse);
	trayicon.scroll_event.connect(volume);
	create_menuSystem();
	trayicon.popup_menu.connect((icon, button, event_time)=>{
		menuSystem.popup (null, null, trayicon.position_menu, button, event_time);
		});

/*    trayicon.popup_menu.connect(menuSystem_popup);*/
	trayicon.set_visible(true);
	Notify.init("TrayTool");
	Gtk.main();
	return 0;
}
/*private void menuSystem_popup(uint button, uint time) {*/
/*    menuSystem.popup(null, null, null, button, time);*/
/*}*/


