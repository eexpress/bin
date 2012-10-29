using Gtk;
using GLib.Process;
using Notify;

StatusIcon trayicon;
Notification msg;
Notification vol;
MatchInfo info;
string stdoutstr;
DateTime starttime;
Menu menuSystem;
bool rightmode;
string svol;
ImageMenuItem menuApp;

void create_menuSystem() {
	menuSystem = new Menu();
	var file = File.new_for_path (GLib.Environment.get_variable("HOME")+"/.config/traytool/app");
	if (file.query_exists ()) {
		try {
		var dis = new DataInputStream(file.read());
		string line;
		while ((line = dis.read_line (null)) != null) {
			if(line=="") continue;
			string cmd =line;
			menuApp = new ImageMenuItem.with_label(cmd);
			menuApp.activate.connect(()=>{
			spawn_command_line_async(cmd);
			});
		menuSystem.append(menuApp);
        }
		}catch (Error e){error("%s", e.message);}
	menuSystem.append(new SeparatorMenuItem());
	}

	var menuShutdown = new ImageMenuItem.with_label("Shut Dwon");
/*    menuShutdown.set_image(new Gtk.Image.from_stock (Stock.STOP, Gtk.IconSize.MENU));*/
	menuShutdown.set_image(new Gtk.Image.from_file ("/usr/share/icons/Humanity/apps/24/system-shutdown.svg"));
	menuShutdown.activate.connect(()=>{
			spawn_command_line_async("dbus-send --system --print-reply  --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop");
			});
	menuSystem.append(menuShutdown);

	var menuSuspend = new ImageMenuItem.with_label("Suspend");
	menuSuspend.set_image(new Gtk.Image.from_file ("/usr/share/icons/Humanity/apps/24/system-suspend.svg"));
	menuSuspend.activate.connect(()=>{
			spawn_command_line_async("dbus-send --system --print-reply --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend");
			});
	menuSystem.append(menuSuspend);

	var menuHibernate = new ImageMenuItem.with_label("Hibernate");
	menuHibernate.set_image(new Gtk.Image.from_file ("/usr/share/icons/Humanity/apps/24/system-suspend-hibernate.svg"));
	menuHibernate.activate.connect(()=>{
			spawn_command_line_async("dbus-send --system --print-reply --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Hibernate");
			});
	menuSystem.append(menuHibernate);

	menuSystem.append(new SeparatorMenuItem());

	var menuAbout = new ImageMenuItem.from_stock(Stock.ABOUT, null);
	menuAbout.activate.connect(()=>{
			var now = new DateTime.now_local ();
			if(now.compare(starttime)==-1) return;
			msg = new Notification("TrayTool introduce 0.5", "鼠标按键说明：\n1：显示说明，30秒内只显示一次\n2：退出\n3：交换左右手鼠标。比如当前鼠标是右手操作，左手握鼠标，食指按下原来的3键，则交换1/3键，切换成左手设置\n4：（滚轮向上）加大音量\n5：（滚轮向下）减小音量\n---------------\n"+now.to_string(), "dialog-information");
			starttime=now.add_seconds(30);
			msg.show();
			});
	menuSystem.append(menuAbout);

	var menuQuit = new ImageMenuItem.from_stock(Stock.QUIT, null);
	menuQuit.activate.connect(Gtk.main_quit);
	menuSystem.append(menuQuit);

	menuSystem.show_all();
}

void check_status(){
	spawn_command_line_sync("xmodmap -pp", out stdoutstr);
	Regex r = /\b1\b\s*\b1\b/; r.match(stdoutstr,0,out info);
	rightmode=info.matches();
	if(rightmode) trayicon.set_from_stock(Stock.JUSTIFY_RIGHT); else trayicon.set_from_stock(Stock.JUSTIFY_LEFT);
	spawn_command_line_sync("amixer get Master", out stdoutstr);
	r = /\d*%/; r.match(stdoutstr,0,out info);
	svol=info.fetch(0);
	trayicon.set_tooltip_text ("音量："+svol+"\n模式："+(rightmode?"右":"左")+"手鼠标");
}

bool mouse(Gdk.EventButton e){
	switch(e.button){
		case 1:
			menuSystem.popup (null, null, trayicon.position_menu, e.button, 0);
			break;
		case 2:
			Gtk.main_quit();break;
		case 3:
			if(rightmode){
				trayicon.set_from_stock(Stock.JUSTIFY_LEFT);
				rightmode=false;
				spawn_command_line_async("xmodmap -e 'pointer = 3 2 1'");
			}else{
				trayicon.set_from_stock(Stock.JUSTIFY_RIGHT);
				rightmode=true;
				spawn_command_line_async("xmodmap -e 'pointer = 1 2 3'");
			}
			trayicon.set_tooltip_text ("音量："+svol+"\n模式："+(rightmode?"右":"左")+"手鼠标");
			break;
	}
	return true;
}

bool volume(Gdk.EventScroll e){
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
	svol=info.fetch(0);
	trayicon.set_tooltip_text ("音量："+svol+"\n模式："+(rightmode?"右":"左")+"手鼠标");
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

static int main (string[] args) {
	Gtk.init(ref args);
	var now = new DateTime.now_local ();
	starttime=now;
	trayicon = new StatusIcon.from_stock(Stock.JUSTIFY_LEFT);
	check_status();
	trayicon.button_release_event.connect(mouse);
	trayicon.scroll_event.connect(volume);
	create_menuSystem();
	trayicon.set_visible(true);
	Notify.init("TrayTool");
	Gtk.main();
	return 0;
}

