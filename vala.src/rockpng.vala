//!valac --pkg gtk+-3.0 -X -lm %

using Gtk;
using Cairo;
//--------------------------------------------------------
public class swing {
	const double cos_a[]={0.2588,0.5,0.7071,0.866,0.966,1,  1,0.966,0.866,0.7071,0.5,0.2588};	//cos函数 0-75度,+15递增
	int cnt;				//查表循环计数
	int direct;				//顺时钟为1
	int max_angle;			//每周期递减的最大角度，递减表现为阻尼。

	public double angle;	//唯一外部使用的参数
//---------------------
	public void init() {max_angle=10; angle=0; direct=1; cnt=6;}
//---------------------
	public bool need_draw_swing() {
		if(max_angle==0) {init(); return false;}
		angle+=direct*(max_angle*cos_a[cnt]);
		if((cnt==cos_a.length-1 && direct==1) || (cnt==0 && direct==-1)) {direct=direct==1?-1:1; max_angle--;}
		else cnt+=direct;	// 转向时，停止一次变动，更加柔和。
//~ 		stdout.printf("cnt -> %d\tdirect -> %d\tmax_angle -> %f\tangle -> %f\n",cnt,direct,max_angle,angle);
		return true;
	}
}
//--------------------------------------------------------

class RockPNG : Gtk.Window {
	ImageSurface img;
	swing sss;
	int w;
	int h;
	int diagonal;

	public RockPNG(string instr) {
//窗口特性
		title = "RockPNG";
		skip_taskbar_hint = true;
		decorated = false;
/*        decorated = true;	//调试，开窗口边框*/
		app_paintable = true;
		set_position(MOUSE);
		set_visual(this.get_screen().get_rgba_visual());
		set_keep_above (true);
stdout.printf("%s ==== Version 0.01 ==== eexpss\n",title);
//允许鼠标事件
		destroy.connect (Gtk.main_quit);
		add_events (Gdk.EventMask.BUTTON_PRESS_MASK|Gdk.EventMask.SCROLL_MASK);
//----------------------------------------------------
//检测文件。
		try {
			File f = File.new_for_path(instr);
			string mime = f.query_info ("standard::content-type", 0, null).get_content_type();
			if (mime != "image/png") error ("%s => not png.\n", instr);
		} catch (GLib.Error e) {error ("%s", e.message);}
//------------------------
//读取图形。
		img = new Cairo.ImageSurface.from_png(instr);
		w=img.get_width(); h=img.get_height();
		diagonal=(int)Math.sqrt(Math.pow(w,2)+Math.pow(h,2));
		set_size_request(diagonal,diagonal);
		sss=new swing(); sss.init();
//----------------------------------------------------
//绘制窗口事件
		draw.connect ((da,ctx) => {	//直接在窗口绘图
			ctx.translate(diagonal/2,diagonal/2); //窗口中心为旋转原点
//~ 			ctx.rotate (rotate*Math.PI/180);
//~ stdout.printf("-> angle:%f\n",sss.angle);
			ctx.rotate(sss.angle*(Math.PI/180));
			ctx.translate(-w/2, -h/2);
			ctx.set_source_surface(img,0,0);
			ctx.paint ();
			return true;
		});
//----------------------------------------------------
		GLib.Timeout.add(50,()=>{
			bool ret=sss.need_draw_swing();
			queue_draw();
			return true;
//~ 			return ret;		//只循环摇动一次
		});
//----------------------------------------------------
//鼠标点击事件
		button_press_event.connect ((e) => {
				//拖动事件，是异步执行的，还会吃掉button_release_event松开按钮事件。捕捉不到结束。
				if(e.button == 1){
					begin_move_drag ((int)e.button, (int)e.x_root, (int)e.y_root, e.time);
				} else {Gtk.main_quit();}
				return true;
		});
//----------------------------------------------------
	}
}
//====================================================
int main (string[] args) {
	Gtk.init (ref args);
	if(args[1]==null) {stdout.printf("need png file.\n"); return 0;}
	var win=new RockPNG(args[1]);
	win.show_all(); Gtk.main(); return 0;
}
