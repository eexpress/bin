#!/usr/bin/perl

# 转换 csv 通讯录成 VCard 3.0 格式。
# 格式标准 https://tools.ietf.org/html/rfc6350
@VCard=(
		["FN:","姓名","名字","Name",],
		["EMAIL;HOME:","电子邮箱","Email",],
		["EMAIL;WORK:","商务邮箱","BEmail",],
		["TEL;HOME;CELL:","手机号码","Tel",],
		["TEL;WORK;CELL:","商务手机","BTel",],
		["ORG:","公司名称","Org",],
		["RELATED;TYPE:","组名","Related",],
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
			if($find==0){push @f,"-"};
		}
		while(<IN>){
			if(/^\s*$/){next};
			if(!/\d/ && !/@/){next};	#无电话无邮箱的不要。
			print "BEGIN:VCARD\n";
			print "VERSION:3.0\n";
			@items=split /,/;
			for($c=0;$c<@f;$c++){
				if(/-/){next};
				chomp $items[$c];
				if($items[$c] eq ""){next};
				print "$f[$c]$items[$c]\n";
			}
			print "END:VCARD\n\n";
		}
	}
}
