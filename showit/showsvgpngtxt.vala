//!valac --pkg gtk+-3.0 --pkg librsvg-2.0 %
//!./%< 字体演示--Text
using Gtk;
using Cairo;

class ShowSVGPNGTXT : Gtk.Window {
		string mime="";
		string tmpstr="";
		string inputtext;
		ImageSurface img;

		Rsvg.Handle handle;
		uint8[] svg_buff={};
		const string keyid="sub0";
		long keyoffset=-1;
		const string switchid="#switch";
		int switchindex=-1;

		int colorindex=0;
		string[] colorlist={"ff0000","FF00FF","ffdd00","00ddff","000000","32CD32","0000dd", "7B68EE"};
		//Red, Magenta, Orange, White, Black, LimeGreen, MediumBlue, MediumSlateBlue
		double hscale=1;	//ctrl滚轮改svg水平缩放
		double scale=1;		//滚轮缩放
		double rotate=0;
		int w=300;
		int h=100;
		double diagonal;	//对角线

		int rootx; int rooty;	//窗口中心的root坐标
		int sw; int sh;	//旋转后的尺寸
		bool pressed;
		double minw; double minh;		//旋转或横向缩放后的原始矩形图形最紧凑尺寸

		string dispfont="Noto Sans";
		const int fsize=60;
		int y_bearing=0;

	public ShowSVGPNGTXT(string instr) {

		string[] fontlist={};
		int fontindex=-1;

		inputtext=instr;

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
		add_events (Gdk.EventMask.BUTTON_PRESS_MASK|Gdk.EventMask.BUTTON_RELEASE_MASK|Gdk.EventMask.SMOOTH_SCROLL_MASK);
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
			f.load_contents(null, out svg_buff, out etag_out);
			handle = new Rsvg.Handle.from_data(svg_buff);
		} catch (GLib.Error e) {error ("%s", e.message);}
		if(handle.has_sub(switchid+"0") && handle.has_sub(switchid+"1")) switchindex=0;

		tmpstr=(string) svg_buff;
		int i=tmpstr.index_of("id=\""+keyid+"\"", 0);
		if(i>0){	//向前找，2种格式
			int l=6;
			int j=tmpstr.substring(0,(long)i).last_index_of("fill:#");
			if(j<0){l=7;j=tmpstr.substring(0,(long)i).last_index_of("fill=\"#");}
			int k=tmpstr.substring(0,(long)i).last_index_of("<");
			if(j>k>0){keyoffset=j+l;}else{	//向后找
				l=6;
				j=tmpstr.substring((long)i).index_of("fill:#");
				if(j<0){l=7;j=tmpstr.substring((long)i).index_of("fill=\"#");}
				k=tmpstr.substring((long)i).index_of("/>");
				if(k>j>0){j+=i;keyoffset=j+l;}
			}
/*if(keyoffset>0)stdout.printf("find fill color: "+tmpstr.substring(keyoffset,6)+"\n");*/
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
		img = new ImageSurface(Format.ARGB32,600,200);
		get_font_size(); img.flush();
		img = new ImageSurface(Format.ARGB32,w,h);
	break;
}
//------------------
		minw=w; minh=h; sw=w; sh=h;
		set_size_request(w,h);
		get_position(out rootx, out rooty);
		rootx+=w/2; rooty+=h/2;
//----------------------------------------------------
//绘制窗口事件
		draw.connect ((da,ctx) => {	//直接在窗口绘图
			ctx.translate((double)(sw/2), (double)(sh/2)); //窗口中心为旋转原点
			ctx.rotate (rotate*Math.PI/180);
			ctx.scale(scale*hscale,scale);
			ctx.translate(-w/2, -h/2);
/*        int tmpx; int tmpy; get_position(out tmpx, out tmpy);*/
/*stdout.printf("%f-->\ttrans: %f x %f\troot: %d x %d\n",rotate,tmpx+sw/2,tmpy+sh/2,rootx,rooty);*/

switch(mime){
	case "image/svg+xml":
		if(switchindex>=0) handle.render_cairo_sub(ctx, switchid+switchindex.to_string());
		else handle.render_cairo(ctx);
		break;
	case "image/png":
		break;
	default:	//text
		ctx.select_font_face(dispfont,FontSlant.NORMAL,FontWeight.BOLD);
		ctx.set_font_size(fsize);
		ctx.set_source_rgba (0.3, 0.3, 0.3, 0.8);
		ctx.move_to(2,y_bearing+2);
		ctx.show_text(inputtext);
		Gdk.RGBA cc=Gdk.RGBA();		//html color convert to rgba
		cc.parse("#"+colorlist[colorindex]);
		ctx.set_source_rgba (cc.red, cc.green, cc.blue, 0.8);
		ctx.move_to(0,y_bearing);
		ctx.show_text(inputtext);
		break;
	}
			ctx.set_source_surface(img,0,0);
			ctx.paint (); //除掉img偏移量，绘图。
			return true;
		});
//----------------------------------------------------
//鼠标点击事件
	button_press_event.connect ((e) => {
			if(e.button == 1){
			pressed=true;
begin_move_drag ((int)e.button, (int)e.x_root, (int)e.y_root, e.time);	//拖动事件，是异步执行的，还会吃掉button_release_event松开按钮事件。捕捉不到结束。
			} else {Gtk.main_quit();}
			return true;
	});
//----------------------------------------------------
//鼠标滚轮事件
scroll_event.connect ((e) => {
	if(pressed){	//上一次拖动后的新中心坐标
		get_position(out rootx, out rooty);
/*        sw=(int)(minw*scale); sh=(int)(minh*scale);*/
		rootx+=sw/2; rooty+=sh/2;
		pressed=false;
/*        stdout.printf("root: %d x %d\n",rootx,rooty);*/
	}
//------------------
	if(e.direction==Gdk.ScrollDirection.UP){
		switch(e.state){
		case SHIFT_MASK:
			rotate+=15; if(rotate>180)rotate-=360;
			getminsize();
			break;
		case CONTROL_MASK:
			if(mime=="image/svg+xml"){
				if(switchindex>=0) switchnext(true);
				else set_scale(ref hscale,true);
			}else{
				if(fontindex<0)break;
get_next_string_array(ref fontlist, ref fontindex, true);
				dispfont=fontlist[fontindex];
				get_font_size(); getminsize();
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
//------------------
	if(e.direction==Gdk.ScrollDirection.DOWN){
		switch(e.state){
		case SHIFT_MASK:
			rotate-=15; if(rotate<-180)rotate+=360;
			getminsize();
			break;
		case CONTROL_MASK:
			if(mime=="image/svg+xml"){
				if(switchindex>=0) switchnext(false);
				else set_scale(ref hscale,false);
			}else{
				if(fontindex<0)break;
get_next_string_array(ref fontlist, ref fontindex, false);
				dispfont=fontlist[fontindex];
				get_font_size(); getminsize();
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
//------------------
	queue_draw();
	return true;
	});
}
//====================================================
	void set_scale(ref double s,bool direction){
		if(direction){	//放大
			s/=0.98;
			if(s>4.5)s=4.5;
		}else{		//缩小
			s*=0.98;
			if(s<0.2)s=0.2;
		}
		getminsize();
	}
//----------------------------------------------------
	void getminsize(){
		double inangle=Math.atan(h/(double)(w*hscale));	//对角线夹角弧度
		double angle=Math.fabs(rotate);	//0-180
		if(angle>90)angle=180-angle;	//0-90
		angle=angle*Math.PI/180;	//变成弧度
		diagonal=Math.sqrt(Math.pow(w*hscale,2)+Math.pow(h,2));
		minw=Math.cos(angle-inangle)*diagonal;
		minh=Math.sin(angle+inangle)*diagonal;
		sw=(int)(minw*scale); sh=(int)(minh*scale);
/*        sw=(int)(Math.ceil)(minw*scale); sh=(int)(Math.ceil)(minh*scale);*/
		move(rootx-sw/2,rooty-sh/2);	//旋转，就界面跳动！！！
		resize(sw,sh);
	}
//----------------------------------------------------
	void loop_color(bool direction){
		if(mime=="image/png")return;
get_next_string_array(ref colorlist, ref colorindex, direction);
		if(mime=="image/svg+xml"&&keyoffset>0){
svg_buff=(tmpstr.substring(0,keyoffset)+colorlist[colorindex]+tmpstr.substring(keyoffset+6)).data;
		try{
			handle = new Rsvg.Handle.from_data(svg_buff);
		} catch (GLib.Error e) {error ("%s", e.message);}
		}
	}
//----------------------------------------------------
	void switchnext(bool direction){
		if(direction) {
			switchindex++;
			if(!handle.has_sub(switchid+switchindex.to_string()))
				switchindex=0;
		} else {
			switchindex--;
			if(switchindex<0){
				switchindex=7;	//max 8 icons
				while(!handle.has_sub(switchid+switchindex.to_string())){
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
		if(array[index]!=""){return;}
		get_next_string_array(ref array,ref index,direction);
	}
//----------------------------------------------------
	void get_font_size(){
		var tmpctx = new Cairo.Context(img);
		Cairo.TextExtents ex;
		tmpctx.select_font_face(dispfont,FontSlant.NORMAL,FontWeight.BOLD);
		tmpctx.set_font_size(fsize);
		tmpctx.text_extents (inputtext, out ex);
/*        w=(int)ex.width; h=(int)ex.height;*/
/*x_bearing: 2.000000, width: 246, x_advance: 249.000000*/
/*y_bearing: -46.000000, height: 57, y_advance: 0.000000*/
		w=(int)ex.x_advance;
		h=(int)ex.height+3;
		y_bearing=(int)Math.fabs(ex.y_bearing);
	}
//----------------------------------------------------
}
//----------------------------------------------------
int main (string[] args) {
	Gtk.init (ref args);
	if(args[1]==null) return 0;
	var win=new ShowSVGPNGTXT(args[1]);
	win.show_all(); Gtk.main(); return 0;
}
