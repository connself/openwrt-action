# OpenWrt_x86
[![Build X86 OpenWrt](https://github.com/connself/openwrt-action/actions/workflows/build-x86_64.yml/badge.svg)](https://github.com/connself/openwrt-action/actions/workflows/build-x86_64.yml)

自编译OpenWrt x86固件  


## 下载地址
详见 [GitHub Releases](https://github.com/connself/openwrt-action/releases)  

## Docker
详见 [Docker 使用说明](https://github.com/connself/openwrt-action/blob/main/x86_64/docker/README.md)  

## PVE
一键安装脚本

```bash -c
"$(curl -fsSL https://raw.githubusercontent.com/connself/openwrt-action/main/openwrt-lxc-install.sh)"
```

## 其他

- Hyper-V的vhdx虚拟磁盘
- VMWare Workstation的vmdk虚拟磁盘
- 有其它需求可以自行使用StarWind V2V Converter工具转换！  

### 鸣谢
- [GitHub Actions](https://github.com/features/actions)
- [OpenWrt](https://github.com/openwrt/openwrt)
- [Lean's OpenWrt](https://github.com/coolsnowwolf/lede)
- [tmate](https://github.com/tmate-io/tmate)
- [mxschmitt/action-tmate](https://github.com/mxschmitt/action-tmate)
- [csexton/debugger-action](https://github.com/csexton/debugger-action)
- [Cowtransfer](https://cowtransfer.com)
- [WeTransfer](https://wetransfer.com/)
- [Mikubill/transfer](https://github.com/Mikubill/transfer)
- [softprops/action-gh-release](https://github.com/softprops/action-gh-release)
- [ActionsRML/delete-workflow-runs](https://github.com/ActionsRML/delete-workflow-runs)
- [dev-drprasad/delete-older-releases](https://github.com/dev-drprasad/delete-older-releases)
- [peter-evans/repository-dispatch](https://github.com/peter-evans/repository-dispatch)
- [kenzok8/openwrt-packages](https://github.com/kenzok8/openwrt-packages)
- [haiibo/openwrt-packages](https://github.com/haiibo/openwrt-packages)
- [kiddin9/openwrt-packages](https://github.com/kiddin9/openwrt-packages)
- [jerrykuku/luci-theme-argon](https://github.com/jerrykuku/luci-theme-argon)
- [roacn/build-actions](https://github.com/roacn/build-actions)
