function FindProxyForURL(url, host) {
	var autoproxy = 'PROXY 127.0.0.1:8087';
	var blackhole = 'PROXY 127.0.0.1:8086';
	if (dnsDomainIs(host, '.google.com') ||
		dnsDomainIs(host, '.google.com.hk') ||
		dnsDomainIs(host, '.wordpress.com') ||
		dnsDomainIs(host, '.youtube.com') ||
		dnsDomainIs(host, '.blogspot.com') ||
		dnsDomainIs(host, '.yting.com') ||
		dnsDomainIs(host, '.ggpht.com') ||
		dnsDomainIs(host, '.wikipedia.org') ||
		dnsDomainIs(host, '.sf.net') ||
		dnsDomainIs(host, '.sourceforge.net') ||
		dnsDomainIs(host, '.twitter.com') ||
		dnsDomainIs(host, '.twimg.com') ||
		dnsDomainIs(host, '.facebook.com') ||
		shExpMatch(host, "*thepiratebay.*") ||
		shExpMatch(host, "*twitter.com*") ||
		shExpMatch(host, "*facebook.com*") ||
		host == 'ow.ly' ||
		host == 'goo.gl')
	{
		return autoproxy;
	}
}
