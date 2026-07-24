#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/uke
KERNEL_PATH := device/xiaomi/uke-kernel

# Inherit from sm8635-common.
$(call inherit-product, device/xiaomi/sm8635-common/common.mk)

# Install the prebuilt kernel image to $(PRODUCT_OUT)/kernel as a standalone
# target. Required by the VINTF kernel compatibility check (check_vintf_all ->
# kernel_version.txt) on the bp4a/userdebug build path; TARGET_PREBUILT_KERNEL
# feeds boot.img but does not install this file.
PRODUCT_COPY_FILES += \
    $(KERNEL_PATH)/kernel:kernel

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

# Overlays
PRODUCT_PACKAGES += \
    FrameworksResUke \
    LunarisSettingsOverlayUke \
    SettingsProviderResUke

# Inherit from the device-specific proprietary files makefile.
$(call inherit-product, vendor/xiaomi/uke/uke-vendor.mk)
