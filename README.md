# Xiaomi Pad 7 (`uke`) Device Tree

This is a draft LineageOS device tree for Xiaomi Pad 7 / POCO Pad X1 (`uke`).
It is intended to be used with the Xiaomi Pad 7 Resources common trees:

```text
device/xiaomi/sm8635-common
device/xiaomi/uke
device/xiaomi/uke-kernel
vendor/xiaomi/sm8635-common
vendor/xiaomi/uke
```

For a `repo` checkout that should use the `vember31` GitHub forks, use
`manifests/vember31_uke.xml` as a local manifest. Lineage roomservice prefixes
normal `lineage.dependencies` entries with `LineageOS/`, so the local manifest
is the owner mapping that makes a build tree fetch these forked repositories:

```text
device/xiaomi/uke                 vember31/android_device_xiaomi_uke
device/xiaomi/sm8635-common       vember31/android_device_xiaomi_sm8635-common
device/xiaomi/uke-kernel          vember31/android_device_xiaomi_uke-kernel
vendor/xiaomi/sm8635-common       vember31/android_vendor_xiaomi_sm8635-common
vendor/xiaomi/uke                 vember31/android_vendor_xiaomi_uke
hardware/xiaomi                   LineageOS/android_hardware_xiaomi
```

Status:

- `device/xiaomi/uke` skeleton exists.
- `device/xiaomi/sm8635-common` is expected to provide the shared board config,
  packages, overlays, fstab, init, VINTF, and shared proprietary blob list.
- `device/xiaomi/uke-kernel` has been generated from the same stock firmware
  with the raw kernel image, DTBO, DTB, vendor ramdisk modules, vendor DLKM
  modules, and system DLKM modules.
- `proprietary-files.txt` is based on
  `uke_global_images_OS3.0.9.0.WOZMIXM_20260323.0000.00_16.0_global` and lists
  the non-common `uke` camera, audio, and touch blobs.
- `vendor/xiaomi/uke` has been generated from the same stock firmware with 751
  device-specific blobs and the camera blob fixups from `extract-files.py`.

The current product fingerprint is based on the extracted `OS3.0.9.0.WOZMIXM`
system build properties.

Bringup note: the public `vendor/xiaomi/sm8635-common` blobs are from Pad 7
Pro firmware. For first bringup, use the local `android_vendor_xiaomi_sm8635-common`
tree regenerated from the same `OS3.0.9.0.WOZMIXM` `uke` firmware so shared
same-path blobs match this device.
