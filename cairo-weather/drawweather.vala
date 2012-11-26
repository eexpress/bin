using Gtk;
using Cairo;
	
string InFile;
File file;
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
const string weekchar[]={"壹","貳","叁","肆","伍","陸","日"};

public class DrawWeather : Gtk.Window {

    private const int SIZE = 30;

    public DrawWeather() {
        title = "DrawWeather";
		skip_taskbar_hint = true;
		decorated = false;
/*        app_paintable = true;*/
		set_visual(this.get_screen().get_rgba_visual());
/*        set_opacity(0.9);*/
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
		return true;
		});
    }

    private bool on_draw (Widget da, Context ctx) {
				Gdk.RGBA c={};
		var now = new DateTime.now_local ();
		var week=now.get_day_of_week();
/*        stdout.printf("week: %d\n",week);*/
		ctx.set_operator (Cairo.Operator.CLEAR);
		ctx.rectangle(0,0,ww,wh);
		ctx.fill();
		ctx.set_operator (Cairo.Operator.OVER);
		try {
		var dis = new DataInputStream (file.read ());
		string line;
		int day=0;
		while ((line = dis.read_line (null)) != null) {
			int v=0;
			if(!line.contains("风"))continue;
			string[] item = line.split ("\t");
			ctx.select_font_face("Vera Sans YuanTi",FontSlant.NORMAL,FontWeight.BOLD);
			foreach (string str in item){
				if(str.contains("风"))ctx.set_font_size(12);else ctx.set_font_size(15);
				ctx.set_source_rgba(0,0,0,1);
				if(v==6){
					string[] two=str.split("-",2);
					int p=0;
					ImageSurface img;
					ctx.save();
					ctx.translate(day*hp+h0,1*vp+v0);
					ctx.scale(0.6,0.6);
					foreach(string s in two){
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
				string tcolor;
				if(day==0){
					tcolor="#E55E23";
					if(v==0){
/*                        frame*/
						ctx.save();
						const int r=20;
						ctx.move_to(h0/2+r,0);
						ctx.rel_line_to(hp-2*r,0);
						ctx.rel_curve_to(0,0,r,0,r,r);
						ctx.rel_line_to(0,wh-2*r);
						ctx.rel_curve_to(0,0,0,r,-r,r);
						ctx.rel_line_to(-(hp-2*r),0);
						ctx.rel_curve_to(0,0,-r,0,-r,-r);
						ctx.rel_line_to(0,-(wh-2*r));
						ctx.rel_curve_to(0,0,0,-r,r,-r);
						c.parse("#141414"); ctx.set_source_rgba(c.red,c.green,c.blue,0.4);
						ctx.fill();

						ctx.set_line_cap(Cairo.LineCap.BUTT);
						ctx.set_line_join(Cairo.LineJoin.ROUND);
						ctx.set_operator(Cairo.Operator.CLEAR);
						int l=10;
						ctx.set_line_width(l/2);
						for(int i=0; i<l; i++){
							ctx.move_to(h0/2,vp*3+i*l);
							ctx.rel_curve_to(hp/3,l*2,hp*2/3,-l*2,hp,0);
							ctx.stroke();
						}
						ctx.restore();
/*                        weekchar*/
						ctx.save();
						ctx.set_operator (Cairo.Operator.SATURATE);
						ctx.set_font_size(65);
						c.parse("#983E16");
						for(int i=0; i<8; i++){
							double a=0.3;
							ctx.move_to(day*hp+h0*3-i,v*vp+v0*4.8+i);
							ctx.set_source_rgba(c.red-i/3,c.green-i/3,c.blue-i/3,a);
							ctx.rotate(-0.4);
							ctx.text_path(weekchar[day]);
							ctx.fill_preserve();
							ctx.stroke();
							ctx.rotate(0.4);
							a=a/1.2;
						}
						ctx.restore();
					}
				}else{
					if(week==6 || week==7 )tcolor="#E55E23"; else tcolor="#C8C8C8";
				}
				c.parse("#141414"); ctx.set_source_rgba(c.red,c.green,c.blue,1);
				ctx.move_to(day*hp+h0+1,v*vp+v0+1);
				ctx.show_text(str);
				c.parse(tcolor); ctx.set_source_rgba(c.red,c.green,c.blue,0.8);
				ctx.move_to(day*hp+h0,v*vp+v0);
				ctx.show_text(str);
				if(v==0)v=v+5;
				v++;
			}
			day++; week++;
		}
		} catch (Error e) {error ("%s", e.message);}
		return true;
	}

    private delegate void DrawMethod ();

    static int main (string[] args) {
        Gtk.init (ref args);
		InFile="t";
		file = File.new_for_path (InFile);
		
		if (!file.query_exists ()) {
		stderr.printf ("File '%s' doesn't exist.\n", file.get_path ());
		return 1;
		}
	
        var DW = new DrawWeather ();
        DW.show_all ();
        Gtk.main ();
        return 0;
    }
}
