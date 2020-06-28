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
	const int size=400;
	const int MIN = size/10;
	const int MAX = size/2-size/12;

	const string B_COLOR="#4E4E4E";
	const string F_COLOR="#CCCCCC";
	const string M_COLOR="#57C575";

	int mm = 0;
	Gdk.RGBA cc;
//----------------------------
	public Timer() {
		title = "AT";
		decorated = false; app_paintable = true;
		set_visual(this.get_screen().get_rgba_visual());
		set_size_request(size,size);
		add_events (Gdk.EventMask.BUTTON_PRESS_MASK|Gdk.EventMask.POINTER_MOTION_MASK);
		destroy.connect (Gtk.main_quit);
		draw.connect (on_draw);
//----------鼠标移动事件。
		motion_notify_event.connect ((e) => {
			int x; int y;
			x=(int)(e.x-size/2); y=(int)(e.y-size/2);
			int d=(int)Math.sqrt(Math.pow(x,2)+Math.pow(y,2));
			if(d<MIN || d>MAX) return true;	//有效圆环
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
		if(d>MAX) return true;	//有效圆环以外
		if(d<MIN){	//圆心之内
			if(e.button == 1){
				begin_move_drag ((int)e.button, (int)e.x_root, (int)e.y_root, e.time);
			}
			else Gtk.main_quit();
			return true;
		}
		if(e.button == 1){	//有效圆环
			stdout.printf("at now + %d minutes\n",mm);
//~ echo 'export DISPLAY=:0.0 && /home/eexpss/bin/rockpng "/home/eexpss/图片/s.png"' |\at "now + 1 minutes"
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
		cc.parse(B_COLOR); ctx.set_source_rgba (cc.red, cc.green, cc.blue, 0.8);
		ctx.arc(0,0,size/2-size/20,0,2*Math.PI);
		ctx.fill();
//---------------------刻度
		ctx.save();
		cc.parse(F_COLOR); ctx.set_source_rgba (cc.red, cc.green, cc.blue, 1);
		for(int i=0;i<60;i++){
			ctx.set_line_width (2);
			ctx.move_to(0,-MAX);
			if(i%5==0){	ctx.rel_line_to(0,15); }else{ ctx.rel_line_to(0,5); }
			ctx.stroke();
			ctx.rotate(6*(Math.PI/180));	//6度一个刻度
		}
		ctx.restore();
//---------------------增加一个扇形延时显示
		ctx.save();
		cc.parse(M_COLOR); ctx.set_source_rgba (cc.red, cc.green, cc.blue, 0.6);
		ctx.rotate(-Math.PI/2);
		ctx.move_to(0,0);
		ctx.arc(0,0,size/2-size/8,0,mm*Math.PI/30);
		ctx.fill();
		ctx.restore();
//---------------------圆心
		cc.parse(F_COLOR); ctx.set_source_rgba (cc.red, cc.green, cc.blue, 1);
		ctx.arc(0,0,MIN,0,2*Math.PI);
		ctx.fill();
//---------------------时间
		cc.parse(B_COLOR); ctx.set_source_rgba (cc.red, cc.green, cc.blue, 0.8);
		ctx.set_font_size(size/12);
		string showtext="%d".printf(mm);
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
