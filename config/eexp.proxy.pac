var keyword_array = [
'google*', 'gstatic', 'gmail', 'sstatic.net', 'recaptcha.net', 'youtube',
'pinterest.com', 'pinimg.com',
'twitter', 'twimg', 'imgur.com',
'telegram.org', 'wire.com', 'tdesktop.com',
'disqus.com',  'wordpress', 'blogspot', 'feedburner.com', 'blogblog', 'blogger',
'reddit.com', 'thepiratebay',	'wikipedia.org',
'bit.ly', 'ift.tt', 't.co', 'ow.ly', 'goo.gl', 'j.mp',
'apkpure.com', 'evozi.com', 'apkmirror.com', 'f-droid.org',
'stackexchange', 'element.io', 'v2raya.org',
'githubusercontent.com', 'githubassets.com',
];

//V2ray Xray
//var port = ["10809", "10809", "10808"];

//v2rayA [HTTP_Port, SOCK_Port, PAC_Port]
var port = ["20171", "20170", "20172"];

function FindProxyForURL (url, host) {		// host 是 :// 之后到第一个 : 或 / 之前的字符串
	for (var item of keyword_array) {
		var append = '.*';
		if (item.indexOf('.') != -1) {		//带点的视为完整域名
			append = '';	//不需要添加后缀
		}
		var str0 = '*.' + item + append;
		var str1 = item + append;
		if (shExpMatch(host, str0) || shExpMatch(host, str1))
			return `HTTP localhost:${port[0]}; HTTPS localhost:${port[0]}; SOCKS5 localhost:${port[1]}; DIRECT`;
	}
	return "DIRECT";
}
