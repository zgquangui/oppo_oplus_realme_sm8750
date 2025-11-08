#!/bin/bash
# 小米13/SM8550自动适配批处理脚本
# 请在项目根目录下执行！（强烈建议先git新分支和全量备份）

# 1. 全库批量替换常见平台标识
echo "批量替换 sm8750/OPPO/realme/oplus -> sm8550/Xiaomi"
find . -type f -exec sed -i 's/sm8750/sm8550/g' {} +
find . -type f -exec sed -i 's/SM8750/SM8550/g' {} +
find . -type f -exec sed -i 's/oppo/xiaomi/g' {} +
find . -type f -exec sed -i 's/OPPO/XIAOMI/g' {} +
find . -type f -exec sed -i 's/realme/xiaomi/g' {} +
find . -type f -exec sed -i 's/oplus/xiaomi/g' {} +

# 2. 常规目录批量重命名（如有则执行）
[ -d device/oppo ] && mv device/oppo device/xiaomi
[ -d device/realme ] && mv device/realme device/xiaomi_realme_bak
[ -d device/oplus ] && mv device/oplus device/xiaomi_oplus_bak
[ -d kernel/oppo ] && mv kernel/oppo kernel/xiaomi
[ -d vendor/oppo ] && mv vendor/oppo vendor/xiaomi
[ -d vendor/realme ] && mv vendor/realme vendor/xiaomi_realme_bak
[ -d vendor/oplus ] && mv vendor/oplus vendor/xiaomi_oplus_bak

# 3. 关键文件批量重命名（如dts/dtb、defconfig等）
echo "检测并批量重命名设备树/defconfig/BoardConfig等关键文件"
find . -type f -name '*sm8750*' -exec bash -c 'mv "$0" "${0/sm8750/sm8550}"' {} \;
find . -type f -name '*SM8750*' -exec bash -c 'mv "$0" "${0/SM8750/SM8550}"' {} \;

# 4. BoardConfig.mk/product/下具体内容替换
echo "修正 BoardConfig.mk/产品配置/platform-name..."
find . -type f -name 'BoardConfig.mk' -exec sed -i \
    -e 's/PRODUCT_PLATFORM := .*/PRODUCT_PLATFORM := nuwa/g' \
    -e 's/TARGET_BOARD_PLATFORM := .*/TARGET_BOARD_PLATFORM := sm8550/g' \
    -e 's/TARGET_BOOTLOADER_BOARD_NAME := .*/TARGET_BOOTLOADER_BOARD_NAME := nuwa/g' \
    {} \;

# 5. 内核相关适配（如有独立内核目录）
find . -type f -name '*defconfig*' -exec sed -i \
    -e 's/sm8750/sm8550/g' \
    -e 's/SM8750/SM8550/g' {} \;
find . -type f -name '*.dts' -exec sed -i \
    -e 's/sm8750/sm8550/g' \
    -e 's/SM8750/SM8550/g' {} \;

# 6. 常规构建脚本、README等适配重命名
find . -type f \( -name '*.sh' -o -name '*.mk' -o -name '*.md' -o -name '*.conf' \) -exec sed -i \
    -e 's/sm8750/sm8550/g' \
    -e 's/SM8750/SM8550/g' \
    -e 's/oppo/xiaomi/g' \
    -e 's/OPPO/XIAOMI/g' \
    -e 's/realme/xiaomi/g' \
    -e 's/oplus/xiaomi/g' {} \;

echo "批量处理完成，请根据编译需要进一步修订专有dts/defconfig/产品设置和小米13平台/官方blobs等内容，后续如需设备专属补丁、下载小米device tree等，可联系我扩展自动化脚本！"
