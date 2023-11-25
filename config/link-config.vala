//~ ⭕ valac --pkg gtk4 --pkg posix link-config.vala
//~ ⭕ ./link-config

using Gtk;

const string appID = "io.github.eexpress.link.config";
const string appTitle = "Link Config";

List<string> pluslist;
ListBox listbox;
Label msg;

string Git_Ls;
string HomeDir;
string WorkDir;
//~ --------------------------------------------------------------------
int main(string[] args) {
//~ 	var app = new Gtk.Application(appID, ApplicationFlags.DEFAULT_FLAGS);
	var app = new Adw.Application(appID, ApplicationFlags.DEFAULT_FLAGS);
	HomeDir = Environment.get_variable("HOME");
	try{	// 获取执行文件路径，并切换工作目录。
		WorkDir = Path.get_dirname(FileUtils.read_link("/proc/self/exe"));
		Posix.chdir(WorkDir);
//~ 		WorkDir = Environment.get_current_dir();
	} catch (Error e) {error ("%s", e.message);}
	Git_Ls = ex("git ls");
	app.activate.connect(onAppActivate);
	return app.run(args);
}
//~ --------------------------------------------------------------------
void onAppActivate(GLib.Application self) {	// 为什么这里必须是 GLib 的 Application
//~ 窗口
	var window = new ApplicationWindow(self as Gtk.Application);
	window.title = appTitle;
	window.set_default_size(400, 420);
	window.resizable = true;
//~ 底盒
	var box = new Box(Orientation.VERTICAL, 5); box.set_margin_start(10);

//~ 	pg = new Adw.PreferencesGroup();
//~ 	pg.title = "备份的配置文件"; pg.description="configure files list.";
//~ 	box.append(pg);
//~ 	var row0 = new Adw.ActionRow();
//~ 	row0.use_markup=true;
//~ 	row0.set_subtitle_selectable(true);
//~ 	row0.subtitle="wlke<b>welkkj</b>wlek";
//~ 	pg.add(row0);

//~ 	var row1 = new Adw.ActionRow();
//~ 	row1.use_markup=true;
//~ 	row1.set_subtitle_selectable(true);
//~ 	row1.subtitle="wlke<b>welkkj</b>wlek";
//~ 	pg.add(row1);

//~ 列表
	listbox = new ListBox();
	refreshListBox();
//~ 拖放
	var string_drop = new DropTarget(GLib.Type.STRING, Gdk.DragAction.COPY);
	listbox.add_controller(string_drop);
	string_drop.drop.connect((self, value, x, y) => {	// value.type_name()
		string s = value.get_string();
		if(checkfile(s)) addfile(File.parse_name(s));
		return true;
	  });
//~ 3个按键
	var bt0 = new Button.with_label("✖️ 取消备份：删除源链接，移动备份文件到源位置");
	var bt1 = new Button.with_label("➕ 添加备份：移动源文件过来，在源位置建立链接");
	var bt2 = new Button.with_label("♻️ 全部恢复：在源位置强行建立全部链接");
	bt0.halign = Align.START; bt1.halign = Align.START; bt2.halign = Align.START;
	bt0.clicked.connect (()=>{
		unowned ListBoxRow? row = listbox.get_selected_row();
		if(row == null) return;
		unowned List<string> lst = pluslist.nth (row.get_index());
		if (rmfile(lst.data, true)){	// 正确删除备份
			listbox.remove(row);
			pluslist.remove_link (lst);
		};
	});
	bt1.clicked.connect (on_add_clicked);
	bt2.clicked.connect (on_restore_clicked);
//~ 信息条
	msg = new Label("XXX"); msg.halign = Align.START;
	string s = WorkDir.replace(HomeDir,"~");
	s = "<b>%s</b>. Ver 0.1. <i>\"%s\"</i>\n".printf(appID, s);
	msg.set_markup(s);
//~ 窗口布局和呈现
	window.child = box; box.append(listbox);
	box.append(bt0); box.append(bt1); box.append(bt2); box.append(msg);
	window.present ();
}
//~ --------------------------------------------------------------------
void on_restore_clicked(){
	pluslist.foreach ((plusfile) => {
		rmfile(plusfile, false);
	});
	msg.set_markup("已经全部恢复配置的链接。");
}
//~ --------------------------------------------------------------------
async void on_add_clicked () {
	File ? f = null;
	var dialog = new Gtk.FileDialog ();	// 需要能选择目录和显示隐藏文件 ！！！！！
	dialog.title = "选择需要收集备份的配置文件";
	try {
		f = yield dialog.open(null, null);	// yield 必须在 async 内部
	} catch (Error e) {error ("%s", e.message);}
	if (f == null) return;	// 直接退出异步函数，会Dismissed by user 追踪与中断点陷阱（核心已转储）??

	if(checkfile(f.get_parse_name())) addfile(f);
}
//~ --------------------------------------------------------------------
bool checkfile(string fn){
	if(!FileUtils.test(fn, FileTest.EXISTS)){msg.set_markup("⚠️ 文件不存在。"); return false;}
	if(FileUtils.test(fn, FileTest.IS_SYMLINK)){msg.set_markup("⚠️ 不能备份链接文件。"); return false;}
	if (! fn.contains(HomeDir+"/."))
		{ msg.set_markup("⚠️ 只能备份家目录下的隐藏目录或文件。"); return false; }
	return true;
}
//~ --------------------------------------------------------------------
bool addfile(File Fconfig){	// 配置文件句柄
	string src = Fconfig.get_parse_name();	// 配置文件
	string plusfile = formatFilename(src, true);	// 带+号文件名
	string dst = WorkDir+"/"+plusfile;	// 备份文件
	File Fbackup = File.parse_name(dst);		// 备份文件句柄
//~ 	print("----\nmv %s %s; ln -sf %s %s\n", src, dst, dst, src);
	try {
		if (Fconfig.move(Fbackup,FileCopyFlags.NONE, null, null)){
			if(Fconfig.make_symbolic_link(dst,null)){	// 注意方向：File是链接，string才是源文件。
				pluslist.append(plusfile); appendListBox(plusfile);
				ex("ls -l "+src); return true;
			}
		};
	} catch (Error e) {error ("%s", e.message);}
	return false;
}
//~ --------------------------------------------------------------------
bool rmfile(string plusfile, bool moveORrestroe){	// 带+号文件名
	string dst = WorkDir+"/"+plusfile;	// 备份文件
	string src = formatFilename(plusfile, false);	// 配置文件
	File Fbackup = File.parse_name(dst);	// 备份文件句柄
	File Fconfig = File.parse_name(src);		// 配置文件句柄
	try {
		if(Fconfig.query_exists()) Fconfig.delete();
	} catch (Error e) {error ("%s", e.message);}
	try {
		if(moveORrestroe){
//~ 	print("----\nrm %s; mv %s %s\n", src, dst, src);
			if(Fbackup.move(Fconfig,FileCopyFlags.NONE, null, null)){
				ex("ls -l "+src); return true;
			}
		}else{
//~ 	print("----\nrm %s; ln -sf %s %s\n", src, src, dst);
			if(Fconfig.make_symbolic_link(dst,null)){
				ex("ls -l "+src); return true;
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
void refreshListBox(){	// remove_all 能工作后，可能需要多次调用。
//~ 	listbox.remove_all();	// not available in gtk4 4.10.5. Use gtk4 >= 4.12
	listplusfile();
	pluslist.foreach ((i) => {		// 警告：不兼容的指针类型间转换
		appendListBox(i);
	});
}
//~ --------------------------------------------------------------------
void appendListBox(string fn){
	var prefix = "";
	var lbl = new Label("");
	lbl.xalign = (float)0;	// 左对齐。默认居中？
	prefix += checklink(fn);	// 正确的链接
	prefix += Git_Ls.contains(fn) ?"☂️️️":"✖️️️️";	// 是否在 git 仓库
	string s = formatFilename(fn, false);
	try {
//~ 家目录路径，转化成~的缩写，缩短显示。
		Regex ex = new Regex("^"+HomeDir);
		s = ex.replace(s, s.length, 0, "~");
//~ 		s = s.replace(HomeDir, "~");	// max_tokens 失效，不安全了。
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
string checklink(string plusfile){	// 带+号的本地文件
//~ 	本地文件转化成源文件
	string r = formatFilename(plusfile, false);
	try {
		if(!FileUtils.test(r, FileTest.EXISTS)) return "␀";	//源配置文件不存在
		if(!FileUtils.test(r, FileTest.IS_SYMLINK)) return "🅕";	//源配置文件必须是链接
		if(FileUtils.read_link(r) != WorkDir+"/"+plusfile) return "💔";	// 源文件链接 == 本地文件
	} catch (Error e) {error ("%s", e.message);}
	return "🔗";
}
//~ --------------------------------------------------------------------
void listplusfile(){
//~ 	找出当前目录+号开头的文件，建立列表。
	pluslist = new List<string> ();
	try {
		var d  = GLib.Dir.open(WorkDir, 0);
		string ? fn = null;	// 可空字符串
		while ((fn = d.read_name()) != null) {
			if(fn[0] == '+') { pluslist.append (fn); }
		}
	} catch (Error e) {error ("%s", e.message);}
	pluslist.sort(strcmp);	// strcmp 什么鬼？
}
//~ --------------------------------------------------------------------
string formatFilename(string str, bool change2plus){
//~ 	change2plus 方向，true 为变+号格式，false 为恢复正常路径格式。
	Regex ex;
	string r = str;	// 不要直接修改传入参数
	if(change2plus){	// "s|^${HOME}/.|+|; s|/|+|g; s|\ |=|g"
		try{
			ex = new Regex("^"+HomeDir+"/.");
			r = ex.replace(r, r.length, 0, "+");
			ex = new Regex("^~/."); r = ex.replace(r, r.length, 0, "+");
			ex = new Regex("/"); r = ex.replace(r, r.length, 0, "+");
			ex = new Regex("\\ "); r = ex.replace(r, r.length, 0, "=");
		}catch (Error e) {error ("%s", e.message);}
	} else {			// 's|^+|~/.|; s|+|/|g; s|=| |g'
		try{
			ex = new Regex("^\\+"); r = ex.replace(r, r.length, 0, HomeDir+"/.");
			ex = new Regex("\\+"); r = ex.replace(r, r.length, 0, "/");
			ex = new Regex("="); r = ex.replace(r, r.length, 0, " ");
		}catch (Error e) {error ("%s", e.message);}
	}
	return r;
}
//~ --------------------------------------------------------------------
//~ void listbox_remove_all(ListBox box){
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
//~ }
//~ --------------------------------------------------------------------
