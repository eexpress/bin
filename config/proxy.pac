var darr = [
'google', 'gstatic', 'google-analytics', 'googleapis', 'googleusercontent', 'youtube',
'twitter', 'twimg', 'cyanogenmod', 'github', 'ytimg',
'ingress', 'appspot.com', 'telegram.org',
'blogblog', 'blogger', 'wordpress', 'blogspot',
'instagram', 'facebook', 'opera', 'wikipedia', 'sf.net',
'sourceforge.net', 'stackoverflow.com', 'xda-developers.com',
'bit.ly', 'ift.tt', 't.co', 'ow.ly', 'goo.gl',
'linuxtoy.org', 'askubuntu.com', 'igfw.cc',
'doubleclick.net', 'disqus.com', 'jav4you',
];

function FindProxyForURL(url, host){
	var autosocks = 'SOCKS5 localhost:1080';
	for(var i=0;i<darr.length;i++){
		var str = '*.' + darr[i] + '.*';
		if(shExpMatch(url,str)) return autosocks;
	}
	return "DIRECT";
}
