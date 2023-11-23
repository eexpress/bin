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
Label msg;
string homedir;
//~ ApplicationWindow window;
//~ --------------------------------------------------------------------
int main(string[] args) {
	var app = new Gtk.Application(appID, ApplicationFlags.DEFAULT_FLAGS);
	homedir = Environment.get_variable("HOME");
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
//~ =======
	listbox = new ListBox();
	var str_drop_target = new DropTarget(GLib.Type.STRING, Gdk.DragAction.COPY);
	listbox.add_controller(str_drop_target);
	str_drop_target.drop.connect((self, value, x, y) => {	// value.type_name()
		string s = value.get_string();
		if(checkfile(s)) {File f = File.parse_name(s); addfile(f);}
		return true;
	  });
//~ --------
	var bt0 = new Button.with_label("✖️ 取消备份：删除链接，移动文件到源位置");
	var bt1 = new Button.with_label("➕ 添加备份：移动源文件过来，在源位置建立链接");
	var bt2 = new Button.with_label("♻️ 全部恢复：在源位置强行建立全部链接");
	window.child = box;box.append(listbox);
	box.append(bt0); box.append(bt1); box.append(bt2);
	bt0.halign = Align.START;
	bt1.halign = Align.START;
	bt2.halign = Align.START;
	bt0.clicked.connect (()=>{
//~ 		listbox_remove_all(box);
//~ 		return;
		unowned ListBoxRow? row = listbox.get_selected_row();
		if(row == null) return;
		unowned List<string> lst = list.nth (row.get_index());
		if (rmfile(lst.data)){	// 正确删除备份
			listbox.remove(row);
			list.remove_link (lst);
//~ 			list.foreach ((i) => { print(i+"\n");});
		};
	});
	bt1.clicked.connect (on_add_clicked);
	//~ ---------------------
	git_ls = ex("git ls");
	//~ ---------------------
	refreshListBox();
	msg = new Label("XXX"); msg.halign = Align.START; box.append(msg);
	window.present ();
	string s = dir.replace(homedir,"~");
	s = "<b>%s</b>. Ver 0.1. <i>\"%s\"</i>\n".printf(appID, s);
	msg.set_markup(s);
}
//~ --------------------------------------------------------------------
void listbox_remove_all(ListBox box){
//~ 		box.selection_mode=SelectionMode.MULTIPLE;
//~     int count = 0;
//~ 		box.select_all();
//~ 		box.selected_foreach((box,row)=>{count++;});
//~ 		box.selected_foreach((box,row)=>{box.remove(row);});	//crash
//~ 		box.selected_foreach((box,row)=>{print("%d\n",row.get_index());});
//~ 		print("box len: %d", count);
//~ 		for (i = count; i > 0; i--){
//~ 				box.remove(box.get_row_at_index(i));
//~ 		}
//~ 		box.selection_mode=SelectionMode.SINGLE;
//~ ---------------------
//~ 		for(var w in box){box.remove(widget);}
//~ 		box.@foreach((widget)=>{box.remove(widget);});
//~ 		return;
//~
//~         listbox.@foreach (() => {
//~             count++;
//~         });
}
//~ --------------------------------------------------------------------
//~ --------------------------------------------------------------------
async void on_add_clicked () {
	File ? f = null;
	var dialog = new Gtk.FileDialog ();	// 需要能选择目录和显示隐藏文件 ！！！！！
	dialog.title = "选择需要收集备份的配置文件";
	try {
		f = yield dialog.open(null, null);
	} catch (Error e) {error ("%s", e.message);}
	if (f == null) return;	// 直接退出异步函数，会Dismissed by user 追踪与中断点陷阱（核心已转储）??

	if(checkfile(f.get_parse_name())) addfile(f);
}
//~ --------------------------------------------------------------------
bool checkfile(string fn){
	if(!FileUtils.test(fn, FileTest.EXISTS)){msg.set_markup("⚠️ 文件不存在。"); return false;}
	if(FileUtils.test(fn, FileTest.IS_SYMLINK)){msg.set_markup("⚠️ 不能备份链接文件。"); return false;}
	if (! fn.contains(homedir+"/."))
		{ msg.set_markup("⚠️ 只能备份家目录下的隐藏目录或文件。"); return false; }
	return true;
}
//~ --------------------------------------------------------------------
bool addfile(File from){	// 从文件选择器传出的绝对文件名句柄
	string src = from.get_parse_name();
	string localfile = formatFilename(src, true);
	string dst = Environment.get_current_dir()+"/"+localfile;
//~ 	print("----\nmv %s %s; ln -sf %s %s\n", src, dst, dst, src);
	File to = File.parse_name(dst);
	try {
		if (from.move(to,FileCopyFlags.NONE, null, null)){
			if(from.make_symbolic_link(dst,null)){	// 注意方向：File是链接，string才是源文件。
				ex("ls -l "+src);
				list.append(localfile);
				appendListBox(localfile);
//~ 				list.foreach ((i) => { print(i+"\n");});
				return true;
			}
		};
	} catch (Error e) {error ("%s", e.message);}
	return false;
}
//~ --------------------------------------------------------------------
bool rmfile(string fn){	// 从List列表中传出的短本地文件名
	string src = Environment.get_current_dir()+"/"+fn;
	string dst = formatFilename(fn, false);
//~ 	print("----\nrm %s; mv %s %s\n", dst, src, dst);
	File from = File.parse_name(src);
	File to = File.parse_name(dst);
	try {
		if(to.delete()){
			if(from.move(to,FileCopyFlags.NONE, null, null)){
				ex("ls -l "+dst);
				return true;
			}
		}
	} catch (Error e) {error ("%s", e.message);}
	return false;
}
//~ --------------------------------------------------------------------
string ex(string cmd){
	string stdout, stderr; int status;
	try{	//~ 简化版本的 spawn_sync。
		Process.spawn_command_line_sync (cmd, out stdout, out stderr, out status);
	} catch (Error e) { error ("%s", e.message);}
	if(status!=0){ print(stderr); }
	return stdout;
}
//~ --------------------------------------------------------------------
void refreshListBox(){
//~ 	listbox.remove_all();	// not available in gtk4 4.10.5. Use gtk4 >= 4.12
	listfile();
	list.foreach ((i) => {		// 警告：不兼容的指针类型间转换
		appendListBox(i);
	});
}
//~ --------------------------------------------------------------------
void appendListBox(string fn){
	var prefix = "";
	var lbl = new Label("");
	lbl.xalign = (float)0;	// 左对齐。默认居中？
	prefix += checklink(fn) ?"🔗":"💔️";	// 正确的链接
	prefix += git_ls.contains(fn) ?"☂️️️":"✖️️️️";	// 是否在 git 仓库
	string s = formatFilename(fn, false);
	try {
//~ 家目录路径，转化成~的缩写，缩短显示。
		Regex ex = new Regex("^"+homedir);
		s = ex.replace(s, s.length, 0, "~");
//~ 		s = s.replace(homedir, "~");	// max_tokens 失效，不安全了。
//~ 目录的最后一段，文件的倒数第二段目录，加粗标记
		string[] a = s.split("/",0);
		if(FileUtils.test(fn, FileTest.IS_DIR)){
			a[a.length-1] = "<b>"+a[a.length-1]+"</b> 📂";
		}else{
			if(a.length>2) a[a.length-2] = "<b>"+a[a.length-2]+"</b>";
			else a[a.length-1] = "<b>"+a[a.length-1]+"</b>";
		}
		s = string.joinv("/", a);		//join 乱码！！
	} catch (Error e) {error ("%s", e.message);}
	lbl.set_markup(prefix+"\t"+s);
	listbox.insert(lbl, -1);
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
			ex = new Regex("^"+homedir+"/.");
			r = ex.replace(r, r.length, 0, "+");
			ex = new Regex("^~/."); r = ex.replace(r, r.length, 0, "+");
			ex = new Regex("/"); r = ex.replace(r, r.length, 0, "+");
			ex = new Regex("\\ "); r = ex.replace(r, r.length, 0, "=");
		}catch (Error e) {error ("%s", e.message);}
	} else {			// 's|^+|~/.|; s|+|/|g; s|=| |g'
		try{
			ex = new Regex("^\\+"); r = ex.replace(r, r.length, 0, homedir+"/.");
			ex = new Regex("\\+"); r = ex.replace(r, r.length, 0, "/");
			ex = new Regex("="); r = ex.replace(r, r.length, 0, " ");
		}catch (Error e) {error ("%s", e.message);}
	}
	return r;
}
