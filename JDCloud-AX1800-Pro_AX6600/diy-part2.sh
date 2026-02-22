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
#sed -i 's/\r$//' $DIY_P2_SH
# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
##-----------------Add meta core for kenzo OpenClash------------------
curl -sL -m 30 --retry 2 https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz -o /tmp/clash.tar.gz
tar zxvf /tmp/clash.tar.gz -C /tmp >/dev/null 2>&1
chmod +x /tmp/clash >/dev/null 2>&1
mkdir -p package/kenzo/luci-app-openclash/root/etc/openclash/core
mv /tmp/clash package/kenzo/luci-app-openclash/root/etc/openclash/core/clash_meta >/dev/null 2>&1
rm -rf /tmp/clash.tar.gz >/dev/null 2>&1
# 确保系统能正确找到雅典娜的无线校准数据
# sed -i 's/jdcloud,re-cs-02/jdcloud,ax6600/g' target/linux/qualcommax/ipq60xx/base-files/etc/hotplug.d/firmware/11-ath11k-caldata
# 1. 修正 U-boot 环境变量工具定义
# sed -i '/redmi,ax5-jdcloud)/i \jdcloud,ax6600|\\\njdcloud,ax1800-pro|\\' package/boot/uboot-envtools/files/qualcommax

# 2. 修正无线校准数据识别路径 (防止 B 站断流)
# 我们用 find 确保能抓到 11-ath11k-caldata 文件
# find target/linux/qualcommax/ -name "11-ath11k-caldata" | xargs -i sed -i 's/jdcloud,re-cs-02/jdcloud,ax6600/g' {}
# find target/linux/qualcommax/ -name "11-ath11k-caldata" | xargs -i sed -i 's/jdcloud,re-ss-01/jdcloud,ax1800-pro/g' {}

# 3. 修正网络接口映射
# find target/linux/qualcommax/ -name "02_network" | xargs -i sed -i 's/jdcloud,re-cs-02/jdcloud,ax6600/g' {}
# find target/linux/qualcommax/ -name "02_network" | xargs -i sed -i 's/jdcloud,re-ss-01/jdcloud,ax1800-pro/g' {}
# sed -i 's/pad-to 6144k/pad-to 12288k/g' target/linux/qualcommax/image/ipq60xx.mk


#第一步：修改 U-Boot 环境变量工具
#（这段代码会在指定机型后插入新机型名称）

sed -i "/redmi,ax5-jdcloud)/i jdcloud,ax6600|\\\\\njdcloud,ax1800-pro|\\\\" package/boot/uboot-envtools/files/qualcommax
#第二步：设备树文件重命名（这是将旧代号改为市场型号的关键步骤）

#mv target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6000-re-ss-01.dts target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6000-ax1800-pro.dts

#mv target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6010-re-cs-02.dts target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6010-ax6600.dts
#修改 DTS 内容
#sed -i 's/led-boot = &led_status_green;/led-boot = \&led_status_red;/' \
#target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6000-re-ss-01.dts

#sed -i 's/led-running = &led_status_blue;/led-running = \&led_status_green;/' \
#target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6000-re-ss-01.dts

#sed -i 's/led-upgrade = &led_status_red;/led-upgrade = \&led_status_green;/' \
#target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6000-re-ss-01.dts

#sed -i 's/led-boot = &led_status_green;/led-boot = \&led_status_red;/' \
#target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6010-re-cs-02.dts

#sed -i 's/led-running = &led_status_blue;/led-running = \&led_status_green;/' \
#target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6010-re-cs-02.dts

#sed -i 's/led-upgrade = &led_status_red;/led-upgrade = \&led_status_green;/' \
#target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6010-re-cs-02.dts

#第三步：修改镜像生成脚本 (ipq60xx.mk)
#（注意： 我这里去掉了改 6144k 的逻辑，默认保持 12288k 以适配你的大分区 U-Boot）

#sed -i 's/jdcloud_re-ss-01/jdcloud_ax1800-pro/g' target/linux/qualcommax/image/ipq60xx.mk

#sed -i 's/jdcloud_re-cs-02/jdcloud_ax6600/g' target/linux/qualcommax/image/ipq60xx.mk

#sed -i 's/jdcloud_ax1800pro/jdcloud_ax1800-pro/g' target/linux/qualcommax/image/ipq60xx.mk

#sed -i 's/pad-to 6144k/pad-to 12288k/g' target/linux/qualcommax/image/ipq60xx.mk
sed -i 's/pad-to 12288k/pad-to 6144k/g' target/linux/qualcommax/image/ipq60xx.mk
# 将该行完全替换为包含无线包定义的新内容
#sed -i "s/DEVICE_DTS_CONFIG \:= config@cp03-c3/DEVICE_DTS_CONFIG \:= ipq6010-re-cs-02/" target/linux/qualcommax/image/ipq60xx.mk
cat target/linux/qualcommax/image/ipq60xx.mk
rm target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6010-re-cs-02.dts
rm target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6010-re-cs.dtsi
cp $GITHUB_WORKSPACE/JDCloud-AX1800-Pro_AX6600/ipq6010-re-cs-02.dts target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6010-re-cs-02.dts
cp $GITHUB_WORKSPACE/JDCloud-AX1800-Pro_AX6600/ipq6010-re-cs.dtsi target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6010-re-cs.dtsi
#第四步：修改设备识别与网络配置
#（让系统内核认出新名字）

#sed -i 's/jdcloud,re-ss-01/jdcloud,ax1800-pro/g' target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6000-ax1800-pro.dts

#sed -i 's/jdcloud,re-cs-02/jdcloud,ax6600/g' target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6010-ax6600.dts

#第五步：全局替换系统脚本中的旧代号
#（包含 Network、Caldata、升级脚本等）

#grep -rl 'jdcloud,re-ss-01' target/linux/qualcommax/ipq60xx/base-files/ | xargs sed -i 's/jdcloud,re-ss-01/jdcloud,ax1800-pro/g'

#grep -rl 'jdcloud,re-cs-02' target/linux/qualcommax/ipq60xx/base-files/ | xargs sed -i 's/jdcloud,re-cs-02/jdcloud,ax6600/g'

# 复制 jdcloud patch 到 OpenWrt 源码 patches 目录
#cp $GITHUB_WORKSPACE/JDCloud-AX1800-Pro_AX6600/999-jdcloud-full-support.patch \
#   target/linux/qualcommax/patches-6.6/999-jdcloud-full-support.patch
#清除缓存
rm -rf tmp/
#ls -l dl | grep "cups"
# 可选：显示一下 patch 已经放到的位置，方便调试
#echo "Patch copied to target/linux/qualcommax/patches-6.6/"
#ls -l target/linux/qualcommax/patches-6.6/
# 打印修改后的 mk 文件关键段落（用于在 Actions 日志中查看）
#echo "==================== 调试：检查 ipq60xx.mk 修改结果 ===================="
# grep -A 15 "jdcloud" target/linux/qualcommax/image/ipq60xx.mk
#cat target/linux/qualcommax/image/ipq60xx.mk
#echo "========================================================================"
# 打印config文件关键段落（用于在 Actions 日志中查看）
#echo "==================== 调试：检查 config 结果 ===================="
#grep -v  "is not set" .config
#echo "========================================================================"


#修改默认主题
sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")
#修改immortalwrt.lan关联IP
sed -i "s/192\.168\.[0-9]*\.[0-9]*/192\.168\.10\.1/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")
#添加编译日期标识
WRT_DATE=$(TZ=UTC-8 date +"%y.%m.%d-%H.%M.%S")
WRT_MARK=${GITHUB_REPOSITORY%%/*}
sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ $WRT_MARK-$WRT_DATE')/g" $(find ./feeds/luci/modules/luci-mod-status/ -type f -name "10_system.js")
#sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ Built by Roc')/g" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js



WIFI_SH=$(find ./target/linux/{mediatek/filogic,qualcommax}/base-files/etc/uci-defaults/ -type f -name "*set-wireless.sh" 2>/dev/null)
WIFI_UC="./package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc"
if [ -f "$WIFI_SH" ]; then
	#修改WIFI名称
	sed -i "s/BASE_SSID='.*'/BASE_SSID='PDCN'/g" $WIFI_SH
	#修改WIFI密码
	#sed -i "s/BASE_WORD='.*'/BASE_WORD='$WRT_WORD'/g" $WIFI_SH
elif [ -f "$WIFI_UC" ]; then
	#修改WIFI名称
	sed -i "s/ssid='.*'/ssid='PDCN'/g" $WIFI_UC
	#修改WIFI密码
	#sed -i "s/key='.*'/key='$WRT_WORD'/g" $WIFI_UC
	#修改WIFI地区
	sed -i "s/country='.*'/country='CN'/g" $WIFI_UC
	#修改WIFI加密
	sed -i "s/encryption='.*'/encryption='psk2+ccmp'/g" $WIFI_UC
fi

CFG_FILE="./package/base-files/files/bin/config_generate"
#修改默认IP地址
sed -i "s/192\.168\.[0-9]*\.[0-9]*/192\.168\.10\.1/g" $CFG_FILE
#修改默认主机名
sed -i "s/hostname='.*'/hostname='OWRT'/g" $CFG_FILE

#配置文件修改
echo "CONFIG_PACKAGE_luci=y" >> ./.config
echo "CONFIG_LUCI_LANG_zh_Hans=y" >> ./.config
echo "CONFIG_PACKAGE_luci-theme-argon=y" >> ./.config
echo "CONFIG_PACKAGE_luci-app-$argon-config=y" >> ./.config

#--------软件源由APK切换到IPK---------#
##echo "CONFIG_USE_APK=n" >> ./.config

#手动调整的插件
#if [ -n "$WRT_PACKAGE" ]; then
#	echo -e "$WRT_PACKAGE" >> ./.config
#fi
WRT_CONFIG=$GITHUB_WORKSPACE/JDCloud-AX1800-Pro_AX6600/.config
WRT_TARGET=$(grep -m 1 -oP '^CONFIG_TARGET_\K[\w]+(?=\=y)' "$WRT_CONFIG")
#高通平台调整
DTS_PATH="./target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/"
if [[ "${WRT_TARGET^^}" == *"QUALCOMMAX"* ]]; then
	#取消nss相关feed
	echo "CONFIG_FEED_nss_packages=n" >> ./.config
	echo "CONFIG_FEED_sqm_scripts_nss=n" >> ./.config
 	#开启sqm-nss插件
	echo "CONFIG_PACKAGE_luci-app-sqm=y" >> ./.config
	echo "CONFIG_PACKAGE_sqm-scripts-nss=y" >> ./.config
 	#设置NSS版本
	echo "CONFIG_NSS_FIRMWARE_VERSION_11_4=n" >> ./.config
	#if [[ "${WRT_CONFIG,,}" == *"ipq50"* ]]; then
	#	echo "CONFIG_NSS_FIRMWARE_VERSION_12_2=y" >> ./.config
	#else
		echo "CONFIG_NSS_FIRMWARE_VERSION_12_5=y" >> ./.config
	#fi
	#无WIFI配置调整Q6大小
	#if [[ "${WRT_CONFIG,,}" == *"wifi"* && "${WRT_CONFIG,,}" == *"no"* ]]; then
	#	find $DTS_PATH -type f ! -iname '*nowifi*' -exec sed -i 's/ipq\(6018\|8074\).dtsi/ipq\1-nowifi.dtsi/g' {} +
	#	echo "qualcommax set up nowifi successfully!"
	#fi
fi
# --- 修正后的关键配置统计 ---
echo '=== 关键配置统计 ==='
[ -f .config ] && {

    echo "=== 最终.config文件详细信息 ==="
    echo "配置文件: $(pwd)/.config"
    echo "文件大小: $(wc -l < .config) 行, $(wc -c < .config) 字节"
    echo "最后修改: $(date -r .config)"
    echo "启用的包: $(grep -c "=y" .config) 个"
    echo "禁用的包: $(grep -c "is not set" .config) 个"
    echo "内核模块: $(grep -c "CONFIG_PACKAGE_kmod" .config) 个"
    echo "LUCI应用: $(grep -c "CONFIG_PACKAGE_luci-app" .config) 个"
} || echo "警告: .config 文件尚未生成"


