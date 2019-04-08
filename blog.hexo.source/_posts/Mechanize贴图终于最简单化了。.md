title: Mechanize贴图终于最简单化了。
date: 2009-12-25 03:12:20
tags:
---

论坛修整。。发这里。 
今天仔细man WWW::Mechanize。理解了。现在都是一句填表贴图的。最精简的perl。
&lt;!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "[http://www.w3.org/TR/html4/loose.dtd](http://www.w3.org/TR/html4/loose.dtd)"&gt;
&lt;html&gt;
&lt;head&gt;
<title>~/应用/脚本/paste-img.pl.html</title>
&lt;meta name="Generator" content="Vim/7.2"&gt;
&lt;meta http-equiv="content-type" content="text/html; charset=UTF-8"&gt;
&lt;/head&gt;
&lt;body bgcolor="#000000" text="#ffffff"&gt;<font face="monospace">
<font color="#ffff00">&#xA0;1 </font><font color="#ff40ff">#!/usr/bin/perl -w</font>

<font color="#ffff00">&#xA0;2 </font>

<font color="#ffff00">&#xA0;3 </font><font color="#ffff00">use utf8</font>;

<font color="#ffff00">&#xA0;4 </font><font color="#ffff00">use strict</font>;

<font color="#ffff00">&#xA0;5 </font><font color="#ffff00">use </font>WWW::Mechanize;

<font color="#ffff00">&#xA0;6 </font>

<font color="#ffff00">&#xA0;7 </font><font color="#ffff00">my</font>&#xA0;<font color="#00ffff">$mech</font>&#xA0;= WWW::Mechanize-&gt;<font color="#ffff00">new</font>();

<font color="#ffff00">&#xA0;8 </font><font color="#ffff00">my</font>&#xA0;<font color="#00ffff">$web_select</font>=<font color="#ffff00">"</font><font color="#ffff00">cjb</font><font color="#ffff00">"</font>;

<font color="#ffff00">&#xA0;9 </font><font color="#00ffff">#my $web_select="kimag";</font>

<font color="#ffff00">10 </font><font color="#00ffff">#my $web_select="ubuntu";</font>

<font color="#ffff00">11 </font><font color="#00ffff">#======================</font>

<font color="#ffff00">12 </font><font color="#00ffff">#----cjb----</font>

<font color="#ffff00">13 </font><font color="#ffff00">if</font>(<font color="#00ffff">$web_select</font>&#xA0;<font color="#ffff00">eq</font>&#xA0;<font color="#ffff00">"</font><font color="#ffff00">cjb</font><font color="#ffff00">"</font>){

<font color="#ffff00">14 </font><font color="#00ffff">$mech</font>&#xA0;-&gt; get(<font color="#ffff00">"</font><font color="#ffff00">[http://www.cjb.net/](http://www.cjb.net/)</font><font color="#ffff00">"</font>);

<font color="#ffff00">15 </font><font color="#00ffff">$mech</font>&#xA0;-&gt; submit_form(

<font color="#ffff00">16 </font>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;<font color="#ffff00">with_fields </font>=&gt; {<font color="#ffff00">"</font><font color="#ffff00">image</font><font color="#ffff00">"</font>&#xA0;=&gt; <font color="#00ffff">$ARGV</font>[<font color="#ffff00">0</font>]});

<font color="#ffff00">17 </font>}

<font color="#ffff00">18 </font><font color="#00ffff">#[http://www.cjb.net/images.html?d2bbe.jpg](http://www.cjb.net/images.html?d2bbe.jpg)</font>

<font color="#ffff00">19 </font><font color="#00ffff">#[http://images.cjb.net/d2bbe.jpg](http://images.cjb.net/d2bbe.jpg)</font>

<font color="#ffff00">20 </font><font color="#00ffff">#======================</font>

<font color="#ffff00">21 </font><font color="#00ffff">#----kimag----</font>

<font color="#ffff00">22 </font><font color="#ffff00">if</font>(<font color="#00ffff">$web_select</font>&#xA0;<font color="#ffff00">eq</font>&#xA0;<font color="#ffff00">"</font><font color="#ffff00">kimag</font><font color="#ffff00">"</font>){

<font color="#ffff00">23 </font><font color="#00ffff">$mech</font>&#xA0;-&gt; get(<font color="#ffff00">"</font><font color="#ffff00">[http://kimag.es/](http://kimag.es/)</font><font color="#ffff00">"</font>);

<font color="#ffff00">24 </font><font color="#00ffff">$mech</font>&#xA0;-&gt; submit_form(

<font color="#ffff00">25 </font>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;<font color="#ffff00">with_fields </font>=&gt; {<font color="#ffff00">"</font><font color="#ffff00">userfile1</font><font color="#ffff00">"</font>&#xA0;=&gt; <font color="#00ffff">$ARGV</font>[<font color="#ffff00">0</font>]});

<font color="#ffff00">26 </font><font color="#00ffff">#&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;form_number =&gt; 1,</font>

<font color="#ffff00">27 </font><font color="#00ffff">#&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;fields =&gt; {"userfile1" =&gt; $ARGV[0]});</font>

<font color="#ffff00">28 </font>}

<font color="#ffff00">29 </font><font color="#00ffff">#[http://kimag.es/view.php?i=55323637.jpg](http://kimag.es/view.php?i=55323637.jpg)</font>

<font color="#ffff00">30 </font><font color="#00ffff">#[http://kimag.es/share/55323637.jpg](http://kimag.es/share/55323637.jpg)</font>

<font color="#ffff00">31 </font><font color="#00ffff">#======================</font>

<font color="#ffff00">32 </font><font color="#00ffff">#----paste.ubuntu----</font>

<font color="#ffff00">33 </font><font color="#ffff00">if</font>(<font color="#00ffff">$web_select</font>&#xA0;<font color="#ffff00">eq</font>&#xA0;<font color="#ffff00">"</font><font color="#ffff00">ubuntu</font><font color="#ffff00">"</font>){

<font color="#ffff00">34 </font><font color="#00ffff">$mech</font>&#xA0;-&gt; get(<font color="#ffff00">"</font><font color="#ffff00">[http://paste.ubuntu.org.cn/](http://paste.ubuntu.org.cn/)</font><font color="#ffff00">"</font>);

<font color="#ffff00">35 </font><font color="#00ffff">$mech</font>&#xA0;-&gt; submit_form(

<font color="#ffff00">36 </font>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;<font color="#ffff00">form_name </font>=&gt; <font color="#ffff00">"</font><font color="#ffff00">editor</font><font color="#ffff00">"</font>&#xA0;,

<font color="#ffff00">37 </font>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;<font color="#ffff00">fields </font>=&gt; { 

<font color="#ffff00">38 </font>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;<font color="#ffff00">"</font><font color="#ffff00">screenshot</font><font color="#ffff00">"</font>&#xA0;=&gt; <font color="#00ffff">$ARGV</font>[<font color="#ffff00">0</font>],

<font color="#ffff00">39 </font>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;<font color="#ffff00">"</font><font color="#ffff00">code2</font><font color="#ffff00">"</font>&#xA0;=&gt; <font color="#ffff00">join</font>(<font color="#ffff00">"</font><font color="#ff40ff">\n</font><font color="#ffff00">"</font>,<font color="#ffff00">`</font><font color="#ffff00">xsel -o</font><font color="#ffff00">`</font>),

<font color="#ffff00">40 </font>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;<font color="#ffff00">"</font><font color="#ffff00">poster</font><font color="#ffff00">"</font>&#xA0;=&gt; <font color="#ffff00">"</font><font color="#ffff00">eexp</font><font color="#ffff00">"</font>

<font color="#ffff00">41 </font>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;} ,

<font color="#ffff00">42 </font>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;<font color="#ffff00">button </font>=&gt; <font color="#ffff00">"</font><font color="#ffff00">paste</font><font color="#ffff00">"</font>);

<font color="#ffff00">43 </font>}

<font color="#ffff00">44 </font><font color="#00ffff">#======================</font>

<font color="#ffff00">45 </font><font color="#ffff00">my</font>&#xA0;<font color="#00ffff">$msg</font>=<font color="#ffff00">"</font><font color="#ffff00">/home/exp/应用/脚本/msg</font><font color="#ffff00">"</font>;

<font color="#ffff00">46 </font><font color="#ffff00">if</font>&#xA0;(<font color="#00ffff">$mech</font>-&gt;success()) {

<font color="#ffff00">47 </font>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;<font color="#ffff00">my</font>&#xA0;<font color="#00ffff">$rr</font>=<font color="#00ffff">$mech</font>-&gt;uri();

<font color="#ffff00">48 </font>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;<font color="#ffff00">print</font>&#xA0;<font color="#ffff00">"</font><font color="#ffff00">贴图地址： </font><font color="#00ffff">$rr</font><font color="#ffff00">&#xA0;。</font><font color="#ff40ff">\n</font><font color="#ffff00">"</font>;

<font color="#ffff00">49 </font>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;<font color="#ffff00">`</font><font color="#ffff00">echo </font><font color="#00ffff">$rr</font><font color="#ffff00">|xsel -i</font><font color="#ffff00">`</font>;

<font color="#ffff00">50 </font>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;<font color="#ffff00">`</font><font color="#00ffff">$msg</font><font color="#ffff00">&#xA0;eog-48.png 贴图地址 </font><font color="#00ffff">$rr</font><font color="#ffff00">`</font>;

<font color="#ffff00">51 </font>} <font color="#ffff00">else</font>&#xA0;{

<font color="#ffff00">52 </font>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;<font color="#ffff00">`</font><font color="#00ffff">$msg</font><font color="#ffff00">&#xA0;贴图 失败</font><font color="#ffff00">`</font>;

<font color="#ffff00">53 </font>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;<font color="#ffff00">print</font>&#xA0;<font color="#ffff00">"</font><font color="#ffff00">ERROR:</font><font color="#ff40ff">\t</font><font color="#ffff00">"</font>.<font color="#00ffff">$mech</font>-&gt;status().<font color="#ffff00">"</font><font color="#ff40ff">\n</font><font color="#ffff00">"</font>;

<font color="#ffff00">54 </font>}

<font color="#ffff00">55 </font><font color="#00ffff">#======================</font>

<font color="#ffff00">56 </font>

</font>&lt;/body&gt;
&lt;/html&gt;