/*● /usr/bin/valac --pkg gtk+-3.0 nmn.vala ; [ $? -eq 0 ] && ./nmn*/

using Gtk;
using Cairo;
using GLib.Process;

const int GDK_KEY_Left = 0xff51;
const int GDK_KEY_Up = 0xff52;
const int GDK_KEY_Right = 0xff53;
const int GDK_KEY_Down = 0xff54;
const int GDK_KEY_Return = 0xff0d;

/*歌词使用逐字模式，使用‘’包括进入单词模式*/
const string instr="""
333-4#4-|5+0-5-#4-5-|666-71-,|5++6-(5-)|
2++6-5-|3++4-3-|23#4-5(6-)|5++0|
333-4(#4-)|5+0-5-#4-5-|666-7(1-,)|3,++4-,3-,|
2,+63-,2-,|1,+5#4-5-|66-6--7-6(5-)|1,++0=

*越过辽阔天'空，' 啦啦啦飞向遥远群'星，'来 '吧！'阿童木爱科学的好少 '年。' 善良勇敢的  啦啦啦铁臂阿童 '木，'十万马'力，'七大神'力，'无私无畏的阿童 '木。'
*穿过广阔大'地，' 啦啦啦潜入深深海'洋，'来 '吧！'阿童木爱科学的好少 '年。' 善良勇敢的  啦啦啦铁臂阿童 '木，'我 们的好朋友'啊，'无私无畏的阿童 '木。'
""";

const string help="""输入：z0d1r2m3f4s5l6x7t7 输入音符  + - 输入增时线和切换减时线  ' 附点 | 小节符
# b 升降符  ( ) 连音符  ; : 左右重复标记  = 输入结束符 , . 高低音点 空格快速清除 
编辑：u 无限恢复。 i a X 插入/追加/删除音符。回车/j 新行和合并行。
p 截图到 ~/nmn.png。 P 截图到 ~/nmn.pdf。 S 截图到 ~/nmn.svg。 
q 产生~/nmn.wav并播放当前乐曲。Q 播放当前位置至少10个音节，直到遇到分段。
w 保存文本到 ~/nmn.txt。 F 选择显示字体。 歌词使用*开头的行录入，空格控制对齐。
[ ] 调整第一行当前歌词位置，{ } 第二行，e 编辑歌词。L 加载文件。
""";

const string[] strtone={"","Do","Re","Mi","Fa","Sol","La","Si"};
const string alphatable="z0d1r2m3f4s5l6x7t7";
const string[] tone={
	"0","c1","d1","e1","f1","g1","a1","b1",
	"0","c2","d2","e2","f2","g2","a2","b2",
	"0","c3","d3","e3","f3","g3","a3","b3",
	"0","c4","d4","e4","f4","g4","a4","b4",
	"0","c5","d5","e5","f5","g5","a5","b5"
};
const string seg="01234567+|\'=;:";
const int maxstep=20;
string notation;
string lyric0;
string lyric1;
string filename;

public class DrawOnWindow : Gtk.Window {
	int ww;
	int wh;		//窗口尺寸
	int size=16;	//字体尺寸
	string fontname="WenQuanYi Zen Hei Mono";
	Cairo.TextExtents ex;
	int[] arraycnt={};	//每行有效列数
	string nmn="";
	int maxcolumn;
	int crow=0;
	int ccol=0;
	int pos=0;
	bool shoting=false;
	int lyp0c=-1;
	int lyp1c=-1;
	string tmp;
	string fconf;
Array<string> history=new Array<string>();
		double bw;
		double bh;		//单元格尺寸
		double fixheight=0;		//初始的固定高度，字宽度变化大。
		double lyh=0;
		int pagex;
		int pagey;
	private const Gtk.TargetEntry[] targets={{"text/uri-list",0,0}};
	DrawingArea drawing_area;
	string exportpath=Environment.get_variable("HOME")+"/";
	int step=maxstep;
	string animate="";

	private void on_drag_data_received (Gdk.DragContext drag_context, int x, int y, Gtk.SelectionData data, uint info, uint time){
		foreach(string uri in data.get_uris ()){
			File file = File.new_for_uri(uri);
			try{
				string str=file.query_info ("standard::content-type", 0, null).get_content_type ();
				if(str=="text/plain"){
					str=Uri.unescape_string(uri.replace("file://",""));
					loadfile(str);
					queue_draw();
					break;
				}
			} catch (GLib.Error e) {error ("%s", e.message);}
		}
		Gtk.drag_finish (drag_context, true, false, time);
	}

	public DrawOnWindow() {
		title = "numbered musical notation - eexpress - v 1.5";
		window_position=Gtk.WindowPosition.CENTER_ALWAYS;
		destroy.connect (Gtk.main_quit);
		ww=700;
		wh=600;
		loadfile("Sample");
		fconf=exportpath+".config/nmn.conf";
		try{
			if(FileUtils.test(fconf,FileTest.IS_REGULAR)){
				FileUtils.get_contents(fconf, out tmp);
				foreach(string line in tmp.split("\n")){
					string[] str=line.split("=",2);
					if(str[0].strip()=="font"){ fontname=str[1].strip(); }
					if(str[0].strip()=="size"){ size=int.parse(str[1].strip()); }
				}
			}
		} catch (GLib.Error e) {error ("%s", e.message);}
		set_default_size(ww,wh);
		drawing_area = new DrawingArea ();
		drawing_area.draw.connect (on_draw);
		add (drawing_area);
		add_events(Gdk.EventMask.BUTTON_PRESS_MASK|Gdk.EventMask.KEY_PRESS_MASK);
		Gtk.drag_dest_set (this,Gtk.DestDefaults.ALL, targets, Gdk.DragAction.COPY);
		drag_data_received.connect(on_drag_data_received);
		button_press_event.connect ((e) => {
			if(e.x<pagex || e.y<pagey-fixheight-lyh || e.x>pagex+arraycnt[arraycnt.length-1]*bw || e.y>pagey-fixheight-lyh+arraycnt.length*bh){
				begin_move_drag ((int) e.button, (int) e.x_root, (int) e.y_root, e.time);
			}else{
				if(e.button == 1 && fixheight != 0){
					double row=(e.y-pagey+fixheight+lyh)/bh;
				double adj=arraycnt[(int)row];
				if(maxcolumn-adj>4){adj=1;}
				else{ adj=1+(maxcolumn-adj)/(adj-0.5); }
				bw=fixheight*1.6*adj;
					double col=(e.x-pagex)/bw;
					ccol=(int)col; crow=(int)row;
					if(crow<0)crow=0;
					if(crow>arraycnt.length-1)crow=arraycnt.length-1;
					if(ccol<0)ccol=0;
					if(ccol>arraycnt[crow]-1)ccol=arraycnt[crow]-1;
					queue_draw();
				}
			}
			showdata();
			return false;
		});
		key_press_event.connect ((e) => {
			if(e.str!="" && alphatable.contains(e.str)){
				int p=alphatable.index_of(e.str,0);
				if(p==p/2*2){p++;}
				string t=alphatable[p].to_string()+nmn.substring(1,-1);
				changedate(t);
			}
			switch(e.keyval){
			case GDK_KEY_Up:
				crow--;
				if(crow<0){crow=arraycnt.length-1;}
				if(ccol>arraycnt[crow]-1)ccol=arraycnt[crow]-1;
				break;
			case GDK_KEY_Down:
				crow++;
				if(crow>arraycnt.length-1){crow=0;}
				if(ccol>arraycnt[crow]-1)ccol=arraycnt[crow]-1;
				break;
			case GDK_KEY_Right:
				ccol++;
				if(ccol>arraycnt[crow]-1)ccol=0;
				break;
			case GDK_KEY_Left:
				ccol--;
				if(ccol<0)ccol=arraycnt[crow]-1;
				break;
			case 'S':
				screensvg();
				stdout.printf("screen save as svg to ~/nmn.svg\n");
				startanimate("SVG");
				break;
			case 'P':
				screenpdf();
				stdout.printf("screen save as pdf to ~/nmn.pdf\n");
				startanimate("PDF");
				break;
			case 'p':
				screenshot();
				stdout.printf("screen save as png to ~/nmn.png\n");
				startanimate("PNG");
				break;
			case '-':
			case ',':
			case '.':
				string t=nmn;
				if(!(t[0]>='0' && t[0]<'8')) break;
				int cnt=0;
				int i;
				for(i=0; i<t.length;i++){if(t[i]==e.keyval)cnt++;}
				cnt++; if(cnt>3)cnt=0;
				int p;
				if(e.str=="-"){
					p=-1;
					t=t.replace("-","");
				}else{
					p=t.last_index_of ("-",0);
					t=t.replace(",","");
					t=t.replace(".","");
				}
				if(p<0)p=0;
				p++;
				string t0=t.substring(0,p);
/*                if(t.contains("?")){p=t.last_index_of ("?",0)+1;}*/
				string t1=t.substring(p,-1);
				t=t0; for(i=0;i<cnt;i++){t+=e.str;} t+=t1;
				changedate(t);
				break;
			case 'i':
				changedate("0"+nmn);
				arraycnt[crow]++;
				break;
			case ' ':
				string t=nmn.substring(0,1);
				changedate(t);
				break;
			case 'a':
				changedate(nmn+"0");
				ccol++;
				arraycnt[crow]++;
				break;
			case 'X':
				changedate("");
				arraycnt[crow]--;
				break;
			case 'j':
				int k=notation.index_of("\n",pos);
				pos=k; nmn="?";
				changedate("");
				break;
			case GDK_KEY_Return:
				ccol=arraycnt[crow];
				changedate("\n"+nmn);
				crow++; ccol=0;
				break;
			case 'q':
				create_wav(0,0,1000);
				startanimate("WAV");
				break;
			case 'Q':
				create_wav(crow,ccol,8);
				startanimate("WAV");
				break;
			case '+':
			case '|':
			case '=':
			case ';':
			case ':':
			case '\'':
				changedate(e.str);
				break;
			case '#':
			case 'b':
			case '(':
			case ')':
				string t=nmn;
				if(!(t[0]>='0' && t[0]<'8')) break;
				if(t.contains(e.str)){ t=t.replace(e.str,""); }
				else{ t+=e.str; }
				if(e.keyval=='#')t=t.replace("b","");
				if(e.keyval=='b')t=t.replace("#","");
				changedate(t);
				break;
			case 'u':
				if(history.length!=0){
					notation=history.index(0);
					history.remove_index(0);
				}
				break;
			case 'F':
				FontChooserDialog dialog;
				dialog = new FontChooserDialog("nmn",this);
				dialog.preview_text="nmn 选择简谱的显示字体。 123";
				dialog.set_font("%s %d".printf(fontname, size));
				dialog.set_show_preview_entry(false);
				if (dialog.run () == Gtk.ResponseType.OK) {
					string s=dialog.get_font_family().get_name();
					if(s!=null)fontname=s;
					size=dialog.get_font_size()/1024;
					if(size<8||size>36)size=16;
				}
				dialog.close();
				try{
					FileUtils.set_contents(fconf, "font="+fontname+"\nsize="+size.to_string()+"\n", -1);
				} catch (GLib.Error e) {error ("%s", e.message);}
				break;
			case 'L':
				Gtk.FileChooserDialog chooser = new Gtk.FileChooserDialog ( "Select your favorite file", this, Gtk.FileChooserAction.OPEN, "_Cancel", Gtk.ResponseType.CANCEL, "_Open", Gtk.ResponseType.ACCEPT);
				chooser.select_multiple = false;
				Gtk.FileFilter filter = new Gtk.FileFilter ();
				chooser.set_filter (filter);
				filter.add_mime_type ("text/plain");
				if (chooser.run () == Gtk.ResponseType.ACCEPT) {
					string fn = Uri.unescape_string(chooser.get_uri().replace("file://",""));
					stdout.printf ("Selection:%s\n",fn);
					loadfile(fn);
				}
				chooser.close ();
				break;
			case 'e':
				Gtk.Window win=new Gtk.Window ();
				win.title="编辑歌词";
				win.set_default_size (ww*2/3, 100);
/*                win.window_position=Gtk.WindowPosition.CENTER_ON_PARENT;*/
				win.window_position=Gtk.WindowPosition.CENTER;
				Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 1);
				box.border_width=10;
				box.spacing=10;
				win.add(box);
				Gtk.TextView view0 = new Gtk.TextView ();
				view0.set_wrap_mode (Gtk.WrapMode.WORD);
				view0.buffer.text = lyric0;
				box.pack_start (view0, false, true, 0);
				Gtk.TextBuffer buf0=view0.get_buffer ();
				buf0.changed.connect (() => {
					lyric0=buf0.text;
					queue_draw();
				});

				Gtk.TextView view1 = new Gtk.TextView ();
				view1.set_wrap_mode (Gtk.WrapMode.WORD);
				view1.buffer.text = lyric1;
				box.pack_start (view1, false, true, 0);
				Gtk.TextBuffer buf1=view1.get_buffer ();
				buf1.changed.connect (() => {
					lyric1=buf1.text;
					queue_draw();
				});

				Gtk.Button bok=new Gtk.Button.from_icon_name("window-close");
				box.pack_end (bok, false, true, 0);
				bok.clicked.connect (() => {
					win.destroy();
				});
				win.show_all();
				break;
			case 'w':
				try{
					string s=notation+"\n*"+lyric0+"\n*"+lyric1;
					FileUtils.set_contents(exportpath+"nmn.txt", s, -1);
				} catch (GLib.Error e) {error ("%s", e.message);}
				stdout.printf("notation save to ~/nmn.txt\n");
				startanimate("TXT");
				break;
			case '[':
				if(!alphatable.contains(nmn[0].to_string()))break;
				if(lyp0c>0 && lyric0[lyp0c-1]==' '){
			lyric0=lyric0.slice(0,lyp0c-1)+lyric0.slice(lyp0c,lyric0.length);
				}
				break;
			case ']':
				if(!alphatable.contains(nmn[0].to_string()))break;
				if(lyp0c>=0){
			lyric0=lyric0.slice(0,lyp0c)+" "+lyric0.slice(lyp0c,lyric0.length);
				}
				break;
			case '{':
				if(!alphatable.contains(nmn[0].to_string()))break;
				if(lyp1c>0 && lyric1[lyp1c-1]==' '){
			lyric1=lyric1.slice(0,lyp1c-1)+lyric1.slice(lyp1c,lyric1.length);
				}
				break;
			case '}':
				if(!alphatable.contains(nmn[0].to_string()))break;
				if(lyp1c>=0){
			lyric1=lyric1.slice(0,lyp1c)+" "+lyric1.slice(lyp1c,lyric1.length);
				}
				break;
			}
			setarraycnt(); showdata();
			queue_draw();
			return false;
		});
	}

	private void changedate(string s){
		string t0,t1;
		history.insert_val(0,notation);
		t0=notation.slice(0,pos);
		t1=notation.substring(pos+nmn.length,-1);
		notation=t0+s+t1;
	}

	private void showdata(){
/*        根据 crow ccol 找到 nmn 位置*/
		int posbegin=0, posend;
		int l,cnt=0;
		char c;
		for(l=0;l<crow;l++){
			posbegin=notation.index_of_char('\n',posbegin+1);
		}
		posend=notation.index_of_char('\n',posbegin+1);
		for(l=posbegin;l<posend;l++){
			c=notation[l];
			if(seg.contains(c.to_string())){
				if(cnt==ccol){
					string t=notation.substring(l+1,-1);
					t._delimit(seg+"\n",'\0');
					nmn=c.to_string()+t;
					pos=l;
					break;
				}
				cnt++;
			}
		}
	}

	/* private void outputnotation(){
		string s=notation;
		string str;
		string cur="";
		int p;
		for(p=0;p<s.length;p++){
			str=s.get_char(p).to_string();
			if(cur==""){cur=str;continue;}
			if(str in seg+"\n"){
				if(cur!=""){
					stdout.printf("%d->%s\t",p,cur.replace("\n","<CR>"));
					cur=str;
					//note.append_val(cur);
				}
			}else{
				cur+=str;
			}
		}
		stdout.printf("%d->%s\n",p,cur.replace("\n","<CR>"));
		stdout.printf ("----------------------------\n");
		//note.append_val(cur);
	} */

	void setarraycnt(){
		string tmp="";
		arraycnt={};
		maxcolumn=0;
		foreach(string s in notation.split("\n")){
			if(s=="")continue;
			tmp+=s; tmp+="\n";
			int cnt=0;
			for(int l=0;l<s.length;l++){
				char c=s[l];
				if(seg.contains(c.to_string()))
				{cnt++;continue;}
			}
			arraycnt+=cnt;
			if(cnt>maxcolumn){maxcolumn=cnt;}
		}
		if(crow>arraycnt.length-1)crow=arraycnt.length-1;
		if(crow<0)crow=0;
		if(ccol>arraycnt[crow]-1)ccol=arraycnt[crow]-1;
		if(ccol<0)ccol=0;
		notation=tmp;
	}

	private void screenshot(){
		var surface = new ImageSurface (Format.ARGB32, ww, wh);
		var ctx = new Cairo.Context (surface);
		shoting=true;
		on_draw(ctx);
		surface.write_to_png (exportpath+"nmn.png");
	}

	private void screensvg(){
		var surface = new SvgSurface(exportpath+"nmn.svg", ww, wh);
		var ctx = new Cairo.Context (surface);
		shoting=true;
		on_draw(ctx);
	}

	private void screenpdf(){
		var surface = new PdfSurface(exportpath+"nmn.pdf", ww, wh);
		var ctx = new Cairo.Context (surface);
		shoting=true;
		on_draw(ctx);
	}

	private void create_wav(int r0, int c0, int minlen){
		int i=7;
		int oldr=crow;
		int oldc=ccol;
		int oldj=0;
		string wav="";
		string repeatwav="";
		bool repeat=false;
		crow=r0; ccol=c0;
		for(;crow<arraycnt.length;crow++){
			while(ccol<arraycnt[crow]){
/*            for(;ccol<arraycnt[crow];ccol++){*/
				showdata();
				ccol++;
				int j=500;
				if("|;:=".contains(nmn[0].to_string())){	//4种分割符
					if(nmn[0]==';'){repeatwav="";repeat=true;}
					if(nmn[0]==':'){wav+=repeatwav; repeatwav="";repeat=false;}
					if(minlen==0)break;
					else continue;
				}
				if(nmn.contains("'")){
					j=oldj/2;
				}else{
					if(!nmn.contains("+")){
						i=nmn[0]-'0'+16;
						for(int l=1;l<nmn.length;l++){
							switch(nmn[l]){
								case ',':
									i+=8;
									break;
								case '.':
									i-=8;
									break;
								case '-':
									j/=2;
									break;
							}
						}
					}
				}
				if(i<0)i=0; if(i>tone.length)i=0;
/*                wav+="%s:%d 0:10 ".printf(tone[i],j);*/
				wav+="%s:%d ".printf(tone[i],j);
				if(repeat) repeatwav+="%s:%d ".printf(tone[i],j);
				oldj=j;
				if(minlen>0)minlen--;
			}
			if(minlen==0)break;
			ccol=0;
		}
		crow=oldr; ccol=oldc;
		if(FileUtils.test("/usr/bin/tones",FileTest.IS_EXECUTABLE)){
			try{
				FileUtils.unlink(exportpath+"nmn.wav");
				FileUtils.set_contents("/tmp/nmn.tones",wav,-1);
				spawn_command_line_sync("tones -w "+exportpath+"nmn.wav "+wav);
				spawn_command_line_async("aplay "+exportpath+"nmn.wav");
			} catch (GLib.Error e) {error ("%s", e.message);}
		}else stdout.printf("CAUTION: play wav need external command \"tones\", please install \"siggen\" package.\n");
	}

	private bool on_draw (Context ctx) {
		double vspace;		//垂直标记的间隔
		int dncnt=0, upcnt=0;	//垂直位置计数
		int lyp0=0;
		int lyp1=0;

		ctx.select_font_face(fontname,FontSlant.NORMAL,FontWeight.BOLD);
		ctx.set_font_size(size);
		ctx.set_line_width(0.5);
		ctx.text_extents("8",out ex);
		fixheight=ex.height;
/*        尺寸由字体高度决定*/
		vspace=fixheight/3;
		bw=fixheight*1.6;		//目前是最长行的最紧格式宽度
		bh=fixheight*7;
		lyh=fixheight*2;
		pagex=(int)(fixheight*3);
		pagey=(int)(fixheight*10);
		if(lyric1!=""){bh+=lyh;}
		resize((int)(pagex*2+maxcolumn*bw),(int)(pagey*2+arraycnt.length*bh));
		this.get_size(out ww,out wh);
		if(filename=="Sample"){
			string ss="Drag File Here.";
			ctx.set_source_rgba (0, 0, 1, 0.4);
			ctx.set_font_size(size*4);
			ctx.move_to(ww/2-centerpos(ctx,ss),wh/2);
			ctx.show_text(ss);
			ctx.set_font_size(size);
		}

		ctx.set_source_rgba (0.8, 0.8, 0.8, 0.4);
		ctx.paint();
		ctx.set_source_rgb (0, 0, 0);
/*----------------------------------------------------------*/
		string ss;
		int row=0, col=0;
		double x=0, y;		//由row,col计算出来
		double x0=0, y0=0;		//上连括号

		foreach(string line in notation.split("\n")){
			y=pagey+row*bh;		//y是音符底部
			if(line=="")continue;
/*            右边缘对齐*/
			double adj=arraycnt[row];
			if(maxcolumn-adj>4){adj=1;}/*差距太大，不做调整*/
			else{ adj=1+(maxcolumn-adj)/(adj-0.5); }
			bw=fixheight*1.6*adj;
		for(int l=0; l<line.length; l++){
			char i=line[l];
			if(seg.contains(i.to_string())){
				x=pagex+col*bw+bw/2;	//x是格子中心坐标
				if(row==crow && col==ccol && ! shoting){
					ctx.set_source_rgba (0, 0, 1, 0.4);
					ctx.rectangle(x-bw/2,y-fixheight-lyh,bw,bh);
					ctx.fill();
					ctx.set_source_rgb (0, 0, 0);
				}
				col++;
			}
			if(i!='-'&&i!='.'){dncnt=0;}
			if(i!=',' && i!='(' && i!=')'){upcnt=0;}
			if(i>='0' && i<'8'){
				ctx.move_to(x-centerpos(ctx,i.to_string()),y);
				ctx.show_text(i.to_string());

				if(lyric0!=""){
					while(!lyric0.valid_char(lyp0) && lyp0<lyric0.length) lyp0++;
					ss=lyric0.get_char(lyp0).to_string();
					if(row==crow && col==ccol+1){ lyp0c=lyp0; }
					if(ss!="\n"){
						lyp0++;
						if(ss=="'"){
							int k=lyric0.index_of("'",lyp0);
							ss=lyric0.slice(lyp0,k);
							lyp0=k+1;
						}
						ctx.move_to(x-centerpos(ctx,ss.get_char(0).to_string()),y+fixheight+lyh);
						ctx.show_text(ss);
					}
				if(lyric1!=""){
					while(!lyric1.valid_char(lyp1) && lyp1<lyric1.length) lyp1++;
					ss=lyric1.get_char(lyp1).to_string();
					if(row==crow && col==ccol+1){ lyp1c=lyp1; }
					if(ss!="\n"){
						lyp1++;
						if(ss=="'"){
							int k=lyric1.index_of("'",lyp1);
							ss=lyric1.slice(lyp1,k);
							lyp1=k+1;
						}
						ctx.move_to(x-centerpos(ctx,ss.get_char(0).to_string()),y+fixheight+lyh*2);
						ctx.show_text(ss);
					}
				}
				}else{
					ss=strtone[i-'0'];
					ctx.set_font_size(size/1.2);
					ctx.move_to(x-centerpos(ctx,ss),y+vspace*2+fixheight*2);
					ctx.show_text(ss);
					ctx.set_font_size(size);
				}
				continue;
			}
			double center=y-fixheight/2;
			switch(i){
			case '=':
				ctx.move_to(x,center-bh/4);
				ctx.rel_line_to(0,bh/2);
				ctx.stroke();
				ctx.set_line_width(size/5);
				ctx.move_to(x+size/4,center-bh/4);
				ctx.rel_line_to(0,bh/2);
				ctx.stroke();
				ctx.set_line_width(0.5);
				break;
			case ':':
				ctx.move_to(x,center-bh/4);
				ctx.rel_line_to(0,bh/2);
				ctx.stroke();
				ctx.set_line_width(size/5);
				ctx.move_to(x+size/4,center-bh/4);
				ctx.rel_line_to(0,bh/2);
				ctx.stroke();
				ctx.set_line_width(0.5);
				ctx.arc(x-size/4,center-bh/8,size/7,0,360*Math.PI/180);
				ctx.fill();
				ctx.arc(x-size/4,center+bh/8,size/7,0,360*Math.PI/180);
				ctx.fill();
				break;
			case ';':
				ctx.set_line_width(size/5);
				ctx.move_to(x,center-bh/4);
				ctx.rel_line_to(0,bh/2);
				ctx.stroke();
				ctx.set_line_width(0.5);
				ctx.move_to(x+size/4,center-bh/4);
				ctx.rel_line_to(0,bh/2);
				ctx.stroke();
				ctx.arc(x+size/2,center-bh/8,size/7,0,360*Math.PI/180);
				ctx.fill();
				ctx.arc(x+size/2,center+bh/8,size/7,0,360*Math.PI/180);
				ctx.fill();
				break;
			case '|':
				ctx.move_to(x,center-bh/4);
				ctx.rel_line_to(0,bh/2);
				ctx.stroke();
				break;
			case '#':
			case 'b':
				ctx.move_to(x-bw/2,y-fixheight+vspace/4);
				ctx.set_font_size(size/2);
				ctx.show_text(i.to_string());
				ctx.set_font_size(size);
				break;
			case '+':
				ss="-";
				ctx.move_to(x-centerpos(ctx,ss),y-vspace);
				ctx.show_text(ss); break;
			case '\'':
				ss=".";
				ctx.move_to(x-centerpos(ctx,ss),y-vspace);
				ctx.show_text(ss); break;
			case '-':
				dncnt++;
				ctx.move_to(x+bw/2,y+dncnt*vspace); ctx.rel_line_to(-bw,0);
				ctx.stroke(); break;
			case '.':
				dncnt++;
				ctx.arc(x,y+dncnt*vspace,size/7,0,360*Math.PI/180);
				ctx.fill(); break;
			case ',':
				upcnt++;
				ctx.arc(x,y-fixheight-upcnt*vspace,size/7,0,360*Math.PI/180);
				ctx.fill(); break;
			case '(':
				x0=x; y0=upcnt;
				break;
			case ')':
				double by=y-fixheight-vspace;
				double vect=(x-x0)/bw*vspace;
				if(y0<upcnt)y0=upcnt;
				y0=y0*vspace;
				ctx.move_to(x0,by-y0);
			ctx.curve_to(x0+vect,by-vect-y0,x-vect,by-vect-y0,x,by-y0);
			ctx.curve_to(x-vect,by-vect-y0-vspace*0.8,x0+vect,by-vect-y0-vspace*0.8,x0,by-y0);
				ctx.fill();
				y0=0;
				break;
			}
		}
		row++; col=0;
		}
/*        显示标题*/
		double vh=pagey/2;
		this.get_size(out ww,out wh);
		ctx.set_font_size(size*1.5);
		ctx.move_to(ww/2-centerpos(ctx,filename), vh);
		ctx.show_text(filename);
		ctx.set_font_size(size);
		ctx.set_source_rgba (0, 0, 1, 0.5);
		if(! shoting){
			ctx.move_to(bw*2,vh);
			ctx.show_text("@%d,%d [%s]".printf(crow,ccol,nmn));
		}
		shoting=false;
/*        显示帮助*/
		vh=wh-pagey;
		ctx.set_font_size(size*3/4);
		foreach(string s in help.split("\n")){
			ctx.move_to(bw*2,vh);
			ctx.show_text(s);
			vh+=fixheight*1.5;
		}
/*        显示动画*/
		if(step<maxstep){
			ctx.set_font_size(size*step);
			ctx.move_to(ww/2-centerpos(ctx,animate),wh/2);
			ctx.set_source_rgba (1, 0, 0, 0.99/(step/5));
			ctx.show_text(animate);
		}
		return true;
	}

	private void startanimate(string s){
		step=0;
		animate=s;
		GLib.Timeout.add(30,()=>{
			step++;
			queue_draw();
			if(step<maxstep)return true; else return false;
		});
	}

	private double centerpos(Context ctx, string s){
		ctx.text_extents(s,out ex);
		return ex.width/2 + ex.x_bearing;
	}

	public bool loadfile(string fn){
		if(fn=="")return false;
		try{
			if(FileUtils.test(fn,FileTest.IS_REGULAR)){
				FileUtils.get_contents(fn, out notation);
				filename=fn;
				int k=filename.last_index_of("/",0);
				filename=filename.substring(k+1,-1);
				k=filename.index_of(".",0);
				filename=filename.slice(0,k);
			}else{
				notation=instr;
				filename="Sample";
			}
		} catch (GLib.Error e) {error ("%s", e.message);}
		if(notation.contains("*")){
			string[] s=notation.split("*",3);
			notation=s[0]; lyric0=s[1]; lyric1=s[2];
		}
		if(lyric0==null)lyric0="";
		if(lyric1==null)lyric1="";
		history.set_size(0);
		setarraycnt(); showdata();
/*        outputnotation();*/
		return true;
	}
	
	static int main (string[] args) {
		Gtk.init (ref args);
		var DW = new DrawOnWindow ();
		DW.show_all ();
		Gtk.main ();
		return 0;
	}
}
