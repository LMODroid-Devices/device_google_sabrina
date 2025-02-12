#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/bin/hw/android.hardware.security.keymint-service.amlogic)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "android.hardware.security.keymint-V1-ndk_platform.so" "android.hardware.security.keymint-V3-ndk.so" "${2}"
            "${PATCHELF}" --replace-needed "android.hardware.security.secureclock-V1-ndk_platform.so" "android.hardware.security.secureclock-V1-ndk.so" "${2}"
            "${PATCHELF}" --replace-needed "android.hardware.security.sharedsecret-V1-ndk_platform.so" "android.hardware.security.sharedsecret-V1-ndk.so" "${2}"
            ;;
        # Use generic Light HAL context for led_control_service
        vendor/etc/init/led_control_service.rc)
            [ "$2" = "" ] && return 0
            sed -i "8d" "${2}"
            ;;
        vendor/etc/init/tee-supplicant.rc)
            [ "$2" = "" ] && return 0
            sed -i 's#/vendor/lib/#/vendor/lib/modules/#g' "${2}"
            ;;
        *)
            return 1
            ;;
    esac

    return 0
}

function blob_fixup_dry() {
    blob_fixup "$1" ""
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=sabrina
export DEVICE_COMMON=sm1-common
export VENDOR=google
export VENDOR_BRAND="${VENDOR}"
export VENDOR_COMMON=amlogic

"./../../${VENDOR_COMMON}/${DEVICE_COMMON}/extract-files.sh" "$@"
