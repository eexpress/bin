using Gtk;
using Cairo;
	
public class ShowIt : Gtk.Window {
	private const Gtk.TargetEntry[] targets={{"text/uri-list",0,0}};
//----------------------------
	public ShowIt() {
		title = "ShowIt";
		var img = new ImageSurface.from_png("screen.png");
		set_size_request(img.get_width(),img.get_height());
		string path=GLib.Environment.get_current_dir();
		destroy.connect (Gtk.main_quit);
		draw.connect ((da,ctx) => {
			ctx.set_operator (Cairo.Operator.SOURCE);
			ctx.set_source_surface(img,0,0);
			ctx.paint (); return true;
			});
//----------------------------Drag&Drop
		Gtk.drag_dest_set (this,Gtk.DestDefaults.ALL, targets, Gdk.DragAction.COPY);
		drag_data_received.connect((drag_context,x, y,data,info,time) => {
			foreach(string uri in data.get_uris ()){
				string mime;
				try{
					mime=File.new_for_uri(uri).query_info ("standard::content-type", 0, null).get_content_type();	// image/png image/svg+xml
				} catch (GLib.Error e) {error ("%s", e.message);}
				string str=Uri.unescape_string(uri.replace("file://",""));
				stdout.printf("filename: \"%s\". mimetype: \"%s\"\n",str, mime);
				if(mime!="image/png" && mime!="image/svg+xml")continue;
	//-------------------
/*                public bool spawn_async_with_pipes (string? working_directory, string[] argv, string[]? envp, SpawnFlags _flags, SpawnChildSetupFunc? child_setup, out Pid child_pid, out int standard_input = null, out int standard_output = null, out int standard_error = null) throws SpawnError */
	try {
		string[] spawn_args = {path+"/showsvgpng", str};
		string[] spawn_env = Environ.get ();
		Pid child_pid;
		int standard_input; int standard_output; int standard_error;

		Process.spawn_async_with_pipes (path, spawn_args, spawn_env, SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD, null, out child_pid, out standard_input, out standard_output, out standard_error);

		ChildWatch.add (child_pid, (pid, status) => {
			// Triggered when the child indicated by child_pid exits
			Process.close_pid (pid);
		});
	} catch (SpawnError e) { print ("Error: %s\n", e.message); }
	//-------------------
			}
			Gtk.drag_finish (drag_context, true, false, time);
		});
	}
//--------------------------------------------------------
	static int main (string[] args) {
		Gtk.init(ref args); var DW = new ShowIt(); DW.show_all();
		Gtk.main(); return 0;
		}
}
