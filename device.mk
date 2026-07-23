#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from sm8635-common.
$(call inherit-product, device/xiaomi/sm8635-common/common.mk)

DEVICE_PATH := device/xiaomi/uke
KERNEL_PATH := device/xiaomi/uke-kernel

# Install the prebuilt kernel image to $(PRODUCT_OUT)/kernel as a standalone
# target. Required by the VINTF kernel compatibility check (check_vintf_all ->
# kernel_version.txt) on the bp4a/userdebug build path; TARGET_PREBUILT_KERNEL
# feeds boot.img but does not install this file.
PRODUCT_COPY_FILES += \
    $(KERNEL_PATH)/kernel:kernel

# System DLKM modules
# uke-kernel tree layout:
#   modules/system/   -> system_dlkm partition (GKI base modules)
SYSTEM_DLKM_MODULES_DIR := $(firstword $(wildcard $(KERNEL_PATH)/modules/system/6.1*))
ifneq ($(SYSTEM_DLKM_MODULES_DIR),)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(SYSTEM_DLKM_MODULES_DIR)/,$(TARGET_COPY_OUT_SYSTEM_DLKM)/lib/modules/$(notdir $(SYSTEM_DLKM_MODULES_DIR))/)
endif

ifneq ($(wildcard $(KERNEL_PATH)/modules/system/flatten),)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(KERNEL_PATH)/modules/system/flatten/,$(TARGET_COPY_OUT_SYSTEM_DLKM)/flatten/lib/modules/)
endif

# Vendor kernel headers from the prebuilt kernel tree, when present.
ifneq ($(wildcard $(KERNEL_PATH)/kernel-headers),)
PRODUCT_VENDOR_KERNEL_HEADERS += $(KERNEL_PATH)/kernel-headers
endif

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
