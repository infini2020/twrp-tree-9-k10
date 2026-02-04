#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from k10 device
$(call inherit-product, device/kindle/k10/device.mk)

PRODUCT_DEVICE := k10
PRODUCT_NAME := twrp_k10
PRODUCT_BRAND := kindle
PRODUCT_MODEL := K10
PRODUCT_MANUFACTURER := kindle

PRODUCT_GMS_CLIENTID_BASE := android-bestone

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="full_k10-user 11 RP1A.200720.011 mp1k61v164bspP1 dev-keys"

BUILD_FINGERPRINT := BLU/G90/G0310WW:10/QP1A.190711.020/1585383273:user/release-keys
