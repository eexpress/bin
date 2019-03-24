//▶ valac --pkg gtk+-3.0 --pkg librsvg-2.0 showsvgpngtxt.vala
using Gtk;
using Cairo;

class ShowSVGPNGTXT : Gtk.Window {

	public ShowSVGPNGTXT(string inputtext) {
		var handle=new Rsvg.Handle();	//new产生的，有初始值
		ImageSurface img;
		double scale=1;
		double rotate=0;
		int w=300;
		int h=100;
		int max;	//正方形边长
		string mime="";
		int fsize=60;
		int sub=-1;	//svg里面的id循环显示，没有sub0就不循环（缺省）。

//窗口特性
		title = "ShowSVGPNGTXT";
		skip_taskbar_hint = true;
		decorated = false;
		app_paintable = true;
		set_position(MOUSE);
		set_visual(this.get_screen().get_rgba_visual());
		set_keep_above (true); 
//允许鼠标事件
		destroy.connect (Gtk.main_quit);
		add_events (Gdk.EventMask.BUTTON_PRESS_MASK|Gdk.EventMask.SCROLL_MASK);
//----------------------------------------------------
//读取图形，准备好img和各种尺寸。
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
		w=(int)handle.width; h=(int)handle.height;
		img = new ImageSurface(Format.ARGB32,w,h);	//创建表面
//------------------------
		//至少有2个sub才允许切换
/*        if self._handle.has_sub(id="#Device") and self._handle.has_sub(id=self._layer):*/

/*https://lazka.github.io/pgi-docs/Rsvg-2.0/classes/Handle.html*/
/* has_sub(id)*/
/*    Parameters:	id (str) – an element’s id within the SVG, starting with “##”, for example, “##layer1”.*/
/* render_cairo_sub(cr, id)*/
/*render_cairo_sub(cr, id)*/
/*    Parameters:	*/

/*        cr (cairo.Context) – A Cairo renderer*/
/*        id (str or None) – An element’s id within the SVG, or None to render the whole SVG. For example, if you have a layer called “layer1” that you wish to render, pass “##layer1” as the id.*/

/*        if(handle.has_sub("##layer1") && handle.has_sub("##layer2"))*/
/*        {stdout.printf("found layer1 and layer2.\n");}*/
/*        if(handle.has_sub("##sub0") && handle.has_sub("##sub1"))*/
/*        {sub=0; stdout.printf("found sub0 and sub1.\n");}*/
//------------------------
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
		w=(int)ex.width; h=(int)ex.height;
/*x_bearing: 2.000000, width: 246.000000, x_advance: 249.000000*/
/*y_bearing: -46.000000, height: 57.000000, y_advance: 0.000000*/
		img.flush();
		img = new ImageSurface(Format.ARGB32,w,h);
	break;
}
		max=(int)Math.sqrt(Math.pow(w,2)+Math.pow(h,2));
		set_size_request(max,max);
/*stdout.printf("w x h: %d x %d\n",w,h);*/
//----------------------------------------------------
//绘制窗口事件
		draw.connect ((da,ctx) => {	//直接在窗口绘图
			ctx.scale(scale,scale);
			ctx.translate(max/2, max/2); //窗口中心为旋转原点
			ctx.rotate (rotate*Math.PI/180);
			ctx.translate(-max/2, -max/2);

switch(mime){
	case "image/svg+xml":
		ctx.translate((max-w)/2,(max-h)/2);
		handle.render_cairo(ctx);
		break;
	case "image/png":
		break;
	default:	//text
		ctx.translate(0,(max-h)/2);
		ctx.select_font_face("Noto Sans CJK SC",FontSlant.NORMAL,FontWeight.BOLD);
		ctx.set_font_size(fsize);
		ctx.set_source_rgba (0.3, 0.3, 0.3, 0.8);
		ctx.move_to(2,h+2);
		ctx.show_text(inputtext);
		ctx.set_source_rgba (1, 0, 0, 0.8);
		ctx.move_to(0,h);
		ctx.show_text(inputtext);
		break;
	}
			ctx.set_source_surface(img,(max-w)/2,(max-h)/2);
			ctx.paint (); //除掉img偏移量，绘图。
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
				stdout.printf("Alt pressed. mime:%s. sub:%d\n",mime,sub);
				if(mime=="image/svg+xml" && sub>=0){
					sub++;
					if(!handle.has_sub("sub"+sub.to_string())){sub=0;}
					stdout.printf("sub%d found.\n",sub);
					var tmpctx = new Cairo.Context(img);
					handle.render_cairo_sub(tmpctx,"sub"+sub.to_string());
				}
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
				if(mime=="image/svg+xml" && sub>=0){
					sub--; if(sub<0)sub=8;	//最多8个颜色循环
					while(!handle.has_sub("sub"+sub.to_string()) && sub>0){
						sub--;
					}
					var tmpctx = new Cairo.Context(img);
					handle.render_cairo_sub(tmpctx,"sub"+sub.to_string());
				}
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
