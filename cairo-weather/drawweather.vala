using Gtk;
using Cairo;
	
string InFile;
File file;
const int hp=120;
const int vp=28;
const int h0=30;
const int v0=40;
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

public class DrawWeather : Gtk.Window {

    private const int SIZE = 30;

    public DrawWeather() {
        title = "DrawWeather";
		skip_taskbar_hint = true;
/*        decorated = false;*/
/*        app_paintable = true;*/
		set_visual(this.get_screen().get_rgba_visual());
		set_opacity(1);
		stick();
/*        set_keep_below(true);*/
		set_default_size(7*hp+h0*2,8*vp+v0*2);
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
/*        ctx.set_operator (Cairo.Operator.OVER);*/
		ctx.set_operator (Cairo.Operator.CLEAR);
		ctx.set_source_rgba(0.5,0,0,0.2);
		ctx.rectangle(0,0,0.9,0.9);
		ctx.fill();
/*        cr.set_operator(cairo.OPERATOR_CLEAR)*/
/*    cr.set_source_rgba(0.5,1.0,0.0,0.5)*/
/*    cr.rectangle(0, 0, 0.9, 0.8)*/
/*    cr.fill()*/
/*        ctx.set_operator (Cairo.Operator.SOURCE);*/
		ctx.set_operator (Cairo.Operator.OVER);
		try {
		var dis = new DataInputStream (file.read ());
		string line;
		int day=0;
		while ((line = dis.read_line (null)) != null) {
			int v=0;
/*            11月25日-十二	小雨	10C-6C	北风微风级*/
			if(!line.contains("风"))continue;
			string[] item = line.split ("\t");
			ctx.select_font_face("Vera Sans YuanTi",FontSlant.NORMAL,FontWeight.BOLD);
			foreach (string str in item){
				if(str.contains("风"))ctx.set_font_size(12);else ctx.set_font_size(15);
				ctx.set_source_rgba(0,0,0,1);
				if(v==5){
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
								ctx.set_source_surface(img,p*30,p*30);
								ctx.paint();
								break;
							}
						}
						p++;
					}
					ctx.restore();
				}
/*                ctx.set_operator (Cairo.Operator.SATURATE);*/
				ctx.move_to(day*hp+h0,v*vp+v0);
				ctx.show_text(str);
/*                stdout.printf("%s - ",str);*/
				if(v==0)v=v+4;
				v++;
			}
			day++;
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
