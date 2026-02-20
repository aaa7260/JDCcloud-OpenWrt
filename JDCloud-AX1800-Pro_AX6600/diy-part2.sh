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
# 修正雅典娜/亚瑟的无线校准数据识别，防止 B 站断流
sed -i 's/jdcloud,re-cs-02/jdcloud,ax6600/g' target/linux/qualcommax/ipq60xx/base-files/etc/hotplug.d/firmware/11-ath11k-caldata
sed -i 's/jdcloud,re-ss-01/jdcloud,ax1800-pro/g' target/linux/qualcommax/ipq60xx/base-files/etc/hotplug.d/firmware/11-ath11k-caldata

# 修正 U-boot 环境工具定义
sed -i '/redmi,ax5-jdcloud)/i \jdcloud,ax6600|\\\njdcloud,ax1800-pro|\\' package/boot/uboot-envtools/files/qualcommax

# （可选）让固件显示的型号名更好看
# sed -i 's/DEVICE_MODEL := AX6600/DEVICE_MODEL := Athena-AX6600/g' target/linux/qualcommax/image/ipq60xx.mk
# sed -i 's/DEVICE_MODEL := AX1800 Pro/DEVICE_MODEL := Arthur-AX1800-Pro/g' target/linux/qualcommax/image/ipq60xx.mk
