#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DOLBY_PATH := vendor/motorola/dolby

# Soong Namespace
PRODUCT_SOONG_NAMESPACES += \
    $(DOLBY_PATH)

# Permissions & Sysconfig
PRODUCT_COPY_FILES += \
    $(DOLBY_PATH)/proprietary/etc/permissions/com.motorola.dolby.dolbyui.dax3.features.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/com.motorola.dolby.dolbyui.dax3.features.xml \
    $(DOLBY_PATH)/proprietary/etc/sysconfig/hiddenapi-whitelist-com.motorola.dolby.dolbyui.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/hiddenapi-whitelist-com.motorola.dolby.dolbyui.xml \
    $(DOLBY_PATH)/proprietary/etc/default-permissions/default-permissions-com.motorola.dolby.dolbyui.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/default-permissions-com.motorola.dolby.dolbyui.xml \
    $(DOLBY_PATH)/proprietary/system_ext/etc/permissions/com.dolby.daxservice.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/com.dolby.daxservice.xml \
    $(DOLBY_PATH)/proprietary/system_ext/etc/permissions/com.motorola.frameworks.core.addon.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/com.motorola.frameworks.core.addon.xml \
    $(DOLBY_PATH)/proprietary/system_ext/etc/permissions/motoaudioeffectsdk.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/motoaudioeffectsdk.xml \
    $(DOLBY_PATH)/proprietary/system_ext/etc/permissions/moto-checkin.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/moto-checkin.xml \
    $(DOLBY_PATH)/proprietary/system_ext/etc/permissions/moto-settings.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/moto-settings.xml \
    $(DOLBY_PATH)/proprietary/system_ext/etc/permissions/moto-core_services.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/moto-core_services.xml

# DAX configs & Codec2
PRODUCT_COPY_FILES += \
    $(DOLBY_PATH)/proprietary/vendor/etc/dolby/dax-default.xml:$(TARGET_COPY_OUT_VENDOR)/etc/dolby/dax-default.xml \
    $(DOLBY_PATH)/proprietary/vendor/etc/media_codecs_dolby_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_dolby_audio.xml

# Properties
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.audio_fx.current=dolby \
    ro.vendor.dolby.dax.version=DAX3_3.11.0.10_r2 \
    vendor.audio.dolby.ds2.enabled=false \
    vendor.audio.dolby.ds2.hardbypass=false

# Packages
PRODUCT_PACKAGES += \
    MotoDolbyDax3 \
    daxService \
    MotorolaSettingsProvider \
    moto-settings \
    moto-checkin \
    moto-core_services \
    com.motorola.frameworks.core.addon \
    motoaudioeffectsdk \
    vendor.dolby.hardware.dms@2.1-service \
    vendor.dolby.media.c2@1.0-service \
    libdapparamstorage \
    libdlbpreg \
    libdmshal \
    vendor.dolby.hardware.dms@2.0 \
    vendor.dolby.hardware.dms@2.1 \
    libdlbdsservice \
    libcodec2_store_dolby \
    libcodec2_soft_ac4dec \
    libcodec2_soft_ddpdec \
    libcodec2_soft_common.vendor \
    libsfplugin_ccodec_utils.vendor \
    libdeccfg \
    libswdap \
    libswgamedap \
    libdlbvol
