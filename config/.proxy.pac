var darr = [
'google', 'gstatic', 'google-analytics', 'googleapis',
'googleusercontent', 'googlecode.com', 'youtube', 'chrome.com',
'gmail', 'sstatic.net', 'github', 'googlevideo.com',
'twitter', 'twimg', 'doubleclick.net', 'cyanogenmod', 'ytimg',
	'tumblr.com', 'recaptcha.net', 'imgchili.net', 
'ingress', 'appspot.com', 'telegram.org', 'webupd8.org',
'pastebin.com', 'disqus.com',
'blogblog', 'blogger', 'wordpress', 'blogspot', 'feedburner.com',
'instagram', 'facebook', 'opera', 'wikipedia', 
	'tapatalk.com', 'viewdns.info',
'bit.ly', 'ift.tt', 't.co', 'ow.ly', 'goo.gl', 'j.mp', 'youtu.be',
'feedburner.com', 'doubleclick.net', 'pinterest.com', 'duckduckgo.com', 
'apkpure.com', 'alternativeto.net', 'evozi.com', 'wire.com', 'apkmirror.com',
];
//▶ curl --socks5 127.0.0.1:1080 'http://www.viewdns.info/chinesefirewall/?domain=opensuse.org'|g -o accessible

function FindProxyForURL(url, host){
	var autosocks = 'SOCKS5 localhost:1080';
	for(var i=0;i<darr.length;i++){
		var append = '.*';
		if(darr[i].indexOf('.') != -1){ append = '/*'; }
		var str0 = '*.' + darr[i] + append;
		var str1 = '*://' + darr[i] + append;
		if(shExpMatch(url,str0) || shExpMatch(url,str1))
			return autosocks;
	}
	return "DIRECT";
}
