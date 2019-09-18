//!valac --pkg gtk+-3.0 --pkg librsvg-2.0 %
//x!./%< 字体演示--Text
//x!./%< switch-Emoticon.svg
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
		double wscale=1;	//ctrl滚轮改svg水平缩放
		double scale=1;		//滚轮缩放
		double rotate=0;
		int w=300;
		int h=100;

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
/*        decorated = true;	//调试，开窗口边框*/
		app_paintable = true;
		set_position(MOUSE);
		set_visual(this.get_screen().get_rgba_visual());
		set_keep_above (true); 
stdout.printf("%s ====== Version 0.62\n",title);
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
			f.load_contents(null, out svg_buff, out etag_out);
/*    svg_buff		附注：需要类型‘char **’，但实参的类型为‘guint8 **’ {或称 ‘unsigned char **’}*/
			handle = new Rsvg.Handle.from_data(svg_buff);
/*            handle = new Rsvg.Handle.from_file(inputtext);*/
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
/*        w=(int)handle.width; h=(int)handle.height;*/
		Rsvg.Rectangle x;
		Rsvg.Length rw, rh;
		bool hasw,hash,hasv;
		handle.get_intrinsic_dimensions (out hasw, out rw, out hash, out rh, out hasv, out x);
		if(hasw && hash){
			if(rw.unit==Rsvg.Unit.MM){	//毫米单位	CM EM EX IN MM PC PERCENT PT PX
				w=(int)(rw.length*handle.dpi_x/25.4);
				h=(int)(rh.length*handle.dpi_y/25.4);
			}else{		//认为是pixel/point单位，枚举都没判断
				w=(int)rw.length; h=(int)rh.length;
			}
		}else{ w=(int)x.width; h=(int)x.height; }	//hasv 都没判断
/*stdout.printf("svg dimension :\t%d x %d,\t%f-%f,\t%d\n",w,h,handle.width,handle.height,(int)rw.unit);*/

		img = new ImageSurface(Format.ARGB32,w,h);	//创建表面
	break;
case "image/png":
		img = new Cairo.ImageSurface.from_png(inputtext);
		w=img.get_width(); h=img.get_height();
	break;
default:	//text
//------------------get font array
		string file_contents="";
		tmpstr=Environment.get_variable("HOME")+"/.config/showit.fontname.list";
		f = File.new_for_path(tmpstr);
		if(f.query_exists()){
			try{
				FileUtils.get_contents(tmpstr, out file_contents);
				if(file_contents!=""){fontlist = file_contents.split("\n",8);}
			} catch (GLib.Error e) {error ("%s", e.message);}
		}
		if(fontlist[0]!=null){fontindex=0; dispfont=fontlist[0];}
//------------------get text display size
		img = new ImageSurface(Format.ARGB32,600,200);
		get_font_size(); img.flush();
		img = new ImageSurface(Format.ARGB32,w,h);
	break;
}
//----------------------------------------------------
//绘制窗口事件
		draw.connect ((da,ctx) => {	//直接在窗口绘图
int diagonal=(int)(Math.sqrt(Math.pow(w*wscale,2)+Math.pow(h,2))*scale);
			resize(diagonal,diagonal);
			ctx.translate(diagonal/2,diagonal/2); //窗口中心为旋转原点
			ctx.rotate (rotate*Math.PI/180);
			ctx.scale(scale*wscale,scale);
			ctx.translate(-w/2, -h/2);
/*stdout.printf("w:%d\th:%d\ts:%f\ths:%f\tr:%f\tdia:%d\n",w,h,scale,wscale,rotate,diagonal);*/

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
		ctx.set_source_rgba (0.3, 0.3, 0.3, 0.8);	//文字阴影
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
			ctx.paint ();
			return true;
		});
//----------------------------------------------------
//鼠标点击事件
	button_press_event.connect ((e) => {
			if(e.button == 1){
begin_move_drag ((int)e.button, (int)e.x_root, (int)e.y_root, e.time);	//拖动事件，是异步执行的，还会吃掉button_release_event松开按钮事件。捕捉不到结束。
			} else {Gtk.main_quit();}
			return true;
	});
//----------------------------------------------------
//鼠标滚轮事件
scroll_event.connect ((e) => {
	bool up;
	if(e.direction==Gdk.ScrollDirection.UP){ up=true; }
	else if(e.direction==Gdk.ScrollDirection.DOWN){ up=false; }
	else return true;
//----------------
	switch(e.state){
	case SHIFT_MASK:	//Shift 旋转
		if(up){rotate+=15; if(rotate>=360)rotate-=360;}
		else{rotate-=15; if(rotate<0)rotate+=360;}
		break;
	case CONTROL_MASK:	//Ctrl
		if(mime=="image/svg+xml"){	//图片
			if(switchindex>=0) switchnext(up);	//切换图层
			else set_scale(ref wscale,up);		//拉伸
		}else{			//文字字体
			if(fontindex<0)break;
			get_next_string_array(ref fontlist, ref fontindex, up);
			dispfont=fontlist[fontindex];
			get_font_size();
		}
		break;
	case MOD1_MASK:		//Alt 修改颜色，适合svg和txt
		loop_color(up); break;
	default:			//缩放
		set_scale(ref scale,up); break;
	}
//----------------
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
/*        Window managers are free to ignore this; most window managers ignore requests for initial window positions (instead using a user-defined placement algorithm) and honor requests after the window has already been shown.*/
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
				switchindex=7;	//Maximum 8 icons
			while(!handle.has_sub(switchid+switchindex.to_string())){switchindex--;}
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
