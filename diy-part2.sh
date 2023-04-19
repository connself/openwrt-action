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

# echo '去掉autocore-x86型号信息中的'Default string - '显示'
# sed -i "s/\${g}' - '//g" package/lean/autocore/files/x86/autocore
echo '调整 x86 型号只显示 CPU 型号'
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}/g' package/lean/autocore/files/x86/autocore

echo '去掉autocore-x86型号信息中的'(CpuMark: xxxx Scores)'显示'
sed -i 's/ <%=luci.sys.exec("cat \/etc\/bench.log") or " "%>//g' package/lean/autocore/files/x86/index.htm


echo '设置时区'
sed -i "s/timezone='UTC'/timezone='CST-8'/" package/base-files/files/bin/config_generate
sed -i "/timezone='CST-8'/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ set system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate
sed -i "s/add_list system.ntp.server='0.openwrt.pool.ntp.org'/add_list system.ntp.server='ntp.aliyun.com'/" package/base-files/files/bin/config_generate
sed -i "s/add_list system.ntp.server='1.openwrt.pool.ntp.org'/add_list system.ntp.server='time1.cloud.tencent.com'/" package/base-files/files/bin/config_generate
sed -i "s/add_list system.ntp.server='2.openwrt.pool.ntp.org'/add_list system.ntp.server='time.ustc.edu.cn'/" package/base-files/files/bin/config_generate
sed -i "s/add_list system.ntp.server='3.openwrt.pool.ntp.org'/add_list system.ntp.server='cn.pool.ntp.org'/" package/base-files/files/bin/config_generate

echo '修改网络设置'
cat >package/base-files/files/etc/networkip <<-EOF
uci delete network.wan                                       # 删除wan口
uci delete network.wan6                                      # 删除wan6口
uci delete network.lan.type                                  # 关闭桥接选项(同下步互斥)
#uci set network.lan.type='bridge'                           # lan口桥接(单LAN口无需桥接，多LAN口必须桥接，同上步互斥)
uci set network.lan.proto='static'                           # lan口静态IP
uci set network.lan.ipaddr='192.168.123.5'                     # IPv4 地址(openwrt后台地址)
uci set network.lan.netmask='255.255.255.0'                  # IPv4 子网掩码
uci set network.lan.gateway='192.168.123.1'                    # IPv4 网关
#uci set network.lan.broadcast='192.168.123.555'               # IPv4 广播
uci set network.lan.dns='192.168.123.1'                        # DNS(多个DNS要用空格分开)
uci set network.lan.delegate='0'                             # 去掉LAN口使用内置的 IPv6 管理
uci set network.lan.ifname='eth0'                            # 设置lan口物理接口为eth0
#uci set network.lan.ifname='eth0 eth1'                      # 设置lan口物理接口为eth0、eth1
#uci set network.lan.mtu='1492'                              # lan口mtu设置为1492
uci delete network.lan.ip6assign                             # 接口→LAN→IPv6 分配长度——关闭，恢复uci set network.lan.ip6assign='64'
uci commit network
uci delete dhcp.lan.ra                                       # 路由通告服务，设置为“已禁用”
uci delete dhcp.lan.ra_management                            # 路由通告服务，设置为“已禁用”
uci delete dhcp.lan.dhcpv6                                   # DHCPv6 服务，设置为“已禁用”
uci set dhcp.lan.ignore='1'                                  # 关闭DHCP功能
uci set dhcp.@dnsmasq[0].filter_aaaa='1'                     # DHCP/DNS→高级设置→解析 IPv6 DNS 记录——禁止
uci set dhcp.@dnsmasq[0].cachesize='0'                       # DHCP/DNS→高级设置→DNS 查询缓存的大小——设置为'0'
uci add dhcp domain
uci set dhcp.@domain[0].name='openwrt'                       # 网络→主机名→主机目录——“openwrt”
uci set dhcp.@domain[0].ip='192.168.123.5'                     # 对应IP解析——192.168.123.5
uci add dhcp domain
uci set dhcp.@domain[1].name='cdn.jsdelivr.net'              # 网络→主机名→主机目录——“cdn.jsdelivr.net”
uci set dhcp.@domain[1].ip='104.16.86.20'                    # 对应IP解析——'104.16.86.20'
uci add dhcp domain
uci set dhcp.@domain[2].name='raw.githubusercontent.com'     # 网络→主机名→主机目录——“raw.githubusercontent.com”
uci set dhcp.@domain[2].ip='185.199.109.133'                 # 对应IP解析——'185.199.109.133'
uci commit dhcp
uci delete firewall.@defaults[0].syn_flood                   # 防火墙→SYN-flood 防御——关闭；默认开启
uci set firewall.@defaults[0].fullcone='1'                   # 防火墙→FullCone-NAT——启用；默认关闭
uci commit firewall
uci set dropbear.@dropbear[0].Port='8822'                    # SSH端口设置为'8822'
uci commit dropbear
uci set system.@system[0].hostname='OpenWrt'                 # 修改主机名称为OpenWrt
uci commit luci
uci set ttyd.@ttyd[0].command='/bin/login -f root'           # 设置ttyd免帐号登录
uci commit ttyd
EOF

echo '设置密码为空'
sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings

echo '删除53端口重定向'
sed -i '/REDIRECT[ \t]\+--to-ports[ \t]\+53/d' package/lean/default-settings/files/zzz-default-settings

echo '设置个性名字'
sed -i "s/OpenWrt /geomch. compiled in $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

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

