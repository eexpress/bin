using GLib;

//https://wiki.gnome.org/Projects/Vala/Gedit3PluginSample

namespace Run5
{
        /*
         * This class will be instantiated and activated for each Gedit View
         */
        public class View : Gedit.ViewActivatable, Peas.ExtensionBase
        {
                public View ()	//产生了一个Object实例?
                {
                        GLib.Object ();
                }

                public Gedit.View view {
                         owned get; construct;
                }
                
                public void activate ()
                {
                        print ("Run5: activated\n");
                        view.key_release_event.connect (this.on_key_release);
                }
                
                public void deactivate ()
                {
                        print ("Run5: deactivated\n");
                        view.key_release_event.disconnect (this.on_key_release);
                }
                
                private bool on_key_release (Gtk.Widget sender, Gdk.EventKey event)
                {
//                		stderr.printf(event.keyval.to_string()+"\n");
                        if (event.keyval == 65474)
                        {	//调试出来的，F5的keyval就是65474
                                Gedit.View view = (Gedit.View)sender;
                                Gtk.TextBuffer buffer = view.get_buffer ();
                                string path = "";


//得到 Gedit.Window，才能获取活动文档路径。
Gedit.Window win = (Gedit.Window)sender.get_parent_window();
//Gedit.Document doc = win.get_active_document();                            
string fn = win.get_title();
//string fn = win.get_active_document().get_uri_for_display ();                            
//string path = win.get_active_document().get_file().get_location().get_path();                            
//stderr.printf("fn: "+fn+"..........\n");
Posix.system("zenity --info --text=."+fn+". &");
//stderr.printf(doc.get_file().get_location().get_path()+"\n");


                                string[] line = buffer.text.split("\n");
                                for(int i = 0; i < 5; i++)
                                {
                                	if("!" in line[i])
                                	{
		                            	string cmd = line[i].split("!")[1];
		                            	Posix.system("gnome-terminal --working-directory="+path+" -e "+cmd+" &");
                                	}
                                }
                        }
                        return true;
                }
        }

        /*
         * Plugin config dialog
         */
        public class Config : Peas.ExtensionBase, PeasGtk.Configurable
        {
                public Config () 
                {
                        Object ();
                }

                public Gtk.Widget create_configure_widget () 
                {	//插件的 Preference 按钮，偏好设置。
                        return new Gtk.Label (" Gedit 3 插件。按 F5 执行文件前5行中，!号后面的命令。 ");
                }
        }
}

[ModuleInit]
public void peas_register_types (TypeModule module) 
{
        var objmodule = module as Peas.ObjectModule;

        // Register my plugin extension
        objmodule.register_extension_type (typeof (Gedit.ViewActivatable), typeof (Run5.View));
        // Register my config dialog
        objmodule.register_extension_type (typeof (PeasGtk.Configurable), typeof (Run5.Config));
}

