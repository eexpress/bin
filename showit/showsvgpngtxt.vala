//!valac --pkg gtk+-3.0 --pkg librsvg-2.0 %
//!./%< 字体演示--Text
using Gtk;
using Cairo;

class ShowSVGPNGTXT : Gtk.Window {
		string mime="";
		string str="";
		uint8[] contents={};
		const string keyid="sub0";
		long offset=-1;
		int colorindex=0;
		string[] colorlist={"ff0000","FF00FF","ffdd00","00ddff","000000","32CD32","0000dd", "7B68EE"};
		//Red, Magenta, Orange, White, Black, LimeGreen, MediumBlue, MediumSlateBlue
		Rsvg.Handle handle;
		int max;	//原始图形正方形边长
		double hscale=1;	//ctrl滚轮改svg水平缩放
		double scale=1;		//滚轮缩放
		double maxscale=1;
		int switchindex=-1;

	public ShowSVGPNGTXT(string inputtext) {
		ImageSurface img;
		double rotate=0;
		int w=300;
		int h=100;

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
		if(handle.has_sub("#switch0") && handle.has_sub("#switch1")) switchindex=0;

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
		w+=w/10;	//不同字体宽度不同。并不方便切换时候resize窗口。
/*x_bearing: 2.000000, width: 246, x_advance: 249.000000*/
/*y_bearing: -46.000000, height: 57, y_advance: 0.000000*/
		img.flush();
		img = new ImageSurface(Format.ARGB32,w,h);
	break;
}
		max=(int)Math.sqrt(Math.pow(w,2)+Math.pow(h,2));
		set_size_request(max,max);
//----------------------------------------------------
//绘制窗口事件
		draw.connect ((da,ctx) => {	//直接在窗口绘图
			ctx.translate(max*maxscale/2, max*maxscale/2); //窗口中心为旋转原点
			ctx.scale(scale,scale);
			ctx.rotate (rotate*Math.PI/180);
			ctx.scale(hscale,1);
			ctx.translate(-max/2, -max/2);

switch(mime){
	case "image/svg+xml":
		ctx.translate((max-w)/2,(max-h)/2);
		if(switchindex>=0) handle.render_cairo_sub(ctx, "#switch"+switchindex.to_string());
		else handle.render_cairo(ctx);
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
					if(switchindex>=0) switchnext(true);
					else set_scale(ref hscale,true);
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
				set_scale(ref scale,true);
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
					if(switchindex>=0) switchnext(false);
					else set_scale(ref hscale,false);
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
				set_scale(ref scale,false);
				break;
			}
		}
		queue_draw();
		return true;
		});
	}
//----------------------------------------------------
	void set_scale(ref double s,bool direction){
		double max0=maxscale;
		if(direction){	//放大
			s/=0.98;
			if(s>4.5)s=4.5;
		}else{		//缩小
			s*=0.98;
			if(s<0.2)s=0.2;
		}
		maxscale=hscale>1?scale*hscale:scale;
/*        Window managers are free to ignore this; most window managers ignore requests for initial window positions (instead using a user-defined placement algorithm) and honor requests after the window has already been shown.*/
/*        int off=(int)(max*(maxscale-max0)/2);*/
/*        int root_x; int root_y;*/
/*        get_position(out root_x, out root_y);*/
/*        move(root_x-off, root_y-off);*/
		resize((int)(max*maxscale),(int)(max*maxscale));
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
//----------------------------------------------------
	void switchnext(bool direction){
		if(direction) {
			switchindex++;
			if(!handle.has_sub("#switch"+switchindex.to_string()))
				switchindex=0;
		} else {
			switchindex--;
			if(switchindex<0){
				switchindex=7;	//max 8 icons
				while(!handle.has_sub("#switch"+switchindex.to_string())){
					switchindex--;
				}
			}
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
