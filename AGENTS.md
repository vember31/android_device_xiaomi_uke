# uke (Xiaomi Pad 7) — Development Notes

## Firmware
- Based on stock firmware: `OS3.0.301.0.WOZMIXM`
- Repos: `vember31/android_device_xiaomi_uke` and related (`lunaris-16.2`)
- Reference repos: `Xiaomi-Pad-7-Pro-Resources` org (lineage-23.2), built against 3.0.8.0 — useful for comparison but firmware version differs.

## Build Commands
```bash
. build/envsetup.sh
breakfast uke
m bacon          # full build + ROM zip
m vendorimage    # rebuild vendor.img only (e.g. after blob fixups)
m vendorbootimage  # rebuild vendor_boot.img only
```

## Proactive Checks

### After extracting blobs from firmware
Run this to find NEEDED library mismatches (versioned .so name drift, common on Qualcomm):
```bash
for so in $(find out/target/product/uke/vendor/lib64 out/target/product/uke/vendor/lib -name '*.so' 2>/dev/null); do
    readelf -d "$so" 2>/dev/null
done | grep NEEDED | awk '{print $NF}' | tr -d '[]' | sort -u | while read lib; do
    found=$(find out/target/product/uke -name "$lib" 2>/dev/null | head -1)
    [ -z "$found" ] && echo "MISSING: $lib"
done
```
Ignore DSP-side hits (`.skel.so`, `libevadsp`, `libdsp_streamer`, `libhcpfrc`, `ubwcdma_dynlib`) — those run on the Hexagon DSP, not the Linux linker. Focus on libraries like `libaudioroute`, `libprocessgroup`, NDK libs.

### Known blob fixups (keep extract-files.py in sync)
- `libar-pal.so`: `libaudioroute.so` → `libaudioroute-v34.so`
- Various `allocator` paths: `libprocessgroup_shim` addition
- CHI override: `allocator-V1-ndk` → `allocator-V2-ndk`

### Before flashing a build
- Verify `vendor_boot.img` has non-zero DTB (`python3 -c "import struct; ..."` or search for `0xd00dfeed` magic)
- Verify `BOARD_INCLUDE_DTB_IN_BOOTIMG` is not being unset (build system uses it as gate for vendor_boot DTB too)

## Known Gotchas
- `BOARD_INCLUDE_DTB_IN_BOOTIMG` must stay `true` — unsets it kills DTB in vendor_boot (device boots to fastboot)
- `DEVICE_MANIFEST_FILE` override in uke/BoardConfig.mk excludes `manifest_non_qmaa.xml` because 3.0.301.0 vendor manifest already declares soundtrigger HAL (duplicate FqInstance error)
- `TARGET_PREBUILT_DTB` is a dead variable in AOSP — use `BOARD_PREBUILT_DTBIMAGE_DIR` or a copy rule instead
- Firmware zip's `update-binary` must use `ZIPFILE="$3"` not `$1` (recovery passes zip as 3rd arg)
