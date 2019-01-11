using Gtk;
using Cairo;
	
public class DrawOnWindow : Gtk.Window {
	DrawingArea drawing_area;

	public DrawOnWindow() {
		title = "Sample";
		destroy.connect (Gtk.main_quit);
		set_default_size(800,600);
		drawing_area = new DrawingArea ();
		drawing_area.draw.connect (on_draw);
		add (drawing_area);
	}

	private bool on_draw (Widget da, Context ctx) {
		ctx.select_font_face(fontname,FontSlant.NORMAL,FontWeight.BOLD);
		ctx.set_font_size(size);
		ctx.set_source_rgb (0, 0, 0);
		return true;
	}

	static int main (string[] args) {
		Gtk.init (ref args);
		var DW = new DrawOnWindow ();
		DW.show_all ();
		Gtk.main ();
		return 0;
	}
}
