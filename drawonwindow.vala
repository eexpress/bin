using Gtk;
using Cairo;
	
public class DrawOnWindow : Gtk.Window {
	int ww;
	int wh;
	string fontname="Nimbus Roman No9 L";
	int size=20;

	public DrawOnWindow() {
		title = "DrawOnWindow Sample";
		destroy.connect (Gtk.main_quit);
		ww=600;
		wh=400;
		set_default_size(ww,wh);
		var drawing_area = new DrawingArea ();
		drawing_area.draw.connect (on_draw);
		add (drawing_area);
	}

	private bool on_draw (Widget da, Context ctx) {
		ctx.select_font_face(fontname,FontSlant.NORMAL,FontWeight.BOLD);
		ctx.set_font_size(size);
		ctx.set_source_rgb (0, 0, 0);
		drawnote(ctx, 100,100,"text at 100,100");
		return true;
	}

	private void drawnote(Context ctx, double x, double y, string s){
		ctx.save();
		ctx.move_to(x,y);
		ctx.text_path(s);
		ctx.fill();
		ctx.restore();
	}

	static int main (string[] args) {
		Gtk.init (ref args);
		var DW = new DrawOnWindow ();
		DW.show_all ();
		Gtk.main ();
		return 0;
	}
}
