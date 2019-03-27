//▶ valac --pkg gtk+-3.0 --pkg librsvg-2.0 showsvgpngtxt.vala
using Gtk;
using Cairo;

class ShowSVGPNGTXT : Gtk.Window {
		string mime="";
		string str="";
		uint8[] contents={};
		const string keyid="sub0";	//改成变色龙？chameleon
		long offset=-1;
		int colorindex=0;
		string[] colorlist={"ff0000","FF00FF","ffa500","ffd700","2e8b57","32CD32","0000cd", "7B68EE"};
		//Red, Magenta, Orange, Gold, SeaGreen, LimeGreen, MediumBlue, MediumSlateBlue
		Rsvg.Handle handle;	//new产生的，有初始值
		int max;	//正方形边长
		double hscale=1;	//滚轮改svg水平缩放
		double wscale=1;	//ctrl滚轮改svg垂直缩放

	public ShowSVGPNGTXT(string inputtext) {
		ImageSurface img;
		double rotate=0;
		int w=300;
		int h=100;
/*        var handle=new Rsvg.Handle();	//new产生的，有初始值*/

		string[] fontlist={};
		int fontindex=-1;
		string dispfont="Noto Sans";
		int fsize=60;

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
/*if(handle.has_sub("#sub0") && handle.has_sub("#sub1"))//work */
		str=(string) contents;
		int i=str.index_of("id=\""+keyid+"\"", 0);
		if(i>0){	//向前找，2种格式
			int l=6;
			int j=str.substring(0,(long)i).last_index_of("fill:#");
			if(j<0){l=7;j=str.substring(0,(long)i).last_index_of("fill=\"#");}
			int k=str.substring(0,(long)i).last_index_of("<");
			if(j>k>0){offset=j+l;}else{	//向后找
				l=6;
				j=str.substring((long)i).index_of("fill:#");
				if(j<0){l=7;j=str.substring((long)i).index_of("fill=\"#");}
				k=str.substring((long)i).index_of("/>");
				if(k>j>0){j+=i;offset=j+l;}
			}
if(offset>0)stdout.printf("find fill color: "+str.substring(offset,6)+"\n");
		}
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
//----------------------------------------------------
//绘制窗口事件
		draw.connect ((da,ctx) => {	//直接在窗口绘图
			if(mime=="image/svg+xml") ctx.scale(wscale,hscale);
			else ctx.scale(wscale,wscale);
			ctx.translate(max/2, max/2); //窗口中心为旋转原点
			ctx.rotate (rotate*Math.PI/180);
			ctx.translate(-max/2, -max/2);

switch(mime){
	case "image/svg+xml":
		ctx.translate((max-w)/2,(max-h)/2);
		handle.render_cairo(ctx);
/*handle.render_cairo_sub(ctx,"#"+keyid);	//work */
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
		//html color "346daa" convert to rgba
		Gdk.RGBA cc=Gdk.RGBA();
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
				rotate+=15; if(rotate>=360)rotate=0;
				break;
			case CONTROL_MASK:
				if(mime=="image/svg+xml"){
					set_scale(ref hscale,true);
				}else{
					if(fontindex<0)break;
get_next_string_array(ref fontlist, ref fontindex, true);
					dispfont=fontlist[fontindex];
				}
				break;
			case MOD1_MASK:	//Alt 修改颜色，适合svg和txt
				loop_color(true);
				break;
			default:
				set_scale(ref wscale,true);
				break;
			}
		}
		if(e.direction==Gdk.ScrollDirection.DOWN){
			switch(e.state){
			case SHIFT_MASK:
				rotate-=15; if(rotate<0)rotate+=360;
				break;
			case CONTROL_MASK:
				if(mime=="image/svg+xml"){
					set_scale(ref hscale,false);
				}else{
					if(fontindex<0)break;
get_next_string_array(ref fontlist, ref fontindex, false);
					dispfont=fontlist[fontindex];
				}
				break;
			case MOD1_MASK:	//Alt 修改颜色，适合svg和txt
				loop_color(false);
				break;
			default:
				set_scale(ref wscale,false);
				break;
			}
		}
		queue_draw();
		return true;
		});
	}
//----------------------------------------------------
	void set_scale(ref double scale,bool direction){
		if(direction){	//放大
			scale/=0.98;
			if(scale>4.5)scale=4.5;
		}else{		//缩小
			scale*=0.98;
			if(scale<0.2)scale=0.2;
		}
		if(mime=="image/svg+xml") resize((int)(max*wscale),(int)(max*hscale));
		else resize((int)(max*wscale),(int)(max*wscale));
	}
//----------------------------------------------------
	void loop_color(bool direction){
		if(mime=="image/png")return;
get_next_string_array(ref colorlist, ref colorindex, direction);
		if(mime=="image/svg+xml"&&offset>0){
contents=(str.substring(0,offset)+colorlist[colorindex]+str.substring(offset+6)).data;
		try{
			handle = new Rsvg.Handle.from_data(contents);
		} catch (GLib.Error e) {error ("%s", e.message);}
		}
	}
//---------------递归找数组中下一个非空字符串----------
	void get_next_string_array(
	ref string[] array, ref int index, bool direction){
		if (direction){	//向后找
			if (index<array.length-1) index++; else index=0;
		}else{	//向前找
			if (index>0) index--; else index=array.length-1;
		}
		if(array[index]!="") return;
		get_next_string_array(ref array,ref index,direction);
	}
//----------------------------------------------------
}
//----------------------------------------------------
int main (string[] args) {
	Gtk.init (ref args);
	if(args[1]==null) return 0;
	var w=new ShowSVGPNGTXT(args[1]);
	w.show_all(); Gtk.main(); return 0;
}
