#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from sm8635-common.
$(call inherit-product, device/xiaomi/sm8635-common/common.mk)

DEVICE_PATH := device/xiaomi/uke
KERNEL_PATH := device/xiaomi/uke-kernel

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

# Vendor kernel headers from the prebuilt kernel tree.
PRODUCT_VENDOR_KERNEL_HEADERS += $(KERNEL_PATH)/kernel-headers

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

# Inherit from the device-specific proprietary files makefile.
$(call inherit-product, vendor/xiaomi/uke/uke-vendor.mk)
