var darr = [
'google*', 'gstatic', 'gmail', 'sstatic.net', 'recaptcha.net',
'youtube', 'chrome.com',
'pinterest.com', 'pinimg.com',
'twitter', 'twimg', 'imgur.com',
'telegram.org', 'wire.com', 'tdesktop.com',
'disqus.com',  'wordpress', 'blogspot', 'feedburner.com', 'blogblog', 'blogger',
'reddit.com', 'valadoc.org', 'greasyfork.org',
'thepiratebay',	'wikipedia.org', 'alternativeto.net',
'bit.ly', 'ift.tt', 't.co', 'ow.ly', 'goo.gl', 'j.mp',
'apkpure.com', 'evozi.com', 'apkmirror.com', 'f-droid.org',
'askubuntu', 'stackexchange', 'stackoverflow',
'element.io'
];
//'fedoraproject.org', 'youneed.win',
//'github', 'githubusercontent.com', 'githubassets.com'

//~ ⭕ curl --proxy 127.0.0.1:10809 https://www.dnsleaktest.com/|g -A1 Hello
//~ ⭕ curl --socks5 127.0.0.1:10808 https://www.dnsleaktest.com/|g -A1 Hello

//V2ray Xray
//var socksport="10808";
//var httpport="10809";

//v2rayA
var socksport="20170";
var httpport="20171";
var httpPACport="20172";

function FindProxyForURL(url, host){
	for(var i=0;i<darr.length;i++){
		var append = '.*';
		if(darr[i].indexOf('.') != -1){ append = '/*'; }
		var str0 = '*.' + darr[i] + append;
		var str1 = '*://' + darr[i] + append;
		if(shExpMatch(url,str0) || shExpMatch(url,str1))
			return "PROXY localhost:"+httpport+"; SOCKS5 localhost:"+socksport+"; DIRECT";
	}
	return "DIRECT";
}
