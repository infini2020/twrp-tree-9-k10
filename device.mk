#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/kindle/k10
# A/B
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service \
    bootctrl.mt6765 \
    libgptutils \
    libz \
    libcutils

# OTA packages - Commented out to reduce image size
# Uncomment if OTA functionality is needed
# PRODUCT_PACKAGES += \
#     otapreopt_script \
#     cppreopts.sh \
#     update_engine \
#     update_verifier \
#     update_engine_sideload

# Omni TWRP 9 additional packages
PRODUCT_PACKAGES += \
    libkeymaster4 \
    libkeymaster41 \
    libpuresoftkeymasterdevice \
    libsoftkeymasterdevice

# Keymaster HAL
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.0-service \
    android.hardware.keymaster@4.0-impl

# Gatekeeper HAL
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service \
    android.hardware.gatekeeper@1.0-impl

# Keystore HAL
PRODUCT_PACKAGES += \
    android.hardware.keystore@1.0-service \
    android.hardware.keystore@1.0-impl
