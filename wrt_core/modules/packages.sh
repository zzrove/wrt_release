#!/usr/bin/env bash

remove_unwanted_packages() {
    local luci_packages=(
        "luci-app-passwall" "luci-app-ddns-go" "luci-app-rclone" "luci-app-ssr-plus"
        "luci-app-vssr" "luci-app-daed" "luci-app-dae" "luci-app-alist" "luci-app-homeproxy"
        "luci-app-haproxy-tcp" "luci-app-openclash" "luci-app-mihomo" "luci-app-appfilter"
        "luci-app-msd_lite" "luci-app-unblockneteasemusic" "luci-app-adguardhome"
    )
    local packages_net=(
        "haproxy" "xray-core" "xray-plugin" "dns2socks" "alist" "hysteria"
        "mosdns" "adguardhome" "ddns-go" "naiveproxy" "shadowsocks-rust"
        "sing-box" "v2ray-core" "v2ray-geodata" "v2ray-plugin" "tuic-client"
        "chinadns-ng" "ipt2socks" "tcping" "trojan-plus" "simple-obfs" "shadowsocksr-libev"
        "dae" "daed" "mihomo" "geoview" "open-app-filter" "msd_lite"
    )
    local packages_utils=(
        "cups"
    )
    for pkg in "${luci_packages[@]}"; do
        if [[ -d ./feeds/luci/applications/$pkg ]]; then
            \rm -rf ./feeds/luci/applications/$pkg
        fi
        if [[ -d ./feeds/luci/themes/$pkg ]]; then
            \rm -rf ./feeds/luci/themes/$pkg
        fi
    done

    for pkg in "${packages_net[@]}"; do
        if [[ -d ./feeds/packages/net/$pkg ]]; then
            \rm -rf ./feeds/packages/net/$pkg
        fi
    done

    for pkg in "${packages_utils[@]}"; do
        if [[ -d ./feeds/packages/utils/$pkg ]]; then
            \rm -rf ./feeds/packages/utils/$pkg
        fi
    done

    if [[ -d ./package/istore ]]; then
        \rm -rf ./package/istore
    fi

    if [ -d "$BUILD_DIR/target/linux/qualcommax/base-files/etc/uci-defaults" ]; then
        find "$BUILD_DIR/target/linux/qualcommax/base-files/etc/uci-defaults/" -type f -name "99*.sh" -exec rm -f {} +
    fi
}

# --- 新增：专门用于添加 daed 插件的函数 ---
add_daed() {
    local repo_url="https://github.com/QiuSimons/luci-app-daed.git"
    local target_dir="$BUILD_DIR/package/dae"

    echo "正在添加 luci-app-daed..."
    rm -rf "$target_dir" 2>/dev/null
    if ! git clone --depth 1 "$repo_url" "$target_dir"; then
        echo "错误：从 $repo_url 克隆 luci-app-daed 仓库失败" >&2
        exit 1
    fi
}

get_custom_feed_name() {
    printf '%s\n' "custom_feed"
}

get_custom_feed_source_dir() {
    printf '%s\n' "$BUILD_DIR/$(get_custom_feed_name)"
}

get_custom_feed_worktree_dir() {
    printf '%s\n' "$BUILD_DIR/feeds/$(get_custom_feed_name)"
}

get_custom_feed_package_dir() {
    printf '%s\n' "$BUILD_DIR/package/feeds/$(get_custom_feed_name)"
}

# (此处省略中间的原有辅助函数，如 update_golang, sync_sparse_packages_to_feed_dir 等...)
# 请保持您原有的这些辅助函数不变

# ... 保持您原文件中后续所有的 update_ 函数 (如 update_lucky, update_smartdns 等) ...

# 确保最后调用了 add_daed (请在主控脚本中调用)
