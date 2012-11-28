using Gtk;
using Cairo;
	
string line;
File logfile;
string InFile;
const int hp=138;
const int vp=24;
const int h0=30;
const int v0=40;
const int ww=7*hp+h0*2;
const int wh=8*vp+v0*2;

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
		this.move(get_screen().get_width()-ww-vp,vp*3);
		return true;
		});
    }

    private bool on_draw (Widget da, Context ctx) {
		var now = new DateTime.now_local ();
		var week=now.get_day_of_week();
		ctx.set_operator (Cairo.Operator.CLEAR);
		ctx.rectangle(0,0,ww,wh);
		ctx.fill();
		ctx.set_operator (Cairo.Operator.OVER);
		try {
		var data = new DataInputStream (logfile.read ());
		int daycnt=0;
		int oldmonth=0;
		while ((line = data.read_line (null)) != null) {
			int v=0;
			string tcolor;
			if(!line.contains("风"))continue;
			ctx.select_font_face("Vera Sans YuanTi",FontSlant.NORMAL,FontWeight.BOLD);
			if(daycnt==0){
				tcolor="#E55E23";
				frame(ctx,h0/2,0,hp,wh,0);
				stamp(ctx, h0*3, v0*4.8, weekchar[week], 65,0.4);
				stamp(ctx, ww/2-hp,wh-vp,now.get_year().to_string(),24,0.2);
			} else if(week==6 || week==7 ){
				tcolor="#E55E23";
				frame(ctx,daycnt*hp+h0/2,0,hp,wh,1);
			} else tcolor="#C8C8C8";
			int month=now.get_month ();
			int day=now.get_day_of_month ();
			string date;
			if(oldmonth!=month){date=month.to_string()+"月"+day.to_string()+"日"; oldmonth=month;}
			else date=day.to_string()+"日";

			line=date+"\t"+line;
			string[] item = line.split ("\t");
			foreach (string str in item){
				if(str.contains("201")) continue;
				if(str.contains("风")) ctx.set_font_size(13);else ctx.set_font_size(16);
				if(v==6){
					string[] two=str.split("转",2);
					int p=0;
					ImageSurface img;
					ctx.save(); ctx.translate(daycnt*hp+h0,1*vp+v0); ctx.scale(0.6,0.6);
					foreach(string s in two){
						if(s.contains("-")) s=s.substring(s.index_of("-",0)+1);
						for(int i = 0; i < w.length ; i++){
							if(s==w[i]){
					img=new Cairo.ImageSurface.from_png("weather-icon/"+"%02d.png".printf(i));
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
				ctx.move_to(daycnt*hp+h0+1,v*vp+v0+1);
				ctx.show_text(str);
				c.parse(tcolor); ctx.set_source_rgba(c.red,c.green,c.blue,0.8);
				ctx.move_to(daycnt*hp+h0,v*vp+v0);
				ctx.show_text(str);
				if(v==0) v=v+5; v++;
			}
			daycnt++; week++; now=now.add_days(1);
		}
		} catch (Error e) {error ("%s", e.message);}
		return true;
	}

	private void stamp(Context ctx, double x, double y, string s, int size, double rotate){
		ctx.save();
		ctx.set_font_size(size);
		c.parse("#983E16");
		ctx.set_source_rgba(c.red/1.5,c.green/1.5,c.blue/1.5,0.6);
		ctx.set_operator (Cairo.Operator.SATURATE);
		ctx.move_to(x,y);
			ctx.rotate(-rotate);
			ctx.text_path(s);
			ctx.set_line_width(3);
			ctx.fill_preserve();
			ctx.stroke();
		for(int i=1; i<size/10+2; i++){
			ctx.set_source_rgba(c.red-i/3,c.green-i/3,c.blue-i/3,0.8);
			ctx.rotate(rotate);
			ctx.move_to(x-i,y+i);
			ctx.rotate(-rotate);
			ctx.text_path(s);
			ctx.fill_preserve();
			ctx.stroke();
		}
		ctx.restore();
	}

	private void frame(Context ctx, int x, int y, int w, int h, int style){
			ctx.save();
			ctx.move_to(x,y);
			int r;
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
			c.parse("#141414"); ctx.set_source_rgba(c.red,c.green,c.blue,0.4);
			ctx.fill();
			ctx.restore();
			ctx.save();

			ctx.set_line_cap(Cairo.LineCap.BUTT);
			ctx.set_line_join(Cairo.LineJoin.ROUND);
			ctx.set_operator(Cairo.Operator.CLEAR);
			int l=10;
			ctx.set_line_width(l/2);
			for(int i=0; i<l; i++){
				ctx.move_to(x,wh/4+i*l);
				if(style==0) ctx.rel_curve_to(hp/3,l*2,hp*2/3,-l*2,hp,0); else {
				int[] t={1,-1,1,-1};foreach(int seg in t) ctx.rel_line_to(hp/4+1,seg*l);
				}
				ctx.stroke();
			}
			ctx.restore();
	}

    static int main (string[] args) {
        Gtk.init (ref args);
		string web="http://qq.ip138.com/weather/hunan/ChangSha.wml";
		if(args[1].contains("ip138")) web=args[1];
		InFile="/tmp/cw.txt";
	try{
		var url=File.new_for_uri(web);
		logfile=File.new_for_path(InFile);
		if(logfile.query_exists()) logfile.delete();
		var dis = new DataInputStream (url.read ());
		var dos = new DataOutputStream (logfile.create(FileCreateFlags.NONE));
		while ((line = dis.read_line (null)) != null) {
			if(line.contains("星期")){
				line=line.replace("<br/>","\t").replace("<b>","\n").replace("</b>","").replace("星期","");
				dos.put_string(line);
				stdout.printf(line);
			}
		}
	} catch (Error e) {error ("%s", e.message);}

        var DW = new DrawWeather ();
        DW.show_all ();
		DW.move(DW.get_screen().get_width()-ww-vp,vp*3);
        Gtk.main ();
        return 0;
    }
}
