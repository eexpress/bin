using Gtk;

string ConfPath;
string IconPath;
KeyFile ConfFile;
string ConfFileName;
StatusIcon AppIcon;
Menu AppMenu;
string appname;

void savecfg(string s){
	var now = new DateTime.now_local ();
	var file = File.new_for_path (ConfFileName);
	file.set_display_name("config-"+now.to_string(),null);
	file = File.new_for_path (ConfFileName);
	{
		var file_stream = file.create (FileCreateFlags.NONE);
		var data_stream = new DataOutputStream (file_stream);
		data_stream.put_string (s);
	} // Streams closed at this point
}

class ShowNote:StatusIcon{
	private StatusIcon sicon;
	private Menu NoteMenu;

	public ShowNote(string icon, string title, string content){
		sicon = new StatusIcon.from_file(IconPath+icon);
		sicon.set_tooltip_text(title+"\n--------\n"+content);
		sicon.button_release_event.connect((e)=>{
			NoteMenu.popup(null, null, sicon.position_menu, e.button, 0);
			return true;
			});
		sicon.set_visible(true);
		create_snote(icon, title, content);
	}

	void create_snote(string icon, string title, string content) {
		NoteMenu = new Menu();
		ImageMenuItem mi;

		mi = new ImageMenuItem.with_label(title);
		mi.set_image(new Gtk.Image.from_file (IconPath+icon));
		NoteMenu.append(mi);
		NoteMenu.append(new SeparatorMenuItem());
		mi = new ImageMenuItem.with_label(content);
		NoteMenu.append(mi);
		NoteMenu.append(new SeparatorMenuItem());

		mi = new ImageMenuItem.from_stock(Stock.EDIT, null);
		mi.activate.connect(()=>{
				sicon.set_visible(false);
				var wnew=new EditNote(icon,title,content);
				wnew.show_all();
				});
		NoteMenu.append(mi);
		mi = new ImageMenuItem.from_stock(Stock.DELETE, null);
		mi.activate.connect(()=>{
				ConfFile.remove_group(title);
				savecfg(ConfFile.to_data(null,null));
				stdout.printf ("记录 %s 被删除。\n",title);
				sicon.set_visible(false);
				});
		NoteMenu.append(mi);
		NoteMenu.show_all();
	}
}

void create_AppMenu() {
	AppMenu = new Menu();
	ImageMenuItem mi;

	mi = new ImageMenuItem.from_stock(Stock.ADD, null);
	mi.activate.connect(()=>{
			var wnew=new EditNote("","","");
			wnew.show_all();
			}
			);
	AppMenu.append(mi);
	AppMenu.append(new SeparatorMenuItem());
	mi = new ImageMenuItem.from_stock(Stock.UNDO, null);
	mi.activate.connect(()=>{
/*            restore last conf file; destroy all ShowNote*/
/*            show_all_from_conf();*/
			});
	AppMenu.append(mi);
	mi = new ImageMenuItem.from_stock(Stock.QUIT, null);
	mi.activate.connect(Gtk.main_quit);
	AppMenu.append(mi);
	AppMenu.show_all();
}

class EditNote : Window {
	private Entry eTitle;
	private TextView eContent;
	private IconView view;
	private TreeIter iter;

	public EditNote(string sicon, string stitle, string scontent){
		string oldgroup=stitle;
		if(oldgroup=="")title="新建笔记";else title="编辑笔记";
		window_position = WindowPosition.CENTER;
		var lTitle=new Label("标题");
		var lContent=new Label("内容");
		var lIcon=new Label("图标");
		eTitle=new Entry(); eTitle.hexpand=true;
		eTitle.placeholder_text="标题不能为空";
		eContent=new TextView(); eContent.hexpand=true;
		eContent.height_request=50;
		eContent.set_wrap_mode(Gtk.WrapMode.WORD);
		if(oldgroup!=""){eTitle.text=stitle; eContent.buffer.text=scontent;}

		var lst=new ListStore(2, typeof(string), typeof (Gdk.Pixbuf));
		lst.clear();
		Gdk.Pixbuf pixbuf;
		string iconname;
		var d = Dir.open(IconPath);
		while ((iconname = d.read_name()) != null) {
			if(!iconname.has_suffix(".png")) continue;
			pixbuf=new Gdk.Pixbuf.from_file(IconPath+iconname);
			lst.append(out iter);
			lst.set(iter,0,iconname,1,pixbuf);
		}
		view=new IconView.with_model(lst);
		view.reorderable=true;

		view.set_selection_mode(Gtk.SelectionMode.SINGLE);
		view.set_pixbuf_column(1);
		var scroll=new ScrolledWindow(null, null);
		scroll.min_content_height=200;
		scroll.min_content_width=300;
		scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
		scroll.add(view);

		var bok=new Button.from_stock(Stock.OK);
		var bcancel=new Button.from_stock(Stock.CANCEL);
		var hbox1 = new Box (Orientation.HORIZONTAL, 5);
		var hbox2 = new Box (Orientation.HORIZONTAL, 5);
		var hbox3 = new Box (Orientation.HORIZONTAL, 5);
		var hbox4 = new Box (Orientation.HORIZONTAL, 5);
		hbox1.add(lTitle); hbox1.add(eTitle);
		hbox2.add(lContent); hbox2.add(eContent);
		lContent.valign=Gtk.Align.START;
		hbox3.add(lIcon); hbox3.add(scroll);
		lIcon.valign=Gtk.Align.START;
		hbox4.add(bok); hbox4.add(bcancel);
		hbox4.halign=Gtk.Align.CENTER;
		hbox4.set_spacing(60);
		var vbox = new Box(Orientation.VERTICAL, 5);
		vbox.border_width=20;
		vbox.add(hbox1); vbox.add(hbox2); vbox.add(hbox3); vbox.add(hbox4);
		add(vbox);
		bcancel.clicked.connect(()=>{this.destroy();});
		bok.clicked.connect(()=>{
				if(eTitle.text==""){
				eTitle.is_focus=true;
				return;
				}
				if(oldgroup!=""){ConfFile.remove_group(oldgroup);}
				Value iname="";
				var s=view.get_selected_items();
				if(s!=null){
				lst.get_iter(out iter,s.data);
				lst.get_value(iter, 0, out iname);
				iconname=(string)iname;
				} else iconname=appname+".png";

				ConfFile.set_string(eTitle.text,"c",eContent.buffer.text);
				ConfFile.set_string(eTitle.text,"i",iconname);
				savecfg(ConfFile.to_data(null,null));
				ShowNote t=new ShowNote(iconname,eTitle.text,eContent.buffer.text);
				t.set_visible(false);
				this.destroy();
				});
		this.show_all();
	}
}

void show_all_from_conf(){
	ConfFile=new KeyFile();
	ConfFile.load_from_file(ConfFileName,KeyFileFlags.NONE);
	foreach (string k in ConfFile.get_groups()){
		string i=ConfFile.get_string(k,"i");
		string t=k;
		string c=ConfFile.get_string(k,"c");
		ShowNote sn = new ShowNote(i,t,c);
		sn.set_visible(false);
	}
}

static int main (string[] args) {
	Gtk.init(ref args);
	appname=GLib.Path.get_basename(args[0]);
	ConfPath=Environment.get_variable("HOME")+"/.config/"+appname+"/";
	ConfFileName=ConfPath+"config";
	stdout.printf ("程序 %s 使用配置文件 %s 。\n",appname,ConfFileName);
	IconPath="/usr/share/traynote/icons/";

	var file = File.new_for_path(ConfFileName);
	if (!file.query_exists()) file.create(FileCreateFlags.NONE);
	else show_all_from_conf();
	create_AppMenu();
	AppIcon = new StatusIcon.from_file(IconPath+appname+".png");
	AppIcon.set_tooltip_text("TrayNote");
	AppIcon.button_release_event.connect((e)=>{
		AppMenu.popup(null, null, AppIcon.position_menu, e.button, 0);
		return true;
		});
	AppIcon.set_visible(true);
	Gtk.main();
	return 0;
}

