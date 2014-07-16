SoftEther VPN for OpenWrt
=
Your router is if ar71xx, you do not need build steps.  
You can get binary package from http://b.mikomoe.jp/.

If you are japanese or could read japanese, Visit [my blog](http://elin.mikomoe.jp/index.php?entry=OpenWRT%E3%81%A7SoftEther-VPN%E3%82%92%E5%8B%95%E3%81%8B%E3%81%99).

Compile
-
1. Install the packages required to compile

  For debian.
  ```
  apt-get install -y subversion make gcc g++ libncurses5-dev libghc-zlib-dev libreadline-dev libssl-dev gawk bzip2 patch sudo
  ```

2. Get OpenWrt SDK and prepare for compile
  ```
  svn co svn://svn.openwrt.org/openwrt/branches/attitude_adjustment
  cd attitude_adjustment
  ```

  SoftEther VPN uses SHA algorithm.  
  For default, it is not enabled.  
  You will need to enabled this.
  ```
  sed -i 's/no-sha0//' package/openssl/Makefile
  ```

  Add following line to feeds.conf file.
  If file not exists, Add line after copy feeds.conf.default to feeds.conf.
  ```
  src-git softethervpn https://github.com/el1n/OpenWRT-package-softether.git
  ```

  Update feeds and Install SoftEther VPN.
  ```
  ./scripts/feeds update
  ./scripts/feeds install softethervpnserver
  ```

3. SDK settings
  ```
  make defconfig
  make menuconfig
  ```
  Change "Target System" for your OpenWrt.  
  Visit "Network/VPN/SoftEther VPN", Check what you need.

4. Build the package
  ```
  make prepare
  make package/softethervpn/compile V=99
  ```
  You can find packages from ./bin directory if compile succeed.

5. Install to OpenWrt

  SoftEther VPN need some packages.
  + zlib
  + libpthread
  + librt
  + libreadline
  + libncurses
  + libiconv-full

  And libopenssl, But can not use SHA algorithm in official build.  
  So install the libopenssl package that was build together with SoftEther VPN.

  However results in "md5sum mismatch" error.  
  Delete the package list once to avoid this.
  ```
  rm /var/opkg-lists/attitude_adjustment
  ```
