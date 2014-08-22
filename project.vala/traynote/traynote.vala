using Gtk;

const string GETTEXT_PACKAGE = "traynote";
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
	try{
	file.set_display_name("config-"+now.to_string(),null);
	file = File.new_for_path (ConfFileName);
	{
		var file_stream = file.create (FileCreateFlags.NONE);
		var data_stream = new DataOutputStream (file_stream);
		data_stream.put_string (s);
	} // Streams closed at this point
	} catch (Error e){stderr.printf ("%s\n", e.message);}
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
			try{
				ConfFile.remove_group(title);
			} catch (Error e){stderr.printf ("%s\n", e.message);}
				savecfg(ConfFile.to_data(null,null));
				stdout.printf (_("record %s deleted.\n"),title);
/*                stdout.printf (_("记录 %s 被删除。\n"),title);*/
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

	public EditNote(string orgicon, string orgtitle, string orgcontent){
		string oldgroup=orgtitle;
		if(oldgroup=="")title=_("New Note");else title=_("Edit Note");
/*        if(oldgroup=="")title=_("新建笔记");else title=_("编辑笔记");*/
		window_position = WindowPosition.CENTER;
		var lTitle=new Label(_("Title  "));
		var lContent=new Label(_("Cotent  "));
		var lIcon=new Label(_("Icon  "));
/*        var lTitle=new Label(_("标题  "));*/
/*        var lContent=new Label(_("内容  "));*/
/*        var lIcon=new Label(_("图标  "));*/
		eTitle=new Entry(); eTitle.hexpand=true;
		eTitle.placeholder_text=_("Title can not be blank");
/*        eTitle.placeholder_text=_("标题不能为空");*/
		eContent=new TextView(); eContent.hexpand=true;
		eContent.height_request=50;
		eContent.set_wrap_mode(Gtk.WrapMode.WORD);
		if(oldgroup!=""){eTitle.text=orgtitle; eContent.buffer.text=orgcontent;}

		var lst=new ListStore(2, typeof(string), typeof (Gdk.Pixbuf));
		lst.clear();
		Gdk.Pixbuf pixbuf;
		string iconname="";
		Dir d;
	try{
		d = Dir.open(IconPath);
		while ((iconname = d.read_name()) != null) {
			if(!iconname.has_suffix(".png")) continue;
			pixbuf=new Gdk.Pixbuf.from_file(IconPath+iconname);
			lst.append(out iter);
			lst.set(iter,0,iconname,1,pixbuf);
		}
	} catch (Error e){stderr.printf ("%s\n", e.message);}
		view=new IconView.with_model(lst);
		view.reorderable=true;

		view.set_selection_mode(Gtk.SelectionMode.SINGLE);
		view.set_pixbuf_column(1);
		var scroll=new ScrolledWindow(null, null);
		scroll.hexpand=true;
		scroll.vexpand=true;
		scroll.min_content_height=300;
		scroll.min_content_width=400;
		scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
		scroll.add(view);
		this.check_resize.connect(()=>{
				view.set_columns(0);
				view.set_columns(-1);
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
		hbox3.add(lIcon); hbox3.add(scroll);
		lIcon.valign=Gtk.Align.START;
		hbox4.add(bok); hbox4.add(bcancel);
		hbox4.halign=Gtk.Align.CENTER;
		hbox4.set_spacing(60);
		var vbox = new Box(Orientation.VERTICAL, 5);
		vbox.border_width=20;
		vbox.add(hbox1); vbox.add(hbox2); vbox.add(hbox3); vbox.add(hbox4);
		add(vbox);
		bcancel.clicked.connect(()=>{
				ShowNote t=new ShowNote(orgicon,orgtitle,orgcontent);
				t.set_visible(false);
				this.destroy();});
		bok.clicked.connect(()=>{
				if(eTitle.text==""){
				eTitle.is_focus=true;
				return;
				}
			try{
				if(oldgroup!=""){ConfFile.remove_group(oldgroup);}
			} catch (Error e){stderr.printf ("%s\n", e.message);}
				Value iname="";
				var s=view.get_selected_items();
				if(s!=null){
				lst.get_iter(out iter,s.data);
				lst.get_value(iter, 0, out iname);
				iconname=(string)iname;
				} else {
					if(oldgroup!="")iconname=orgicon;
					else iconname=appname+".png";
				}

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
	try{
		ConfFile.load_from_file(ConfFileName,KeyFileFlags.NONE);
	} catch (Error e){stderr.printf ("%s\n", e.message);}
	foreach (string k in ConfFile.get_groups()){
		string i="";
		string t="";
		string c="";
		try{
			i=ConfFile.get_string(k,"i");
			t=k;
			c=ConfFile.get_string(k,"c");
		} catch (Error e){stderr.printf ("%s\n", e.message);}
		if(i=="")i=appname+".png";
		ShowNote sn = new ShowNote(i,t,c);
		sn.set_visible(false);
	}
}

static int main (string[] args) {
	Gtk.init(ref args);
/*    Intl.setlocale(LocaleCategory.MESSAGES, "LC_ALL");*/
	Intl.setlocale(LocaleCategory.ALL, "");
/*    Intl.setlocale(LocaleCategory.ALL, "zh_CN.UTF-8");*/
/*    Intl.setlocale(LocaleCategory.MESSAGES, "");*/
	Intl.textdomain(GETTEXT_PACKAGE);
/*    只受 LANGUAGE 影响*/
/*● valac -X -DGETTEXT_PACKAGE="traynote" traynote.vala */
/*● xgettext -o traynote.po -L C# -k_ --from-code=utf-8 traynote.vala */
/*● v traynote.po*/
/*● msgfmt -o traynote.mo traynote.po */

/*    Intl.textdomain(GETTEXT_PACKAGE);*/
/*    Intl.bind_textdomain_codeset(GETTEXT_PACKAGE, "UTF-8");*/
/*    Intl.bindtextdomain(GETTEXT_PACKAGE, "/usr/share/locale");*/

/*    string info;*/
/*    info=Environment.get_variable("HOME")+"\nLANGUAGE:"+Environment.get_variable("LANGUAGE")+"\nLANG:"+Environment.get_variable("LANG")+"\nLC_ALL:"+Environment.get_variable("LC_ALL");*/

/*    Gtk.MessageDialog msg = new Gtk.MessageDialog (null, Gtk.DialogFlags.MODAL, Gtk.MessageType.WARNING, Gtk.ButtonsType.OK_CANCEL, "%s", info);*/
/*    msg.run();*/
/*    stdout.printf ("env: %s\n",info);*/

	appname=GLib.Path.get_basename(args[0]);
	ConfPath=Environment.get_variable("HOME")+"/.config/"+appname+"/";
	ConfFileName=ConfPath+"config";
	stdout.printf (_("Program %s use this config %s.\n"),appname,ConfFileName);
/*    stdout.printf (_("程序 %s 使用配置文件 %s 。\n"),appname,ConfFileName);*/
	IconPath="/usr/share/traynote/icons/";

	var file = File.new_for_path(ConfFileName);
	if (!file.query_exists()){
		try{
			DirUtils.create_with_parents(ConfPath, 0755);
			file.create(FileCreateFlags.NONE);
		} catch (Error e){stderr.printf ("%s\n", e.message);}
	}
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

