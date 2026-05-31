#!/bin/bash
set -e

# Custom packages for IPQ60XX 6.12 nowifi firmware:
# ssr-plus / openclash / ddns-go / msd_lite / upnp / zerotier

clone_pkg() {
  repo="$1"
  dest="$2"
  branch="${3:-}"
  rm -rf "$dest"
  if [ -n "$branch" ]; then
    git clone --depth=1 -b "$branch" "$repo" "$dest"
  else
    git clone --depth=1 "$repo" "$dest"
  fi
}

echo "==> Prepare custom service packages"

# Remove possible duplicates from feeds before adding custom package trees.
rm -rf package/feeds/luci/luci-app-ssr-plus \
       package/feeds/luci/luci-app-openclash \
       package/feeds/luci/luci-app-ddns-go \
       package/feeds/packages/ddns-go \
       feeds/packages/net/ddns-go \

# SSR Plus and its companion packages.
clone_pkg https://github.com/fw876/helloworld.git package/helloworld master

# OpenClash. The package Makefile lives in the luci-app-openclash subdirectory.
clone_pkg https://github.com/vernesong/OpenClash.git package/openclash master

# DDNS-GO LuCI and ddns-go backend.
clone_pkg https://github.com/sirpdboy/luci-app-ddns-go.git package/ddns-go main

# msd_lite backend and LuCI app.

# Make init scripts executable when the upstream tree keeps file mode loosely.
find package/ddns-go package/msd_lite package/luci-app-msd_lite package/openclash package/helloworld \
  -path '*/root/etc/init.d/*' -type f -exec chmod +x {} \; 2>/dev/null || true

# Keep the original nowifi intention clear: do not add Wi-Fi packages here.
echo "==> Custom packages are ready"
