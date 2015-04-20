title: _comp_dpkg_installed_packages：未找到命令
date: 2014-02-06 18:33
tags:
- complete
- alias
- bash 
---
```
▶ type ap
ap 是 'sudo aptitude purge' 的别名
```
以前写的一个补全函数不对了。
查看 /usr/share/bash-completion/completions/aptitude，找到相应的命令段。
```
purge|remove|reinstall|forbid-version)
              COMPREPLY=( \
                  $( _xfunc dpkg _comp_dpkg_installed_packages "$cur" ) )
              return 0
              ;;
```
照抄purge段。
```
▶ git df
diff --git a/config/.bash/alias b/config/.bash/alias
index 227ac94..3545c89 100644
--- a/config/.bash/alias
+++ b/config/.bash/alias
@@ -140,7 +140,8 @@ _show_installed()
        local cur
        COMPREPLY=()
        cur=`_get_cword`
-        COMPREPLY=( $( _comp_dpkg_installed_packages $cur ) )
+#        COMPREPLY=( $( _comp_dpkg_installed_packages $cur ) )
+        COMPREPLY=( $( _xfunc dpkg _comp_dpkg_installed_packages "$cur" ) )
        return 0
}
```
ap的alias补全，恢复正常。
