using Gtk;

string ConfPath;
KeyFile ConfFile;
string ConfFileName;

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

		var menuDel = new ImageMenuItem.from_stock(Stock.DELETE, null);
		menuDel.activate.connect(()=>{
				ConfFile.remove_group(title);
				savecfg(ConfFile.to_data(null,null));
				stdout.printf ("记录 %s 被删除。\n",title);
				sicon.set_visible(false);
				});
		snote.append(menuDel);
		var menuQuit = new ImageMenuItem.from_stock(Stock.QUIT, null);
		menuQuit.activate.connect(()=>{sicon.set_visible(false);});
		snote.append(menuQuit);

		snote.show_all();
	}
}


static int main (string[] args) {
	Gtk.init(ref args);
/*    if(args.length!=4) return 1;*/
	ConfPath=Environment.get_variable("HOME")+"/.config/traynote/";
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
		sn[cnt] = new ShowNote(i,t,c); sn[cnt].set_visible(false);
		cnt++;
	}
	Gtk.main();
	return 0;
}

