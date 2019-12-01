//devhelp里面的 Namespace 使用 using; Package 使用 --pkg。
//! valac --pkg gtk+-3.0  --pkg posix "%f"
// valac --pkg webkit2gtk-4.0 --pkg libedataserver-1.2 --pkg gtk+-3.0 "%f"
using Gtk;

int main(string[] args)
{
	string v2raycmd = "/home/eexpss/bin/app/v2ray-linux-64/v2ray";
	string dir = GLib.Environment.get_home_dir()+"/bin/config/proxy.config";
	string suffix = ".json";

	Array<string> lbstr = new Array<string> ();

    Gtk.init (ref args);

    var window = new Gtk.Window ();

    window.title = "系统代理";
    window.set_position (Gtk.WindowPosition.CENTER);
    window.set_default_size (500, 500);
    window.destroy.connect (Gtk.main_quit);

	var grid = new Gtk.Grid ();
	grid.column_spacing = 5;
	grid.row_spacing = 5;
	grid.margin = 5;
//----------------------------------------
//Gtk.SearchBar
	var list = new Gtk.ListBox();

	var entry = new Gtk.SearchEntry();
//	entry.set_icon_from_icon_name(Gtk.EntryIconPosition.PRIMARY, "edit-find");	//system-search 金色放大镜 edit-find 蓝色放大镜
//	entry.set_icon_from_icon_name(Gtk.EntryIconPosition.SECONDARY, "edit-clear");
//	entry.icon_press.connect((pos,e)=>{
//		if(pos == Gtk.EntryIconPosition.SECONDARY){entry.text="";}
//		list.invalidate_filter();
//	});
//	entry.activate.connect(()=>{list.invalidate_filter();});
	entry.search_changed.connect(()=>{list.invalidate_filter();});
//	entry.set_max_width_chars(40);
	entry.hexpand = true;
	grid.attach(entry, 0, 0, 3, 1);
//-----------------------------------------
	var info = new Info();
	
	string? f = null;
	string tmp;
	string protocol;
	try{
		var d = Dir.open(dir,0);
		while((f=d.read_name ())!=null){
			if(f.has_suffix(suffix)){
				FileUtils.get_contents(dir+"/"+f, out tmp);
				protocol = "shadowsocks" in tmp? "shadowsocks":"vmess";
				list.insert(info.show(f, protocol), -1);
				lbstr.append_val(protocol+", "+f);
//				如何在进程中查找已经启动的json，并给它上色成使用中的状态。
			}
		}
	} catch (GLib.Error e) {error ("%s", e.message);}
//-----------------------------------------
	list.set_filter_func((row)=>{
		if(entry.text in lbstr.index(row.get_index())){return true;}
		return false;
	});
//-----------------------------------------
	list.row_selected.connect((x, row)=>{
//		int i = row.get_index();
		string conf = lbstr.index(row.get_index()).split(", ")[1];
//		print("select: %d\tconf:\t%s\n",i,conf);
		Posix.system("sudo pkill  -9 -x v2ray; sudo "+v2raycmd+" -config \""+dir+"/"+conf+"\" &");
	});
//-----------------------------------------
	var scroll = new Gtk.ScrolledWindow(null, null);
	scroll.add(list);
	scroll.expand = true;
	grid.attach(scroll, 0, 1, 3, 1);
//-----------------------------------------
	grid.attach(new Separator(HORIZONTAL), 0, 2, 3, 1);
	grid.attach(new Label("系统代理模式"), 0, 3, 1, 1);
	grid.attach(new Separator(HORIZONTAL), 0, 4, 3, 1);
	var rb1 = new Gtk.RadioButton.with_label(null, "禁用");
	var rb2 = new Gtk.RadioButton.with_label_from_widget(rb1, "手动，全局");
	var rb3 = new Gtk.RadioButton.with_label_from_widget(rb1, "自动，PAC");
	grid.attach(rb1, 0, 5, 1, 1);
	grid.attach(rb2, 1, 5, 1, 1);
	grid.attach(rb3, 2, 5, 1, 1);
	var ss = new GLib.Settings ("org.gnome.system.proxy");
	string sm = ss.get_string ("mode");
	switch (sm){
		case "none":
			rb1.set_active(true);
			break;
		case "manual":
			rb2.set_active(true);
			break;
		case "auto":
			rb3.set_active(true);
			break;
	}
//	print("mode: %s\n",sm);
	rb1.clicked.connect(()=>{ss.set_string("mode", "none");});
	rb2.clicked.connect(()=>{ss.set_string("mode", "manual");});
	rb3.clicked.connect(()=>{ss.set_string("mode", "auto");});
//-----------------------------------------
    window.add(grid);
    window.show_all();
    Gtk.main ();
    return 0;
}

//----------------------------------------------------------
class Info {
	public Gtk.Label show(string fname, string protocol)
	{
		string color;
		string fill;
		if(protocol == "shadowsocks"){
			color = "#ce5c00";
			fill = "";
		}else{
			color = "#3465a4";
			fill = "      ";
		}
		var lbl = new Gtk.Label("");
		lbl.xalign = (float)0;
		lbl.set_markup(" "+fill+"<span background=\""+color+"\" foreground=\"#ffffff\"><b> "+protocol+" </b></span>\t<big>"+fname+"</big>");
		return lbl;
	}	
}
//----------------------------------------------------------

