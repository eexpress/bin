---
title: 手机上使用openkeychain
date: 2017-05-01 14:21:21
tags:
- gpg
- openkeychain
---
###openkeychain+password-store

传输私钥，最安全的方法，就是导出的私钥也加密。

```
gpg --armor --export-secret-keys YOUREMAILADDRESS | gpg --armor --symmetric --output mykey.sec.asc 
```

随便写一个密码。
 
官方居然建议使用这样的密码 gpg --armor --gen-random 1 20，你叫我如何输入哦。 

丢手机，文件没法关联到 openkeychain 打开。

最后是文件分享到 openkeychain，然后打开，输入密码，选择导入按两次。

终于导入了密钥。 

https://github.com/zeapo/Android-Password-Store#readme
从 F-Droid 下载apk。

https://f-droid.org/repository/browse/?fdid=com.zeapo.pwdstore。

https://f-droid.org/repo/com.zeapo.pwdstore_77.apk。

axel下载都慢得出血。。。 

选择 OpenPGP 应用 为 OpenKeychain后，下一项目选择 Key Id，还是无内容可选。

bug open: https://github.com/zeapo/Android-Password-Store/issues/279

https://f-droid.org/repo/org.sufficientlysecure.keychain_43001.apk
