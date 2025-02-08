# 修改默认IP & 固件名称
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
sed -i "s/hostname='.*'/hostname='Roc'/g" package/base-files/files/bin/config_generate

# 移除要替换的包
rm -rf feeds/packages/net/alist
rm -rf feeds/luci/applications/luci-app-alist
rm -rf feeds/packages/net/adguardhome
rm -rf feeds/packages/net/ariang
rm -rf package/emortal/luci-app-athena-led

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# eBPF
echo "CONFIG_DEVEL=y" >> ./.config
echo "CONFIG_BPF_TOOLCHAIN_HOST=y" >> ./.config
echo "# CONFIG_BPF_TOOLCHAIN_NONE is not set" >> ./.config
echo "CONFIG_KERNEL_BPF_EVENTS=y" >> ./.config
echo "CONFIG_KERNEL_CGROUP_BPF=y" >> ./.config
echo "CONFIG_KERNEL_DEBUG_INFO=y" >> ./.config
echo "CONFIG_KERNEL_DEBUG_INFO_BTF=y" >> ./.config
echo "# CONFIG_KERNEL_DEBUG_INFO_REDUCED is not set" >> ./.config
echo "CONFIG_KERNEL_XDP_SOCKETS=y" >> ./.config

echo "CONFIG_BPF=y" >> ./target/linux/qualcommax/config-6.6
echo "CONFIG_BPF_SYSCALL=y" >> ./target/linux/qualcommax/config-6.6
echo "CONFIG_BPF_JIT=y" >> ./target/linux/qualcommax/config-6.6
echo "CONFIG_CGROUPS=y" >> ./target/linux/qualcommax/config-6.6
echo "CONFIG_KPROBES=y" >> ./target/linux/qualcommax/config-6.6
echo "CONFIG_NET_INGRESS=y" >> ./target/linux/qualcommax/config-6.6
echo "CONFIG_NET_EGRESS=y" >> ./target/linux/qualcommax/config-6.6
echo "CONFIG_NET_SCH_INGRESS=m" >> ./target/linux/qualcommax/config-6.6
echo "CONFIG_NET_CLS_BPF=m" >> ./target/linux/qualcommax/config-6.6
echo "CONFIG_NET_CLS_ACT=y" >> ./target/linux/qualcommax/config-6.6
echo "CONFIG_BPF_STREAM_PARSER=y" >> ./target/linux/qualcommax/config-6.6
echo "CONFIG_DEBUG_INFO=y" >> ./target/linux/qualcommax/config-6.6
echo "# CONFIG_DEBUG_INFO_REDUCED is not set" >> ./target/linux/qualcommax/config-6.6
echo "CONFIG_DEBUG_INFO_BTF=y" >> ./target/linux/qualcommax/config-6.6
echo "CONFIG_KPROBE_EVENTS=y" >> ./target/linux/qualcommax/config-6.6
echo "CONFIG_BPF_EVENTS=y" >> ./target/linux/qualcommax/config-6.6

#修改jdc re-ss-01 (亚瑟) 的内核大小为12M
sed -i "/^define Device\/jdcloud_re-ss-01/,/^endef/ { /KERNEL_SIZE := 6144k/s//KERNEL_SIZE := 12288k/ }" target/linux/qualcommax/image/ipq60xx.mk

#修改jdc re-cs-02 (雅典娜) 的内核大小为12M
sed -i "/^define Device\/jdcloud_re-cs-02/,/^endef/ { /KERNEL_SIZE := 6144k/s//KERNEL_SIZE := 12288k/ }" target/linux/qualcommax/image/ipq60xx.mk

#修改jdc re-cs-07 (太乙) 的内核大小为12M
sed -i "/^define Device\/jdcloud_re-cs-07/,/^endef/ { /KERNEL_SIZE := 6144k/s//KERNEL_SIZE := 12288k/ }" target/linux/qualcommax/image/ipq60xx.mk

#coremark修复
sed -i 's/mkdir \$(PKG_BUILD_DIR)\/\$(ARCH)/mkdir -p \$(PKG_BUILD_DIR)\/\$(ARCH)/g' ../feeds/packages/utils/coremark/Makefile

# 想要剔除的
echo "CONFIG_PACKAGE_htop=n" >> ./.config
echo "CONFIG_PACKAGE_iperf3=n" >> ./.config
echo "CONFIG_PACKAGE_luci-app-wolplus=n" >> ./.config
echo "CONFIG_PACKAGE_luci-app-tailscale=n" >> ./.config
echo "CONFIG_PACKAGE_luci-app-advancedplus=n" >> ./.config
echo "CONFIG_PACKAGE_luci-theme-kucat=n" >> ./.config
# 一定要禁止编译这个coremark 不然会导致编译失败
# echo "CONFIG_PACKAGE_coremark=n" >> ./.config

# 可以让FinalShell查看文件列表并且ssh连上不会自动断开
echo "CONFIG_PACKAGE_openssh-sftp-server=y" >> ./.config
# 解析、查询、操作和格式化 JSON 数据
echo "CONFIG_PACKAGE_jq=y" >> ./.config
# base64 修改码云上的内容 需要用到
echo "CONFIG_PACKAGE_coreutils-base64=y" >> ./.config
# 简单明了的系统资源占用查看工具
echo "CONFIG_PACKAGE_btop=y" >> ./.config
# 多网盘存储
echo "CONFIG_PACKAGE_luci-app-alist=y" >> ./.config
# 强大的工具Lucky大吉(需要添加源或git clone)
echo "CONFIG_PACKAGE_luci-app-lucky=y" >> ./.config
# 网络通信工具
echo "CONFIG_PACKAGE_curl=y" >> ./.config
# BBR 拥塞控制算法(终端侧)
echo "CONFIG_PACKAGE_kmod-tcp-bbr=y" >> ./.config
echo "CONFIG_DEFAULT_tcp_bbr=y" >> ./.config
# 磁盘管理
echo "CONFIG_PACKAGE_luci-app-diskman=y" >> ./.config
# 其他调整
# 大鹅
echo "CONFIG_PACKAGE_luci-app-daed=y" >> ./.config
# 大鹅-next
# echo "CONFIG_PACKAGE_luci-app-daed-next=y" >> ./.config
# 连上ssh不会断开并且显示文件管理
echo "CONFIG_PACKAGE_openssh-sftp-server"=y
# docker只能集成
echo "CONFIG_PACKAGE_luci-app-dockerman=y" >> ./.config
# qBittorrent
echo "CONFIG_PACKAGE_luci-app-qbittorrent=y" >> ./.config
# 添加Homebox内网测速
# echo "CONFIG_PACKAGE_luci-app-homebox=y" >> ./.config
# echo "CONFIG_PACKAGE_homebox=y" >> ./.config
# V2rayA
echo "CONFIG_PACKAGE_luci-app-v2raya=y" >> ./.config
echo "CONFIG_PACKAGE_v2ray-core=y" >> ./.config
echo "CONFIG_PACKAGE_v2ray-geoip=y" >> ./.config
echo "CONFIG_PACKAGE_v2ray-geosite=y" >> ./.config
# NSS的sqm
echo "CONFIG_PACKAGE_luci-app-sqm=y" >> ./.config
echo "CONFIG_PACKAGE_sqm-scripts-nss=y" >> ./.config
# NSS MASH
echo "CONFIG_ATH11K_NSS_MESH=y" >> ./.config
# 不知道什么 加上去
echo "CONFIG_PACKAGE_MAC80211_NSS_REDIRECT=y" >> ./.config
# istore 编译报错
echo "CONFIG_PACKAGE_luci-app-istorex=y" >> ./.config
# QuickStart
# echo "CONFIG_PACKAGE_luci-app-quickstart=y" >> ./.config
# filebrowser-go
echo "CONFIG_PACKAGE_luci-app-filebrowser-go=y" >> ./.config
# 图形化web UI luci-app-uhttpd	
echo "CONFIG_PACKAGE_luci-app-uhttpd=y" >> ./.config
# 多播
# echo "CONFIG_PACKAGE_luci-app-syncdial=y" >> ./.config
# MosDNS
echo "CONFIG_PACKAGE_luci-app-mosdns=y" >> ./.config
# Natter2
echo "CONFIG_PACKAGE_luci-app-natter2=y" >> ./.config

# Alist & AdGuardHome & WolPlus & AriaNg & 集客无线AC控制器 & Lucky & 雅典娜LED控制 & MosDNS
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist
git_sparse_clone main https://github.com/kenzok8/small-package adguardhome luci-app-adguardhome v2dat mosdns luci-app-mosdns luci-app-istorex istoreenhance luci-app-istoredup luci-app-istoreenhance luci-app-istorego luci-app-istorepanel luci-app-natter2
git_sparse_clone main https://github.com/VIKINGYFY/packages luci-app-wolplus
git_sparse_clone master https://github.com/immortalwrt/packages net/ariang
git clone --depth=1 https://github.com/lwb1978/openwrt-gecoosac package/openwrt-gecoosac
# git clone --depth=1 https://github.com/gdy666/luci-app-lucky package/luci-app-lucky
git cline --depth=1 https://github.com/selfcan/luci-app-homebox
# 拉取Lucky最新版的源码
git clone https://github.com/sirpdboy/luci-app-lucky.git package/lucky
git clone --depth=1 https://github.com/NONGFAH/luci-app-athena-led package/luci-app-athena-led
chmod +x package/luci-app-athena-led/root/etc/init.d/athena_led
chmod +x package/luci-app-athena-led/root/usr/sbin/athena-led
# QiuSimons luci-app-daed
rm -rf ../feeds/luci/applications/luci-app-{dae*}
rm -rf ../feeds/packages/net/{dae*}
git clone https://github.com/QiuSimons/luci-app-daed package/dae
mkdir -p Package/libcron && wget -O Package/libcron/Makefile https://raw.githubusercontent.com/immortalwrt/packages/refs/heads/master/libs/libcron/Makefile
# luci-app-daed-next
git clone https://github.com/sbwml/luci-app-daed-next package/daed-next

# 添加源
echo "src-git small8 https://github.com/kenzok8/small-package" >>"feeds.conf.default"

./scripts/feeds update -a
./scripts/feeds install -a
