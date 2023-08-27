#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

echo "--------------diy-part2 start--------------"

echo '修改网络设置'
sed -i 's/192.168.1.1/192.168.123.5/g' package/base-files/files/bin/config_generate

echo '设置密码为空'
sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings

echo '设置作者信息'
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt-$(TZ=UTC-8 date "+%Y.%m.%d")'/g" package/lean/default-settings/files/zzz-default-settings   
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By GEOMCH'/g" package/lean/default-settings/files/zzz-default-settings

echo 'zzz-default-settings自定义'
# 网络配置信息，将从 zzz-default-settings 文件的第2行开始添加 
# 参考 https://github.com/coolsnowwolf/lede/blob/master/package/lean/default-settings/files/zzz-default-settings
# 先替换掉最后一行 exit 0 再追加自定义内容
sed -i '/.*exit 0*/c\# 自定义配置' package/lean/default-settings/files/zzz-default-settings
cat >> package/lean/default-settings/files/zzz-default-settings <<-EOF
uci delete network.wan                                       # 删除wan口
uci delete network.wan6                                      # 删除wan6口
uci delete network.lan.type                                  # 关闭桥接选项(同下步互斥)
#uci set network.lan.type='bridge'                           # lan口桥接(单LAN口无需桥接,多LAN口必须桥接,同上步互斥)
uci set network.lan.proto='static'                           # lan口静态IP
uci set network.lan.ipaddr='192.168.123.5'                   # IPv4 地址(openwrt后台地址)
uci set network.lan.netmask='255.255.255.0'                  # IPv4 子网掩码
uci set network.lan.gateway='192.168.123.1'                  # IPv4 网关
#uci set network.lan.broadcast='192.168.123.555'             # IPv4 广播
uci set network.lan.dns='192.168.123.1'                      # DNS(多个DNS要用空格分开)
uci set network.lan.delegate='0'                             # 去掉LAN口使用内置的 IPv6 管理
uci set network.lan.ifname='eth0'                            # 设置lan口物理接口为eth0
#uci set network.lan.ifname='eth0 eth1'                      # 设置lan口物理接口为eth0、eth1
#uci set network.lan.mtu='1492'                              # lan口mtu设置为1492
uci delete network.lan.ip6assign                             # 接口→LAN→IPv6 分配长度——关闭,恢复uci set network.lan.ip6assign='64'
uci commit network
uci delete dhcp.lan.ra                                       # 路由通告服务,设置为“已禁用”
uci delete dhcp.lan.ra_management                            # 路由通告服务,设置为“已禁用”
uci delete dhcp.lan.dhcpv6                                   # DHCPv6 服务,设置为“已禁用”
uci set dhcp.lan.ignore='1'                                  # 关闭DHCP功能
uci set dhcp.@dnsmasq[0].filter_aaaa='1'                     # DHCP/DNS→高级设置→解析 IPv6 DNS 记录——禁止
uci set dhcp.@dnsmasq[0].cachesize='0'                       # DHCP/DNS→高级设置→DNS 查询缓存的大小——设置为'0'
uci add dhcp domain
uci set dhcp.@domain[0].name='openwrt'                       # 网络→主机名→主机目录——“openwrt”
uci set dhcp.@domain[0].ip='192.168.123.5'                   # 对应IP解析——192.168.123.5
uci commit dhcp
uci delete firewall.@defaults[0].syn_flood                   # 防火墙→SYN-flood 防御——关闭;默认开启
uci set firewall.@defaults[0].fullcone='1'                   # 防火墙→FullCone-NAT——启用;默认关闭
uci commit firewall

exit 0
EOF

#设置ttyd免帐号登录
sed -i 's/\/bin\/login/\/bin\/login -f root/' feeds/packages/utils/ttyd/files/ttyd.config

# echo '去掉autocore-x86型号信息中的'Default string - '显示'
# sed -i "s/\${g}' - '//g" package/lean/autocore/files/x86/autocore
echo '调整 x86 型号只显示 CPU 型号'
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}/g' package/lean/autocore/files/x86/autocore

echo '去掉autocore-x86型号信息中的 CpuMark: xxxx Scores 显示'
sed -i 's/ <%=luci.sys.exec("cat \/etc\/bench.log") or " "%>//g' package/lean/autocore/files/x86/index.htm


echo '设置个性banner'
cat > package/base-files/files/etc/banner <<EOF
                                                       __   
       .-----.-----.-----.-----.--.--.--.----.|  |_ 
       |  _  |  _  |  -__|     |  |  |  |   _||   _|
       |_____|   __|_____|__|__|________|__|  |____|
             |__| W I R E L E S S    F R E E D O M
        _________________________________________
        
           %D %V, %C
           geomch
        _________________________________________
EOF
# cp $GITHUB_WORKSPACE/banner package/base-files/files/etc/banner