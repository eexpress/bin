function FindProxyForURL(url, host) {
	var autosocks = 'SOCKS5 127.0.0.1:7070';
	var autoproxy = 'PROXY 127.0.0.1:8087';
	var blackhole = 'PROXY 127.0.0.1:8086';
    if (host == '127.0.0.1' || isPlainHostName(host)) { return "DIRECT"; }
	if (
		dnsDomainIs(host, '.google.com') ||
		dnsDomainIs(host, 'plus.google.com') ||
		dnsDomainIs(host, '.googleapis.com') ||
		dnsDomainIs(host, '.gigacircle.com') ||
		dnsDomainIs(host, '.toshl.com') ||
		dnsDomainIs(host, '.opera.com') ||
		dnsDomainIs(host, '.cloudfront.net') ||
		dnsDomainIs(host, '.google.com.hk') ||
		dnsDomainIs(host, '.googlecode.com') ||
		dnsDomainIs(host, '.googleusercontent.com') || 
		dnsDomainIs(host, '.gstatic.com') || host == 'gstatic.com' ||
		dnsDomainIs(host, '.wordpress.com') ||
		dnsDomainIs(host, '.youtube.com') ||
		dnsDomainIs(host, '.blogspot.com') ||
		dnsDomainIs(host, '.blogspot.tw') ||
		dnsDomainIs(host, '.blogspot.hk') ||
		dnsDomainIs(host, '.ytimg.com') ||
		dnsDomainIs(host, '.ggpht.com') ||
		dnsDomainIs(host, '.wikipedia.org') ||
		dnsDomainIs(host, '.sf.net') ||
		dnsDomainIs(host, '.sourceforge.net') ||
		dnsDomainIs(host, '.stackoverflow.com') ||
		dnsDomainIs(host, '.xda-developers.com') ||
		dnsDomainIs(host, '.sstatic.net') ||
		dnsDomainIs(host, '.instagram.net') ||
		dnsDomainIs(host, '.twitter.com') ||
		dnsDomainIs(host, '.twimg.com') ||
		dnsDomainIs(host, '.opera.com') ||
		dnsDomainIs(host, '.jav4you.com') || dnsDomainIs(host, '.dmm.co.jp') || dnsDomainIs(host, '.21stp.com') ||
		dnsDomainIs(host, '.bit.ly') || host == 'bit.ly' ||
		dnsDomainIs(host, '.t.co') || host == 't.co' ||
		shExpMatch(host, "*thepiratebay.*") ||
		shExpMatch(host, "*twitter.com*") ||
		shExpMatch(host, "*facebook.com*") ||
		dnsDomainIs(host, '.facebook.com') || host == 'facebook.com' ||
		dnsDomainIs(host, '.connect.facebook.net') ||
		host == 'connect.facebook.net' ||
		/^https?:\/\/[^\/]+facebook\.com/i.test(url) ||
		host == 'ow.ly' ||
		host == 'goo.gl') { return autosocks; }
	return "DIRECT";
}
