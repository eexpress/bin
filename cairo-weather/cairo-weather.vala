using Gtk;
using Cairo;
	
string city;
string weather;
const double scale=1;
const int segw=138;
const int segh=24;
const int h0=30;
const int v0=40;
const int ww=(int)((7*segw+h0*2)*scale);
const int wh=(int)((8*segh+v0*2)*scale);
const string sharepath="/usr/share/cairo-weather/";

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

    private const int SIZE = 30;
	public	Gdk.RGBA c;

    public DrawWeather() {
        title = "DrawWeather";
		skip_taskbar_hint = true;
		decorated = false;
		set_visual(this.get_screen().get_rgba_visual());
		stick();
		set_keep_below(true);
		set_default_size(ww,wh);
        destroy.connect (Gtk.main_quit);
        var drawing_area = new DrawingArea ();
        drawing_area.draw.connect (on_draw);
        add (drawing_area);
		drawing_area.add_events (Gdk.EventMask.BUTTON_PRESS_MASK);
		drawing_area.button_press_event.connect ((e) => {
		if(e.button == 1){
			begin_move_drag ((int) e.button, (int) e.x_root, (int) e.y_root, e.time);
		} else {Gtk.main_quit();}
		this.move(get_screen().get_width()-ww-segh,segh*3);
		return true;
		});
    }

    private bool on_draw (Widget da, Context ctx) {
		var now = new DateTime.now_local ();
		var week=now.get_day_of_week();
		ctx.set_operator (Cairo.Operator.CLEAR);
		ctx.rectangle(0,0,ww,wh); ctx.fill();
		ctx.set_operator (Cairo.Operator.OVER);
		ctx.scale(scale,scale);
		int daycnt=0;
		int oldmonth=0;
		string oldlmonth="";
		foreach(string line in weather.split("\n")){
			int v=0;
			string tcolor;
			if(!line.contains("风"))continue;
			ctx.select_font_face("Vera Sans YuanTi",FontSlant.NORMAL,FontWeight.BOLD);
			if(daycnt==0){
				tcolor="#E55E23";
				frame(ctx,h0/2,0,segw,wh,0);
				stamp(ctx, h0*3, v0*4.8, weekchar[week], 56,0.4);
				stamp(ctx, ww/2-segw,wh-segh,now.get_year().to_string()+" "+city,22,0.2);
			} else if(week==6 || week==7 ){
				tcolor="#A54E13";
				frame(ctx,daycnt*segw+h0/2,0,segw,wh,1);
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
					ctx.save(); ctx.translate(daycnt*segw+h0,1*segh+v0); ctx.scale(0.6,0.6);
					foreach(string s in two){
						if(s.contains("-")) s=s.substring(s.index_of("-",0)+1,-1);
						for(int i = 0; i < w.length ; i++){
							if(s==w[i]){
					img=new Cairo.ImageSurface.from_png(sharepath+"weather-icon/"+"%02d.png".printf(i));
								ctx.set_source_surface(img,p*40,p*40);
								ctx.paint();
								break;
							}
						}
						p++;
					}
					ctx.restore();
				}
				c.parse("#141414"); ctx.set_source_rgba(c.red,c.green,c.blue,0.8);
				ctx.move_to(daycnt*segw+h0+1,v*segh+v0+1);
				ctx.show_text(str);
				c.parse("#C4C4C4"); ctx.set_source_rgba(c.red,c.green,c.blue,0.2);
				ctx.move_to(daycnt*segw+h0-1,v*segh+v0-1);
				ctx.show_text(str);
				c.parse(tcolor); ctx.set_source_rgba(c.red,c.green,c.blue,0.8);
				ctx.move_to(daycnt*segw+h0,v*segh+v0);
				ctx.show_text(str);
				if(v==0) v=v+5; v++;
			}
			daycnt++; week++; now=now.add_days(1);
		}
		try{
			Gdk.Pixbuf screenshot = Gdk.pixbuf_get_from_window(da.get_window(),0,0,ww,wh);
			screenshot.save("/tmp/cw.png","png");
		} catch (Error e) {error ("%s", e.message);}
		return true;
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
		string web="http://qq.ip138.com/weather/hunan/ChangSha.wml";
		if(args[1].contains("qq.ip138.com")) web=args[1];
	try{
		var url=File.new_for_uri(web);
		var dis = new DataInputStream (url.read ());
		while ((line = dis.read_line (null)) != null) {
			if(line.contains("天气预报<br/>")){
				city=line.replace("天气预报<br/>","")._chomp();
			}
			if(line.contains("星期")){
				weather=line.replace("<br/>","\t").replace("<b>","\n").replace("</b>","").replace("星期","");
				stdout.printf(weather);
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
