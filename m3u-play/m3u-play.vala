using Gtk;
// valac --pkg gtk+-3.0 --pkg posix "%f"

int main(string[] args)
{
	Array<string> mname = new Array<string> ();
	Array<string> muri = new Array<string> ();

    Gtk.init (ref args);

    var window = new Gtk.Window ();

    window.title = "M3U Play";
    window.set_position (Gtk.WindowPosition.CENTER);
    window.set_default_size (300, 800);
    window.destroy.connect (Gtk.main_quit);

//----------------------------------------
	var grid = new Gtk.Grid ();
	grid.column_spacing = 5;
	grid.row_spacing = 5;
	grid.margin = 5;	//Gtk.Widget属性

	var list = new Gtk.ListBox();

	var entry = new Gtk.Entry();
	entry.set_icon_from_icon_name(Gtk.EntryIconPosition.PRIMARY, "edit-find");	//system-search 金色放大镜 edit-find 蓝色放大镜
	entry.set_icon_from_icon_name(Gtk.EntryIconPosition.SECONDARY, "edit-clear");
	entry.icon_press.connect((pos,e)=>{
		if(pos == Gtk.EntryIconPosition.SECONDARY){entry.text="";}
		list.invalidate_filter();
	});
	entry.activate.connect(()=>{list.invalidate_filter();});
	entry.set_max_width_chars(40);
	entry.hexpand = true;
	grid.attach(entry, 0, 0, 1, 1);
//-----------------------------------------
	string mn = "x";
	try{
		string tmp;
		string fconf="x.m3u";
		if(FileUtils.test(fconf,FileTest.IS_REGULAR)){
			FileUtils.get_contents(fconf, out tmp);
			string[] line = tmp.split("\n");
			for(int i=0; i<line.length; i++){
				if("#EXTINF" in line[i]){mn = line[i].split(",")[1];}
				if("://" in line[i]){
					mname.append_val(mn);
					muri.append_val(line[i]);
				}
			}
		}
	} catch (GLib.Error e) {error ("%s", e.message);}
//-----------------------------------------
	list.set_filter_func((row)=>{
		if(entry.text in mname.index(row.get_index())){return true;}
		return false;
	});
//-----------------------------------------
	list.row_selected.connect((x, row)=>{
		int i = row.get_index();
		Posix.system("totem \'"+muri.index(i)+"\' &");
	});
//	list.row_selected.connect(play);
//void play (Gtk.ListBox x, Gtk.ListBoxRow? row)
//{
//	int i = row.get_index();
//	Posix.system("totem \'"+muri.index(i)+"\' &");
//}
//-----------------------------------------
	for(int i = 0; i < mname.length ; i++){
		var id = new UriInfo();
		list.insert(id.show(mname.index(i), muri.index(i)),-1);
	}
//-----------------------------------------
	var scroll = new Gtk.ScrolledWindow(null, null);
	scroll.add(list);
	scroll.expand = true;
	grid.attach(scroll, 0, 1, 1, 1);
    window.add(grid);
    window.show_all();
    Gtk.main ();
    return 0;
}
//----------------------------------------------------------
class UriInfo {
	public Gtk.Label show(string name, string uri)
	{
		string protocol = uri[0:4];
		string color = protocol in "https"?"#ce5c00":"#3465a4";
		var lbl = new Gtk.Label("");
//使用pango和变量中文后，文字垂直顶格，Label高度增加，还调整不好。使用常量高度正常。
//		lbl.height_request = 10;	//只能增大有效。
//		lbl.yalign = (float)0.5;	//垂直对齐无效
		lbl.xalign = (float)0;
		lbl.set_markup("<span background=\""+color+"\" foreground=\"#ffffff\"><b> "+protocol+" </b></span>\t<big>"+name+"</big>");
		return lbl;
	}	
}
//----------------------------------------------------------

