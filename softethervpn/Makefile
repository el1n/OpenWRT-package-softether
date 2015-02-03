# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=softethervpn
PKG_VERSION:=4.13
PKG_RELEASE:=9525
#PKG_VERSION2:=rtm
PKG_VERSION2:=beta
PKG_DATE:=2015.02.02

PKG_BUILD_DIR:=$(BUILD_DIR)/v$(PKG_VERSION)-$(PKG_RELEASE)
PKG_SOURCE:=softether-src-v$(PKG_VERSION)-$(PKG_RELEASE)-$(PKG_VERSION2).tar.gz
PKG_SOURCE_URL:=http://jp.softether-download.com/files/softether/v$(PKG_VERSION)-$(PKG_RELEASE)-$(PKG_VERSION2)-$(PKG_DATE)-tree/Source_Code/
PKG_MD5SUM:=70015eebed6a93a0f600dc31293d2e5a

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/softethervpnserver
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  TITLE:=Open-Source Free Cross-platform Multi-protocol VPN
  URL:=http://www.softether.org/
  DEPENDS:=+libpthread +librt +libreadline +libopenssl +libncurses +kmod-tun
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
endef

define Build/Compile
	make \
		-C $(PKG_BUILD_DIR) \
		-f src/makefiles/linux_32bit.mak \
		src/bin/BuiltHamcoreFiles/unix/hamcore.se2
	mv $(PKG_BUILD_DIR)/src/bin/BuiltHamcoreFiles/unix/hamcore.se2 $(PKG_BUILD_DIR)/src/bin/BuiltHamcoreFiles/unix/hamcore.se2.1

	make \
		-C $(PKG_BUILD_DIR) \
		-f src/makefiles/linux_32bit.mak \
		clean
	mv $(PKG_BUILD_DIR)/src/bin/BuiltHamcoreFiles/unix/hamcore.se2.1 $(PKG_BUILD_DIR)/src/bin/BuiltHamcoreFiles/unix/hamcore.se2
	#touch -d "`date -d 1day`" $(PKG_BUILD_DIR)/tmp/hamcorebuilder
	touch -d "`date -d 1day`" $(PKG_BUILD_DIR)/src/bin/BuiltHamcoreFiles/unix/hamcore.se2

	$(MAKE) \
		$(TARGET_CONFIGURE_OPTS) \
		CCFLAGS="-I$(STAGING_DIR)/usr/include $(ICONV_CFLAGS) -minterlink-mips16" \
		LDFLAGS="-L$(STAGING_DIR)/usr/lib $(ICONV_LDFLAGS) -liconv" \
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
