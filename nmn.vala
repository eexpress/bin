/*● /usr/bin/valac --pkg gtk+-3.0 nmn.vala ; [ $? -eq 0 ] && ./nmn*/

using Gtk;
using Cairo;

/*string fontname;*/
/*const string outputfile="/tmp/nmn.png";*/
/*const string alphatable="d1 r2 m3 f4 s5 l6 x7 t7";*/
/*const string input[]={"1d2","3b3","4c4","2d1","|","3c4","2e0","7a2","5e3"};*/
const string input[]={"3c2","3c2","3c3","4c2","#","4c3","|","5c1","0c3","5c3","#","4c3","5c3","|","6c2","6c2","6c3","7c2","1d3","|","n","5c0","6c3","5c3","|","2c0","6c3","5c3","|","3c0","4c3","3c3","|","n","2c2","3c2","#","4c3","5c2","6c3","|","5c0","0c2","|","3c2","3c2","3c3","4c2","#","4c2","|","n","5c1","0c3","5c3","#","4c3","5c3","|","","","","","","","","",""};
const string tone[]={"Do","Re","Mi","Fa","Sol","La","Si"};
const int pagex=50;
const int pagey=80;
	
public class DrawOnWindow : Gtk.Window {
	int ww;
	int wh;
	int size=20;
/*    string fontname="Vera Sans YuanTi";*/
	string fontname="Nimbus Roman No9 L";
	Cairo.TextExtents ex;
	double bw;
	double bh;
	double vspace;
	double textheight;
	double yoffset;
	double bx;
	double by;


	public DrawOnWindow() {
		title = "numbered musical notation";
		destroy.connect (Gtk.main_quit);
/*        set_visual(this.get_screen().get_rgba_visual());*/
		ww=700;
		wh=400;
/*        bw=size*1.5;*/
/*        vspace=bh/10;*/
		set_default_size(ww,wh);
		var drawing_area = new DrawingArea ();
		drawing_area.draw.connect (on_draw);
		add (drawing_area);
/*        key_press_event.connect ((e) => {*/
/*            return true;*/
/*        });*/
	}

	private bool on_draw (Widget da, Context ctx) {
		bx=pagex;
		by=pagey;
/*        setup size according to font size*/
		ctx.select_font_face(fontname,FontSlant.NORMAL,FontWeight.BOLD);
		ctx.set_font_size(size);
		ctx.set_line_width(0.5);
		ctx.text_extents("8",out ex);
		textheight=ex.height;
		vspace=textheight/3;
		bw=textheight*1.8;
		bh=textheight*6;
/*        stdout.printf(textheight.to_string()+"\n");*/

		ctx.set_source_rgb (0, 0, 0);
		for(int i=0; i<input.length;i++){
			bx+=bw;
			drawnote(ctx,bx,by,input[i]);
		}
		return true;
	}

	private void drawnote(Context ctx, double x, double y, string s){
		int i;
		string sshow;
		ctx.save();
/*        ctx.move_to(x,y); ctx.line_to(x+bw,y); ctx.line_to(x+bw,y+bh); ctx.line_to(x,y+bh); ctx.line_to(x,y); ctx.stroke();*/
/*-------------------------*/
/*        x,y as center point, locate at bottom of text*/
		i=s[0];
		switch(i){
			case '|':
				ctx.move_to(x,y-bh/4);
				ctx.line_to(x,y+bh/4);
				ctx.stroke();
				return;
			case '#':
				ctx.move_to(x-bw/2,y-ex.height+vspace/4);
				ctx.set_font_size(size/2);
				ctx.show_text("#");
				ctx.set_font_size(size);
				bx-=bw;
				return;
			case 'n':
				bx=pagex;
				by=by+bh;
				return;
		}
		if(i>='0' && i<'8'){
			ctx.move_to(x-centerpos(ctx,s[0].to_string()),y);
			ctx.show_text(s[0].to_string());

			sshow=tone[i-'1'];
			ctx.set_font_size(size/1.2);
			ctx.move_to(x-centerpos(ctx,sshow),y+vspace*7);
			ctx.show_text(sshow);
		}
/*-------------------------*/
		i=s[2];
		ctx.set_font_size(size);
		switch(i){
			case '0':
				sshow="-";
				ctx.move_to(x+bw-2*centerpos(ctx,sshow),y-vspace);
				ctx.show_text(sshow);
				ctx.move_to(x+2*bw-2*centerpos(ctx,sshow),y-vspace);
				ctx.show_text(sshow);
/*                ctx.rel_move_to(bw,0);*/
/*                ctx.show_text(sshow);*/
				bx+=2*bw;
				yoffset=0;
				break;
			case '1':
				sshow="-";
				ctx.move_to(x+bw-centerpos(ctx,sshow),y);
				ctx.show_text(sshow);
				bx+=bw;
				yoffset=0;
				break;
			case '2':
				yoffset=0;
				break;
			case '3':
				yoffset=y+vspace;
				ctx.move_to(x-bw/2,yoffset); ctx.line_to(x+bw/2,yoffset);
				yoffset=1;
				break;
			case '4':
				yoffset=y+vspace;
				ctx.move_to(x-bw/2,yoffset); ctx.line_to(x+bw/2,yoffset);
				yoffset=y+vspace*2;
				ctx.move_to(x-bw/2,yoffset); ctx.line_to(x+bw/2,yoffset);
				yoffset=2;
				break;
		}
		ctx.stroke();

/*-------------------------*/
		yoffset=y+yoffset*vspace+vspace;
		i=s[1];
		switch(i){
			case 'a':
				ctx.arc(x,yoffset,2,0,360*Math.PI/180);
				ctx.arc(x,yoffset+vspace,2,0,360*Math.PI/180);
				ctx.fill();
				break;
			case 'b':
				ctx.arc(x,yoffset,2,0,360*Math.PI/180);
				ctx.fill();
				break;
			case 'c':
				break;
			case 'd':
				ctx.arc(x,y-textheight-vspace,2,0,360*Math.PI/180);
				ctx.fill();
				break;
			case 'e':
				ctx.arc(x,y-textheight-vspace,2,0,360*Math.PI/180);
				ctx.arc(x,y-textheight-2*vspace,2,0,360*Math.PI/180);
				ctx.fill();
				break;

		}
/*-------------------------*/
		ctx.restore();
	}

	private double centerpos(Context ctx, string s){
		ctx.text_extents(s,out ex);
		return ex.width/2 + ex.x_bearing;
	}

	static int main (string[] args) {
		Gtk.init (ref args);
		var DW = new DrawOnWindow ();
		DW.show_all ();
		Gtk.main ();
		return 0;
	}
}
