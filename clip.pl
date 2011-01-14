#!/usr/bin/perl

my $TERM='xterm -e';

my @clip0=(
"24 24 197 2","   c #000000",".  c #010100","X  c #010101","o  c #090602",
"O  c #150F02","+  c #150F03","@  c #130C05","#  c #150E05","xx c #160F05",
"%  c #171004","&  c #1A1203","*  c #1A1303","=  c #1B1303","-  c #1D1502",
";  c #1C1403",":  c #1E1602",">  c #181104",",  c #191204","<  c #24180B",
"1  c #28292A","2  c #2F3133","3  c #422C12","4  c #432C12","5  c #047400",
"6  c #067600","7  c #0E7F00","8  c #5B5D5E","9  c #876409","0  c #886408",
"q  c #A97B0D","w  c #AA7C0D","e  c #8C6330","r  c #8C673B","t  c #0F8100",
"y  c #118200","u  c #178606","i  c #198B03","p  c #198C00","a  c #1B8F00",
"s  c #1D9000","d  c #1D9100","f  c #219500","g  c #249900","h  c #279C00",
"j  c #289E00","k  c #299E00","l  c #2A980E","z  c #2C9614","x  c #32AA00",
"c  c #34AC00","v  c #37AD03","b  c #33A804","n  c #35A60B","m  c #3CAE0A",
"M  c #38A414","N  c #29862A","B  c #42AF14","V  c #45A52C","C  c #50AD36",
"Z  c #6EC93F","A  c #6FCA3F","S  c #4C9B49","D  c #549D57","F  c #6FB95C",
"G  c #73B26F","H  c #7EB57E","J  c #76CA4D","K  c #7DCE55","L  c #AF8307",
"P  c #B08307","I  c #B48805","U  c #D0A128","Y  c #D1A128","T  c #A18257",
"R  c #A68657","E  c #A98957","W  c #AD8C56","Q  c #B08F56","!  c #B49255",
"~  c #B79554","^  c #BF9B53","/  c #BB9854","(  c #AB9B67",")  c #AB9B68",
"_  c #A48D73","`  c #A59077","'  c #C29E53","]  c #D7AF47","[  c #D4AD4F",
"{  c #C6A252","}  c #C9A551","|  c #CDA751"," . c #D0AA50",".. c #8AD95B",
"X. c #8BDB5B","o. c #83CD63","O. c #82C867","+. c #84CA67","@. c #84CC67",
"#. c #87CF66","ss c #86CE67","%. c #9BDB79","&. c #A4E776","*. c #A5E876",
"=. c #898E92","-. c #99C696",";. c #ADDD99",":. c #AAE488",">. c #BBED9B",
",. c #A3CAA4","<. c #B8D6B6","1. c #B6E2A2","2. c #D5C59B","3. c #C0F29A",
"4. c #C1F39B","5. c #E6D3A0","6. c #C3E9AE","7. c #C2E3B7","8. c #C1DAC3",
"9. c #C8CDD2","0. c #CACFD4","q. c #CCD1D5","w. c #CED3D7","e. c #D7D7D6",
"r. c #D0D4D8","t. c #D2D6D9","y. c #D3D7DB","u. c #D4D8DC","i. c #D5D9DE",
"p. c #D8DCDF","a. c #D5F3C2","s. c #D6F4C2","d. c #DCF6CC","f. c #D6E6D6",
"g. c #D6E4D9","h. c #D9E7D9","j. c #D8E6DB","k. c #E5F6DB","l. c #DBDFE3",
"z. c #DEE0E2","x. c #DFE1E3","c. c #E4EDE6","v. c #E1E5E8","b. c #E2E6E9",
"n. c #E6ECE9","m. c #E6EEE8","M. c #EBEDEF","N. c #EAF1EC","B. c #ECEEF0",
"V. c #EDEFF1","C. c #EEEFF1","Z. c #EEF0F2","A. c #EFF0F2","S. c #EFF1F2",
"D. c #EFF1F3","F. c #F0F1F3","G. c #F0F2F3","H. c #F0F4F1","J. c #F2F6F3",
"K. c #F5F4F2","L. c #F0F2F4","P. c #F1F2F4","I. c #F1F3F4","U. c #F2F3F4",
"Y. c #F2F4F5","T. c #F3F4F5","R. c #F4F7F4","E. c #F4F5F6","W. c #F4F5F7",
"Q. c #F5F6F7","!. c #F6F9F6","~. c #F6F9F7","^. c #FBFAF7","/. c #F6F7F8",
"(. c #F7F8F8","). c #F7F8F9","_. c #F8F9F9","`. c #F8FAF9","'. c #F9FAF9",
"]. c #F8F9FA","[. c #F9FAFB","{. c #FAFBFA","}. c #FAFAFB","|. c #FAFBFB",
" X c #FBFCFB",".X c #FBFBFC","XX c #FBFCFC","oX c #FCFCFC","OX c #FCFCFD",
"+X c #FDFDFD","@X c #FDFEFD","#X c #FDFDFE","$X c #FDFEFE","%X c #FEFEFE",
"&X c #FEFEFF","*X c #FFFFFF","=X c None",
"=X=X=X=X=X=X=X=X=X=X. 1 1 . =X=X=X=X=X=X=X=X=X=X",
"=X=X=X=X=X=X=X=X=X. =.i.i.=.. =X=X=X=X=X=X=X=X=X",
"=X=X=X=X=X=X. . . 2 |.8 8 |.2 . . . =X=X=X=X=X=X",
"=X=X=X=X+ 9 L I ) E.XXl.z.+XE.) I L 0 + =X=X=X=X",
"=X=X=X. q ] 5.2.l.l.l.l.l.l.l.i.2.5.] w . =X=X=X",
"=X=X=X% U ^.|.M.y.t.t.w.w.w.9.9.p.b.K.U % =X=X=X",
"=X=X=X- [ XX|.+X|.|.|./.E.E.Y.F.V.b.A.[ - =X=X=X",
"=X=X=X-  .XX+X+X+X+Xd.s.s.k.+X+X+XM.A. .- =X=X=X",
"=X=X=X- | XX+X+X+X~.>.>.>.6.{.+X+XF.F.| - =X=X=X",
"=X=X=X- } +X+X+X+X~.:.&.*.>. X+X+XU.F.} - =X=X=X",
"=X=X=X; { |.+X+X+XJ.%...X.;.'.+X+XY.F.{ ; =X=X=X",
"=X=X=X& ' |.7.O.sso.J J A K #.ss+.j.U.' , =X=X=X",
"=X=X=X& ^ (.f.C M n b x c v m B F n.U.^ , =X=X=X",
"=X=X=X& / (.{.<.l d g h k k k V j.(.U./ , =X=X=X",
"=X=X=X, ~ (.+X(.-.a p a d d z 8.+X|.U.~ , =X=X=X",
"=X=X=X, ! (.+X+XD.G t t y u ,.|.+X.XU.! , =X=X=X",
"=X=X=X, Q Y.+X+X+XN.S 5 5 H ~.+X+X+XU.W & =X=X=X",
"=X=X=X% W U.+X+X+X+Xg.N D N.+X+X+X+XU.W % =X=X=X",
"=X=X=XxxE Y.+X+X+X+X+Xj.c.+X+X+X+X+XU.E % =X=X=X",
"=X=X=XxxR Y.+X+X+X+X+X+X+X+X+X+X+X+XF.R xx=X=X=X",
"=X=X=XxxT A.+X+X+X+X+X+X+X+X+X+X+X+XV.T xx=X=X=X",
"=X=X=Xo e e.Y.E.Y.E.E.E.E.E.E.Y.Y.U.e.e o =X=X=X",
"=X=X=X=X4 r _ ` ` ` ` ` ` ` ` ` ` _ r 4 =X=X=X=X",
"=X=X=X=X=X@ < < < < < < < < < < < < @ =X=X=X=X=X"
);

my @clip1=(
"24 24 163 2","   c #000000",".  c #010001","X  c #010101","o  c #020102",
"O  c #020202","+  c #030203","@  c #030303","#  c #040303","$  c #050304",
"%  c #050305","&  c #040404","*  c #050505","=  c #060406","-  c #070506",
";  c #060606",":  c #070707",">  c #090608",",  c #080808","<  c #090909",
"1  c #0A0A0A","2  c #0B0B0B","3  c #0C080A","4  c #0D080C","5  c #0D090C",
"6  c #0F0A0E","7  c #0C0C0C","8  c #0D0D0D","9  c #0E0E0E","0  c #0F0F0F",
"q  c #150E13","w  c #101010","e  c #111111","r  c #121212","t  c #191017",
"y  c #181216","u  c #1B1118","i  c #191919","p  c #1A1A1A","a  c #1E1E1E",
"s  c #1F1F1F","d  c #1A0924","f  c #241726","g  c #271824","h  c #291A26",
"j  c #291828","k  c #230933","l  c #290B3D","z  c #2A0C3D","x  c #202020",
"c  c #232323","v  c #262626","b  c #272727","n  c #282828","m  c #292929",
"M  c #2B2B2B","N  c #2C2C2C","B  c #2E2E2E","V  c #3E243B","C  c #303030",
"Z  c #323232","A  c #3C3C3C","S  c #3D1C47","D  c #3C1550","F  c #3E0C64",
"G  c #3F0D65","H  c #491C5D","J  c #472848","K  c #5C345B","L  c #441264",
"P  c #541A76","I  c #522266","U  c #663869","Y  c #474747","T  c #6D6D6D",
"R  c #6F6F6F","E  c #707070","W  c #717171","Q  c #737373","!  c #747474",
"~  c #757575","^  c #767676","/  c #777777","(  c #797979",")  c #7A7A7A",
"_  c #7C7C7C","`  c #7D7D7D","'  c #7F7F7F","]  c #5A1789","[  c #5B1889",
"{  c #642486","}  c #782F99","|  c #7B3497"," . c #7D3697",".. c #793198",
"X. c #7B3398","o. c #7C329C","O. c #7424A4","+. c #7526A4","@. c #8231AA",
"#. c #8935B2",'$. c #814980',"%. c #8B4C8F","&. c #9046A3","*. c #AB62A8",
"=. c #B363B5","-. c #9035C0",";. c #9136C0",":. c #AE52C9",">. c #BA59D3",
",. c #BD50EB","<. c #D679D5","1. c #C75BEB","2. c #C351F5","3. c #CA59F4",
"4. c #CC57FB","5. c #C852FC","6. c #CB53FF","7. c #CD55FF","8. c #D369EB",
"9. c #D567F1","0. c #D661FF","q. c #D761FF","w. c #D863FF","e. c #DB66FF",
"r. c #DE6AFF","t. c #E26EFF","y. c #E26FFF","u. c #E470FF","i. c #E673FF",
"p. c #E674FC","a. c #E879F9","s. c #EE7DFF","d. c #F07EFF","f. c #808080",
"g. c #828282","h. c #838383","j. c #8F8F8F","k. c #9B9B9B","l. c #A1A1A1",
"z. c #A2A2A2","x. c #A4A4A4","c. c #B1B1B1","v. c #B3B3B3","b. c #B7B7B7",
"n. c #F180FF","m. c #F989FE","M. c #FB8BFF","N. c #C0C0C0","B. c #CACACA",
"V. c #D4D4D4","C. c #D5D5D5","Z. c #D6D6D6","A. c #D7D7D7","S. c #D8D8D8",
"D. c #D9D9D9","F. c #DADADA","G. c #DBDBDB","H. c #DEDEDE","J. c #E2E2E2",
"K. c #E7E7E7","L. c #E8E8E8","P. c #EBEBEB","I. c None",
"I.I.I.I.I.I.I.I.I.I.b.A.V.b.I.I.I.I.I.I.I.I.I.I.",
"I.I.I.I.I.I.I.I.I.c.E v v T c.I.I.I.I.I.I.I.I.I.",
"I.I.I.I.I.I.j.j.z.B.; z.z.; B.z.j.j.I.I.I.I.I.I.",
"I.I.I.I.J.b.x.z.~ < O s s O < ~ z.x.b.J.I.I.I.I.",
"I.I.I.N.x.E A Y v x x x s x x x Y A E z.N.I.I.I.",
"I.I.I.G.h.; ; r v v M M N N Z Z x i 8 h.G.I.I.I.",
"I.I.I.A.T O O O ; ; ; < < < 8 8 r i r T A.I.I.I.",
"I.I.I.A.T ; O O O O k l z d O O O r 8 T A.I.I.I.",
"I.I.I.A.E O O O O ; L L L D % O O 8 8 E G.I.I.I.",
"I.I.I.G.E O O O O > P [ ] L % O O 8 8 E A.I.I.I.",
"I.I.I.A.~ ; O O O 4 { +.O.I % O O 2 8 E G.I.I.I.",
"I.I.I.G.Q ; S  .X.o.#.#.-.@.} } X.g 8 ~ A.I.I.I.",
"I.I.I.G.~ ; j :.1.3.4.7.6.6.2.,.&.y < ~ G.I.I.I.",
"I.I.I.A./ ; ; J 9.r.e.w.0.0.0.>.g ; 8 / A.I.I.I.",
"I.I.I.G.) , O - U p.i.i.t.t.8.V O ; 8 ~ G.I.I.I.",
"I.I.I.A.) - O O 6 %.d.s.s.a.K ; O ; 8 ) G.I.I.I.",
'I.I.I.G.) < O O O q =.M.M.$.> O O O 8 _ G.I.I.I.',
"I.I.I.G._ < O O O O h <.*.q O O O O 8 _ G.I.I.I.",
"I.I.I.G._ 8 O O O O O h u O O O O O 8 h.G.I.I.I.",
"I.I.I.G.h.< O O O O O O O O O O O O 8 _ G.I.I.I.",
"I.I.I.G.h.8 O O O O O O O O O O O O r h.G.I.I.I.",
"I.I.I.H.z.v 8 < < 8 < < < < < 8 < < M k.G.I.I.I.",
"I.I.I.I.A.k.E E T E E T E E T E E ~ k.A.I.I.I.I.",
"I.I.I.I.I.P.K.P.K.K.P.K.K.P.K.P.K.P.P.I.I.I.I.I."
);

use Gtk2 "-init"; 
use Encode;
$SIG{CHLD} = 'IGNORE';
$last="";
$enable=0;
use File::Basename qw/basename dirname/;
#$_=basename $0; s/\..*//; $base=$_;
#print "basename:".$_."\n"; exit;
#chdir dirname (-l $0?readlink $0:$0);
chdir "$ENV{HOME}/下载";
my $clip = Gtk2::Clipboard -> get(Gtk2::Gdk::Atom -> intern("PRIMARY", 0));
$clip -> signal_connect("owner-change" => \&deal);

$pixbuf0 = Gtk2::Gdk::Pixbuf->new_from_xpm_data(@clip0);
$pixbuf1 = Gtk2::Gdk::Pixbuf->new_from_xpm_data(@clip1);
#$pixbuf0 = Gtk2::Gdk::Pixbuf->new_from_inline(@icon0);
#$pixbuf1 = Gtk2::Gdk::Pixbuf->new_from_inline(@icon1);

my $status_icon = Gtk2::StatusIcon->new;
$status_icon->signal_connect('button-press-event',\&tray);
#$status_icon->set_from_file($base."0.png");
#$status_icon->set_from_file("clip0.png");
#$status_icon->set_from_pixbuf($pixbuf0);
#$status_icon->set_tooltip(decode("utf8","监视剪贴板内容，自动下载资源"));
tray();
$status_icon->set_visible(1);

Gtk2 -> main;
exit 0;
#----------------------------------
sub tray{
$enable=$enable?0:1;
$status_icon->set_from_pixbuf($enable?$pixbuf0:$pixbuf1);
$_=$enable?"监视剪贴板内容，自动下载资源":"剪贴板监视已关闭";
$status_icon->set_tooltip(decode("utf8",$_));
#$status_icon->set_from_file($enable?$base."0.png":$base."1.png");
}

#----------------------------------
sub deal{
return 0 if ! $enable;
$_= $clip -> wait_for_text,"primary";
#@url=m"http://[^\s]*"g;
@url=m"(?:http|mms|rtsp)://[^\s]*"g;
if($#url<0){print "none url\n";return 1;}
foreach(@url){
my $t;
s/\W+$//;
next if $last eq $_;
$last=$_;
#print "find:$_\n";next;
#----------------------------------
if(/v.youku.com/ || /tudou.com\/playlist/ || /v.ku6.com/ || /6.cn\/watch/ || /tv.sohu.com/){
   $t="下载flash资源";
   if(fork()==0){`$TERM ~/bin/flash-down.pl $_`;exit;}
}
if(m"http://u.115.com/file/\w+"){
   $t="下载115资源";
   if(fork()==0){`$TERM ~/bin/115_client $&`;exit;}
}
if(/rapidshare.com/ || /hotfile.com.*html/){
   $t="保存slimrat资源";
   if(fork()==0){`$TERM ~/bin/slimrat $_`;exit;}
}
if(/^mms/ || /^rtsp/ || /\.asx$/){
   $t="播放网络流媒体";
   if(fork()==0){`$TERM mplayer $_`;exit;}
}
#----------------------------------
if($t){
print "$t ===> $_\n";
$t=decode("utf8",$t);
`$ENV{HOME}/bin/msg elvis.png  $t $_`;
} else {print "unrecognized url\n"; return 1;}
}
}

