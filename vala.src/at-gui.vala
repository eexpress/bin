//!valac --pkg gtk+-3.0 -X -lm %f
//#!./% &
using Gtk;
using Cairo;
//--------------------------------------------------------
/*
圆心：鼠标1键拖动，其他键退出。
其他：鼠标1键选择定时。
*/
//--------------------------------------------------------
public class Timer : Gtk.Window {
	int size=400;
	int mm = 0;
	const int DCENTER = 10;		//圆心尺寸除数

	const string back_color="#4E4E4E";

	Gdk.RGBA cc;
	string showtext="";
//----------------------------
	public Timer() {
		cc=Gdk.RGBA();
		title = "AT";
		decorated = false;
		app_paintable = true;
		set_visual(this.get_screen().get_rgba_visual());
		set_size_request(size,size);
		destroy.connect (Gtk.main_quit);
		add_events (Gdk.EventMask.BUTTON_PRESS_MASK|Gdk.EventMask.POINTER_MOTION_MASK);
		draw.connect (on_draw);
//----------鼠标移动事件。
	motion_notify_event.connect ((e) => {
		int x; int y;
		x=(int)(e.x-size/2); y=(int)(e.y-size/2);
		int d=(int)Math.sqrt(Math.pow(x,2)+Math.pow(y,2));
		if(d<size/DCENTER||d>size/2-size/15) return true;	//有效圆环
		double cm=Math.atan2(y, x)/(Math.PI/180)+90;
		if(cm<0) cm+=360;
		mm=(int)(cm/6);
		queue_draw();
		return true;
	});
//----------鼠标点击事件。
	button_press_event.connect ((e) => {
		int x; int y;
		x=(int)(e.x-size/2); y=(int)(e.y-size/2);
		int d=(int)Math.sqrt(Math.pow(x,2)+Math.pow(y,2));
		if(d>size/2-size/15) return true;	//有效圆环以外
		if(d<size/DCENTER){	//圆心之内
			if(e.button == 1){
				begin_move_drag ((int)e.button, (int)e.x_root, (int)e.y_root, e.time);
			}
			else Gtk.main_quit();
			return true;
		}
		if(e.button == 1){	//有效圆环
			stdout.printf("at now + %d minutes\n",mm);
//~ 			echo 'export DISPLAY=:0.0 && /home/eexpss/bin/rockpng "/home/eexpss/图片/s.png"' |\at "now + 1 minutes"
//~ echo "export DISPLAY=:0.0 && /home/eexpss/bin/rockpng "/home/eexpss/图片/s.png"" |\at "now + 1 minutes"

			Gtk.main_quit();
		}
		return true;
	});
}
//---------------------
	private bool on_draw (Context ctx) {
		ctx.translate(size/2, size/2);	//窗口中心为坐标原点。
		ctx.set_line_cap (Cairo.LineCap.ROUND);
		ctx.set_operator (Cairo.Operator.SOURCE);
//---------------------底色
		cc.parse(back_color);
		ctx.set_source_rgba (cc.red, cc.green, cc.blue, 0.8);
		ctx.arc(0,0,size/2-size/20,0,2*Math.PI);
		ctx.fill();
//---------------------刻度
		ctx.save();
		cc.parse("#999999");
		ctx.set_source_rgba (cc.red, cc.green, cc.blue, 1);
		for(int i=0;i<60;i++){
			ctx.set_line_width (2);
			ctx.move_to(0,-(size/2-size/12));
			if(i%5==0){	ctx.rel_line_to(0,15); }else{ ctx.rel_line_to(0,5); }
			ctx.stroke();
			ctx.rotate(6*(Math.PI/180));	//6度一个刻度
		}
		ctx.restore();
//---------------------增加一个扇形延时显示
		ctx.save();
		cc.parse("#57C575");
		ctx.set_source_rgba (cc.red, cc.green, cc.blue, 1);
		ctx.rotate(-Math.PI/2);
		ctx.move_to(0,0);
		ctx.arc(0,0,size/2-size/9,0,mm*Math.PI/30);
		ctx.fill();
		ctx.restore();
//---------------------圆心
		cc.parse("#C7C7C7");
		ctx.set_source_rgba (cc.red, cc.green, cc.blue, 1);
		ctx.arc(0,0,size/DCENTER,0,2*Math.PI);
		ctx.fill();
//---------------------时间
		cc.parse(back_color);
		ctx.set_source_rgba (cc.red, cc.green, cc.blue, 0.8);
		ctx.set_font_size(size/12);
		showtext="%d".printf(mm);
		Cairo.TextExtents ex;
		ctx.text_extents (showtext, out ex);
		ctx.move_to(-ex.width/2,ex.height/2);
		ctx.show_text(showtext);
		return true;
	}
}
//--------------------------------------------------------
int main (string[] args) {
	Gtk.init(ref args);
	var ww = new Timer(); ww.show_all();
	Gtk.main(); return 0;
}
//--------------------------------------------------------
