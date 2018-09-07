#!/usr/bin/perl

# 转换 csv 通讯录成 VCard 3.0 格式。
# 格式标准 https://tools.ietf.org/html/rfc6350
# 列定义：VCard, 139, 163, gmail
# 姓名,邮件地址,移动电话,联系地址,邮政编码,联系电话,公司,公司地址,公司邮编,公司电话,传真电话,生日,ICQ,主页地址,备用邮箱1,备用邮箱2,部门,职位,纪念日,备注,__cm_group
# 163自己导入导出的格式都乱。
@VCard=(
		["FN:","姓名",		"姓名",		"姓名",		"First Name",		],
		["EMAIL;TYPE=INTERNET;TYPE=HOME:",		"电子邮箱",	"邮件地址",	"E-mail Address",	],
		["EMAIL;TYPE=INTERNET;TYPE=WORK:",		"商务邮箱",	"工作邮箱",	"E-mail 2 Address",	],
		["TEL;TYPE=CELL:",	"手机号码",	"移动电话",	"Mobile Phone",		],
		["TEL;TYPE=WORK:",	"商务手机",	"商务手机",	"Business Phone",	],
		["ORG:",			"公司名称",	"公司",		"Company",			],
		["RELATED;TYPE:",	"组名",		"联系组",	"Categories",		],
);

@f=();
foreach(@ARGV){		# 可以读入多个csv格式文件。
	if (/\.csv$/){
		open IN,"<$_";
		$_=<IN>;	# 第一行必须是定义字段。
		@items=split /,/;
		foreach(@items){
			$i=$_; chomp $i;
			$find=0;
			foreach(@VCard){
				if($i~~$_){
					push @f,$_->[0];
					$find=1;
					last;
				}
			}
			if($find==0){push @f,"x-x"};
		}
		while(<IN>){
			if(/^\s*$/){next};
			if(!/\d/ && !/@/){next};	#无电话无邮箱的不要。
			print "BEGIN:VCARD\n";
			print "VERSION:3.0\n";
			@items=split /,/;
			for($c=0;$c<@f;$c++){
				if(/x-x/){next};
				chomp $items[$c];
				if($items[$c] eq ""){next};
				print "$f[$c]$items[$c]\n";
			}
			print "END:VCARD\n\n";
		}
	}
}
