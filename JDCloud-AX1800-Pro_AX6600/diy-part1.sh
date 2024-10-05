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
svn export https://github.com/kiddin9/openwrt-packages/tree/master/luci-app-pgyvpn package/luci-app-pgyvpn
svn export https://github.com/kiddin9/openwrt-packages/tree/master/pgyvpn package/pgyvpn
svn export https://github.com/kiddin9/openwrt-packages/tree/master/luci-app-phtunnel package/luci-app-phtunnel
svn export https://github.com/kiddin9/openwrt-packages/tree/master/phtunnel package/phtunnel
