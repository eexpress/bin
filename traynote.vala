using Gtk;

string configpath;

class ShowNote:StatusIcon{
	private StatusIcon sicon;
	private Menu snote;
	private ImageMenuItem menuApp;

	public ShowNote(string icon, string title, string content){
		sicon = new StatusIcon.from_file(configpath+icon+".png");
		sicon.set_tooltip_text(title);
		sicon.button_release_event.connect((e)=>{
			snote.popup(null, null, sicon.position_menu, e.button, 0);
			return true;
			});
/*        sicon.popup_menu.connect((button,time)=>{*/
/*            snote.popup(null, null, null, button, time);*/
/*            });*/
/*        sicon.set_visible(true);*/
		create_snote(icon, title, content);
	}

	void create_snote(string icon, string title, string content) {
		snote = new Menu();

		menuApp = new ImageMenuItem.with_label(title);
		menuApp.set_image(new Gtk.Image.from_file (configpath+icon+".png"));
		snote.append(menuApp);
		snote.append(new SeparatorMenuItem());
	/*    string[] s=content.split("\\n",10);*/
	/*    foreach(string x in s){*/
	/*        menuApp = new ImageMenuItem.with_label(x);*/
	/*        snote.append(menuApp);*/
	/*    }*/
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
	configpath=GLib.Environment.get_variable("HOME")+"/.config/traynote/";

	var sn1 = new ShowNote("market","购买","tt");
	var sn2 = new ShowNote("web-browser","xx","tt");
	sn1.set_visible(false);
	sn2.set_visible(false);
	Gtk.main();
	return 0;
}

