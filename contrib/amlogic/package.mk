# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="hyperhdr"
PKG_VERSION="v22.0.0"
PKG_REV="1"
PKG_LICENSE="MIT"
PKG_ADDON_VERSION="22.0.0"
PKG_MAINTAINER="HyperHDR"
PKG_SITE="https://github.com/user83749/HyperHDR"
PKG_URL="https://github.com/user83749/HyperHDR.git"
GET_HANDLER_SUPPORT="git"
PKG_DEPENDS_TARGET="toolchain qt-everywhere pkg-config:host libjpeg-turbo alsa-lib zstd"
PKG_TOOLCHAIN="cmake"
PKG_SECTION="service"
PKG_SHORTDESC="HyperHDR: an ambient lighting controller"
PKG_LONGDESC="HyperHDR 22.0.0 with an experimental smoothing frame-delay (updateDelay)."

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="HyperHDR"
PKG_ADDON_TYPE="xbmc.service"

# Setting default values
PKG_PLATFORM="-DPLATFORM=linux -DENABLE_AMLOGIC=ON"
PKG_PLATFORM="$PKG_PLATFORM -DENABLE_WS281XPWM=OFF -DENABLE_FRAMEBUFFER=OFF -DENABLE_PIPEWIRE=OFF -DENABLE_X11=OFF -DENABLE_CEC=OFF"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_NO_SYSTEM_FROM_IMPORTED=ON \
                       -DCMAKE_BUILD_TYPE=Release \
                       -DUSE_STATIC_QT_PLUGINS=ON \
                       -DENABLE_DEPENDENCY_PACKAGING=ON \
                       $PKG_PLATFORM \
                       -Wno-dev"

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/{bin,lib,share,lib.private}

  cp -r -P -p $(get_install_dir hyperhdr)/usr/bin/hyperhdr* ${ADDON_BUILD}/${PKG_ADDON_ID}/bin

  if [ -d "$(get_install_dir hyperhdr)/usr/lib/hyperhdr" ]; then
    cp -r -P $(get_install_dir hyperhdr)/usr/lib/hyperhdr/* ${ADDON_BUILD}/${PKG_ADDON_ID}/lib
  fi
  if [ -d "$(get_install_dir hyperhdr)/usr/share/hyperhdr" ]; then
    cp -r -P $(get_install_dir hyperhdr)/usr/share/hyperhdr/* ${ADDON_BUILD}/${PKG_ADDON_ID}/share
  fi

  patchelf --set-rpath '$ORIGIN/../lib' ${ADDON_BUILD}/${PKG_ADDON_ID}/bin/hyperhdr

  cp -p $(get_install_dir zstd)/usr/lib/libzstd.so.1 ${ADDON_BUILD}/${PKG_ADDON_ID}/lib.private
  patchelf --add-rpath '$ORIGIN/../lib.private' ${ADDON_BUILD}/${PKG_ADDON_ID}/bin/hyperhdr
}
