# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=utvpn
PKG_VERSION:=1.01
PKG_RELEASE:=7101

PKG_BUILD_DIR:=$(BUILD_DIR)/utvpn-unix-v101-7101-public
PKG_SOURCE:=utvpn-src-unix-v101-7101-public-2010.06.27.tar.gz
PKG_SOURCE_URL:=http://utvpn.tsukuba.ac.jp/files/utvpn/v1.01-7101-public-2010.06.27/Source%20Code%20(Win32%20and%20Unix)/
PKG_MD5SUM:=7a3f13621524b754da37ade8afceae85

include $(INCLUDE_DIR)/package.mk

define Package/utvpn
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  TITLE:=Open source solution as for PacketiX VPN
  URL:=http://utvpn.tsukuba.ac.jp/
endef

define Build/Configure
	cd $(PKG_BUILD_DIR)
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		LDSHARED="$(TARGET_CROSS)ld -shared" \
		CFLAGS="$(TARGET_CFLAGS) $(FPIC)" \
		CCFLAGS="-I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/usr/lib/libiconv-full/include" \
		LDFLAGS="-L$(STAGING_DIR)/usr/lib -L$(STAGING_DIR)/usr/lib/libiconv-full/lib" \
		-f makefiles/linux_32bit_ja.mak
endef

define Build/InstallDev
endef

# libz.so is needed for openssl (utvpn-dynamic)
define Package/utvpn/install
	mkdir -p $(PKG_INSTALL_DIR)/etc/init.d
	mkdir -p $(PKG_INSTALL_DIR)/usr/bin
	$(CP) $(PKG_BUILD_DIR)/rc/openwrt $(PKG_INSTALL_DIR)/etc/init.d/utvpn
	$(CP) $(PKG_BUILD_DIR)/output/utvpnserver/* $(PKG_INSTALL_DIR)/usr/bin
	$(INSTALL_DIR) $(1)
	$(CP) $(PKG_INSTALL_DIR)/* $(1)
endef

$(eval $(call BuildPackage,utvpn))
