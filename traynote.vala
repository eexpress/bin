using Gtk;

string configpath;

class ShowNote:StatusIcon{
	private StatusIcon sicon;
	private Menu snote;
	private ImageMenuItem menuApp;

	public ShowNote(string icon, string title, string content){
		sicon = new StatusIcon.from_file(configpath+icon+".png");
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
		menuApp.set_image(new Gtk.Image.from_file (configpath+icon+".png"));
		snote.append(menuApp);
		snote.append(new SeparatorMenuItem());
		menuApp = new ImageMenuItem.with_label(content);
		snote.append(menuApp);
		snote.append(new SeparatorMenuItem());

		var menuDel = new ImageMenuItem.from_stock(Stock.DELETE, null);
		menuDel.activate.connect(()=>{
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
	configpath=Environment.get_variable("HOME")+"/.config/traynote/";

	KeyFile file=new KeyFile();
	ShowNote sn[10];
	int cnt=0;
	file.load_from_file(configpath+"config",KeyFileFlags.NONE);
	foreach (string k in file.get_groups()){
		string i=file.get_string(k,"i");
		string t=k;
		string c=file.get_string(k,"c");
		stdout.printf("%s\t%s\t%s\n",i,t,c);
		sn[cnt] = new ShowNote(i,t,c); sn[cnt].set_visible(false);
		cnt++;
	}
	Gtk.main();
	return 0;
}

