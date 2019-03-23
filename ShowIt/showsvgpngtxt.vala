//▶ valac --pkg gtk+-3.0 --pkg librsvg-2.0 showsvgpngtxt.vala
using Gtk;
using Cairo;

class ShowSVGPNGTXT : Gtk.Window {

	public ShowSVGPNGTXT(string inputtext) {
		Rsvg.Handle handle;
		ImageSurface img;
		double scale=1;
		double rotate=0;
		int w=300;
		int h=100;
		int max;	//正方形边长
		string mime="";
		int fsize=60;

//窗口特性
		title = "ShowSVGPNGTXT";
		skip_taskbar_hint = true;
		decorated = false;
		app_paintable = true;
		set_position(MOUSE);
		set_visual(this.get_screen().get_rgba_visual());
		set_keep_above (true); 
/*        set_resizable(true);*/
//允许鼠标事件
		destroy.connect (Gtk.main_quit);
		add_events (Gdk.EventMask.BUTTON_PRESS_MASK|Gdk.EventMask.SCROLL_MASK);
//----------------------------------------------------
//读取图形
		File f = File.new_for_path(inputtext);
		if(f.query_exists()){
		try {
mime = f.query_info ("standard::content-type", 0, null).get_content_type();
		} catch (GLib.Error e) {error ("%s", e.message);}
		}
switch(mime){
case "image/svg+xml":
		try {
			handle = new Rsvg.Handle.from_file(inputtext);
		} catch (GLib.Error e) {error ("%s", e.message);}
		w=(int)(handle.width*scale); h=(int)(handle.height*scale);
		img = new ImageSurface(Format.ARGB32,w,h);	//创建表面
		var tmpctx = new Cairo.Context(img);	//挂上绘图环境
		handle.render_cairo(tmpctx);	//svg库填入环境，其实是填入表面
	break;
case "image/png":
		img = new Cairo.ImageSurface.from_png(inputtext);
		w=img.get_width(); h=img.get_height();
	break;
default:	//text
		img = new ImageSurface(Format.ARGB32,w,h);
		var tmpctx = new Cairo.Context(img);
		Cairo.TextExtents ex;
		tmpctx.select_font_face("DejaVu Sans",FontSlant.NORMAL,FontWeight.BOLD);
		tmpctx.set_font_size(fsize);
		tmpctx.text_extents (inputtext, out ex);
		w=(int)(ex.width+Math.fabs(ex.x_bearing)+Math.fabs(ex.x_advance));
		h=(int)(ex.height+Math.fabs(ex.y_bearing)+Math.fabs(ex.y_advance));	//y_bearing 可能大负数
/*x_bearing: 2.000000, width: 246.000000, x_advance: 249.000000*/
/*y_bearing: -46.000000, height: 57.000000, y_advance: 0.000000*/
/*stdout.printf("w x h: %d x %d\n",w,h);*/
		img.flush();
		img = new ImageSurface(Format.ARGB32,w,h);
		tmpctx = new Cairo.Context(img);
		tmpctx.select_font_face("Noto Sans CJK SC",FontSlant.NORMAL,FontWeight.BOLD);
		tmpctx.set_font_size(fsize);
		tmpctx.set_source_rgba (0.3, 0.3, 0.3, 0.8);
		tmpctx.move_to(2,h-(int)Math.fabs(ex.y_bearing)+2);
		tmpctx.show_text(inputtext);
		tmpctx.set_source_rgba (1, 0, 0, 0.8);
		tmpctx.move_to(0,h-(int)Math.fabs(ex.y_bearing));
		tmpctx.show_text(inputtext);
	break;
}
/*        max=w; if(w<h)max=h; max=(int)(max*1.2);*/
		max=(int)Math.sqrt(Math.pow(w,2)+Math.pow(h,2));
		set_size_request(max,max);
//----------------------------------------------------
//绘制窗口事件
		draw.connect ((da,ctx) => {	//直接在窗口绘图
/*            ctx.set_operator (Cairo.Operator.SOURCE);*/
//缩放只是针对已经画好了的img，应该实时渲染，把上面部分纳入这里。??????
			ctx.scale(scale,scale);
			ctx.translate(max/2, max/2);
			ctx.rotate (rotate*Math.PI/180);
			ctx.translate(-max/2, -max/2);
			ctx.set_source_surface(img,(max-w)/2,(max-h)/2);	//选择svg贴到的img
			ctx.paint ();
			return true;
		});
//----------------------------------------------------
//鼠标点击事件
		button_press_event.connect ((e) => {
				if(e.button == 1){
begin_move_drag ((int)e.button, (int)e.x_root, (int)e.y_root, e.time);
				} else {Gtk.main_quit();}
				return true;
		});
//----------------------------------------------------
//鼠标滚轮事件
/*MOD1_MASK the Alt key*/
/*CONTROL_MASK | SHIFT_MASK | MOD1_MASK | SUPER_MASK | HYPER_MASK | META_MASK. In other words, Control, Shift, Alt, Super, Hyper and Meta.*/
/*Gdk.ModifierType.SHIFT_MASK*/
scroll_event.connect ((e) => {
		if(e.direction==Gdk.ScrollDirection.UP){
			switch(e.state){
			case SHIFT_MASK:
				rotate+=15; 
				if(rotate>=360)rotate=0;
				break;
			case CONTROL_MASK:
				break;
			case MOD1_MASK:	//Alt
				break;
			default:
				scale/=0.98;
				if(scale>4.5)scale=4.5;
				resize((int)(max*scale),(int)(max*scale));
				break;
			}
		}
		if(e.direction==Gdk.ScrollDirection.DOWN){
			switch(e.state){
			case SHIFT_MASK:
				rotate-=15;
				if(rotate<0)rotate+=360;
				break;
			case CONTROL_MASK:
				break;
			case MOD1_MASK:	//Alt
				break;
			default:
				scale*=0.98;
				if(scale<0.2)scale=0.2;
				resize((int)(max*scale),(int)(max*scale));
				break;
			}
		}
		queue_draw();
		return true;
		});
	}
//----------------------------------------------------
	static int main (string[] args) {
		Gtk.init (ref args);
		if(args[1]==null) return 0;
		var w=new ShowSVGPNGTXT(args[1]);
		w.show_all(); Gtk.main(); return 0; }
}
