#!/usr/bin/perl

use 5.010;
use MIME::Base64;
use JSON;

$_=defined $ARGV[0]?$ARGV[0]:`xclip -o`;
s'^vmess://'';
$_=decode_base64($_);
say; say "==================";
$rh=decode_json($_);
if($rh->{"add"} eq ""){say "格式无效"; exit;}

# 输出成v2ray格式的json文件
$_='// https://www.v2ray.com/chapter_00/start.html
{
	"inbounds": [{
		"port": 1080,  // 本机 SOCKS 代理端口
		"listen": "127.0.0.1",
		"protocol": "socks",
		"settings": { "udp": true }
	}],
	"outbounds": [{
		"protocol": "vmess",	//协议
		"settings": {
		"vnext": [{
			"address": "xxxadd", // 服务器地址
			"port": xxxport,  // 服务器端口
			// ID 和 AlterID
			"users": [{ "id": "xxxid", "alterId": xxxaid }]
		}]
	}
	},{
	"protocol": "freedom",
	"tag": "direct",
	"settings": {}
	}],
	"routing": {
	"domainStrategy": "IPOnDemand",
	"rules": [{
		"type": "field",
		"ip": ["geoip:private"],
		"outboundTag": "direct"
	}]
	}
}
';
s/xxxadd/$rh->{add}/; s/xxxport/$rh->{port}/;
s/xxxid/$rh->{id}/; s/xxxaid/$rh->{aid}/;
$f="$ENV{HOME}/vv-$rh->{ps}.json";
open OUT,">$f"; say $f;
print OUT $_; close OUT;
