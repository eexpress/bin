
using Gtk;
using WebKit;		// ⭕ pi webkit2gtk3-devel

// valac --pkg webkit2gtk-4.0 --pkg gtk+-3.0 "%f"

// VBox 等各种 Box，都快死了。全部转移到 Grid 控件。

public WebKit.WebView web;

int main(string[] args)
{
    Gtk.init (ref args);

    var window = new Gtk.Window ();

    window.title = "Find Book";
    window.set_position (Gtk.WindowPosition.CENTER);
    window.set_default_size (650, 650);
    window.destroy.connect (Gtk.main_quit);

//----------------------------------------
	var grid = new Gtk.Grid ();
	grid.column_spacing = 10;
	grid.row_spacing = 10;
	grid.margin = 15;	//Gtk.Widget属性

	var label = new Gtk.Label("输入要搜索的书名");
	//label.set_markup("<small></small>");
	grid.attach(label, 0, 0, 1, 1);

	var entry = new Gtk.Entry();
	entry.set_max_width_chars(40);
	entry.hexpand = true;
	grid.attach(entry, 1, 0, 1, 1);

//	var button = new Gtk.Button.from_icon_name("system-search");
	var button = new Gtk.Button.from_icon_name("edit-find");
	grid.attach(button, 2, 0, 1, 1);

	var list = new Gtk.ListBox();
	var id0 = new InfoDownload();
	var id1 = new InfoDownload();
	var id2 = new InfoDownload();
	var id3 = new InfoDownload();
	list.insert(id0.show("1.jpg","凡·高密码","凡·高的举世名画《向日葵》里埋藏着怎样的秘密？"),-1);
	list.insert(id1.show("3.jpg","大唐悬疑录4·大明宫密码","易学奇书《推背图》，相传为唐代数学家李淳风与天文学家袁天罡所著，融易学、天文、诗词、谜语、图画为一体，仅六十则谶言便算尽天下大势。然自成书起，便版本各异，真假难辨，让大明宫充满腥风血雨？"),-1);
	list.insert(id2.show("2.jpg","死亡密码","刑侦总队密码组是顶刑侦总队\n密码组是顶级情报人刑侦总队级情报人员的培训、任命和派遣机构"),-1);
	list.insert(id3.show("sample.png","山海经密码","本书为网络版本，原名《桐宫之囚》。这是一个历史记载的真实故事构"),-1);

	grid.attach(list, 0, 1, 3, 1);

//-----------------------------------------
	web = new WebKit.WebView();
	web.load_uri("http://www.kusuu.net/");
	web.load_changed.connect(printHTML);
//-----------------------------------------
    window.add(grid);
    window.show_all();
    Gtk.main ();
    return 0;
}

//----------------------------------------------------------
void printHTML(LoadEvent load_event)
{
	if(load_event == FINISHED){
		stderr.printf(web.get_title());
	}
}
//----------------------------------------------------------
class InfoDownload {
	Gtk.ProgressBar pbar;
	Gtk.Button butt;
	string url;
//-----------------------------------------
	public Gtk.Grid show(string imagefile, string bookname, string bookinfo)
	{
		url = bookinfo;
		var g = new Gtk.Grid ();
		var img = new Gtk.Image.from_file(imagefile);
		img.set_size_request(128, 128);		//最小宽度 128
		var name = new Gtk.Label(bookname);
		name.halign = START;
		var info = new Gtk.TextView();
		info.buffer.text = bookinfo;
		info.expand = true;
		info.wrap_mode = CHAR;	//自动折行
		pbar = new Gtk.ProgressBar();
		pbar.expand = true;
		butt = new Gtk.Button.from_icon_name("emblem-downloads");
		butt.clicked.connect(download);

		g.margin = 10;	//Gtk.Widget属性
		g.column_spacing = 15;
		g.row_spacing = 15;
		g.attach(img,  0, 0, 1, 3);
		g.attach(name, 1, 0, 2, 1);
		g.attach(info, 1, 1, 2, 1);
		g.attach(pbar, 1, 2, 1, 1);
		g.attach(butt, 2, 2, 1, 1);

		return g;
	}	
//-----------------------------------------
	void download()
	{
		stderr.printf(url);
		pbar.fraction = 0.8;
	}
//-----------------------------------------
}
//----------------------------------------------------------

