function FindProxyForURL(url, host) {
    var autoproxy = 'PROXY 127.0.0.1:8087';
    var blackhole = 'PROXY 127.0.0.1:8086';
    if (dnsDomainIs(host, '.google.com') ||
        dnsDomainIs(host, '.google.com.hk') ||
        dnsDomainIs(host, '.gmail.com') ||
        dnsDomainIs(host, '.wordpress.com') ||
        dnsDomainIs(host, '.youtube.com') ||
        dnsDomainIs(host, '.blogspot.com') ||
        dnsDomainIs(host, '.wikipedia.org') ||
        dnsDomainIs(host, '.sf.net') ||
        dnsDomainIs(host, '.sourceforge.net') ||
        dnsDomainIs(host, '.twitter.com') ||
        dnsDomainIs(host, '.facebook.com') ||
		shExpMatch(url, "*.thepiratebay.*") ||
		shExpMatch(url, "twitter.*") ||
		host == 'ow.ly' ||
        host == 'goo.gl')
    {
        return autoproxy;
    }
}
