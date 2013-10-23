using Gtk;
using Cairo;
	
public class DrawOnWindow : Gtk.Window {
	int ww;
	int wh;
	string fontname="文泉驿正黑";
	int size=12;
	string str="text";
	private const Gtk.TargetEntry[] targets={{"text/uri-list",0,0}};
	DrawingArea drawing_area;
	int wx=100;
	int wy=100;

	public DrawOnWindow() {
		title = "DrawOnWindow Sample";
		destroy.connect (Gtk.main_quit);
		ww=800;
		wh=600;
		set_default_size(ww,wh);
		drawing_area = new DrawingArea ();
		drawing_area.draw.connect (on_draw);
		add (drawing_area);

		Gtk.drag_dest_set (this,Gtk.DestDefaults.ALL, targets, Gdk.DragAction.COPY);
		this.drag_data_received.connect(this.on_drag_data_received);
	}

	private bool on_draw (Widget da, Context ctx) {
		ctx.select_font_face(fontname,FontSlant.NORMAL,FontWeight.BOLD);
		ctx.set_font_size(size);
		ctx.set_source_rgb (0, 0, 0);
		drawnote(ctx,wx,wy,str+" at %d,%d".printf(wx,wy));
		return true;
	}

	private void drawnote(Context ctx, double x, double y, string s){
		ctx.save();
		ctx.move_to(x,y);
		ctx.text_path(s);
		ctx.fill();
		ctx.restore();
	}

	private void on_drag_data_received (Gdk.DragContext drag_context, int x, int y, Gtk.SelectionData data, uint info, uint time){
		foreach(string uri in data.get_uris ()){
			File file = File.new_for_uri(uri);
			string mime=file.query_info ("standard::content-type", 0, null).get_content_type ();
/*            str=file.get_basename ()+" [%s]".printf(mime);*/
			str=Uri.unescape_string(uri.replace("file://",""))+" [%s]".printf(mime);
		}
		wx=x; wy=y;
		Gtk.drag_finish (drag_context, true, false, time);
		drawing_area.queue_draw_area(0,0,ww,wh);
	}

	static int main (string[] args) {
		Gtk.init (ref args);
		var DW = new DrawOnWindow ();
		DW.show_all ();
		Gtk.main ();
		return 0;
	}
}
