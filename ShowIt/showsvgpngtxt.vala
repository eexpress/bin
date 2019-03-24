//▶ valac --pkg gtk+-3.0 --pkg librsvg-2.0 showsvgpngtxt.vala
using Gtk;
using Cairo;

class ShowSVGPNGTXT : Gtk.Window {
		string mime="";
		string str="";
		uint8[] contents={};
		long offset=-1;
		int colorindex=0;
		string[] colorlist={"6faa34","e24f51","346daa","c555ea","aa7e34"};

	public ShowSVGPNGTXT(string inputtext) {
		var handle=new Rsvg.Handle();	//new产生的，有初始值
		ImageSurface img;
		double scale=1;
		double rotate=0;
		int w=300;
		int h=100;
		int max;	//正方形边长

		int fsize=60;
		string[] fontlist={};
		string dispfont="Noto Sans";
		int fontindex=-1;

/*        int sub=-1;	//svg里面的id循环显示，没有sub0就不循环（缺省）。*/
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
//------------------------
switch(mime){
case "image/svg+xml":
		try {
			string etag_out;
			f.load_contents(null, out contents, out etag_out);
			handle = new Rsvg.Handle.from_data(contents);
/*            handle = new Rsvg.Handle.from_file(inputtext);*/
		} catch (GLib.Error e) {error ("%s", e.message);}
		str=(string) contents;
		int i=str.index_of("id=\"sub0\"", 0);
		int j=str.substring(0,(long)i).last_index_of("fill:#");
/*        stdout.printf("find \"fill:#\" here: "+j.to_string()+".\ttext:"+str.substring(j+6,6)+"\n");*/
		offset=j+6;
		w=(int)handle.width; h=(int)handle.height;
		img = new ImageSurface(Format.ARGB32,w,h);	//创建表面
	break;
case "image/png":
		img = new Cairo.ImageSurface.from_png(inputtext);
		w=img.get_width(); h=img.get_height();
	break;
default:	//text
//------------------get font array
		string file_contents="";
try{
		FileUtils.get_contents("fontname.list", out file_contents);
		if(file_contents!=""){fontlist = file_contents.split("\n",8);}
} catch (GLib.Error e) {error ("%s", e.message);}
if(fontlist[0]!=""){fontindex=0; dispfont=fontlist[0];}
/*foreach(string fn in fontlist){ stdout.printf(fn+"\n"); }*/
//------------------get text display size
		img = new ImageSurface(Format.ARGB32,w,h);
		var tmpctx = new Cairo.Context(img);
		Cairo.TextExtents ex;
		tmpctx.select_font_face(dispfont,FontSlant.NORMAL,FontWeight.BOLD);
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
		ctx.select_font_face(dispfont,FontSlant.NORMAL,FontWeight.BOLD);
		ctx.set_font_size(fsize);
		ctx.set_source_rgba (0.3, 0.3, 0.3, 0.8);
		ctx.move_to(2,h+2);
		ctx.show_text(inputtext);
		//346daa convert to rgba
/*        Gdk.RGBA cc;*/
		var cc=new Gdk.RGBA();
		cc.parse("#"+colorlist[colorindex]);
		ctx.set_source_rgba (cc.red, cc.green, cc.blue, 0.8);
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
			case CONTROL_MASK:	//font
				if(fontindex<0)break;
				fontindex++;
while(fontlist[fontindex]=="" && fontindex<fontlist.length)fontindex++;
				if(fontindex>=fontlist.length)fontindex=0;
				dispfont=fontlist[fontindex];
/*                stdout.printf(fontindex.to_string()+":"+dispfont+"\n");*/
				break;
			case MOD1_MASK:	//Alt 修改颜色，适合svg和txt
				if(mime=="image/png")break;
				loop_color(true);
				if(mime=="image/svg+xml"&&offset>0){
contents=(str.substring(0,offset)+colorlist[colorindex]+str.substring(offset+6)).data;
				try{
					handle = new Rsvg.Handle.from_data(contents);
				} catch (GLib.Error e) {error ("%s", e.message);}
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
			case CONTROL_MASK:	//font
				if(fontindex<0)break;
				fontindex--; if(fontindex<0)fontindex=fontlist.length-1;
				while(fontlist[fontindex]=="" && fontindex>0)fontindex--;
				dispfont=fontlist[fontindex];
/*                stdout.printf(fontindex.to_string()+":"+dispfont+"\n");*/
				break;
			case MOD1_MASK:	//Alt 修改颜色，适合svg和txt
				if(mime=="image/png")break;
				loop_color(false);
				if(mime=="image/svg+xml"&&offset>0){
contents=(str.substring(0,offset)+colorlist[colorindex]+str.substring(offset+6)).data;
				try{
					handle = new Rsvg.Handle.from_data(contents);
				} catch (GLib.Error e) {error ("%s", e.message);}
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
	public void loop_color(bool y){
		if(y){		//up
if(colorindex<colorlist.length-1)colorindex++;else colorindex=0;
		}else{		//down
if(colorindex>0)colorindex--;else colorindex=colorlist.length-1;
		}
	}
//----------------------------------------------------
	static int main (string[] args) {
		Gtk.init (ref args);
		if(args[1]==null) return 0;
		var w=new ShowSVGPNGTXT(args[1]);
		w.show_all(); Gtk.main(); return 0; }
}
