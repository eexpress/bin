/*● /usr/bin/valac --pkg gtk+-3.0 nmn.vala ; [ $? -eq 0 ] && ./nmn*/

using Gtk;
using Cairo;

/*string fontname;*/
/*const string outputfile="/tmp/nmn.png";*/
/*const string alphatable="d1 r2 m3 f4 s5 l6 x7 t7";*/
/*const string input[]={"1d2","3b3","44","2d1","|","34","2e0","7a2","5e3"};*/

const string instr=""" 333-4#4-|5+0-5-#4-5-|666-71-,|5++(6-5-)|
2++6-5-|3++4-3-|23#4-(56-)|5++0|
333-(4#4-)|5+0-5-#4-5-|666-(71-,)|3,++4-,3-,|
2,+63-,2-,|1,+5#4-5-|66-6--7-(65-)|1,++0||
""";
const string tone[]={"","Do","Re","Mi","Fa","Sol","La","Si"};
const int pagex=50;
const int pagey=80;
string contents;
int dncnt;
int upcnt;
int maxtoneperline;

int calwidth(string s){
	int cnt=0;
	for(int i=0;i<s.length;i++){
		char j=s[i];
		if(j>='0'&&j<='7'){cnt++;continue;}
		if(j=='+'){cnt++;continue;}
		if(j=='|'&&s[i+1]!='|'){cnt++;continue;}
	}
	return cnt;
}

public class DrawOnWindow : Gtk.Window {
	int ww;
	int wh;
	int size=20;
	string fontname="Nimbus Roman No9 L";
	Cairo.TextExtents ex;
	double bw;
	double bh;
	double vspace;
	double textheight;


	public DrawOnWindow() {
		title = "numbered musical notation - eexpress - v 1.0";
		destroy.connect (Gtk.main_quit);
		ww=700;
		wh=600;
		set_default_size(ww,wh);
		var drawing_area = new DrawingArea ();
		drawing_area.draw.connect (on_draw);
		add (drawing_area);
/*        key_press_event.connect ((e) => {*/
/*            return true;*/
/*        });*/
	}

	private bool on_draw (Widget da, Context ctx) {
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
/*        bw=textheight*1.8;*/
		bh=textheight*6;

		ctx.set_source_rgb (0, 0, 0);
		x=pagex;
		y=pagey;
/*----------------------------------------------------------*/
		foreach(string line in contents.split("\n")){
/*            adjust align*/
			if(line=="")continue;
			double adj=calwidth(line);
			if(maxtoneperline-adj>3){adj=1;}else{
				adj=1+(maxtoneperline-adj)/adj;
			}
			bw=textheight*1.8*adj;
		for(int l=0; l<line.length; l++){
			char i=line[l];
			if(i!='-'&&i!='.'){dncnt=0;}
			if(i!=','){upcnt=0;}
			if(i>='0' && i<'8'){
				ctx.move_to(x-centerpos(ctx,i.to_string()),y);
				ctx.show_text(i.to_string());

				ss=tone[i-'0'];
				ctx.set_font_size(size/1.2);
				ctx.move_to(x-centerpos(ctx,ss),y+vspace*7);
				ctx.show_text(ss);
				ctx.set_font_size(size);
				x+=bw;
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
				x+=bw;
				break;
			case '#':
				ctx.move_to(x-bw/2,y-ex.height+vspace/4);
				ctx.set_font_size(size/2);
				ctx.show_text("#");
				ctx.set_font_size(size);
				break;
/*            case '\n':*/
/*                x=pagex;*/
/*                y=y+bh;*/
/*                break;*/
			case '+':
				ss="-";
				ctx.move_to(x-centerpos(ctx,ss),y-vspace);
				ctx.show_text(ss);
				x+=bw;
				break;
			case '-':
				dncnt++;
				ctx.move_to(x-bw/2,y+dncnt*vspace); ctx.rel_line_to(-bw,0);
				ctx.stroke();
				break;
			case '.':
				dncnt++;
				ctx.arc(x-bw,y+dncnt*vspace,size/7,0,360*Math.PI/180);
				ctx.fill();
				break;
			case ',':
				upcnt++;
				ctx.arc(x-bw,y-textheight-upcnt*vspace,size/7,0,360*Math.PI/180);
				ctx.fill();
				break;
			case '(':
				bx0=x;
				break;
			case ')':
				bx1=x-bw;
				double by=y-textheight-vspace;
				ctx.move_to(bx0,by);
				ctx.curve_to(bx0+vspace,by-vspace,bx1-vspace,by-vspace,bx1,by);
				ctx.stroke();
				break;
			}
		}
		x=pagex;
		y=y+bh;
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
		foreach(string l in contents.split("\n")){
			int toneinline=calwidth(l);
/*            stdout.printf ("toneinline: %d\n",toneinline);*/
			if(toneinline>maxtoneperline){maxtoneperline=toneinline;}
		}
		var DW = new DrawOnWindow ();
		DW.show_all ();
		Gtk.main ();
		return 0;
	}
}
