#!/usr/bin/perl

use utf8;
use Gtk2 "-init";

# need replace '$.' and '$ ' to 'yy' 'xx'
$pix_l = Gtk2::Gdk::Pixbuf->new_from_xpm_data(
"23 24 115 2 ", "   c #B51515", ".  c #B51616", "X  c #B51717",
"o  c #B61717", "O  c #B61818", "+  c #B61919", "@  c #B71A1A",
"#  c #B71B1B", "xx c #B71C1C", "%  c #B71D1D", "&  c #BA2424",
"*  c #BA2525", "=  c #BA2626", "-  c #BB2727", ";  c #BC2A2A",
":  c #BD2E2E", ">  c #BD2F2F", ",  c #C03838", "<  c #C34141",
"1  c #C54646", "2  c #C54747", "3  c #C54848", "4  c #C74D4D",
"5  c #CA5656", "6  c #CA5858", "7  c #CB5B5B", "8  c #CB5C5C",
"9  c #CC5D5D", "0  c #CC5F5F", "q  c #CF6767", "w  c #D16F6F",
"e  c #D26F6F", "r  c #D27070", "t  c #D27272", "y  c #D37474",
"u  c #D47676", "i  c #D47777", "p  c #D57B7B", "a  c #D57C7C",
"s  c #D67E7E", "d  c #949494", "f  c #A1A1A1", "g  c #A7A7A7",
"h  c #ACACAC", "j  c #B2B2B2", "k  c #B5B5B5", "l  c #B6B6B6",
"z  c #B7B7B7", "x  c #D78080", "c  c #D78181", "v  c #D88484",
"b  c #D98686", "n  c #DA8989", "m  c #DA8B8B", "M  c #DB8E8E",
"N  c #DC9191", "B  c #DD9292", "V  c #DD9393", "C  c #DD9494",
"Z  c #DD9595", "A  c #DF9A9A", "S  c #DF9B9B", "D  c #E09D9D",
"F  c #E09E9E", "G  c #E2A5A5", "H  c #E3A5A5", "J  c #E4A8A8",
"K  c #E4A9A9", "L  c #E4AAAA", "P  c #E6AFAF", "I  c #E9B9B9",
"U  c #E9BABA", "Y  c #EABDBD", "T  c #EABEBE", "R  c #C2C2C2",
"E  c #C3C3C3", "W  c #CCCCCC", "Q  c #D7D7D7", "!  c #D8D8D8",
"~  c #ECC3C3", "^  c #EDC6C6", "/  c #EEC9C9", "(  c #EFCCCC",
")  c #EFCDCD", "_  c #F0CFCF", "`  c #F1D3D3", "'  c #F1D4D4",
"]  c #F2D5D5", "[  c #F4DCDC", "{  c #F4DDDD", "}  c #E3E3E3",
"|  c #EAEAEA", " . c #F7E5E5", ".. c #F8E8E8", "X. c #F9EBEB",
"o. c #F9ECEC", "O. c #F2F2F2", "+. c #F7F7F7", "@. c #FBF2F2",
"#. c #FCF5F5", "yy c #FCF7F7", "%. c #FDF7F7", "&. c #F8F8F8",
"*. c #F9F9F9", "=. c #FBFBFB", "-. c #FDF8F8", ";. c #FDF9F9",
":. c #FEFBFB", ">. c #FCFCFC", ",. c #FDFDFD", "<. c #FEFDFD",
"1. c #FEFEFE", "2. c #FFFEFE", "3. c #FFFFFF", "4. c None",
"4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.",
"4.4.W 1.&.d R 1.&.f k 1.1.g h &.1.z 4.4.4.4.4.",
"4.! X.c H 1.@.b D 1.#.m V :.1.V m #.j 4.4.4.4.",
"4.1.e     ( b     I C     H L     C 1.4.4.4.4.",
"4.1.7     I e     H s     M V     x 1.4.4.4.4.",
"4.1.7     I e     H x     V C     x 1.4.4.4.4.",
"4.1.9     I e     y 7     V C     x 1.4.4.4.4.",
"4.1.7     L 4             q M     x 1.4.4.4.4.",
"4.1.7     #   5 H / ^ F 3   #     x 1.4.4.4.4.",
"4.1.7     - T 1.1.1.1.1.1.H xx    x 1.4.4.4.4.",
"4.1.7   xx( 1.1.1.1.1.1.1.1.P     x 1.4.4.4.4.",
"4.1.7   x 1.1.:.C 3 4 L 1.1.1.9   x 1.4.4.4.4.",
"4.1.9   { 1.1.p         F 1.1.I   x 1.4.4.4.4.",
"4.1.7 - 1.1.:.#         , 1.1.X.  x 1.4.4.4.4.",
"4.1.9 - 1.1.@.          > 1.1.o.  x 1.4.4.4.4.",
"4.1.a   o.1.1.7         p 1.1./   x 1.4.4.4.4.",
"4.} I   S 1.1.X.7 # # t #.1.1.i   x 1.4.4.4.4.",
"4.4.:., ; X.1.1.1.#.#.1.1.1.` #   x 1.! 4.4.4.",
"4.4.O.^ # <  .1.1.1.1.1.1.[ >     7 P T 1.k 4.",
"4.4.4.1.H # - M [ :.:.' a xx            m 1.4.",
"4.4.4.4.1._ 1     xx#                   e 1.4.",
"4.4.4.4.4.| 1._ V i t t t t t t t t t x X.Q 4.",
"4.4.4.4.4.4.4.E &.1.1.1.1.1.1.1.1.1.1.1.W 4.4.",
"4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4."
);

$pix_r = Gtk2::Gdk::Pixbuf->new_from_xpm_data(
"23 24 115 2 ", "   c #B51515", ".  c #B51616", "X  c #B51717",
"o  c #B61717", "O  c #B61818", "+  c #B61919", "@  c #B71A1A",
"#  c #B71B1B", "xx c #B71C1C", "%  c #B71D1D", "&  c #BA2424",
"*  c #BA2525", "=  c #BA2626", "-  c #BB2727", ";  c #BC2A2A",
":  c #BD2E2E", ">  c #BD2F2F", ",  c #C03838", "<  c #C34141",
"1  c #C54646", "2  c #C54747", "3  c #C54848", "4  c #C74D4D",
"5  c #CA5656", "6  c #CA5858", "7  c #CB5B5B", "8  c #CB5C5C",
"9  c #CC5D5D", "0  c #CC5F5F", "q  c #CF6767", "w  c #D16F6F",
"e  c #D26F6F", "r  c #D27070", "t  c #D27272", "y  c #D37474",
"u  c #D47676", "i  c #D47777", "p  c #D57B7B", "a  c #D57C7C",
"s  c #D67E7E", "d  c #949494", "f  c #A1A1A1", "g  c #A7A7A7",
"h  c #ACACAC", "j  c #B2B2B2", "k  c #B5B5B5", "l  c #B6B6B6",
"z  c #B7B7B7", "x  c #D78080", "c  c #D78181", "v  c #D88484",
"b  c #D98686", "n  c #DA8989", "m  c #DA8B8B", "M  c #DB8E8E",
"N  c #DC9191", "B  c #DD9292", "V  c #DD9393", "C  c #DD9494",
"Z  c #DD9595", "A  c #DF9A9A", "S  c #DF9B9B", "D  c #E09D9D",
"F  c #E09E9E", "G  c #E2A5A5", "H  c #E3A5A5", "J  c #E4A8A8",
"K  c #E4A9A9", "L  c #E4AAAA", "P  c #E6AFAF", "I  c #E9B9B9",
"U  c #E9BABA", "Y  c #EABDBD", "T  c #EABEBE", "R  c #C2C2C2",
"E  c #C3C3C3", "W  c #CCCCCC", "Q  c #D7D7D7", "!  c #D8D8D8",
"~  c #ECC3C3", "^  c #EDC6C6", "/  c #EEC9C9", "(  c #EFCCCC",
")  c #EFCDCD", "_  c #F0CFCF", "`  c #F1D3D3", "'  c #F1D4D4",
"]  c #F2D5D5", "[  c #F4DCDC", "{  c #F4DDDD", "}  c #E3E3E3",
"|  c #EAEAEA", " . c #F7E5E5", ".. c #F8E8E8", "X. c #F9EBEB",
"o. c #F9ECEC", "O. c #F2F2F2", "+. c #F7F7F7", "@. c #FBF2F2",
"#. c #FCF5F5", "yy c #FCF7F7", "%. c #FDF7F7", "&. c #F8F8F8",
"*. c #F9F9F9", "=. c #FBFBFB", "-. c #FDF8F8", ";. c #FDF9F9",
":. c #FEFBFB", ">. c #FCFCFC", ",. c #FDFDFD", "<. c #FEFDFD",
"1. c #FEFEFE", "2. c #FFFEFE", "3. c #FFFFFF", "4. c None",
"4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.",
"4.4.4.4.4.l 3.*.h g 3.3.l f *.3.R d *.3.W 4.4.",
"4.4.4.4.j #.m V :.:.V m #.3.A b @.3.H x ..Q 4.",
"4.4.4.4.3.C     K H     C I     x _     t 3.4.",
"4.4.4.4.3.x     C N     x H     w I     6 3.4.",
"4.4.4.4.3.x     C N     x H     w I     9 3.4.",
"4.4.4.4.3.x     C N     8 y     w I     8 3.4.",
"4.4.4.4.3.x     M q             4 P     6 3.4.",
"4.4.4.4.3.x     #   2 S ^ / H 5   #     8 3.4.",
"4.4.4.4.3.x     xxH 3.3.3.3.3.3.Y *     6 3.4.",
"4.4.4.4.3.x     P 3.3.3.3.3.3.3.3.( #   9 3.4.",
"4.4.4.4.3.x   9 3.3.3.J 4 2 C :.3.3.a   8 3.4.",
"4.4.4.4.3.x   I 3.3.S         p 3.3.{   6 3.4.",
"4.4.4.4.3.x   ..3.3.>         xxyy3.3.& 9 3.4.",
"4.4.4.4.3.x   o.3.3.>           @.3.3.* q :.4.",
"4.4.4.4.3.x   / 3.3.a         6 3.3...  p 3.4.",
"4.4.4.4.3.x   i 3.3.yyt #   6 o.3.3.A   I } 4.",
"4.4.4.Q 3.x   xx' 3.3.3.yyyy3.3.3...; , :.4.4.",
"4.l 3.Y P 6     > ' 3.3.3.3.3.3. .< # ~ O.4.4.",
"4.3.m             % a ' :.yy[ M * # K 3.4.4.4.",
"4.3.w                   # #     1 ( 3.4.4.4.4.",
"4.! ..x t t t t t t t t t y V ` 3.| 4.4.4.4.4.",
"4.4.W 3.3.3.3.3.3.3.3.3.3.3.+.E 4.4.4.4.4.4.4.",
"4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4.4."
);

#$session=$ENV{DESKTOP_SESSION}=~/^Fvwm/;
#$session=$ENV{DESKTOP_SESSION}=~/^ubuntu/;
#if(!$session)
#{
#`xmodmap -e "pointer = 1 2 3"`;
#$r=`gconftool-2 -g /desktop/gnome/peripherals/mouse/left_handed`;
#chomp $r;
#$r=($r eq "false"?"right":"left");
#} else {
#}
$r=`xmodmap -pp|grep "\<3\>\s*\<1\>"`;
$r=$r==1?"right":"left";

if($ARGV[0] eq "once"){
swap(); exit;
}

#%gconf_button_layout_str=(
#        "right"=>":minimize,maximize,close",
#        "left"=>"close,maximize,minimize:",
#        );

$status_icon = Gtk2::StatusIcon->new;
$status_icon->set_from_pixbuf($r eq "right"?$pix_r:$pix_l);
$status_icon->set_tooltip("左右键切换鼠标习惯，中键退出");
$status_icon->signal_connect('button_release_event',\&swap_mouse);
$status_icon->set_visible(1);
Gtk2->main();

sub swap_mouse{
my ($widget, $event) = @_;
if($event->button eq 2){exit;}
swap();
$status_icon->set_from_pixbuf(($r eq "left")?$pix_l:$pix_r);
}

sub swap{
#`gconftool-2 -s /apps/gwd/mouse_wheel_action shade -t string`;
#`gconftool-2 -s /desktop/gnome/peripherals/mouse/left_handed false -t bool`;
#`gconftool-2 -s /apps/metacity/general/button_layout $gconf_button_layout_str{$r} -t string`;
if($r eq "left"){
#    print "set => right hand\n";
	`xmodmap -e "pointer = 1 2 3"`;
	`xsetroot -cursor_name left_ptr`;
	`synclient TapButton1=1 TapButton2=2 TapButton3=3`;
	$r="right";
}
else{
#    print "set => left hand\n";
	`xmodmap -e "pointer = 3 2 1"`;
	`xsetroot -cursor_name right_ptr`;
	`synclient TapButton1=3 TapButton2=2 TapButton3=1`;
	$r="left";
}
}
