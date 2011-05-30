/*******************************************************************************
** created:
**    19.2.2006
**
** last change:
**    20.2.2006
**
** author:
**    Mirco "MacSlow" Mueller <macslow@bangang.de>
**
** license:
**    GPL
**
** modify:
**    eexpress@163.com
**
** bugs:
**    - there are no size-checks done for the input-shape, so I don't know what
**      will happen, if you make the window super large
*******************************************************************************/

#include <math.h>
/*#include <gdk/gdkkeysyms.h>*/
#include <gtk/gtk.h>
#if !GTK_CHECK_VERSION(2,9,0)
#include <X11/Xlib.h>
#include <X11/extensions/shape.h>
#include <gdk/gdkx.h>
#endif

#define WIN_WIDTH 600
#define WIN_HEIGHT 600

GtkWidget* pWindow = NULL;
gint g_iCurrentWidth = WIN_WIDTH;
gint g_iCurrentHeight = WIN_HEIGHT;
char buf[255];
gint rootx=0,rooty=0;

void update_input_shape (GtkWidget* pWindow, int iWidth, int iHeight);
void on_alpha_screen_changed (GtkWidget* pWidget, GdkScreen* pOldScreen, GtkWidget* pLabel);
void render (cairo_t* pCairoContext, gint iWidth, gint iHeight);
gboolean on_expose (GtkWidget* pWidget, GdkEventExpose* pExpose);
/*gboolean on_key_press (GtkWidget* pWidget, GdkEventKey* pKey, gpointer userData);*/
gboolean on_button_press (GtkWidget* pWidget, GdkEventButton* pButton, GdkWindowEdge edge);
gboolean on_configure (GtkWidget* pWidget, GdkEventConfigure* pEvent, gpointer data);
#if !GTK_CHECK_VERSION(2,9,0)
void do_shape_combine_mask (GdkWindow* window, GdkBitmap* mask, gint x, gint y);
#endif
void update_input_shape (GtkWidget* pWindow, int iWidth, int iHeight);

void on_alpha_screen_changed (GtkWidget* pWidget,
							  GdkScreen* pOldScreen,
							  GtkWidget* pLabel)
{                       
	GdkScreen* pScreen = gtk_widget_get_screen (pWidget);
	GdkColormap* pColormap = gdk_screen_get_rgba_colormap (pScreen);
      
	if (!pColormap)
		pColormap = gdk_screen_get_rgb_colormap (pScreen);

	gtk_widget_set_colormap (pWidget, pColormap);
}

void render (cairo_t* pCairoContext, gint iWidth, gint iHeight)
{
gint w,h;
/*        cairo_scale (pCairoContext, (double) iWidth, (double) iHeight);*/
	cairo_set_source_rgba (pCairoContext, 1.0f, 1.0f, 1.0f, 0.0f);
	cairo_set_operator (pCairoContext, CAIRO_OPERATOR_SOURCE);
	cairo_paint (pCairoContext);
/*        cairo_set_source_rgba (pCairoContext, 1.0f, 0.0f, 0.0f, 0.75f);*/
/*        cairo_set_line_width (pCairoContext, 0.1f);*/
/*        cairo_move_to (pCairoContext, 0.15f, 0.15f);*/
/*        cairo_line_to (pCairoContext, 0.85f, 0.85f);*/
/*        cairo_move_to (pCairoContext, 0.85f, 0.15f);*/
/*        cairo_line_to (pCairoContext, 0.15f, 0.85f);*/
/*        cairo_stroke (pCairoContext);*/
	cairo_surface_t *image;
	image = cairo_image_surface_create_from_png (buf);
	w=cairo_image_surface_get_width (image);
	h=cairo_image_surface_get_height (image);
	gtk_widget_set_size_request (pWindow, w, h);
/*        gtk_widget_set_size_request (pWindow, cairo_image_surface_get_width (image), cairo_image_surface_get_height (image));*/
	cairo_set_source_surface (pCairoContext, image, 0, 0);
	cairo_paint (pCairoContext);

	gtk_window_resize((GtkWindow *)pWindow,w,h);
	if(rootx!=0){
	GdkScreen* pScreen = gtk_widget_get_screen (pWindow);
	if(rootx<0) rootx= gdk_screen_get_width(pScreen)-cairo_image_surface_get_width (image)+rootx;
	if(rooty<0) rooty= gdk_screen_get_height(pScreen)-cairo_image_surface_get_height (image)+rooty;
	gtk_window_move(GTK_WINDOW (pWindow), rootx, rooty);
	g_printf("%d %d\n",rootx, rooty);
	}
}

gboolean on_expose (GtkWidget* pWidget, GdkEventExpose* pExpose)
{
	gint iWidth;
	gint iHeight;
	cairo_t* pCairoContext = NULL;

	pCairoContext = gdk_cairo_create (pWidget->window);
	if (!pCairoContext)
		return FALSE;

	gtk_window_get_size (GTK_WINDOW (pWidget), &iWidth, &iHeight);
	render (pCairoContext, iWidth, iHeight);
	cairo_destroy (pCairoContext);

	return FALSE;
}

gboolean on_configure (GtkWidget* pWidget,
					   GdkEventConfigure* pEvent,
					   gpointer userData)
{
	gint iNewWidth = pEvent->width;
	gint iNewHeight = pEvent->height;

	if (iNewWidth != g_iCurrentWidth || iNewHeight != g_iCurrentHeight)
	{
		update_input_shape (pWidget, iNewWidth, iNewHeight);
		g_iCurrentWidth = iNewWidth;
		g_iCurrentHeight = iNewHeight;
	}

	return FALSE;
}

/*gboolean on_key_press (GtkWidget* pWidget, GdkEventKey* pKey, gpointer userData)*/
/*{*/
/*        if (pKey->type == GDK_KEY_PRESS){*/
/*                switch (pKey->keyval){*/
/*                        case GDK_Escape :*/
/*                        case GDK_q :*/
/*                                gtk_main_quit ();*/
/*                        break;}}*/
/*        return FALSE;*/
/*}*/

gboolean on_button_press (GtkWidget* pWidget,GdkEventButton* pButton, GdkWindowEdge edge)
{
	if (pButton->type == GDK_BUTTON_PRESS){
		if (pButton->button == 1)
			gtk_window_begin_move_drag (GTK_WINDOW (gtk_widget_get_toplevel (pWidget)), pButton->button, pButton->x_root, pButton->y_root, pButton->time);
		if (pButton->button == 2)
			gtk_window_begin_resize_drag (GTK_WINDOW (gtk_widget_get_toplevel (pWidget)), edge, pButton->button, pButton->x_root, pButton->y_root, pButton->time);
		if (pButton->button == 3) gtk_main_quit ();}
	return FALSE;
}

#if !GTK_CHECK_VERSION(2,9,0)
/* this is piece by piece taken from gtk+ 2.9.0 (CVS-head with a patch applied
regarding XShape's input-masks) so people without gtk+ >= 2.9.0 can compile and
run input_shape_test.c */
void do_shape_combine_mask (	GdkWindow* window,
				GdkBitmap* mask,
				gint x,
				gint y)
{
	Pixmap pixmap;
	int ignore;
	int maj;
	int min;

	if (!XShapeQueryExtension (GDK_WINDOW_XDISPLAY (window), &ignore, &ignore))
		return;

	if (!XShapeQueryVersion (GDK_WINDOW_XDISPLAY (window), &maj, &min))
		return;

	/* for shaped input we need at least XShape 1.1 */
	if (maj != 1 && min < 1)
		return;

	if (mask)
		pixmap = GDK_DRAWABLE_XID (mask);
	else
	{
		x = 0;
		y = 0;
		pixmap = None;
	}

	XShapeCombineMask (GDK_WINDOW_XDISPLAY (window),
			   GDK_DRAWABLE_XID (window),
			   ShapeInput,
			   x,
			   y,
			   pixmap,
			   ShapeSet);
}
#endif

void update_input_shape (GtkWidget* pWindow, int iWidth, int iHeight)
{
	static GdkBitmap* pShapeBitmap = NULL;
	static cairo_t* pCairoContext = NULL;

	pShapeBitmap = (GdkBitmap*) gdk_pixmap_new (NULL, iWidth, iHeight, 1);
	if (pShapeBitmap)
	{
		pCairoContext = gdk_cairo_create (pShapeBitmap);
		if (cairo_status (pCairoContext) == CAIRO_STATUS_SUCCESS)
		{
			render (pCairoContext, iWidth, iHeight);
			cairo_destroy (pCairoContext);
#if !GTK_CHECK_VERSION(2,9,0)
			do_shape_combine_mask (pWindow->window, NULL, 0, 0);
			do_shape_combine_mask (pWindow->window, pShapeBitmap, 0, 0);
#else
			gtk_widget_input_shape_combine_mask (pWindow, NULL, 0, 0);
			gtk_widget_input_shape_combine_mask (pWindow, pShapeBitmap, 0, 0);
#endif
		}
		g_object_unref ((gpointer) pShapeBitmap);
	}
}

int main (int argc, char** argv)
{
	GdkBitmap* pShapeMaskBitmap = NULL;

	gtk_init (&argc, &argv);

	if(g_file_test(argv[1],G_FILE_TEST_IS_REGULAR))
		g_strlcpy(buf,argv[1],255);
	else {
		g_strlcpy(buf,"/tmp/weather.png",255);
		if(!g_file_test(buf,G_FILE_TEST_IS_REGULAR))
			{g_printf("not a file: %s.\n", buf); return 1;}
	}
	
	pWindow = gtk_window_new (GTK_WINDOW_TOPLEVEL);
	on_alpha_screen_changed (pWindow, NULL, NULL);
	gtk_widget_set_app_paintable (pWindow, TRUE);
	gtk_window_set_decorated (GTK_WINDOW (pWindow), FALSE);
	gtk_window_set_resizable (GTK_WINDOW (pWindow), TRUE);
	gtk_window_set_title (GTK_WINDOW (pWindow), "Cairo Weather");
	gtk_widget_set_size_request (pWindow, g_iCurrentWidth, g_iCurrentHeight);
	gtk_widget_add_events (pWindow, GDK_BUTTON_PRESS_MASK);
	gtk_widget_show (pWindow);
	gtk_window_set_keep_above(GTK_WINDOW(pWindow),TRUE);
/*        gtk_window_set_type_hint(GTK_WINDOW(pWindow),GDK_WINDOW_TYPE_HINT_DOCK);*/
/*        gtk_window_set_type_hint((GtkWindow *)pWindow,GDK_WINDOW_TYPE_HINT_DOCK);*/
	if(argv[2]!=NULL && argv[3]!=NULL)
	{rootx=atoi(argv[2]); rooty=atoi(argv[3]);}

	g_signal_connect (G_OBJECT (pWindow),
					  "destroy",
					  G_CALLBACK (gtk_main_quit),
					  NULL);
	g_signal_connect (G_OBJECT (pWindow),
					  "expose-event",
					  G_CALLBACK (on_expose),
					  NULL);
	g_signal_connect (G_OBJECT (pWindow),
					  "configure-event",
					  G_CALLBACK (on_configure),
					  NULL);
/*        g_signal_connect (G_OBJECT (pWindow),*/
/*                                          "key-press-event",*/
/*                                          G_CALLBACK (on_key_press),*/
/*                                          NULL);*/
	g_signal_connect (G_OBJECT (pWindow),
					  "button-press-event",
					  G_CALLBACK (on_button_press),
					  NULL);

	update_input_shape (pWindow, g_iCurrentWidth, g_iCurrentHeight);

	gtk_main ();

	return 0;
}
