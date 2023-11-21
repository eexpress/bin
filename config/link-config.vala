//~ ⭕ valac --pkg gtk4 --pkg posix link-config.vala
//~ ⭕ ./link-config
//~ 警告：传递‘g_list_foreach’的第 2 个参数时在不兼容的指针类型间转换 [-Wincompatible-pointer-types]

using Gtk;

const string appID = "io.github.eexpress.link.config";
const string appTitle = "Link Config";
string git_ls;
string dir;
//~ --------------------------------------------------------------------
int main(string[] args) {
	var app = new Gtk.Application(appID, ApplicationFlags.DEFAULT_FLAGS);
	try{	// 获取执行文件路径，并切换工作目录。
		dir = Path.get_dirname(FileUtils.read_link("/proc/self/exe"));
		Posix.chdir(dir);
	} catch (Error err) {error ("%s", err.message);}
	app.activate.connect(onAppActivate);
	return app.run(args);
}
//~ --------------------------------------------------------------------
void onAppActivate(GLib.Application self) {	// 为什么这里必须是 GLib 的 Application
	var window = new ApplicationWindow(self as Gtk.Application);
	window.title = appTitle;
	window.set_default_size(400, 420);
	window.resizable = true;
	//~ ---------------------
	var box = new Box(Orientation.VERTICAL, 5);
	box.set_margin_start(10);
//~ 	box.set_margin_top(20);	// 无效？
	var lb = new ListBox();
	var bt0 = new Button.with_label("✖️ 取消备份：删除链接，移动文件到源位置");
	var bt1 = new Button.with_label("➕ 添加备份：移动源文件过来，在源位置建立链接");
	var bt2 = new Button.with_label("♻️ 全部恢复：在源位置强行建立全部链接");
	window.child = box;box.append(lb);
	box.append(bt0); box.append(bt1); box.append(bt2);
	bt0.halign = Align.START;
	bt1.halign = Align.START;
	bt2.halign = Align.START;
//~ 	bt1.clicked.connect (on_open_clicked);
	//~ ---------------------
	try{
		Process.spawn_sync (null,{"git", "ls"},null,SpawnFlags.SEARCH_PATH,null,out git_ls,null,null);
//~ 		print("git ls 的输出\n"+git_ls);
	} catch (Error err) {error ("%s", err.message);}
	//~ ---------------------
	refreshlist(lb);
	window.present ();
	print("==> %s. Version 0.1. Dir is \"%s\".\n", appID, dir);
}
//~ --------------------------------------------------------------------
//~ --------------------------------------------------------------------
//~ --------------------------------------------------------------------
//~ void on_open_clicked () {
//~ 	File ? f = null;
//~ 	var dialog = new Gtk.FileDialog ();
//~ 	dialog.title = _("选择需要收集备份的配置文件");
//~ 	try {
//~ 		f = yield dialog.open(null, null);	// error: yield expression not available outside async method
//~ 		f =  dialog.open(null, null);	// error: invocation of void method not allowed as expression
//~ 	} catch (Error e) {error ("%s", e.message);}
//~ 	if (f != null) {
//~ 		print (f.get_basename () );
//~ 		print (f.get_uri () );
//~ 	}
//~ }
//~ --------------------------------------------------------------------
void refreshlist(ListBox lb){
  	List<string> list = new List<string> ();
	list = listfile();
	list.sort(strcmp);	// strcmp 什么鬼？
	list.foreach ((i) => {		// 警告：不兼容的指针类型间转换
		var prefix = "";
		var lbl = new Label("");
			lbl.xalign = (float)0;	// 左对齐。默认居中？
			prefix += FileUtils.test(i, FileTest.IS_DIR)?"🅳":"🇫";	// 是目录
			prefix += checklink(i) ?"🔗":"💔️";	// 正确的链接
			prefix += git_ls.contains(i) ?"☂️️️":"✖️️️️";	// 是否在 git 仓库

//~ 			lbl.set_markup(fill+"<span background=\""+color[hash.get(flag)]+
//~ 			"\"	foreground=\"#ffffff\"><b> "+flag+" </b></span>  "+name+"");
			lbl.set_markup(prefix+"    "+formatFilename(i, false));
			lb.insert(lbl, -1);
	});
}
//~ --------------------------------------------------------------------
bool checklink(string localfile){	// 带+号的本地文件
//~ 	本地文件转化成源文件
	var r = formatFilename(localfile, false);
	try {
	//~ 	获取源配置文件的绝对路径
		var e = new Regex("^~"); r = e.replace(r, r.length, 0, Environment.get_variable("HOME"));
	//~ 	----------------
		if(FileUtils.test(localfile, FileTest.IS_SYMLINK)) return false;	// 本地文件不能是链接
		if(!FileUtils.test(r, FileTest.IS_SYMLINK)) return false;	//源配置文件必须是链接
		if(FileUtils.read_link(r) != Environment.get_current_dir()+"/"+localfile) return false;	// 源文件链接 == 本地文件
	} catch (Error err) {error ("%s", err.message);}
	return true;
}
//~ --------------------------------------------------------------------
List<string> listfile(){
	List<string> list = new List<string> ();
	try {
		var d  = GLib.Dir.open(dir, 0);
		string ? fn = null;	// 可空字符串
		while ((fn = d.read_name()) != null) {
			if(fn[0] == '+') { list.append (fn); }
		}
	} catch (Error err) {error ("%s", err.message);}
	return list;
}
//~ --------------------------------------------------------------------
string formatFilename(string str, bool change2plus){
//~ 	change2plus 方向，true 为变+号格式，false 为恢复正常路径格式。
	Regex e;
	string r = str;	// 不要直接修改传入参数
	if(change2plus){	// "s|^${HOME}/.|+|; s|/|+|g; s|\ |=|g"
		try{
			e = new Regex("^"+Environment.get_variable("HOME")+"/.");
			r = e.replace(r, r.length, 0, "+");
			e = new Regex("^~/."); r = e.replace(r, r.length, 0, "+");
			e = new Regex("/"); r = e.replace(r, r.length, 0, "+");
			e = new Regex("\\ "); r = e.replace(r, r.length, 0, "=");
		}catch (Error err) {error ("%s", err.message);}
	} else {			// 's|^+|~/.|; s|+|/|g; s|=| |g'
		try{
			e = new Regex("^\\+"); r = e.replace(r, r.length, 0, "~/.");
//~ 			e = new Regex("^\\+"); r = e.replace(r, r.length, 0, Environment.get_variable("HOME")+"/.");
			e = new Regex("\\+"); r = e.replace(r, r.length, 0, "/");
			e = new Regex("="); r = e.replace(r, r.length, 0, " ");
		}catch (Error err) {error ("%s", err.message);}
	}
	return r;
}
