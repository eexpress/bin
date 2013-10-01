/*● /usr/bin/valac --pkg gtk+-3.0 nmn.vala ; [ $? -eq 0 ] && ./nmn*/

using Gtk;
using Cairo;

/*string fontname;*/
/*const string outputfile="/tmp/nmn.png";*/
/*const string alphatable="d1 r2 m3 f4 s5 l6 x7 t7";*/
/*const string input[]={"1d2","3b3","44","2d1","|","34","2e0","7a2","5e3"};*/

/*const string instr=""" 333-4#4-|5+0-5-#4-5-|666-71-,|5++(6-5-)|*/
/*2++6-5-|3++4-3-|23#4-(56-)|5++0|*/
/*333-(4#4-)|5+0-5-#4-5-|666-(71-,)|3,++4-,3-,|*/
/*2,+63-,2-,|1,+5#4-5-|66-6--7-(65-)|1,++0|| """;*/

const string instr="""
3'越'3'过'3'辽'-4'阔'#4'天'-|5'空，'+0-5'啦'-#4'啦啦'-5-|6'飞'6'向'6'遥'-7'远'1'群'-,|5'星'，++(6'来'-5-)|
2'吧！'++6'阿'-5'童'-|3'木'++4'爱'-3'科'-|2'学'3'的'#4'好'-(5'少'6-)|5'年'++0|
3'善'，3'良'3'勇'-(4'敢'#4'的'-)|5+0-5'啦'-#4'啦'-5'啦'-|6'铁'6'臂'6'阿'-(7'童'1-,)|3'木',++4'十'-,3'万'-,|
2'马',+6'力，'3'七'-,2'大'-,|1'神',+5'力，'#4'无'-5'私'-|6'无'6'畏'-6'的'--7'阿'-(6'童'5-)|1'木',++0|| """;

/*const string lyric=""" 越过辽阔天空，啦啦啦飞向遥远群星，来*/
/*吧！阿童木爱科学的好少年*/
/*善，良勇敢的啦啦啦铁臂阿童木十万*/
/*马力，七大神力，无私无畏的阿童木 """;*/

const string tone[]={"","Do","Re","Mi","Fa","Sol","La","Si"};
string contents;

public class DrawOnWindow : Gtk.Window {
	int ww;
	int wh;
	int size=20;
	string fontname="Vera Sans YuanTi";
/*    string fontname="Nimbus Roman No9 L";*/
	Cairo.TextExtents ex;
	double bw;
	double bh;
	double vspace;
	double textheight;
	int pagex;
	int pagey;
	bool lyric;
	int[] arraycnt={};
	int maxcolumn;
	int dncnt;
	int upcnt;
/*    int maxrow;*/


	public DrawOnWindow() {
		title = "numbered musical notation - eexpress - v 1.0";
		destroy.connect (Gtk.main_quit);
		ww=700;
		wh=600;
		set_default_size(ww,wh);
		var drawing_area = new DrawingArea ();
		drawing_area.draw.connect (on_draw);
		add (drawing_area);
/*        drawing_area.destroy.connect (on_destroy);*/
/*        key_press_event.connect ((e) => {*/
/*            return true;*/
/*        });*/
		setarraycnt();
	}

	void setarraycnt(){
		foreach(string s in contents.split("\n")){
			int cnt=0;
			for(int i=0;i<s.length;i++){
				char j=s[i];
				if(j>='0'&&j<='7'){cnt++;continue;}
				if(j=='+'){cnt++;continue;}
				if(j=='|'&&s[i+1]!='|'){cnt++;continue;}
			}
			if(cnt==0)continue;
			arraycnt+=cnt;
			if(cnt>maxcolumn){maxcolumn=cnt;}
		}
/*            stdout.printf("\n---------> arraycnt:");*/
/*            foreach(int x in arraycnt){ stdout.printf(x.to_string()+","); }*/
/*            stdout.printf("\b\t maxcolumn:%d\t maxrow:%d\n", maxcolumn, arraycnt.length);*/
	}

/*    private bool on_destroy(){*/
/*        var surface = new ImageSurface (Format.ARGB32, 800, 800);*/
/*        var ctx = new Cairo.Context (surface);*/
/*        on_draw(ctx);*/
/*        surface.write_to_png ("/tmp/nmn.png");*/
/*    }*/

/*    private bool on_draw (Widget da, Context ctx) {*/
	private bool on_draw (Context ctx) {
	double x;
	double y;
	string ss;
	double bx0=0;
	double bx1=0;
/*        setup size according to font size*/
		ctx.select_font_face(fontname,FontSlant.NORMAL,FontWeight.BOLD);
		ctx.set_font_size(size);
		ctx.set_line_width(0.5);
		ctx.text_extents("8",out ex);
		textheight=ex.height;
		vspace=textheight/3;
		bw=textheight*1.8;
		bh=textheight*6;
		pagex=(int)textheight*4;
		pagey=(int)textheight*6;
		resize(pagex*2+(int)((maxcolumn-1)*bw),pagey*2+(int)(arraycnt.length*bh));

		ctx.set_source_rgb (0, 0, 0);
		lyric=contents.contains("'");
		x=pagex;
		y=pagey;
/*        stdout.printf("Start Draw. -------------\n");*/
/*----------------------------------------------------------*/
		int loop=0;
		foreach(string line in contents.split("\n")){
/*            adjust align*/
			if(line=="")continue;
/*            double adj=calwidth(line);*/
			double adj=arraycnt[loop]; loop++;
			if(maxcolumn-adj>3){adj=1;}else{
				adj=1+(maxcolumn-adj)/(adj-0.5);
			}
			bw=textheight*1.8*adj;
		for(int l=0; l<line.length; l++){
			char i=line[l];
			if(i!='-'&&i!='.'){dncnt=0;}
			if(i!=','){upcnt=0;}
			if(i>='0' && i<'8'){
				ctx.move_to(x-centerpos(ctx,i.to_string()),y);
				ctx.show_text(i.to_string());

				if(lyric){
					if(line[l+1]=='\''){
						ss=line.substring(l+2,-1);
						ss=ss.substring(0,ss.index_of_char('\'',0));
/*                        ss=line.substring(l+2,-1).delimit("'",'\0');*/
/*                        ss=line.substring(l+2,-1).replace("'*","");*/
/*                        delimit 需要类型‘gchar *’，但实参的类型为‘const gchar *’*/
/*                    左对齐歌词*/
						ctx.move_to(x-centerpos(ctx,i.to_string()),y+vspace*7);
						ctx.show_text(ss);
						l+=ss.length;
					}
				}else{
					ss=tone[i-'0'];
					ctx.set_font_size(size/1.2);
					ctx.move_to(x-centerpos(ctx,ss),y+vspace*7);
					ctx.show_text(ss);
					ctx.set_font_size(size);
				}
				x+=bw; continue;
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
				x+=bw; break;
			case '#':
				ctx.move_to(x-bw/2,y-ex.height+vspace/4);
				ctx.set_font_size(size/2);
				ctx.show_text("#");
				ctx.set_font_size(size);
				break;
/*            case '\n': x=pagex; y=y+bh; break;*/
			case '+':
				ss="-";
				ctx.move_to(x-centerpos(ctx,ss),y-vspace);
				ctx.show_text(ss); x+=bw; break;
			case '-':
				dncnt++;
				ctx.move_to(x-bw/2,y+dncnt*vspace); ctx.rel_line_to(-bw,0);
				ctx.stroke(); break;
			case '.':
				dncnt++;
				ctx.arc(x-bw,y+dncnt*vspace,size/7,0,360*Math.PI/180);
				ctx.fill(); break;
			case ',':
				upcnt++;
				ctx.arc(x-bw,y-textheight-upcnt*vspace,size/7,0,360*Math.PI/180);
				ctx.fill(); break;
			case '(':
				bx0=x; break;
			case ')':
				bx1=x-bw;
				double by=y-textheight-vspace;
				ctx.move_to(bx0,by);
				ctx.curve_to(bx0+vspace,by-vspace,bx1-vspace,by-vspace,bx1,by);
				ctx.stroke();
				break;
			}
		}
		x=pagex; y=y+bh;
		}
		return true;
	}

	private double centerpos(Context ctx, string s){
		ctx.text_extents(s,out ex);
		return ex.width/2 + ex.x_bearing;
	}
	
	static int main (string[] args) {
		Gtk.init (ref args);
		if(args[1]==null) contents=instr;
		else{
			try{
				if(File.new_for_path(args[1]).query_exists() == true){
					FileUtils.get_contents(args[1], out contents);
				}else{
					contents=instr;
				}
			} catch (GLib.Error e) {error ("%s", e.message);}
		}
		var DW = new DrawOnWindow ();
		DW.show_all ();
		Gtk.main ();
		return 0;
	}
}
