using Gtk;
using Cairo;
	
string city;
string weather;
string appname;
string sharepath;
string conffile;
const int segw=138;
const int segh=24;
const int w0=30;
const int h0=40;
int ww;
int wh;
const string outputfile="/tmp/cw.png";
/*config*/
double scale=1;
string fontname;
string web;
/*string pos="-80,80";*/

const int zoom[]={6,5,4,3,2,1,0,0,0,0,0,1,2,3,4,5,6};
/*const int zoom[]={6,5,4,3,2,1,0,1,2,3,2,1,0,1,2,3,4,5,6};*/
const string w[] = {
	"", "", "","","",
	"", "", "雨夹雪","阵雨","小雨",
	"中雨", "大雨", "暴雨","小雪","中雪",
	"大雪", "暴雪", "雷阵雨","","",
	"", "", "","","",
	"", "多云", "","","",
	"", "阴", "晴","","",
	"", "", "","","",
	"", "", "","",""
};
const string weekchar[]={"","壹","貳","叁","肆","伍","陸","日"};

public class DrawWeather : Gtk.Window {

	public	Gdk.RGBA c;
	public int step=zoom.length;
	ImageSurface png;
	ImageSurface appicon0;
	ImageSurface appicon1;
	string todaypng0="";
	string todaypng1="";

    public DrawWeather() {
		ww=(int)((7*segw+w0*2)*scale);
		wh=(int)((8*segh+h0*2)*scale);
        title = "DrawWeather";
		skip_taskbar_hint = true;
		decorated = false;
		set_visual(this.get_screen().get_rgba_visual());
		stick();
		set_keep_below(true);
		set_default_size(ww,wh);
        destroy.connect (Gtk.main_quit);

		var surface = new ImageSurface (Format.ARGB32, ww*2, wh*2);
		var ctx = new Cairo.Context (surface);
		drawpng (ctx);
		surface.write_to_png (outputfile);
		png = new ImageSurface.from_png(outputfile);
		appicon0 = new ImageSurface.from_png(todaypng0);
		appicon1 = new ImageSurface.from_png(todaypng1);

		add_events (Gdk.EventMask.BUTTON_PRESS_MASK|Gdk.EventMask.SCROLL_MASK|Gdk.EventMask.ENTER_NOTIFY_MASK);
        draw.connect ((da,ctx)=>{
			ctx.set_operator (Cairo.Operator.SOURCE);
			ctx.scale(scale/2,scale/2);
			ctx.set_source_surface(png,0,0);
			ctx.paint();
			if(step<zoom.length){
				var i=Math.cos(zoom[step]*15*Math.PI/180);
				ctx.set_operator (Cairo.Operator.OVER);
				ctx.scale(2*i,2*i);
				ctx.set_source_surface(appicon0,appicon0.get_width()/2*(1-i)+zoom[step]*10,appicon0.get_height()/2*(1-i)+w0);
				ctx.paint();
				ctx.set_source_surface(appicon1,appicon1.get_width()/2*(1-i)+h0+zoom[step]*100,appicon1.get_height()/2*(1-i)+h0+w0);
				ctx.paint();
			}
			return true;
			});
		enter_notify_event.connect ((e) => {
			step=0;
			GLib.Timeout.add(80,()=>{
				step++;
				queue_draw();
				if(step<zoom.length)return true; else return false;
				});
			return true;
			});
		button_press_event.connect ((e) => {
			if(e.button == 1){
				begin_move_drag ((int) e.button, (int) e.x_root, (int) e.y_root, e.time);
			} else {Gtk.main_quit();}
			this.move(get_screen().get_width()-ww-segh,segh*3);
			return true;
		});
		scroll_event.connect ((e) => {
			if(e.direction==Gdk.ScrollDirection.UP){
				scale/=0.9;
				if(scale>1.5)scale=1.5;
			}
			if(e.direction==Gdk.ScrollDirection.DOWN){
				scale*=0.9;
				if(scale<0.5)scale=0.5;
			}
			ww=(int)((7*segw+w0*2)*scale);
			wh=(int)((8*segh+h0*2)*scale);
			this.resize(ww,wh);
			return true;
		});
    }

    private void drawpng (Context ctx) {
		var now = new DateTime.now_local ();
		var week=now.get_day_of_week();
		ctx.set_operator (Cairo.Operator.OVER);
		ctx.scale(scale*2,scale*2);
		int daycnt=0;
		int oldmonth=0;
		string oldlmonth="";
		foreach(string line in weather.split("\n")){
			int v=0;
			string tcolor;
			if(!line.contains("风"))continue;
			ctx.select_font_face(fontname,FontSlant.NORMAL,FontWeight.BOLD);
			if(daycnt==0){
				tcolor="#E55E23";
				frame(ctx,w0/2,0,segw,8*segh+h0*2,0);
				stamp(ctx, w0*3, h0*4.8, weekchar[week], 56,0.4);
				stamp(ctx, 3*segw+w0,7*segh+h0*2,now.get_year().to_string()+" "+city,22,0.2);
			} else if(week==6 || week==7 ){
				tcolor="#A54E13";
				frame(ctx,daycnt*segw+w0/2,0,segw,8*segh+h0*2,1);
			} else tcolor="#C8C8C8";
			int month=now.get_month ();
			int day=now.get_day_of_month ();
			string date;
			if(oldmonth!=month){date=month.to_string()+"月"+day.to_string()+"日"; oldmonth=month;}
			else date=day.to_string()+"日";
// lunar
			try{
				string calendar=sharepath+"calendar/calendar."+now.get_year().to_string()+".lunar";
				var file = File.new_for_path(calendar);
				if(file.query_exists() == true){
					string file_contents;
					string lmonth="";
					string lunar="";
					FileUtils.get_contents(calendar, out file_contents);
					foreach(string l in file_contents.split("\n")){
						if(l.contains("月")) lmonth=l.split("\t",0)[1];
						if(l.contains("%s/%s".printf(month.to_string(),day.to_string()))){
							lunar=l.split("\t",0)[1];
							if(!date.contains("月") && oldlmonth!=lmonth && !lunar.contains("月")) {
								date=date+"-"+lmonth+lunar;oldlmonth=lmonth;}
							else date=date+"-"+lunar;
							break;
						}
					}
				}
			} catch (Error e) {error ("%s", e.message);}

			line=date+"\t"+line;
			string[] item = line.split ("\t");
			foreach (string str in item){
				if(str.contains("201")) continue;
				if(str.contains("风")) ctx.set_font_size(13);else ctx.set_font_size(16);
				if(v==6){
					string[] two=str.split("转",2);
					int p=0;
					ImageSurface img;
					ctx.save(); ctx.translate(daycnt*segw+w0,1*segh+h0); ctx.scale(0.6,0.6);
					foreach(string s in two){
						if(s.contains("-")) s=s.substring(s.index_of("-",0)+1,-1);
						for(int i = 0; i < w.length ; i++){
							if(s==w[i]){
								var sp=sharepath+"weather-icon/"+"%02d.png".printf(i);
								if(daycnt==0){
									if(p==0)todaypng0=sp;
									else todaypng1=sp;
								}
								img=new ImageSurface.from_png(sp);
								ctx.set_source_surface(img,p*h0,p*h0);
								ctx.paint();
								break;
							}
						}
						p++;
					}
					ctx.restore();
				}
				c.parse("#141414"); ctx.set_source_rgba(c.red,c.green,c.blue,0.8);
				ctx.move_to(daycnt*segw+w0+1,v*segh+h0+1);
				ctx.show_text(str);
				c.parse("#C4C4C4"); ctx.set_source_rgba(c.red,c.green,c.blue,0.2);
				ctx.move_to(daycnt*segw+w0-1,v*segh+h0-1);
				ctx.show_text(str);
				c.parse(tcolor); ctx.set_source_rgba(c.red,c.green,c.blue,0.8);
				ctx.move_to(daycnt*segw+w0,v*segh+h0);
				ctx.show_text(str);
				if(v==0) v=v+5; v++;
			}
			daycnt++; week++; now=now.add_days(1);
		}
	}

	private void stamp(Context ctx, double x, double y, string s, int size, double rotate){
		ctx.save();
		ctx.set_font_size(size);
		ctx.set_operator (Cairo.Operator.SATURATE);
		for(double i=0; i<size/10; i++){
			double j, a;
			if(i==0) {j=1.5;a=0.58;} else {j=1;a=0.73;i++;}
			c.parse("#E55E23");
			ctx.set_source_rgba((c.red-i/3)/j,(c.green-i/3)/j,(c.blue-i/3)/j,a);
			ctx.move_to(x-i,y+i);
			ctx.rotate(-rotate);
			ctx.text_path(s);
			ctx.fill_preserve();
			ctx.stroke();
			ctx.rotate(rotate);
		}
		ctx.restore();
	}

	private void frame(Context ctx, int x, int y, int w, int h, int style){
			ctx.save();
			ctx.move_to(x,y);
			int r; double alpha;
			if(w<h) r=w/8; else r=h/8;
			ctx.rel_move_to(r,0);
			ctx.rel_line_to(w-2*r,0);
			ctx.rel_curve_to(0,0,r,0,r,r);
			ctx.rel_line_to(0,h-2*r);
			ctx.rel_curve_to(0,0,0,r,-r,r);
			ctx.rel_line_to(-(w-2*r),0);
			ctx.rel_curve_to(0,0,-r,0,-r,-r);
			ctx.rel_line_to(0,-(h-2*r));
			ctx.rel_curve_to(0,0,0,-r,r,-r);
			if(style==0)alpha=0.4;else alpha=0.2;
			c.parse("#141414"); ctx.set_source_rgba(c.red,c.green,c.blue,alpha);
			ctx.fill();
			ctx.restore();
			ctx.save();

			ctx.set_line_cap(Cairo.LineCap.BUTT);
			ctx.set_line_join(Cairo.LineJoin.ROUND);
			ctx.set_operator(Cairo.Operator.CLEAR);
			int l=12; int lw=4;
			ctx.set_line_width(lw);
			for(int i=0; i<l; i++){
				ctx.move_to(x,wh/4+i*lw*2);
				if(style==0) ctx.rel_curve_to(segw/3,l*2,segw*2/3,-l*2,segw,0); else {
				int[] t={1,-1,1,-1};foreach(int seg in t) ctx.rel_line_to(segw/4+1,seg*l);
				}
				ctx.stroke();
			}
			ctx.restore();
	}

    static int main (string[] args) {
        Gtk.init (ref args);
		string line;
		web="http://qq.ip138.com/weather/hunan/ChangSha.wml";
		fontname="Vera Sans YuanTi";
		appname=GLib.Path.get_basename(args[0]);
		sharepath="/usr/share/"+appname+"/";
		conffile=Environment.get_variable("HOME")+"/.config/"+appname+"/config";
		stdout.printf(conffile+" : url, font, scale.\n");
	try{
		var conf=File.new_for_path(conffile);
		var rc = new DataInputStream (conf.read ());
		while ((line = rc.read_line (null)) != null) {
			if(line.contains("#")) continue;
			if(!line.contains("=")) continue;
			string[] k=line.split("=",2);
			stdout.printf(k[0]+" -> "+k[1]+"\n");
			if(k[0]=="url") web=k[1];
			if(k[0]=="font") fontname=k[1];
			if(k[0]=="scale") scale=double.parse(k[1]);
		}
		if(args[1].contains("qq.ip138.com")) web=args[1];
		var url=File.new_for_uri(web);
		var dis = new DataInputStream (url.read ());
		while ((line = dis.read_line (null)) != null) {
			if(line.contains("天气预报<br/>")){
				city=line.replace("天气预报<br/>","")._chomp();
			}
			if(line.contains("星期")){
				weather=line.replace("<br/>","\t").replace("<b>","\n").replace("</b>","").replace("星期","");
				stdout.printf(weather+"\n");
			}
		}
	} catch (Error e) {error ("%s", e.message);}

        var DW = new DrawWeather ();
        DW.show_all ();
		DW.move(DW.get_screen().get_width()-ww-segh,segh*3);
        Gtk.main ();
        return 0;
    }
}
