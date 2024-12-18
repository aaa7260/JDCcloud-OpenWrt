#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
git clone https://github.com/kenzok8/openwrt-packages package/kenzo
git clone https://github.com/kenzok8/small package/small

# 添加mihomo feed
echo "src-git mihomo https://github.com/morytyann/OpenWrt-mihomo.git;main" >> "feeds.conf.default"
# Add luci-theme-argon
# rm -rf lede/package/lean/luci-theme-argon
# git clone https://github.com/jerrykuku/luci-theme-argon.git
# rm -rf package/lean/luci-theme-argon/
#git clone --depth 1 -b master https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
#git clone --depth 1 -b master https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
# git clone --depth 1 -b main https://github.com/morytyann/OpenWrt-mihomo.git package/OpenWrt-mihomo
