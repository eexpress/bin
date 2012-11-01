using Gtk;

string ConfPath;
KeyFile ConfFile;
string ConfFileName;
StatusIcon AppIcon;
Menu AppMenu;
ImageMenuItem AppMenuItem;

void savecfg(string s){
	var now = new DateTime.now_local ();
/*    stdout.printf ("时间 %s 。\n",now.to_string());*/

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
	private Menu snote;
	private ImageMenuItem menuApp;

	public ShowNote(string icon, string title, string content){
		sicon = new StatusIcon.from_file(ConfPath+icon+".png");
		sicon.set_tooltip_text(title+"\n--------\n"+content);
		sicon.button_release_event.connect((e)=>{
			snote.popup(null, null, sicon.position_menu, e.button, 0);
			return true;
			});
		sicon.set_visible(true);
		create_snote(icon, title, content);
	}

	void create_snote(string icon, string title, string content) {
		snote = new Menu();

		menuApp = new ImageMenuItem.with_label(title);
		menuApp.set_image(new Gtk.Image.from_file (ConfPath+icon+".png"));
		snote.append(menuApp);
		snote.append(new SeparatorMenuItem());
		menuApp = new ImageMenuItem.with_label(content);
		snote.append(menuApp);
		snote.append(new SeparatorMenuItem());

		var menuEdit = new ImageMenuItem.from_stock(Stock.EDIT, null);
		snote.append(menuEdit);
		var menuDel = new ImageMenuItem.from_stock(Stock.DELETE, null);
		menuDel.activate.connect(()=>{
				ConfFile.remove_group(title);
				savecfg(ConfFile.to_data(null,null));
				stdout.printf ("记录 %s 被删除。\n",title);
				sicon.set_visible(false);
				});
		snote.append(menuDel);
		snote.show_all();
	}
}

void create_AppMenu() {
	AppMenu = new Menu();

	AppMenuItem = new ImageMenuItem.from_stock(Stock.ADD, null);
	AppMenuItem.activate.connect(()=>{
			var waddnote=new EditNote("here","","");
			waddnote.show_all();
			}
			);
	AppMenu.append(AppMenuItem);
	AppMenu.append(new SeparatorMenuItem());
	AppMenuItem = new ImageMenuItem.from_stock(Stock.UNDO, null);
	AppMenu.append(AppMenuItem);
	AppMenuItem = new ImageMenuItem.from_stock(Stock.QUIT, null);
	AppMenu.append(AppMenuItem);
	AppMenu.show_all();
}

class EditNote : Window {
	private Entry eTitle;
	private TextView eContent;
	private IconView iIcon;

	public EditNote(string sicon, string stitle, string scontent){
		title="编辑";
		window_position = WindowPosition.CENTER;
		set_default_size (300, 300);
		var lTitle=new Label("标题");
		var lContent=new Label("内容");
		var lIcon=new Label("图标");
		eTitle=new Entry(); eTitle.hexpand=true;
		eContent=new TextView(); eContent.hexpand=true;
		eContent.height_request=50;

		var lst=new ListStore(4, typeof(string), typeof(string),typeof (Gdk.Pixbuf),typeof(bool));
/*        var lst=new ListStore(3, typeof(string), typeof(Image),typeof (bool));*/
		lst.clear();
		string filename="market.png";
		TreeIter iter;
		Gdk.Pixbuf img;
		img=new Gdk.Pixbuf.from_file("/home/eexp/.config/traynote/market.png");
/*        img=new Gdk.Pixbuf.from_file(ConfPath+filename);*/
		lst.append(out iter);
		lst.set(iter,0,ConfPath+filename,1,filename,2,img,3,true);
/*        lst.set(iter,0,ConfPath+filename,1,filename,2,img,3,true);*/
		iIcon=new IconView.with_model(lst);
		iIcon.set_selection_mode(Gtk.SelectionMode.SINGLE);
		iIcon.set_text_column(0);
		iIcon.set_pixbuf_column(1);
		iIcon.selection_changed.connect(()=>{
				});


		var bok=new Button.from_stock(Stock.OK);
		var bcancel=new Button.from_stock(Stock.CANCEL);
		var hbox1 = new Box (Orientation.HORIZONTAL, 5);
		var hbox2 = new Box (Orientation.HORIZONTAL, 5);
		var hbox3 = new Box (Orientation.HORIZONTAL, 5);
		var hbox4 = new Box (Orientation.HORIZONTAL, 5);
		hbox1.add(lTitle); hbox1.add(eTitle);
		hbox2.add(lContent); hbox2.add(eContent);
		lContent.valign=Gtk.Align.START;
		hbox3.add(lIcon); hbox3.add(iIcon);
		hbox4.add(bok); hbox4.add(bcancel);
		hbox4.halign=Gtk.Align.CENTER;
		hbox4.set_spacing(40);
		var vbox = new Box(Orientation.VERTICAL, 15);
		vbox.border_width=20;
		vbox.add(hbox1); vbox.add(hbox2); vbox.add(hbox3); vbox.add(hbox4);
		add(vbox);
/*        eTitle.text=stitle; eContent.insert_at_cursor(scontent);*/
		this.show_all();
	}
}

static int main (string[] args) {
	Gtk.init(ref args);
/*    if(args.length!=4) return 1;*/
	ConfPath=Environment.get_variable("HOME")+"/.config/"+args[0]+"/";
	ConfFileName=ConfPath+"config";
	ConfFile=new KeyFile();

	ShowNote sn[10];
	int cnt=0;
	ConfFile.load_from_file(ConfFileName,KeyFileFlags.NONE);
	foreach (string k in ConfFile.get_groups()){
		string i=ConfFile.get_string(k,"i");
		string t=k;
		string c=ConfFile.get_string(k,"c");
/*        stdout.printf("%s\t%s\t%s\n",i,t,c);*/
		sn[cnt] = new ShowNote(i,t,c);
		sn[cnt].set_visible(false);
		cnt++;
	}
	create_AppMenu();
	AppIcon = new StatusIcon.from_file(ConfPath+args[0]+".png");
	AppIcon.set_tooltip_text("TrayNote");
	AppIcon.button_release_event.connect((e)=>{
		AppMenu.popup(null, null, AppIcon.position_menu, e.button, 0);
		return true;
		});
	AppIcon.set_visible(true);
	Gtk.main();
	return 0;
}

