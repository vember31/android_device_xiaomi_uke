#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

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
    BuildDesc="missi-user 16 BP2A.250605.031.A3 OS3.0.9.0.WOZMIXM release-keys" \
    BuildFingerprint=Xiaomi/missi/missi:16/BP2A.250605.031.A3/OS3.0.9.0.WOZMIXM:user/release-keys \
    DeviceName=$(PRODUCT_SYSTEM_DEVICE) \
    DeviceProduct=$(PRODUCT_SYSTEM_NAME)

# GMS
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
