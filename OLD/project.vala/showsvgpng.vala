// Syntastic
// modules: gtk+-3.0, librsvg-2.0
//▶ valac --pkg gtk+-3.0 --pkg librsvg-2.0 ShowSVGPNG.vala
using Gtk;
using Cairo;

class ShowSVGPNG : Gtk.Window {

	public ShowSVGPNG(string fimg) {
		Rsvg.Handle handle;
		ImageSurface img;
		double scale=1;
		double rotate=0;
		int w;
		int h;
		int max;	//正方形边长

//窗口特性
		title = "ShowSVGPNG";
		skip_taskbar_hint = true;
		decorated = false;
		app_paintable = true;
		set_visual(this.get_screen().get_rgba_visual());
		set_keep_above (true); 
/*        set_resizable(true);*/
//允许鼠标事件
		destroy.connect (Gtk.main_quit);
		add_events (Gdk.EventMask.BUTTON_PRESS_MASK|Gdk.EventMask.SCROLL_MASK);
//读取图形
if(fimg.has_suffix(".svg")){
		try {
			handle = new Rsvg.Handle.from_file(fimg);
		} catch (GLib.Error e) {error ("%s", e.message);}
		w=(int)(handle.width*scale); h=(int)(handle.height*scale);
		img = new ImageSurface(Format.ARGB32,w,h);	//创建表面
		var ctr = new Cairo.Context(img);	//挂上绘图环境
		handle.render_cairo(ctr);	//svg库填入环境，其实是填入表面
} else {	//png
		img = new Cairo.ImageSurface.from_png(fimg);
		w=img.get_width(); h=img.get_height();
}
		max=w; if(w<h)max=h; max=(int)(max*1.05);
		set_size_request(max,max);
//绘制窗口事件
		draw.connect ((da,ctx) => {	//直接在窗口绘图
/*            ctx.set_operator (Cairo.Operator.SOURCE);*/
			ctx.scale(scale,scale);
			ctx.translate(max/2, max/2);
			ctx.rotate (rotate*Math.PI/180);
			ctx.translate(-max/2, -max/2);
			ctx.set_source_surface(img,(max-w)/2,(max-h)/2);	//选择svg贴到的img
			ctx.paint ();
			return true;
		});
//鼠标点击事件
		button_press_event.connect ((e) => {
				if(e.button == 1){
begin_move_drag ((int)e.button, (int)e.x_root, (int)e.y_root, e.time);
				} else {Gtk.main_quit();}
				return true;
		});
//鼠标滚轮事件
		scroll_event.connect ((e) => {
		if((e.state & Gdk.ModifierType.SHIFT_MASK)!=0) {	//按shift键旋转
			if(e.direction==Gdk.ScrollDirection.UP){
				rotate+=15; 
				if(rotate>=360)rotate=0;
			}
			if(e.direction==Gdk.ScrollDirection.DOWN){
				rotate-=15;
				if(rotate<0)rotate+=360;
			}
			queue_draw();
		}else{		//滚轮直接缩放
			if(e.direction==Gdk.ScrollDirection.UP){
				scale/=0.98;
				if(scale>4.5)scale=4.5;
			}
			if(e.direction==Gdk.ScrollDirection.DOWN){
				scale*=0.98;
				if(scale<0.2)scale=0.2;
			}
			resize((int)(max*scale),(int)(max*scale));
		}
		return true;
		});
	}
//----------------------------------------------------
//----------------------------------------------------
	static int main (string[] args) {
		Gtk.init (ref args);
if(args[1]!=null && File.new_for_path(args[1]).query_exists() == true){
		if(args[1].has_suffix(".svg") || args[1].has_suffix(".png")){
			var wsvgpng = new ShowSVGPNG(args[1]);
			wsvgpng.show_all ();
			Gtk.main ();
		}}
		return 0;
	}
}
