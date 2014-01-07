# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=softethervpn
PKG_VERSION:=4.03
PKG_RELEASE:=9408

PKG_BUILD_DIR:=$(BUILD_DIR)/v4.03-9408
PKG_SOURCE:=softether-src-v4.03-9408-rtm.tar.gz
PKG_SOURCE_URL:=http://jp.softether-download.com/files/softether/v4.03-9408-rtm-2014.01.04-tree/Source%20Code/
PKG_MD5SUM:=85e6889e3285a05a0c7b231bda1ca57a

include $(INCLUDE_DIR)/package.mk

define Package/softethervpnserver
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  TITLE:=Open-Source Free Cross-platform Multi-protocol VPN
  URL:=http://www.softether.org/
  DEPENDS:=+libpthread +librt +libreadline +libopenssl +libncurses +libiconv-full
endef

define Package/softethervpnclient
	$(call Package/softethervpnserver)
endef

define Package/softethervpnbridge
	$(call Package/softethervpnserver)
endef

define Package/softethervpncmd
	$(call Package/softethervpnserver)
endef

define Build/Configure
	cd $(PKG_BUILD_DIR)
endef

define Build/Compile
	$(MAKE) \
		$(TARGET_CONFIGURE_OPTS) \
		CCFLAGS="-I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/usr/lib/libiconv-full/include" \
		LDFLAGS="-L$(STAGING_DIR)/usr/lib -L$(STAGING_DIR)/usr/lib/libiconv-full/lib" \
		-C $(PKG_BUILD_DIR) \
		-f src/makefiles/linux_32bit.mak
endef

define Package/softethervpnserver/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/vpnserver/* $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/rc/vpnserver $(1)/etc/init.d/softethervpnserver
endef

define Package/softethervpnclient/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/vpnclient/* $(1)/usr/bin
endef

define Package/softethervpnbridge/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/vpnbridge/* $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/rc/vpnbridge $(1)/etc/init.d/softethervpnbridge
endef

define Package/softethervpncmd/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/vpncmd/* $(1)/usr/bin
endef

$(eval $(call BuildPackage,softethervpnserver))
$(eval $(call BuildPackage,softethervpnclient))
$(eval $(call BuildPackage,softethervpnbridge))
$(eval $(call BuildPackage,softethervpncmd))
