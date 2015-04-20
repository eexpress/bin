title: git 修改提交的注释
date: 2014-08-03 17:55
tags:
- git
---
After you push commit A yourself (in
       the first picture in this section), replace it with "git commit --amend" to
       produce commit B, and you try to push it out, because forgot that you have
       pushed A out already. In such a case, and only if you are certain that nobody in
       the meantime fetched your earlier commit A (and started building on top of it),
       you can run "git push --force" to overwrite it. In other words, "git push
       --force" is a method reserved for a case where you do mean to lose history.

手快+自动脚本，搞错了注释。

    只能这样重新修改
```
▶ git commit --amend
```
    如果不强制，就这样了。
```
▶ git push
To git@github.com:eexpress/eexp-bin.git
 ! [rejected]        master -> master (non-fast-forward)
error: 无法推送一些引用到 'git@github.com:eexpress/eexp-bin.git'
提示：更新被拒绝，因为您当前分支的最新提交落后于其对应的远程分支。
提示：再次推送前，先与远程变更合并（如 'git pull ...'）。详见
提示：'git push --help' 中的 'Note about fast-forwards' 小节。
```
    然后强制推送
```
▶ git push --force
```
