/*▶ valac --pkg gtk+-3.0 -X -lm timer.vala*/
using Gtk;
using Cairo;
	
//---------------------------------------
public class swing {
	public double vscale;
	int cnt;		//下摆动需要cnt
	const int max_cnt=6;	//半幅度下摆动次数
	int direct;
	double step_angle;	//switch of swing
	double decay=0.1;	//const
	double angle;
	const double min_angle=50;	//第一次到达后，确定max_cnt
	public bool dark=true;	//for light deal
//---------------------
	public void init() {step_angle=10; angle=90; direct=1; cnt=0; vscale=1;}
//---------------------
	public bool need_draw_swing() {
			if(step_angle<=0) {init(); 
			return false;}
			angle-=step_angle*direct;
			step_angle-=decay;
			//需要容错。保持摇摆能归位。
			if(step_angle<=0 && angle<89) step_angle=decay;
			if(direct==1){	//下摆动记次数
				cnt++;
				if(cnt>=max_cnt) {direct=-1; cnt=0;}
			}else{	//上摆动经过90度才改变方向
				dark=!dark;	//direct change from -1 to 1
				if(angle>=90) direct=1;
			}
			vscale=Math.sin(angle*(Math.PI/180));
			return true;
		}
}
//---------------------------------------

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
	int timespan=0;	//alarm和time的分钟差距。
	DateTime now;
/*    string svg="<可以embed svg，需要将\"替换成'>";*/
/*        handle = new Rsvg.Handle.from_data(svg.data);*/
//----------------------------
	public Timer() {
	Gdk.RGBA cc=Gdk.RGBA();
	string showtext="";
		title = "Timer";
		decorated = false;
		app_paintable = true;
		set_visual(this.get_screen().get_rgba_visual());
		set_size_request(size,size);
		var sss=new swing(); sss.init();
		destroy.connect (Gtk.main_quit);
add_events (Gdk.EventMask.BUTTON_PRESS_MASK|Gdk.EventMask.SCROLL_MASK);

		GLib.Timeout.add_seconds(10,()=>{
			queue_draw();
			if(h==th && m==tm && alarm_alpha==1){
				GLib.Timeout.add(50,()=>{
					if(sss.need_draw_swing()){queue_draw(); return true;}
					else return false;});
					present(); set_keep_above(true);
	string exec=GLib.Environment.get_home_dir()+"/.config/time.script";
/*                Posix.system("canberra-gtk-play -f cow.wav");*/
try {
	string[] spawn_args = {"/usr/bin/canberra-gtk-play","-l","5","-i","complete"};
	File f = File.new_for_path(exec);
	if(f.query_exists()){spawn_args = {exec};}
	string[] spawn_env = Environ.get ();
	Pid child_pid;
	Process.spawn_async ("/", spawn_args, spawn_env, SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD, null, out child_pid);
ChildWatch.add(child_pid,(pid,status) => {Process.close_pid(pid);});
} catch (SpawnError e) { print ("Error: %s\n", e.message); }
			}
			return true;});

		draw.connect ((da,ctx) => {
/*            handle.render_cairo(ctx);*/
			Cairo.TextExtents ex;
			ctx.set_font_size(size/8);
			ctx.translate(size/2, size/2);	//窗口中心为坐标原点。
			ctx.set_line_cap (Cairo.LineCap.ROUND);
			ctx.set_operator (Cairo.Operator.SOURCE);
			ctx.scale(1,sss.vscale);

			ctx.set_source_rgba (0, 0, 0, 1);
			ctx.set_line_width (size/30);
			ctx.arc(0,0,size/2.2,0,2*Math.PI);
			ctx.stroke();
			cc.parse("#D8D8D8");
			ctx.set_source_rgba (cc.red, cc.green, cc.blue, 1);
			ctx.set_line_width (size/20);
			ctx.arc(0,0,size/2.3,0,2*Math.PI);
			ctx.stroke();
			double xx;
			if(!sss.dark) xx=sss.vscale; else xx=1/sss.vscale;
			cc.parse("#C3C3C3");
			ctx.set_source_rgba (cc.red*xx, cc.green*xx, cc.blue*xx, 0.8);
			ctx.arc(0,0,size/2-size/20,0,2*Math.PI);
			ctx.fill();
			cc.parse("#D8D8D8");
			ctx.set_source_rgba (0, 0, 0, 0);
			ctx.set_line_width (3);
			ctx.arc(0,0,size/2.5,0,2*Math.PI);
			ctx.stroke();
//---------------------graduation
			for(int i=0;i<12;i++){
				ctx.set_line_width (size/20);
				ctx.save();
				ctx.rotate(i*30*(Math.PI/180));
				if(i%3==0){
					ctx.set_line_width (size/30);
					ctx.set_source_rgba (0, 0, 0, 0.8);
				}else{
					ctx.set_line_width (size/50);
					ctx.set_source_rgba (0.2, 0.2, 0.2, 0.2);
				}
				ctx.move_to(0,-(size/2-20));
				ctx.rel_line_to(0,-5); ctx.stroke();
				ctx.restore();
			}
//---------------------alarm text
			cc.parse("#A80CA8");	//紫色
			ctx.set_source_rgba (cc.red, cc.green, cc.blue, alarm_alpha);
			showtext="%02d:%02d".printf(th,tm);
			ctx.text_extents (showtext, out ex);
			ctx.move_to(-ex.width/2,ex.height*2);
			ctx.show_text(showtext);
			if(timespan>0){
				showtext="+"+timespan.to_string();
				ctx.text_extents (showtext, out ex);
				ctx.move_to(-ex.width/2,ex.height*3.5);
				ctx.show_text(showtext);
			}
//---------------------clock text
			ctx.set_source_rgba (0, 0, 0, alarm_alpha);
			now = new DateTime.now_local ();
			h=now.get_hour(); m=now.get_minute();
			h%=12;
			showtext="%02d:%02d".printf(h,m);
			ctx.text_extents (showtext, out ex);
			ctx.move_to(-ex.width/2,-ex.height);
			ctx.show_text(showtext);
//---------------------
draw_line(ctx, "#000000", 0.9, size/20, (h*30+m*30/60)*(Math.PI/180),0,-(int)(size/3.6));	//时针，30度1小时
draw_line(ctx, "", 0.9, size/30, m*6*(Math.PI/180),0,-(int)(size/2.5));	//分针，6度1分钟
draw_line(ctx, "#A80CA8", alarm_alpha, size/25, Dalarm*(Math.PI/180),0,-(int)(size/4));	//定时针，30度1小时，30度内分60分钟
//---------------------center
			ctx.set_source_rgba (0, 0, 0, 0.9);
			ctx.arc(0,0,size/20,0,2*Math.PI);
			ctx.fill();
			ctx.set_source_rgba (0.87, 0, 0, 0.9);	//暗红
			ctx.arc(0,0,size/35,0,2*Math.PI);
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
			if(e.button == 1){
				alarm_alpha=alarm_alpha==1?0:1;
				if(alarm_alpha==0) set_keep_above(false);
				queue_draw();}
			else Gtk.main_quit();
			return true;
		}
		timespan=0;
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
		int x; int y; get_position(out x, out y);
		x=(int)(e.x_root-x-size/2);
		y=(int)(e.y_root-y-size/2);
		int d=(int)Math.sqrt(Math.pow(x,2)+Math.pow(y,2));
		if(e.direction==Gdk.ScrollDirection.UP){
			if(d<size/20){timespan++;change_from_current_time();}
			else if(size<400)size+=50;
		}
		if(e.direction==Gdk.ScrollDirection.DOWN){
			if(d<size/20){timespan--;change_from_current_time();}
			else if(size>100)size-=50;
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
	void change_from_current_time(){
		//从now加减timespan分钟，设置th:tm
		DateTime x=now.add_minutes(timespan);
		th=x.get_hour(); tm=x.get_minute();
		th%=12;
		Dalarm=th*30+tm/2;
		queue_draw();
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
