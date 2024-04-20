#!/bin/bash
#
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After install feeds)
#

echo "--------------diy-part2 start--------------"


echo 'Themes 主题'

# 更改 Argone 主题背景
cp -f $GITHUB_WORKSPACE/diy/argon/bg1.jpg package/luci-theme-argone/htdocs/luci-static/argone/img/bg1.jpg

# 修改 argone 为默认主题,可根据你喜欢的修改成其他的（不选择那些会自动改变为默认主题的主题才有效果）
sed -i 's/luci-theme-bootstrap/luci-theme-argone/g' feeds/luci/collections/luci/Makefile

echo '修改网络设置'
sed -i 's/192.168.1.1/192.168.123.5/g' package/base-files/files/bin/config_generate

echo '设置密码为空'
sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings

echo '设置作者信息'
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt-$(TZ=UTC-8 date "+%Y.%m.%d")'/g" package/lean/default-settings/files/zzz-default-settings   
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By GEOMCH'/g" package/lean/default-settings/files/zzz-default-settings


#设置ttyd免帐号登录
sed -i 's/\/bin\/login/\/bin\/login -f root/' feeds/packages/utils/ttyd/files/ttyd.config

# echo '去掉autocore-x86型号信息中的'Default string - '显示'
# sed -i "s/\${g}' - '//g" package/lean/autocore/files/x86/autocore
echo '调整 x86 型号只显示 CPU 型号'
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}/g' package/lean/autocore/files/x86/autocore

echo '去掉autocore-x86型号信息中的 CpuMark: xxxx Scores 显示'
sed -i 's/ <%=luci.sys.exec("cat \/etc\/bench.log") or " "%>//g' package/lean/autocore/files/x86/index.htm


echo '设置个性banner'
cp $GITHUB_WORKSPACE/diy/banner package/base-files/files/etc/banner