//~ ⭕ valac --pkg gtk4 link-config.vala 
//~ ⭕ ./link-config 

using Gtk;
//~ using Cairo;
//~ using Rsvg;

const string appID = "io.github.eexpress.link.config";
const string appTitle = "Link Config";
//~ static int count = 0;
//~ static int x = 10;
Gtk.ApplicationWindow window;
//~ Resource res;

int main(string[] args) {
	var app = new Gtk.Application(appID, ApplicationFlags.DEFAULT_FLAGS);
	app.activate.connect(onAppActivate);
	return app.run(args);
}

void onAppActivate(GLib.Application self) {
//~   Resource res = null;res.load("./res.gresource");
//~   if (res.load("res.gresource")) {
//~ 	  resources_register(res);
//~ 	} else {
//~ 		print("no gresource.\n");
//~ 	}
//~   var file = File.new_for_uri("resource:///img/r1.svg");
//~ var path=GLib.Environment.get_current_dir();
//~ print("当前目录："+path+"\n");
//~   var file = File.new_for_path(path+"/img/r1.svg");
//~   if(file.query_exists()){
//~ 	  print ("resouce exist.\n");
//~   }else{ print("resouce no found.\n");}

  window = new Gtk.ApplicationWindow(self as Gtk.Application);
//~   var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 10);
//~   var label = new Gtk.Label("Click the button");
//~   var button = new Gtk.Button.with_label("🤔");

//~   window.child = box;
  window.title = appTitle;
  window.set_default_size(400, 400);
  window.resizable = true;
//~   window.move(10,10); 	//	not exist
//~   window.decorated = false;
//~   window.set_keep_above (true); 	//	not exist
//~   window.app_paintable = true;	//	not exist

//~   box.halign = Gtk.Align.CENTER; box.valign = Gtk.Align.CENTER;
//~   box.append(label); box.append(button);

//~   button.halign = Gtk.Align.CENTER; button.valign = Gtk.Align.CENTER;
//~   button.clicked.connect(onButtonClicked);
  window.present ();
  print("==> %s / Version 0.1\n", appTitle);
 
  string r = formatFilename("~/.config/neo vim/init.rc", true);
	print("========----->"+r+"\n");
  r = formatFilename("/home/eexpss/.config/neo vim/init.rc", true);
	print("========----->"+r+"\n");
  r = formatFilename("+config+neo=vim+init.rc", false);
	print("========----->"+r+"\n");
}

//~ void onButtonClicked(Gtk.Button self) {
//~   print("You clicked %d times!\n", ++count);
//~   x+=10;
//~   window.move(x,10);	// not exist
//~ }

string formatFilename(string str, bool change2plus){
//~ 	change2plus 方向，true 为变+号格式，false 为恢复正常路径格式。
	Regex e;
	string r = str;	// 不要直接修改传入参数
	if(change2plus){	// "s|${HOME}/.|+|; s|/|+|g; s|\ |=|g"
		try{
			e = new Regex("^"+Environment.get_variable("HOME")+"/.");
			r = e.replace(r, r.length, 0, "+");
			e = new Regex("^~/."); r = e.replace(r, r.length, 0, "+");
			e = new Regex("/"); r = e.replace(r, r.length, 0, "+");
			e = new Regex("\\ "); r = e.replace(r, r.length, 0, "=");
		}catch (GLib.Error err) {error ("%s", err.message);}
	} else {			// 's|+|/|g; s|=|\\\\ |g; s|^/|~/.|'
		try{
			e = new Regex("^\\+"); r = e.replace(r, r.length, 0, "~/.");
			e = new Regex("\\+"); r = e.replace(r, r.length, 0, "/");
			e = new Regex("="); r = e.replace(r, r.length, 0, " ");
		}catch (GLib.Error err) {error ("%s", err.message);}
	}
	return r;
}
