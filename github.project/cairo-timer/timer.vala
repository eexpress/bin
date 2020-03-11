//!valac --pkg gtk+-3.0 -X -lm %f
//#!./% &
using Gtk;
using Cairo;
	
//--------------------------------------------------------
public class swing {
	const double cos_a[]={0.2588,0.5,0.7071,0.866,0.966,1,  1,0.966,0.866,0.7071,0.5,0.2588};	//cos 0-75,+15
	int cnt;	//012345(1) 543210(-1) 012345(-1) 543210(1)
	const int max_cnt=6;	//半幅度摆动次数，回位不计数
	int direct;	//顺时钟为1
	double step_angle=10;	//first degree
	const double decay=1;

	public double angle;
//---------------------
	public void init() {
	step_angle=10; angle=0; direct=1; cnt=6;}
//---------------------
	public bool need_draw_swing() {
		if(step_angle==0) {init(); return false;}
		angle+=direct*(step_angle*cos_a[cnt]);
		if((cnt==cos_a.length-1 && direct==1) || (cnt==0 && direct==-1)) {direct=direct==1?-1:1; step_angle-=decay;}
		else cnt+=direct;
		return true;
	}
//---------------------
}
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
	const string alarm_color="#57C575";
	const string hand_color="#F1F1F1";
	const string back_color="#4E4E4E";
/*    const string center_color="#C02C3F";*/
	const string shadow="#cEcEcE";
	const double alarm_true=0.9;
	const double alarm_false=0.5;
	double alarm_alpha=alarm_false;
	int timespan=0;	//alarm和time的分钟差距。
	DateTime now;
	Gdk.RGBA cc;
/*    string svg="<可以embed svg，需要将\"替换成'>";*/
/*        handle = new Rsvg.Handle.from_data(svg.data);*/
//----------------------------
	public Timer(string instr) {
		cc=Gdk.RGBA();
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
			queue_draw(); sss.init();
			if(h==th && m==tm && alarm_alpha==alarm_true){
				if(instr!="0"){
					GLib.Timeout.add(50,()=>{
						bool ret=sss.need_draw_swing();
						queue_draw(); return ret;
						});
				}
				present(); set_keep_above(true);
				string exec=GLib.Environment.get_home_dir()+"/.config/time.script";
				try {
					File f = File.new_for_path(exec);
					if(! f.query_exists()){exec = "/usr/bin/canberra-gtk-play -l 5 -i complete";}
					Process.spawn_command_line_async(exec);
				} catch (SpawnError e) { print ("Error: %s\n", e.message); }
			}
			return true;});

		draw.connect ((da,ctx) => {
			Cairo.TextExtents ex;
			ctx.set_font_size(size/12);
			ctx.translate(size/2, size/2);	//窗口中心为坐标原点。
			ctx.set_line_cap (Cairo.LineCap.ROUND);
			ctx.set_operator (Cairo.Operator.SOURCE);
			if(instr=="z"){
			ctx.rotate(sss.angle*(Math.PI/180));
			}
			if(instr=="y"||instr=="x"){
			double vscale=Math.cos(sss.angle*(Math.PI/180));
			if(instr=="y") ctx.scale(1,vscale);
			else ctx.scale(vscale,1);
			}

			cc.parse(back_color);	//底色
			ctx.set_source_rgba (cc.red, cc.green, cc.blue, 0.8);
			ctx.arc(0,0,size/2-size/20,0,2*Math.PI);
			ctx.fill();

			cc.parse(shadow);	//边缘
			ctx.set_source_rgba (cc.red, cc.green, cc.blue, 1);
			ctx.set_line_width (size/16);
			ctx.arc(0,0,size/2.35,0,2*Math.PI);
			ctx.stroke();
			cc.parse(hand_color);	//亮色边缘
			ctx.set_source_rgba (cc.red, cc.green, cc.blue, 1);
			ctx.set_line_width (size/19);
			ctx.arc(0,0,size/2.33,0,2*Math.PI);
			ctx.stroke();
//---------------------graduation
			for(int i=0;i<12;i++){
				ctx.set_line_width (size/20);
				ctx.save();
				ctx.rotate(i*30*(Math.PI/180));
				if(i%3==0){
					cc.parse(back_color);	//边缘
					ctx.set_source_rgba (cc.red, cc.green, cc.blue, 1);
					ctx.set_line_width (size/50);
/*                    ctx.set_source_rgba (0, 0, 0, 0.8);*/
				}else{
					cc.parse(shadow);	//边缘
					ctx.set_source_rgba (cc.red, cc.green, cc.blue, 1);
					ctx.set_line_width (size/200);
/*                    ctx.set_source_rgba (0.2, 0.2, 0.2, 0.2);*/
				}
				ctx.move_to(0,-(size/2-size/12));
				ctx.rel_line_to(0,-5); ctx.stroke();
				ctx.restore();
			}
//---------------------alarm text
			if(alarm_alpha==alarm_false)
				{ctx.set_source_rgba (0, 0, 0, 1);}
			else{
				cc.parse(alarm_color);
				ctx.set_source_rgba (cc.red, cc.green, cc.blue, alarm_alpha);
			}
			showtext="%02d:%02d".printf(th,tm);
			ctx.text_extents (showtext, out ex);
			ctx.move_to(-ex.width/2,ex.height*4);
			ctx.show_text(showtext);
			if(timespan>0){
				showtext="+"+timespan.to_string();
				ctx.text_extents (showtext, out ex);
				ctx.move_to(-ex.width/2,ex.height*5.5);
				ctx.show_text(showtext);
			}
//---------------------clock text
			ctx.set_source_rgba (0, 0, 0, 1);
			now = new DateTime.now_local ();
			h=now.get_hour(); m=now.get_minute();
			h%=12;
			showtext="%02d:%02d".printf(h,m);
			ctx.text_extents (showtext, out ex);
			ctx.move_to(-ex.width/2,-ex.height*2.5);
			ctx.show_text(showtext);
//---------------------
draw_line(ctx, hand_color, size/15, (h*30+m*30/60)*(Math.PI/180),-(int)(size/3.6),false);	//时针，30度1小时
draw_line(ctx, "#F1F1F1", size/20, m*6*(Math.PI/180),-(int)(size/3),false);	//分针，6度1分钟
draw_line(ctx, "#F1F1F1", size/50, Dalarm*(Math.PI/180),-(int)(size/4),true);	//定时针，30度1小时，30度内分60分钟
//---------------------center
			ctx.set_line_width (1);
			cc.parse(back_color);
			ctx.set_source_rgba (cc.red, cc.green, cc.blue, 0.8);
			ctx.arc(1,1,size/20,0,2*Math.PI);
			ctx.stroke();
			cc.parse(hand_color);
			ctx.set_source_rgba (cc.red, cc.green, cc.blue, 1);
			ctx.arc(0,0,size/20,0,2*Math.PI);
			ctx.fill();
			if(alarm_alpha==alarm_true){cc.parse(alarm_color);}
			else{cc.parse(back_color);}
			ctx.set_source_rgba (cc.red, cc.green, cc.blue, 1);
			ctx.arc(0,0,size/40,0,2*Math.PI);
			ctx.fill();
			return true;
		});
//----------鼠标点击事件。
	button_press_event.connect ((e) => {
		int x; int y;
		x=(int)(e.x-size/2); y=(int)(e.y-size/2);
		int d=(int)Math.sqrt(Math.pow(x,2)+Math.pow(y,2));
		if(d<size/20){	//圆心之内
			if(e.button == 1){
	alarm_alpha=alarm_alpha==alarm_false?alarm_true:alarm_false;
//				if(alarm_alpha==alarm_true) set_keep_above(false);
				set_keep_above(false);
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
		int x; int y;
		x=(int)(e.x-size/2); y=(int)(e.y-size/2);
		int d=(int)Math.sqrt(Math.pow(x,2)+Math.pow(y,2));
		if(e.direction==Gdk.ScrollDirection.UP){
			if(d<size/20){timespan++;change_from_current_time();}	//圆心位置
			else if(size<400)size+=50;	//钟面位置
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
	void draw_line(Cairo.Context ctx, string color, int width, double angle, int len, bool dot){
		ctx.save();
		ctx.rotate(angle);
		cc.parse(shadow);	//阴影
		ctx.set_source_rgba (cc.red, cc.green, cc.blue, 1);
		ctx.set_line_width (width+size/200);
		ctx.move_to (0, 0); ctx.line_to(0, len); ctx.stroke();
		cc.parse(hand_color);	//指针颜色
		ctx.set_source_rgba (cc.red, cc.green, cc.blue, 1);
		ctx.set_line_width (width);
		ctx.move_to (0, 0); ctx.line_to(0, len); ctx.stroke();
		if(dot){
			cc.parse(alarm_color);
			ctx.set_source_rgba (cc.red, cc.green, cc.blue, alarm_true);
			if(alarm_alpha==alarm_false){ ctx.move_to (0, len-len/6); }
			else{ ctx.move_to (0, len/2); }
			ctx.line_to(0, len); ctx.stroke();
		}
		ctx.restore();	//消除旋转的角度
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
		//增加x,y,z,0的参数，缺省为z。
		string s = args[1];
		if(s!="x" && s!="y" && s!="z" && s!="0") s="z";
/*        stdout.printf("instr = %s.\n",instr);*/
		var ww = new Timer(s); ww.show_all();
		Gtk.main(); return 0;
}
//--------------------------------------------------------
