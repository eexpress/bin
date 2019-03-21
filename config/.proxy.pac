//'google', 'gstatic', 'google-analytics', 'googleapis', 'googleusercontent', 'googlecode.com', 'googlevideo.com', 

var darr = [
'google*', 'gstatic', 'gmail', 'sstatic.net', 'recaptcha.net', 
'youtube', 'chrome.com',
'pinterest.com', 'pinimg.com',
'github', 'githubusercontent.com',
'twitter', 'twimg',
'telegram.org', 'wire.com',
'disqus.com',  'wordpress', 'blogspot', 'feedburner.com', 'blogblog', 'blogger',
'reddit.com', 'valadoc.org',
'thepiratebay',	'wikipedia.org', 'alternativeto.net',
'bit.ly', 'ift.tt', 't.co', 'ow.ly', 'goo.gl', 'j.mp',
'apkpure.com', 'evozi.com', 'apkmirror.com', 'f-droid.org',
];
//▶ curl --socks5 127.0.0.1:1080 'http://www.viewdns.info/chinesefirewall/?domain=opensuse.org'|g -o accessible

// https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt

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
