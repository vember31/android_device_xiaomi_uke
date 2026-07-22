#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/uke
KERNEL_PATH := device/xiaomi/uke-kernel

# Inherit from sm8635-common board configuration.
include device/xiaomi/sm8635-common/BoardConfigCommon.mk

# Board - TARGET_BOOTLOADER_BOARD_NAME defaults to "pineapple" via sm8635-common.

# Kernel version (6.1, GKI 2.0) - prebuilt only.
TARGET_KERNEL_VERSION := 6.1
TARGET_NO_KERNEL_OVERRIDE := true

# Kernel - prebuilt from device/xiaomi/uke-kernel.
# The Xiaomi-Pad-7-Pro-Resources uke-kernel tree currently stores the kernel
# as "kernel", panel DTBO as dtbo.img, and extracted DTBs under dtbs/.
ifneq ($(wildcard $(KERNEL_PATH)/kernel),)
TARGET_FORCE_PREBUILT_KERNEL := true
TARGET_PREBUILT_KERNEL       := $(KERNEL_PATH)/kernel
BOARD_PREBUILT_DTBOIMAGE     := $(KERNEL_PATH)/dtbo.img
BOARD_INCLUDE_DTB_IN_BOOTIMG :=
BOARD_KERNEL_SEPARATED_DTBO  :=
endif

ifneq ($(wildcard $(KERNEL_PATH)/dtb.img),)
TARGET_PREBUILT_DTB := $(KERNEL_PATH)/dtb.img
else ifneq ($(wildcard $(KERNEL_PATH)/dtbs/*.dtb),)
BOARD_PREBUILT_DTBIMAGE_DIR := $(KERNEL_PATH)/dtbs
endif

# Kernel modules
# uke-kernel tree layout:
#   modules/vendor/   -> vendor_dlkm partition (.ko + modules.load)
#   modules/ramdisk/  -> vendor_boot ramdisk (.ko + modules.load)
ifneq ($(wildcard $(KERNEL_PATH)/modules/vendor/modules.load),)
BOARD_VENDOR_KERNEL_MODULES                := $(wildcard $(KERNEL_PATH)/modules/vendor/*.ko)
BOARD_VENDOR_KERNEL_MODULES_LOAD           := $(strip $(shell cat $(KERNEL_PATH)/modules/vendor/modules.load))
BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE := $(KERNEL_PATH)/modules/vendor/modules.blocklist
endif

ifneq ($(wildcard $(KERNEL_PATH)/modules/ramdisk/modules.load),)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES                := $(wildcard $(KERNEL_PATH)/modules/ramdisk/*.ko)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD           := $(strip $(shell cat $(KERNEL_PATH)/modules/ramdisk/modules.load))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE := $(KERNEL_PATH)/modules/ramdisk/modules.blocklist
endif

ifneq ($(wildcard $(KERNEL_PATH)/modules/ramdisk/modules.load.recovery),)
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/modules/ramdisk/modules.load.recovery))
endif

# Workaround to make lineage's soong generator work
TARGET_KERNEL_SOURCE := $(KERNEL_PATH)/kernel-headers

# VINTF - keep the common Xiaomi/QCOM manifests, but avoid the non-QMAA audio
# fragments that can duplicate vendor-declared soundtrigger HALs.
DEVICE_MANIFEST_FILE := \
    $(COMMON_PATH)/configs/vintf/manifest.xml

# Partitions - measured from OS3.0.301.0.WOZMIXM fastboot firmware.
BOARD_SUPER_PARTITION_SIZE           := 11274289152
BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE := 11263803392

# SELinux
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# Properties
TARGET_ODM_PROP += $(DEVICE_PATH)/configs/properties/odm.prop
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/configs/properties/system.prop
