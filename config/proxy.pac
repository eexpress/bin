var darr = [
'google', 'gstatic', 'google-analytics', 'googleapis', 'googleusercontent', 'googlecode.com', 'youtube', 'gmail', 'sstatic.net',
'twitter', 'twimg', 'doubleclick.net', 'cyanogenmod', 'github', 'ytimg',
'ingress', 'appspot.com', 'telegram.org', 'reddit.com',
'blogblog', 'blogger', 'wordpress', 'blogspot',
'instagram', 'facebook', 'opera', 'wikipedia', 'sf.net',
'sourceforge.net', 'stackoverflow.com', 'xda-developers.com',
'bit.ly', 'ift.tt', 't.co', 'ow.ly', 'goo.gl', 'j.mp',
'linuxtoy.org', 'askubuntu.com', 'igfw.cc',
'doubleclick.net', 'disqus.com', 'linuxquestions.org',
'faqoverflow.com', 'systhread.net', 'gravatar.com',
'pasteasy', 'ggpht', 'ubuntubuzz.com', 'anitalink.com',
'jav4you.com', 'publicbt.com', 'demonii.com', 'airvpn.org',
'exceptionfound.com', 'pubzi.com',
];

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
