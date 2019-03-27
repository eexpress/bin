/*▶ valac --pkg gtk+-3.0 -X -lm timer.vala*/
using Gtk;
using Cairo;
	
//--------------------------------------------------------
/*
圆心：鼠标1键开关定时，其他键退出。
其他：鼠标1键拖动，其他键选择定时。
滚轮：切换显示大小
*/
//--------------------------------------------------------
public class Timer : Gtk.Window {
	int size=400;
	int th=0; int tm=0;
	int h; int m;
	double Dalarm=0;
	double alarm_alpha=0;	//no alarm
//----------------------------
	public Timer() {
	Gdk.RGBA cc=Gdk.RGBA();
	string time="";
		title = "Timer";
		decorated = false;
		app_paintable = true;
		set_visual(this.get_screen().get_rgba_visual());
/*        set_keep_above (true);*/
		set_size_request(size,size);
		destroy.connect (Gtk.main_quit);
		add_events (Gdk.EventMask.BUTTON_PRESS_MASK|Gdk.EventMask.SCROLL_MASK);

		GLib.Timeout.add_seconds(10,()=>{
			queue_draw();
			if(h==th && m==tm && alarm_alpha==1){
/*                Posix.system("canberra-gtk-play -f cow.wav");*/
try {
	string[] spawn_args = {"/usr/bin/canberra-gtk-play","-l","5","-i","complete"};
	string[] spawn_env = Environ.get ();
	Pid child_pid;
	int standard_input; int standard_output; int standard_error;
	Process.spawn_async_with_pipes ("/", spawn_args, spawn_env, SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD, null, out child_pid, out standard_input, out standard_output, out standard_error);
ChildWatch.add(child_pid,(pid,status) => {Process.close_pid(pid);});
} catch (SpawnError e) { print ("Error: %s\n", e.message); }
			}
			return true;});

		draw.connect ((da,ctx) => {
			ctx.set_font_size(size/6);
			Cairo.TextExtents ex;
			ctx.translate(size/2, size/2);	//窗口中心为坐标原点。
			ctx.set_line_cap (Cairo.LineCap.ROUND);
			ctx.set_operator (Cairo.Operator.SOURCE);
			cc.parse("#A80CA8");	//紫色
			ctx.set_source_rgba (cc.red, cc.green, cc.blue, 1);
			ctx.set_line_width (size/20);
			ctx.arc(0,0,size/2-size/20/2,0,2*Math.PI);
			ctx.stroke();
			cc.parse("#C3C3C3");	//灰色
			ctx.set_source_rgba (cc.red, cc.green, cc.blue, 0.8);
			ctx.arc(0,0,size/2-size/20,0,2*Math.PI);
			ctx.fill();
//---------------------graduation
			for(int i=0;i<12;i++){
				ctx.set_line_width (size/20);
				ctx.save();
				ctx.rotate(i*30*(Math.PI/180));
				if(i%3==0){
					ctx.set_line_width (size/20);
					ctx.set_source_rgba (0, 0, 0, 0.9);
				}else{
					ctx.set_line_width (size/50);
					ctx.set_source_rgba (0.2, 0.2, 0.2, 0.4);
				}
				ctx.move_to(0,-(size/2-20));
				ctx.rel_line_to(0,-5); ctx.stroke();
				ctx.restore();
			}
//---------------------alarm text
			cc.parse("#A80CA8");	//紫色
			ctx.set_source_rgba (cc.red, cc.green, cc.blue, alarm_alpha);
			time=th.to_string()+":"+tm.to_string();
			ctx.text_extents (time, out ex);
			ctx.move_to(-ex.width/2,ex.height*2);
			ctx.show_text(time);
//---------------------clock text
			ctx.set_source_rgba (0.2, 0.2, 0.8, alarm_alpha);	//蓝色
			var now = new DateTime.now_local ();
			h=now.get_hour(); m=now.get_minute();
			if(h>=12)h-=12;
			time=h.to_string()+":"+m.to_string();
			ctx.text_extents (time, out ex);
			ctx.move_to(-ex.width/2,-ex.height);
			ctx.show_text(time);
//---------------------
draw_line(ctx, "#353CDB", 0.9, size/20, (h*30+m*30/60)*(Math.PI/180),0,-(size/2-45));	//时针，30度1小时
draw_line(ctx, "", 0.9, size/30, m*6*(Math.PI/180),0,-(size/2-30));	//分针，6度1分钟
draw_line(ctx, "#A80CA8", alarm_alpha, size/25, Dalarm*(Math.PI/180),0,-(size/4));	//定时针，30度1小时，30度内分60分钟
//---------------------center
			ctx.set_source_rgba (0.9, 0.2, 0.2, 0.9);	//蓝色
			ctx.arc(0,0,size/20,0,2*Math.PI);
			ctx.fill();
			return true;
		});
//----------鼠标点击事件。
	button_press_event.connect ((e) => {
	//----------root坐标转窗口坐标，计算和原点的距离。
		int x; int y; get_position(out x, out y);
		x=(int)(e.x_root-x-size/2);
		y=(int)(e.y_root-y-size/2);
		int d=(int)Math.sqrt(Math.pow(x,2)+Math.pow(y,2));
		if(d<size/20){	//圆心之内
			if(e.button == 1){alarm_alpha=alarm_alpha==1?0:1;queue_draw();}
			else Gtk.main_quit();
			return true;
		}
		if(e.button == 1){	//圆心之外
begin_move_drag ((int)e.button, (int)e.x_root, (int)e.y_root, e.time);
		} else {
			Dalarm=Math.atan2(y, x)/(Math.PI/180)+90;
			if(Dalarm<0)Dalarm+=360;	//修正成向上为0度。
			th=(int)(Dalarm/30);	//30度1小时
			tm=(int)((Dalarm-th*30)/30*60);
			tm=tm/5*5;		//调整成5分钟一格
			queue_draw();
		}
		return true;
	});
//------------鼠标滚轮事件
	scroll_event.connect ((e) => {
		if(e.direction==Gdk.ScrollDirection.UP){
			if(size<400)size+=50;
		}
		if(e.direction==Gdk.ScrollDirection.DOWN){
			if(size>100)size-=50;
		}
		set_size_request(size,size);
		return true;
	});
	//---------------------
}
//---------------------
	void draw_line(Cairo.Context ctx, string color, double alpha, int width, double angle, int dx, int dy){
		Gdk.RGBA rgb=Gdk.RGBA();
		if(color!=""){
			rgb.parse(color);
			ctx.set_source_rgba (rgb.red, rgb.green, rgb.blue, alpha);
		}
		ctx.save(); 
		if(width>0) ctx.set_line_width (width);
		ctx.move_to (0, 0);
		ctx.rotate(angle); ctx.line_to(dx, dy);
		ctx.stroke(); ctx.restore();
	}
//---------------------
}
//--------------------------------------------------------
int main (string[] args) {
		Gtk.init(ref args);
		var ww = new Timer(); ww.show_all();
		Gtk.main(); return 0;
}
//--------------------------------------------------------
