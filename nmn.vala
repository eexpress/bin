/*● /usr/bin/valac --pkg gtk+-3.0 nmn.vala ; [ $? -eq 0 ] && ./nmn*/

using Gtk;
using Cairo;

/*string fontname;*/
/*const string outputfile="/tmp/nmn.png";*/
/*const string alphatable="d1 r2 m3 f4 s5 l6 x7 t7";*/
/*const string input[]={"1d2","3b3","44","2d1","|","34","2e0","7a2","5e3"};*/

/*" 越过辽阔天空，啦啦啦飞向遥远群星，来吧！阿童木爱科学的好少年善，良勇敢的啦啦啦铁臂阿童木十万马力，七大神力，无私无畏的阿童木 "*/

/*const string instr=""" 333-4#4-|5+0-5-#4-5-|666-71-,|5++(6-5-)|*/
/*2++6-5-|3++4-3-|23#4-(56-)|5++0|*/
/*333-(4#4-)|5+0-5-#4-5-|666-(71-,)|3,++4-,3-,|*/
/*2,+63-,2-,|1,+5#4-5-|66-6--7-(65-)|1,++0|| """;*/

const string instr="""
3'越:穿'3'过:'3'辽:广'-4'阔:'#4'天:大'-|5'空，:地，'+0-5'啦:'-#4'啦啦:'-5-|6'飞:潜'6'向:入'6'遥:深'-7'远:深'1'群:海'-,|5'星，:洋，'，++(6'来:'-5-)|
2'吧！:'++6'阿:'-5'童:'-|3'木:'++4'爱:'-3'科:'-|2'学:'3'的:'#4'好:'-(5'少:'6-)|5'年。:'++0|
3'善:'，3'良:'3'勇:'-(4'敢:'#4'的:'-)|5+0-5'啦:'-#4'啦:'-5'啦:'-|6'铁:'6'臂:'6'阿:'-(7'童:'1-,)|3'木，:',++4'十:我'-,3'万'-,|
2'马:们',+6'力，:的'3'七:好'-,2'大:朋'-,|1'神:友',+5'力，:啊'#4'无:'-5'私:'-|6'无:'6'畏:'-6'的:'--7'阿:'-(6'童:'5-)|1'木。:',++0|| """;


const string tone[]={"","Do","Re","Mi","Fa","Sol","La","Si"};
string contents;
string filename;

public class DrawOnWindow : Gtk.Window {
	int ww;
	int wh;		//窗口尺寸
	int size=20;	//字体尺寸
	string fontname="Vera Sans YuanTi";
/*    string fontname="Nimbus Roman No9 L";*/
	Cairo.TextExtents ex;
	int[] arraycnt={};	//每行有效列数
	int maxcolumn;
	int crow=3;
	int ccol=5;


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
				if((j>='0' && j<'8') || j=='+' || (j=='|' && s[i+1]!='|'))
				{cnt++;continue;}
			}
			if(cnt==0)continue;
			arraycnt+=cnt;
			if(cnt>maxcolumn){maxcolumn=cnt;}
		}
	}

/*    private bool on_destroy(){*/
/*        var surface = new ImageSurface (Format.ARGB32, 800, 800);*/
/*        var ctx = new Cairo.Context (surface);*/
/*        on_draw(ctx);*/
/*        surface.write_to_png ("/tmp/nmn.png");*/
/*    }*/

/*    private bool on_draw (Widget da, Context ctx) {*/
	private bool on_draw (Context ctx) {
		double bw, bh;		//单元格尺寸
		double vspace;		//垂直标记的间隔
		int dncnt=0, upcnt=0;	//垂直位置计数
		double fixheight;		//初始的固定高度，字宽度变化大。
		bool lyric;
		int pagex, pagey;

		ctx.select_font_face(fontname,FontSlant.NORMAL,FontWeight.BOLD);
		ctx.set_font_size(size);
		ctx.set_line_width(0.5);
		ctx.text_extents("8",out ex);
		fixheight=ex.height;
/*        尺寸由字体高度决定*/
		vspace=fixheight/3;
		bw=fixheight*1.8;		//目前是最长行的最紧格式宽度
		bh=fixheight*5;
		pagex=(int)(bw*2);
		pagey=(int)(bh*2);
		resize((int)(pagex*2+maxcolumn*bw),(int)(pagey*2+arraycnt.length*bh));

		ctx.set_source_rgb (0, 0, 0);
		lyric=contents.contains("'");
		if(contents.contains(":")){bh=fixheight*8;}
/*        stdout.printf("Start Draw. -------------\n");*/
/*----------------------------------------------------------*/
		string ss;
		int row=0, col=0;
		double x=0, y;		//由row,col计算出来
		double x0=0;		//上连括号

		foreach(string line in contents.split("\n")){
			y=pagey+row*bh-bh/4;
			if(line=="")continue;
/*            右边缘对齐*/
			double adj=arraycnt[row];
			if(maxcolumn-adj>3){adj=1;}/*差距太大，不做调整*/
			else{ adj=1+(maxcolumn-adj)/(adj-0.5); }
			bw=fixheight*1.8*adj;
			row++;
			col=0;
		for(int j=0; j<line.length; j++){
			char i=line[j];
			if((i>='0' && i<'8') || i=='+' || i=='|'){
				x=pagex+col*bw+bw/2;	//x是格子中心坐标
				col++;
				if(row==crow && col==ccol){
					ctx.set_source_rgba (0, 0, 1, 0.2);
					ctx.rectangle(x-bw/2,y-bh/4,bw,bh);
					ctx.fill();
					ctx.set_source_rgb (0, 0, 0);
				}
			}
			if(i!='-'&&i!='.'){dncnt=0;}
			if(i!=','){upcnt=0;}
			if(i>='0' && i<'8'){
				ctx.move_to(x-centerpos(ctx,i.to_string()),y);
				ctx.show_text(i.to_string());

				if(lyric){
					if(line[j+1]=='\''){
						ss=line.substring(j+2,-1);
						ss=ss.substring(0,ss.index_of_char('\'',0));
						j+=ss.length;
/*                    左对齐歌词*/
						if(ss.contains(":")){
							string[] sx=ss.split(":",2);
							if(sx[1]=="")sx[1]=sx[0];
							ctx.move_to(x-centerpos(ctx,i.to_string()),y+vspace*4+fixheight*3);
							ctx.show_text(sx[1]);
							ss=sx[0];
						}
						ctx.move_to(x-centerpos(ctx,i.to_string()),y+vspace*2+fixheight*2);
						ctx.show_text(ss);
					}
				}else{
					ss=tone[i-'0'];
					ctx.set_font_size(size/1.2);
					ctx.move_to(x-centerpos(ctx,ss),y+vspace*2+fixheight*2);
					ctx.show_text(ss);
					ctx.set_font_size(size);
				}
				continue;
			}
			switch(i){
			case '|':
				if(line[j+1]=='|'){
					j++;
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
				ctx.move_to(x+bw/2,y-fixheight+vspace/4);
				ctx.set_font_size(size/2);
				ctx.show_text("#");
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
				x0=x+bw; break;
			case ')':
				double by=y-fixheight-vspace;
				ctx.move_to(x0,by);
				ctx.curve_to(x0+vspace,by-vspace,x-vspace,by-vspace,x,by);
				ctx.stroke();
				break;
			}
		}
		}
		this.get_size(out ww,out wh);
		ctx.move_to(ww/2-centerpos(ctx,filename), bh/2);
		ctx.show_text(filename);
		return true;
	}

	private double centerpos(Context ctx, string s){
		ctx.text_extents(s,out ex);
		return ex.width/2 + ex.x_bearing;
	}
	
	static int main (string[] args) {
		Gtk.init (ref args);
		filename="Sample";
		if(args[1]==null) contents=instr;
		else{
			try{
				File f=File.new_for_path(args[1]);
				if(f.query_exists() == true){
					FileUtils.get_contents(args[1], out contents);
					filename=f.get_basename();
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
