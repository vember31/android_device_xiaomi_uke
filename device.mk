#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/uke

KERNEL_PATH := $(DEVICE_PATH)-kernel

# Inherit from the common OEM chipset makefile.
$(call inherit-product, device/xiaomi/sm8635-common/common.mk)

# Overlays
PRODUCT_PACKAGES += \
    FrameworksResUke \
    SettingsProviderResUke

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Maintainer prop
PRODUCT_PRODUCT_PROPERTIES += \
    ro.lunaris.maintainer=vember31

# Inherit the proprietary files
$(call inherit-product, vendor/xiaomi/uke/uke-vendor.mk)
