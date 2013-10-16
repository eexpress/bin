/*● /usr/bin/valac --pkg gtk+-3.0 nmn.vala ; [ $? -eq 0 ] && ./nmn*/

using Gtk;
using Cairo;
using GLib.Process;

const int GDK_KEY_Left = 0xff51;
const int GDK_KEY_Up = 0xff52;
const int GDK_KEY_Right = 0xff53;
const int GDK_KEY_Down = 0xff54;
const int GDK_KEY_Return = 0xff0d;

/*逐字模式，使用‘’包括进入单词模式*/
const string instr="""
333-4#4-|5+0-5-#4-5-|666-71-,|5++6-(5-)|
2++6-5-|3++4-3-|23#4-5(6-)|5++0|
333-4(#4-)|5+0-5-#4-5-|666-7(1-,)|3,++4-,3-,|
2,+63-,2-,|1,+5#4-5-|66-6--7-6(5-)|1,++0||

:越过辽阔天'空，' 啦啦啦飞向遥远群'星，'来 '吧！'阿童木爱科学的好少 '年。' 善良勇敢的  啦啦啦铁臂阿童 '木，'十万马'力，'七大神'力，'无私无畏的阿童 '木。'
:穿过广阔大'地，' 啦啦啦潜入深深海'洋，'来 '吧！'阿童木爱科学的好少 '年。' 善良勇敢的  啦啦啦铁臂阿童 '木，'我 们的好朋友'啊，'无私无畏的阿童 '木。'
""";

const string help="""编辑：d1r2m3f4s5l6x7t7 输入音符。 - , . 循环切换音调和拍子。 #（）切换上面的附加音符。 
+ | 延长音和分割符。 u 恢复最后三次。 i a x 插入/追加/删除音符。回车/j 新行和合并行。
p 截图到 /tmp/nmn.png。 w 保存文本到 /tmp/nmn.nmn。 q 产生/tmp/nmn.wav并播放当前乐曲。
c 选择显示字体。
""";

const string strtone[]={"","Do","Re","Mi","Fa","Sol","La","Si"};
const string alphatable="d1r2m3f4s5l6x7t7";
const string tone[]={
	"0","c1","d1","e1","f1","g1","a1","b1",
	"0","c2","d2","e2","f2","g2","a2","b2",
	"0","c3","d3","e3","f3","g3","a3","b3",
	"0","c4","d4","e4","f4","g4","a4","b4",
	"0","c5","d5","e5","f5","g5","a5","b5"
};
string notation;
string old0;
string old1;
string old2;
string lyric1;
string lyric2;
string filename;

public class DrawOnWindow : Gtk.Window {
	int ww;
	int wh;		//窗口尺寸
	int size=16;	//字体尺寸
/*    string fontname="Vera Sans YuanTi";*/
	string fontname="WenQuanYi Zen Hei Mono";
/*    string fontname="Nimbus Roman No9 L";*/
	Cairo.TextExtents ex;
	int[] arraycnt={};	//每行有效列数
	string nmn="";
	int maxcolumn;
	int crow=0;
	int ccol=0;
	int pos=0;


	public DrawOnWindow() {
		title = "numbered musical notation - eexpress - v 1.1";
		destroy.connect (Gtk.main_quit);
		ww=700;
		wh=600;
		set_default_size(ww,wh);
		var drawing_area = new DrawingArea ();
		drawing_area.draw.connect (on_draw);
		add (drawing_area);
		add_events(Gdk.EventMask.KEY_PRESS_MASK);
		setarraycnt(); showdata();
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
			case 'p':
				screenshot();
				stdout.printf("screenshot save at /tmp/nmn.png\n");
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
/*                    t._delimit("-",'?');*/
					t=t.replace("-","");
				}else{
					p=t.last_index_of ("-",0);
/*                    t._delimit(",.",'?');*/
					t=t.replace(",","");
					t=t.replace(".","");
				}
/*                if(p<0)p=t.last_index_of ("'",0);*/
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
			case 'a':
				changedate(nmn+"0");
				arraycnt[crow]++;
				break;
			case 'x':
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
				showdata();
				changedate("\n"+nmn);
				crow++; ccol=0;
				break;
			case 'q':
				create_wav();
				break;
			case '+':
			case '|':
				changedate(e.str);
				break;
			case '#':
			case 'b':
			case '(':
			case ')':
				string t=nmn;
				if(t.contains(e.str)){ t=t.replace(e.str,""); }else{ t+=e.str; }
				changedate(t);
				break;
			case 'u':
				if(old0!=""){
					notation=old0;
					old0=old1; old1=old2; old2="";
				}
				break;
			case 'c':
				FontChooserDialog dialog;
				dialog = new FontChooserDialog("nmn",this);
				dialog.preview_text="nmn 选择简谱的显示字体。 123";
				dialog.set_font("%s %d".printf(fontname, size));
				dialog.set_show_preview_entry(false);
				if (dialog.run () == Gtk.ResponseType.OK) {
					fontname=dialog.get_font_family().get_name();
					size=dialog.get_font_size()/1024;
					if(size<8||size>36)size=16;
				}
				dialog.close();
				break;
			case 'w':
				try{
					string s=notation+"\n:"+lyric1+"\n:"+lyric2;
					FileUtils.set_contents("/tmp/nmn.nmn", s, -1);
				} catch (GLib.Error e) {error ("%s", e.message);}
				stdout.printf("notation save to /tmp/nmn.nmn\n");
				break;
			}
			setarraycnt(); showdata();
			drawing_area.queue_draw_area(0,0,ww,wh);
			return false;
		});
	}

	private void changedate(string s){
		string t0,t1;
		old2=old1;
		old1=old0;
		old0=notation;
		t0=notation.slice(0,pos);
		t1=notation.substring(pos+nmn.length,-1);
		notation=t0+s+t1;
	}

	private void showdata(){
/*        find nmn pos with crow ccol*/
		int posbegin=0, posend;
		int l,cnt=0;
		char c;
		for(l=0;l<crow;l++){
			posbegin=notation.index_of_char('\n',posbegin+1);
		}
		posend=notation.index_of_char('\n',posbegin+1);
		for(l=posbegin;l<posend;l++){
			c=notation[l];
			if((c>='0' && c<'8') || c=='+' || (c=='|' && notation[l+1]!='|')){
				if(cnt==ccol){
					string t=notation.substring(l+1,-1);
					t._delimit("01234567+|\n",'\0');
					nmn=c.to_string()+t;
					pos=l;
					break;
				}
				cnt++;
			}
		}
	}

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
				if((c>='0' && c<'8') || c=='+' || (c=='|' && s[l+1]!='|'))
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
		on_draw(ctx);
		surface.write_to_png ("/tmp/nmn.png");
	}

	private void create_wav(){
		int i=7;
		int oldr=crow;
		int oldc=ccol;
		string wav="";
		for(crow=0;crow<arraycnt.length;crow++){
			for(ccol=0;ccol<arraycnt[crow];ccol++){
				showdata();
				int j=400;
				if(nmn.contains("|"))continue;
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
				if(i<0)i=0; if(i>tone.length)i=0;
				wav+="%s:%d 0:20 ".printf(tone[i],j);
			}
		}
/*        stdout.printf("wav->%s\n",wav);*/
		crow=oldr; ccol=oldc;
		try{
			FileUtils.unlink("/tmp/nmn.wav");
			spawn_command_line_async("tones -w /tmp/nmn.wav "+wav);
			spawn_command_line_async("aplay /tmp/nmn.wav");
		} catch (GLib.Error e) {error ("%s", e.message);}
	}

	private bool on_draw (Context ctx) {
		double bw, bh;		//单元格尺寸
		double vspace;		//垂直标记的间隔
		int dncnt=0, upcnt=0;	//垂直位置计数
		double fixheight;		//初始的固定高度，字宽度变化大。
		int pagex;
		int lyp0=0;
		int lyp1=0;

		ctx.select_font_face(fontname,FontSlant.NORMAL,FontWeight.BOLD);
		ctx.set_font_size(size);
		ctx.set_line_width(0.5);
		ctx.text_extents("8",out ex);
		fixheight=ex.height;
/*        尺寸由字体高度决定*/
		vspace=fixheight/3;
		bw=fixheight*1.8;		//目前是最长行的最紧格式宽度
		bh=fixheight*7;
		pagex=(int)(bw*2);
		if(lyric2!=""){bh=fixheight*8;}
/*        resize((int)(pagex*2+maxcolumn*bw),(int)((arraycnt.length+2)*bh));*/
		resize((int)(pagex*2+maxcolumn*bw),(int)(bh*3+(arraycnt.length-1)*bh));

		ctx.set_source_rgba (0.8, 0.8, 0.8, 0.4);
		ctx.paint();
		ctx.set_source_rgb (0, 0, 0);
/*----------------------------------------------------------*/
		string ss;
		int row=0, col=0;
		double x=0, y;		//由row,col计算出来
		double x0=0;		//上连括号

		foreach(string line in notation.split("\n")){
			y=bh+row*bh;
			if(line=="")continue;
/*            右边缘对齐*/
			double adj=arraycnt[row];
			if(maxcolumn-adj>3){adj=1;}/*差距太大，不做调整*/
			else{ adj=1+(maxcolumn-adj)/(adj-0.5); }
			bw=fixheight*1.8*adj;
		for(int l=0; l<line.length; l++){
			char i=line[l];
			if((i>='0' && i<'8') || i=='+' || i=='|'){
				x=pagex+col*bw+bw/2;	//x是格子中心坐标
				if(row==crow && col==ccol){
					ctx.set_source_rgba (0, 0, 1, 0.4);
					ctx.rectangle(x-bw/2,y-bh/4,bw,bh);
					ctx.fill();
					ctx.set_source_rgb (0, 0, 0);
				}
				col++;
			}
			if(i!='-'&&i!='.'){dncnt=0;}
			if(i!=','){upcnt=0;}
			if(i>='0' && i<'8'){
				ctx.move_to(x-centerpos(ctx,i.to_string()),y);
				ctx.show_text(i.to_string());

				if(lyric1!=""){
					while(!lyric1.valid_char(lyp0) && lyp0<lyric1.length) lyp0++;
					ss=lyric1.get_char(lyp0).to_string();
					if(ss!="\n"){
						lyp0++;
						if(ss=="'"){
							int k=lyric1.index_of("'",lyp0);
							ss=lyric1.slice(lyp0,k);
							lyp0=k+1;
						}
						ctx.move_to(x-centerpos(ctx,ss.get_char(0).to_string()),y+fixheight*3);
						ctx.show_text(ss);
					}
				if(lyric2!=""){
					while(!lyric2.valid_char(lyp1) && lyp1<lyric2.length) lyp1++;
					ss=lyric2.get_char(lyp1).to_string();
					if(ss!="\n"){
						lyp1++;
						if(ss=="'"){
							int k=lyric2.index_of("'",lyp1);
							ss=lyric2.slice(lyp1,k);
							lyp1=k+1;
						}
						ctx.move_to(x-centerpos(ctx,ss.get_char(0).to_string()),y+fixheight*5);
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
			switch(i){
			case '|':
				if(line[l+1]=='|'){
					l++;
					ctx.move_to(x,y-bh/4);
					ctx.rel_line_to(0,bh/2);
					ctx.stroke();
					ctx.set_line_width(size/5);
					ctx.move_to(x+size/4,y-bh/4);
					ctx.rel_line_to(0,bh/2);
					ctx.stroke();
					ctx.set_line_width(0.5);
				}else{
					ctx.move_to(x,y-bh/4);
					ctx.line_to(x,y+bh/4);
					ctx.stroke();
				}
				break;
			case '#':
			case 'b':
				ctx.move_to(x+bw/2,y-fixheight+vspace/4);
				ctx.set_font_size(size/2);
				ctx.show_text(i.to_string());
				ctx.set_font_size(size);
				break;
			case '+':
				ss="-";
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
				x0=x; break;
			case ')':
				double by=y-fixheight-vspace;
				ctx.move_to(x0,by);
				ctx.curve_to(x0+vspace,by-vspace,x-vspace,by-vspace,x,by);
				ctx.stroke();
				break;
			}
		}
		row++; col=0;
		}
/*        显示标题*/
		double vh=bh*2/4;
		this.get_size(out ww,out wh);
		ctx.move_to(ww/2-centerpos(ctx,filename), vh);
		ctx.show_text(filename);
		ctx.set_source_rgba (0, 0, 1, 0.5);
		ctx.move_to(bw*2,vh);
		ctx.show_text("%d,%d <%s>".printf(crow,ccol,nmn));

		vh=wh-bh;
		ctx.set_font_size(size*3/4);
		foreach(string s in help.split("\n")){
			ctx.move_to(bw*2,vh);
			ctx.show_text(s);
			vh+=fixheight*1.5;
		}
		ctx.set_font_size(size);
/*        ctx.set_source_rgb (0, 0, 0);*/
		return true;
	}

	private double centerpos(Context ctx, string s){
		ctx.text_extents(s,out ex);
		return ex.width/2 + ex.x_bearing;
	}
	
	static int main (string[] args) {
		Gtk.init (ref args);
		filename="Sample";
		if(args[1]==null) notation=instr;
		else{
			try{
				File f=File.new_for_path(args[1]);
				if(f.query_exists() == true){
					FileUtils.get_contents(args[1], out notation);
					filename=f.get_basename();
				}else{
					notation=instr;
				}
			} catch (GLib.Error e) {error ("%s", e.message);}
		}
		if(notation.contains(":")){
			string[] s=notation.split(":",3);
			notation=s[0]; lyric1=s[1]; lyric2=s[2];
		}
		if(lyric1==null)lyric1="";
		if(lyric2==null)lyric2="";
		old0=""; old1=""; old2="";
/*        stdout.printf("notation : %s\n",notation);*/
/*        stdout.printf("lyric1 : %s\n",lyric1);*/
/*        stdout.printf("lyric2 : %s\n",lyric2);*/
		var DW = new DrawOnWindow ();
		DW.show_all ();
		Gtk.main ();
		return 0;
	}
}
