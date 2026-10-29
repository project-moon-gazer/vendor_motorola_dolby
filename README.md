# Motorola Dolby Atmos DAX3 (Standalone Vendor Tree)

This repository provides a standalone, drop-in vendor tree for **Motorola Dolby Atmos DAX3** compatible with modern Android versions (Android 14 / Android 15 / QPR / API 35 & 36).

---

## 📦 What's Included

* **Dolby UI & System Service**:
  * `MotoDolbyDax3` (`com.motorola.dolby.dolbyui`) – User interface with profile switching, equalizers, surround virtualizer, and volume leveler.
  * `daxService` (`com.dolby.daxservice`) – Background service controlling the Dolby Audio Processing (DAP) daemon and hardware HAL.
* **Hardware Abstraction Layer (HAL)**:
  * `vendor.dolby.hardware.dms@2.1-service` – Dolby Mobile Solution (DMS) HIDL HAL daemon.
  * VINTF compatibility matrix fragment (`vintf/dolby_framework_compatibility_matrix.xml`).
* **Media Codec2 Service**:
  * `vendor.dolby.media.c2@1.0-service` – Codec2 service providing Dolby AC-4 (`c2.dolby.ac4.decoder`) and Dolby Digital Plus / Enhanced AC-3 (`c2.dolby.eac3.decoder`).
* **Audio Processing & Effect Libraries**:
  * `libswdap.so` – Software DAP effect library.
  * `libswgamedap.so` – Game DAP effect library.
  * `libdlbvol.so` – Dolby Volume Leveler effect library.
  * Supporting libraries: `libdmshal.so`, `libdlbdsservice.so`, `libdapparamstorage.so`, `libdlbpreg.so`, `libdeccfg.so`, etc.
* **SELinux Policies**:
  * Full sepolicy in `sepolicy/vendor/` including compatibility with Android 15 (`platform_app_36`), preventing SELinux denials for ServiceManager and hwservicemanager.

---

## 🚀 Integration Guide

### 1. Include in Device Tree

#### A. In `BoardConfig.mk` (or `BoardConfigCommon.mk`):
Add the following line to include the Dolby vendor sepolicy and VINTF matrix:
```make
include vendor/motorola/dolby/BoardConfigDolby.mk
```

#### B. In `device.mk` (or product makefile):
Add the following line to inherit all packages, libraries, permissions, and properties:
```make
$(call inherit-product, vendor/motorola/dolby/dolby.mk)
```

---

### 2. Configure `audio_effects.xml`

In your device's audio effects configuration file (typically `vendor/etc/audio_effects.xml` or `device/<oem>/<device>/audio/audio_effects.xml`):

#### A. Under `<libraries>`:
```xml
        <!-- DOLBY DAP -->
        <library name="dap" path="libswdap.so"/>
        <library name="dvl" path="libdlbvol.so"/>
        <!-- DOLBY GAME -->
        <library name="gamedap" path="libswgamedap.so"/>
        <!-- DOLBY END -->
```

#### B. Under `<effects>`:
```xml
        <!-- DOLBY DAP -->
        <effect name="dap" library="dap" uuid="9d4921da-8225-4f29-aefa-39537a04bcaa"/>
        <effect name="dlb_music_listener" library="dvl" uuid="40f66c8b-5aa5-4345-8919-53ec431aaa98"/>
        <effect name="dlb_ring_listener" library="dvl" uuid="21d14087-558a-4f21-94a9-5002dce64bce"/>
        <effect name="dlb_alarm_listener" library="dvl" uuid="6aff229c-30c6-4cc8-9957-dbfe5c1bd7f6"/>
        <effect name="dlb_system_listener" library="dvl" uuid="874db4d8-051d-4b7b-bd95-a3bebc837e9e"/>
        <effect name="dlb_notification_listener" library="dvl" uuid="1f0091e3-6ad8-40fe-9b09-5948f9a26e7e"/>
        <!-- DOLBY GAME -->
        <effect name="gamedap" library="gamedap" uuid="3783c334-d3a0-4d13-874f-0032e5fb80e2"/>
        <!-- DOLBY END -->
```

#### C. Under `<postprocess>`:
```xml
    <postprocess>
        <stream type="music">
            <apply effect="dlb_music_listener"/>
        </stream>
        <stream type="ring">
            <apply effect="dlb_ring_listener"/>
        </stream>
        <stream type="alarm">
            <apply effect="dlb_alarm_listener"/>
        </stream>
        <stream type="system">
            <apply effect="dlb_system_listener"/>
        </stream>
        <stream type="notification">
            <apply effect="dlb_notification_listener"/>
        </stream>
    </postprocess>
```

---

### 3. Configure Media Codecs (`media_codecs_c2.xml`)

Ensure your device's media codecs configuration includes the Dolby Audio Codec2 definitions. In your `media_codecs_c2.xml`:

```xml
    <Include href="media_codecs_dolby_audio.xml" />
```

Alternatively, copy `proprietary/vendor/etc/media_codecs_dolby_audio.xml` into your device configs.

---

### 4. Codec2 Vendor Dependencies

The Codec2 Dolby service (`vendor.dolby.media.c2@1.0-service`) relies on `libcodec2_soft_common.so` and `libsfplugin_ccodec_utils.so`.

In `dolby.mk`, these are included via AOSP vendor targets:
```make
PRODUCT_PACKAGES += \
    libcodec2_soft_common.vendor \
    libsfplugin_ccodec_utils.vendor
```
Do not provide static or duplicate prebuilt binaries for these libraries in `Android.bp`, as Soong will build them natively for vendor matching your ROM's bionic libc++.

---

### 5. SELinux & Android 15 Compatibility

On Android 15 (target SDK 35/36), platform-signed apps execute within the `platform_app_36` domain rather than `platform_app`. 

This repository's `sepolicy/vendor/hal_dms.te` includes:
```te
hal_client_domain(platform_app, hal_dms)
hal_client_domain(platform_app_36, hal_dms)

binder_call(hal_dms_default, platform_app)
binder_call(hal_dms_default, platform_app_36)

get_prop(platform_app, vendor_mot_dolby_prop)
get_prop(platform_app_36, vendor_mot_dolby_prop)
```
and defines `vendor_hal_dms_service` in `sepolicy/vendor/service_contexts` to allow `DaxService` to safely check AIDL interfaces before falling back to HIDL.
