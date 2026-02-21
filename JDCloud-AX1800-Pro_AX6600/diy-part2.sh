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

#sed -i '/redmi,ax5-jdcloud)/i jdcloud,ax6600|\\njdcloud,ax1800-pro|\' package/boot/uboot-envtools/files/qualcommax

#第二步：设备树文件重命名（这是将旧代号改为市场型号的关键步骤）

#mv target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6000-re-ss-01.dts target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6000-ax1800-pro.dts

#mv target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6010-re-cs-02.dts target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6010-ax6600.dts

#第三步：修改镜像生成脚本 (ipq60xx.mk)
#（注意： 我这里去掉了改 6144k 的逻辑，默认保持 12288k 以适配你的大分区 U-Boot）

#sed -i 's/jdcloud_re-ss-01/jdcloud_ax1800-pro/g' target/linux/qualcommax/image/ipq60xx.mk

#sed -i 's/jdcloud_re-cs-02/jdcloud_ax6600/g' target/linux/qualcommax/image/ipq60xx.mk

#sed -i 's/jdcloud_ax1800pro/jdcloud_ax1800-pro/g' target/linux/qualcommax/image/ipq60xx.mk

#sed -i 's/pad-to 6144k/pad-to 12288k/g' target/linux/qualcommax/image/ipq60xx.mk

#第四步：修改设备识别与网络配置
#（让系统内核认出新名字）

#sed -i 's/jdcloud,re-ss-01/jdcloud,ax1800-pro/g' target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6000-ax1800-pro.dts

#sed -i 's/jdcloud,re-cs-02/jdcloud,ax6600/g' target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6010-ax6600.dts

#第五步：全局替换系统脚本中的旧代号
#（包含 Network、Caldata、升级脚本等）

#grep -rl 'jdcloud,re-ss-01' target/linux/qualcommax/ipq60xx/base-files/ | xargs sed -i 's/jdcloud,re-ss-01/jdcloud,ax1800-pro/g'

#grep -rl 'jdcloud,re-cs-02' target/linux/qualcommax/ipq60xx/base-files/ | xargs sed -i 's/jdcloud,re-cs-02/jdcloud,ax6600/g'
# 复制 jdcloud patch 到 OpenWrt 源码 patches 目录
cp $GITHUB_WORKSPACE/JDCloud-AX1800-Pro_AX6600/999-jdcloud-full-support.patch \
   target/linux/qualcommax/patches-6.6/999-jdcloud-full-support.patch

# 可选：显示一下 patch 已经放到的位置，方便调试
echo "Patch copied to target/linux/qualcommax/patches-6.6/"
ls -l target/linux/qualcommax/patches-6.6/
