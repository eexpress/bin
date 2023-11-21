//~ ⭕ valac --pkg gtk4 --pkg posix link-config.vala
//~ ⭕ ./link-config
//~ 警告：传递‘g_list_foreach’的第 2 个参数时在不兼容的指针类型间转换 [-Wincompatible-pointer-types]

using Gtk;

const string appID = "io.github.eexpress.link.config";
const string appTitle = "Link Config";
string git_ls;
string dir;
List<string> list;
ListBox listbox;
//~ ApplicationWindow window;
//~ --------------------------------------------------------------------
int main(string[] args) {
	var app = new Gtk.Application(appID, ApplicationFlags.DEFAULT_FLAGS);
	try{	// 获取执行文件路径，并切换工作目录。
		dir = Path.get_dirname(FileUtils.read_link("/proc/self/exe"));
		Posix.chdir(dir);
	} catch (Error e) {error ("%s", e.message);}
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
	listbox = new ListBox();
	var bt0 = new Button.with_label("✖️ 取消备份：删除链接，移动文件到源位置");
	var bt1 = new Button.with_label("➕ 添加备份：移动源文件过来，在源位置建立链接");
	var bt2 = new Button.with_label("♻️ 全部恢复：在源位置强行建立全部链接");
	window.child = box;box.append(listbox);
	box.append(bt0); box.append(bt1); box.append(bt2);
	bt0.halign = Align.START;
	bt1.halign = Align.START;
	bt2.halign = Align.START;
	bt0.clicked.connect (()=>{
		int i = listbox.get_selected_row().get_index();
		unowned List<string> e = list.nth (i);
		rmfile(e.data);
	});
	bt1.clicked.connect (on_open_clicked);
	//~ ---------------------
	git_ls = exec({"git","ls"});
	//~ ---------------------
	refreshListBo();
	window.present ();
	print("==> %s. Version 0.1. Dir is \"%s\".\n", appID, dir);
}
//~ --------------------------------------------------------------------
//~ --------------------------------------------------------------------
//~ --------------------------------------------------------------------
async void on_open_clicked () {
	File ? f = null;
	var dialog = new Gtk.FileDialog ();
	dialog.title = "选择需要收集备份的配置文件";
	try {
		f = yield dialog.open(null, null);
	} catch (Error e) {error ("%s", e.message);}
	if (f == null) return;	// 直接退出异步函数，会Dismissed by user 追踪与中断点陷阱（核心已转储）??
	if(f.query_file_type(FileQueryInfoFlags.NOFOLLOW_SYMLINKS)==FileType.SYMBOLIC_LINK)
	{print("不能备份链接文件。"); return;}
//~ 	string s = f.get_parse_name();
//~ 	if(FileUtils.test(s, FileTest.IS_SYMLINK)) {print("不能备份链接文件。"); return;}
//~ 	if (s.contains(Environment.get_variable("HOME")+"/.")) {
//~ 		print("add: ->"+s+"<-\n");
//~ 		addfile(f);
//~ 	} else print("只能备份家目录下的隐藏目录或文件。");
	addfile(f);
}
//~ --------------------------------------------------------------------
void addfile(File from){	// 从文件选择器传出的绝对文件名句柄
	string src = from.get_parse_name();
	string dst = Environment.get_current_dir()+"/"+formatFilename(src, true);
	print("----\nmv %s %s; ln -sf %s %s\n", src, dst, dst, src);
	File to = File.parse_name(dst);
	try {
		if (from.move(to,FileCopyFlags.NONE, null, null)){
			if(from.make_symbolic_link(dst,null)){	// 注意方向：File是链接，string才是源文件。
				exec({"ls","-l",src});
			}
		};
	} catch (Error e) {error ("%s", e.message);}
	refreshListBo();
}
//~ --------------------------------------------------------------------
void rmfile(string fn){	// 从List列表中传出的短本地文件名
	string src = Environment.get_current_dir()+"/"+fn;
	string dst = formatFilename(fn, false);
	print("----\nrm %s; mv %s %s\n", dst, src, dst);
	File from = File.parse_name(src);
	File to = File.parse_name(dst);
	try {
		if(to.delete()){
			if(from.move(to,FileCopyFlags.NONE, null, null)){
				exec({"ls","-l",dst});
			}
		}
	} catch (Error e) {error ("%s", e.message);}
	refreshListBo();
}
//~ --------------------------------------------------------------------
string exec(string[] str){
	string r;
	try{
		Process.spawn_sync (null,str,null,SpawnFlags.SEARCH_PATH,null,out r,null,null);
		print("外部命令输出\n"+r+"\n");
	} catch (Error e) {error ("%s", e.message);}
	return r;
}
//~ 		try{
//~ 			shellcmd = "bash -c \""+file.get_string(title,"Check").replace("\"","\\\"")+"\"";
//~ 			Process.spawn_command_line_sync (shellcmd,
//~ 			out ls_stdout, out ls_stderr, out ls_status);
//~ 			if(ls_status!=0){ print(ls_stderr); }
//~ 			else{ check = ls_stdout.chomp(); }
//~ 		} catch(Error e){ print ("catch => %s\n", e.message); }
//~ --------------------------------------------------------------------
void refreshListBo(){
//~ 	listbox.remove_all();	// not available in gtk4 4.10.5. Use gtk4 >= 4.12
	listfile();
	list.foreach ((i) => {		// 警告：不兼容的指针类型间转换
		var prefix = "";
		var lbl = new Label("");
			lbl.xalign = (float)0;	// 左对齐。默认居中？
			prefix += checklink(i) ?"🔗":"💔️";	// 正确的链接
			prefix += git_ls.contains(i) ?"☂️️️":"✖️️️️";	// 是否在 git 仓库
//~ 仅仅在显示时，使用~的缩写。
			string s = formatFilename(i, false);
			try {
				Regex ex = new Regex("^"+Environment.get_variable("HOME"));
				s = ex.replace(s, s.length, 0, "~");
			} catch (Error e) {error ("%s", e.message);}
			lbl.set_markup(prefix+"\t"+s+(FileUtils.test(i, FileTest.IS_DIR)?"📂":""));
			listbox.insert(lbl, -1);
	});
}
//~ --------------------------------------------------------------------
bool checklink(string localfile){	// 带+号的本地文件
//~ 	本地文件转化成源文件
	var r = formatFilename(localfile, false);
	try {
		if(!FileUtils.test(r, FileTest.IS_SYMLINK)) return false;	//源配置文件必须是链接
		if(FileUtils.read_link(r) != Environment.get_current_dir()+"/"+localfile) return false;	// 源文件链接 == 本地文件
	} catch (Error e) {error ("%s", e.message);}
	return true;
}
//~ --------------------------------------------------------------------
void listfile(){
//~ 	找出当前目录+号开头的文件，建立列表。
	list = new List<string> ();
	try {
		var d  = GLib.Dir.open(dir, 0);
		string ? fn = null;	// 可空字符串
		while ((fn = d.read_name()) != null) {
			if(fn[0] == '+') { list.append (fn); }
		}
	} catch (Error e) {error ("%s", e.message);}
	list.sort(strcmp);	// strcmp 什么鬼？
}
//~ --------------------------------------------------------------------
string formatFilename(string str, bool change2plus){
//~ 	change2plus 方向，true 为变+号格式，false 为恢复正常路径格式。
	Regex ex;
	string r = str;	// 不要直接修改传入参数
	if(change2plus){	// "s|^${HOME}/.|+|; s|/|+|g; s|\ |=|g"
		try{
			ex = new Regex("^"+Environment.get_variable("HOME")+"/.");
			r = ex.replace(r, r.length, 0, "+");
			ex = new Regex("^~/."); r = ex.replace(r, r.length, 0, "+");
			ex = new Regex("/"); r = ex.replace(r, r.length, 0, "+");
			ex = new Regex("\\ "); r = ex.replace(r, r.length, 0, "=");
		}catch (Error e) {error ("%s", e.message);}
	} else {			// 's|^+|~/.|; s|+|/|g; s|=| |g'
		try{
			ex = new Regex("^\\+"); r = ex.replace(r, r.length, 0, Environment.get_variable("HOME")+"/.");
			ex = new Regex("\\+"); r = ex.replace(r, r.length, 0, "/");
			ex = new Regex("="); r = ex.replace(r, r.length, 0, " ");
		}catch (Error e) {error ("%s", e.message);}
	}
	return r;
}
