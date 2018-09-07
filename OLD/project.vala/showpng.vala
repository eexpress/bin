using Gtk;
using Cairo;

class ShowPNG : Gtk.Window {

	public ShowPNG(string fimg) {
        title = "ShowPNG";
		skip_taskbar_hint = true;
        decorated = false;
        app_paintable = true;
		set_visual(this.get_screen().get_rgba_visual());
		set_opacity(1);
		stick();
		var img = new Cairo.ImageSurface.from_png (fimg);
		set_size_request(img.get_width(),img.get_height());
		var drawing_area = new DrawingArea ();
		drawing_area.draw.connect ((da,ctx) => {
				ctx.set_operator (Cairo.Operator.SOURCE);
				ctx.set_source_surface(img,0,0);
				ctx.paint ();
				return true;
				});
        add (drawing_area);

		drawing_area.add_events (Gdk.EventMask.BUTTON_PRESS_MASK);
		drawing_area.button_press_event.connect ((e) => {
				if(e.button == 1){
					begin_move_drag ((int) e.button, (int) e.x_root, (int) e.y_root, e.time);
				} else {Gtk.main_quit();}
				return true;
				});

		destroy.connect (Gtk.main_quit);
	}

	static int main (string[] args) {
		Gtk.init (ref args);
		string file= "/tmp/weather.png";
		if(args[1]!=null && args[1].has_suffix(".png")) file = args[1];
		var showpng = new ShowPNG(file);
		showpng.show_all ();
		Gtk.main ();
		return 0;
	}
}
