using Gtk;
//! valac --pkg gtk+-3.0 --pkg posix "%f"

int main(string[] args) {
	Array<string> mname = new Array<string>();
	Array<string> muri	= new Array<string>();

	Gtk.init(ref args);

	var window = new Gtk.Window();

	window.title = "M3U Play";
	window.set_position(Gtk.WindowPosition.CENTER);
	window.set_default_size(300, 800);
	window.destroy.connect(Gtk.main_quit);

	//----------------------------------------
	var grid			= new Gtk.Grid();
	grid.column_spacing = 5;
	grid.row_spacing	= 5;
	grid.margin			= 5;  // Gtk.Widget属性

	var list = new Gtk.ListBox();

	var sentry = new Gtk.SearchEntry();
	sentry.search_changed.connect(() => { list.invalidate_filter(); });
	sentry.hexpand = true;
		grid.attach(sentry, 0, 0, 1, 1);
		//-----------------------------------------
		string mn = "x";
		try {
			string tmp;
			string fconf = "x.m3u";
			if (FileUtils.test(fconf, FileTest.IS_REGULAR)) {
				FileUtils.get_contents(fconf, out tmp);
				string[] line = tmp.split("\n");
				for (int i = 0; i < line.length; i++) {
					if ("#EXTINF" in line[i]) { mn = line[i].split(",")[1]; }
					if ("://" in line[i]) {
						mname.append_val(mn);
						muri.append_val(line[i]);
					}
				}
			}
		} catch (GLib.Error e) { error("%s", e.message); }
		//-----------------------------------------
		list.set_filter_func((row) => {
			if (sentry.text in mname.index(row.get_index())) { return true; }
			return false;
		});
	//-----------------------------------------
	list.row_selected.connect((x, row) => {
		int i = row.get_index();
		Posix.system("ffplay -x 1200 \'" + muri.index(i) + "\' &");
	});
	//-----------------------------------------
	for (int i = 0; i < mname.length; i++) {
		var id = new UriInfo();
		list.insert(id.show(mname.index(i), muri.index(i)), -1);
	}
	//-----------------------------------------
	var scroll
		= new Gtk.ScrolledWindow(null, null);
		scroll.add(list);
		scroll.expand = true;
		grid.attach(scroll, 0, 1, 1, 1);
		window.add(grid);
		int x; int y; window.get_position(out x, out y); window.move(0, y);
		window.show_all();
		Gtk.main();
		return 0;
}
//----------------------------------------------------------
class UriInfo {
	public Gtk.Label show(string name, string uri) {
		string protocol = uri [0:4];
		string color	= protocol in "https" ? "#ce5c00" : "#3465a4";
		var lbl			= new Gtk.Label("");
		lbl.xalign		= (float)0;
		lbl.set_markup("<span background=\"" + color + "\" foreground=\"#ffffff\"><b> " + protocol + " </b></span>\t<big>" + name.chomp() + "</big>");
		return lbl;
	}
}
//----------------------------------------------------------
