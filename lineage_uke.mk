#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

# Build flags
WITH_GMS := true
USE_REALITY_ENGINE := true
SURFACE_FLINGER_BOOST := true

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_tablet_wifionly.mk)

# Inherit from device makefile.
$(call inherit-product, device/xiaomi/uke/device.mk)

PRODUCT_DEVICE := uke
PRODUCT_BRAND := Xiaomi
PRODUCT_NAME := lineage_uke
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_MODEL := 2410CRP4CG

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

# Lunaris
PRODUCT_SYSTEM_PROPERTIES += \
    ro.lunaris.maintainer=vember31

WITH_GMS := true
SURFACE_FLINGER_BOOST := true
TARGET_CUSTOM_UDFPS := false

# Enable speed-profile dexopt
TARGET_OPTIMIZED_DEXOPT := true

# Boot animation
TARGET_BOOT_ANIMATION_RES := 1080

# Reality Engine
USE_REALITY_ENGINE := true

$(call soong_config_set,surfaceflinger,frame_rate_category_high,120)
$(call soong_config_set,surfaceflinger,frame_rate_category_min,60)

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="missi-user 16 BP2A.250605.031.A3 OS3.0.8.0.WOZMIXM release-keys" \
    BuildFingerprint=Xiaomi/uke_global/uke:16/BP2A.250605.031.A3/OS3.0.8.0.WOZMIXM:user/release-keys
