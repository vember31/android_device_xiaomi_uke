#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

# Lunaris device options.
TARGET_CUSTOM_UDFPS := false
WITH_GMS := true
WITH_GMS_COMMS_SUITE := true
WITH_PIXEL_LAUNCHER := true
TARGET_USE_MAPS := true
TARGET_USE_FILES := true
TARGET_USE_GPHOTOS := true
TARGET_USE_WALLPAPERS := true
USE_REALITY_ENGINE := true
SURFACE_FLINGER_BOOST := true
TARGET_SUPPORTS_GOOGLE_TELEPHONY := false

$(call soong_config_set,surfaceflinger,frame_rate_category_high,144)
$(call soong_config_set,surfaceflinger,frame_rate_category_min,60)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_tablet_wifionly.mk)

# Inherit from uke device.
$(call inherit-product, device/xiaomi/uke/device.mk)

# Device identifier
PRODUCT_NAME := lineage_uke
PRODUCT_DEVICE := uke
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := Xiaomi Pad 7
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_SYSTEM_NAME := uke_global
PRODUCT_SYSTEM_DEVICE := uke

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="missi-user 16 BP2A.250605.031.A3 OS3.0.301.0.WOZMIXM release-keys" \
    BuildFingerprint=Xiaomi/missi/missi:16/BP2A.250605.031.A3/OS3.0.301.0.WOZMIXM:user/release-keys \
    DeviceName=$(PRODUCT_SYSTEM_DEVICE) \
    DeviceProduct=$(PRODUCT_SYSTEM_NAME)

# GMS
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

# Lunaris
PRODUCT_PRODUCT_PROPERTIES += \
    ro.lunaris.maintainer=vember31
