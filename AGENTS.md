# AGENTS.md - 项目上下文文件

## 项目概述

这是一个用于 **FATARUS K10** 设备（设备代号：`k62v1_64_bsp_S30_254_incell_1036_dianshang`，产品名称：`k10`）的 Android 设备树项目，专门用于构建 **TWRP（Team Win Recovery Project）** 自定义恢复环境。

该项目经过优化配置，以生成较小的 TWRP 镜像文件，禁用了一些非核心功能以减小体积。

### 关键技术信息

- **设备品牌**: kindle
- **设备型号**: K10
- **制造商**: kindle
- **设备代号**: k62v1_64_bsp_S30_254_incell_1036_dianshang
- **产品名称**: k10
- **平台**: MediaTek MT6765 (Helio P35)
- **架构**: ARM64 (支持 64 位和 32 位 ABI)
- **CPU**: Cortex-A53 (64位) + Cortex-A53 (32位)
- **内核**: 使用预构建内核
- **Android 版本**: 基于 Android 11
- **安全补丁**: 2099-12-31（防止回滚保护）
- **恢复分区支持**: A/B OTA 更新支持
- **中文语言支持**: 默认语言设置为简体中文

### 项目类型

这是一个 **Android 设备树项目**，用于构建 TWRP 自定义恢复镜像。项目采用标准的 Android 构建系统，使用 Makefile 和 Soong 构建系统。

### 优化目标

项目配置专注于减小 TWRP 镜像大小，通过禁用非必要功能（如多语言支持、工具箱、重新打包工具、APEX 预优化等）来优化镜像体积。

## 项目结构

```
E:\demo\k10\
├───Android.bp              # Soong 构建系统配置
├───Android.mk              # Makefile 构建系统配置
├───AndroidProducts.mk      # 产品定义
├───BoardConfig.mk          # 板级配置（核心配置文件）
├───device.mk               # 设备级配置
├───extract-files.sh        # 从设备提取专有文件的脚本
├───twrp_k10.mk             # TWRP 产品配置
├───README.md               # 项目说明文档
├───AGENTS.md               # 项目上下文文档（本文件）
├───prebuilt/
│   └───kernel              # 预构建内核镜像
├───recovery/
│   └───root/
│       └───init.recovery.mt6762.rc  # 恢复模式初始化脚本
├───recovery.fstab          # 恢复分区挂载表
├───setup-makefiles.sh      # 设置 Makefile 的脚本
└───vendorsetup.sh          # 环境设置脚本
```

## 关键文件说明

### BoardConfig.mk
这是最重要的配置文件，定义了：
- 设备架构（ARM64 + ARM32）
- 平台（MT6765）
- 内核配置（预构建内核路径）
- 分区大小和布局
- A/B OTA 配置
- TWRP 主题和配置
- 安全补丁级别

### device.mk
定义了产品包和 A/B OTA 配置：
- Boot Control HAL（android.hardware.boot@1.0-impl、android.hardware.boot@1.0-service、bootctrl.mt6765 等）
- OTA 更新工具（已注释掉以减小镜像大小，需要时可启用）
- 预优化脚本（AB_OTA_POSTINSTALL_CONFIG）

### twrp_k10.mk
TWRP 产品定义文件，定义了：
- 产品继承关系（继承自 core_64_bit.mk、full_base_telephony.mk 和 vendor/twrp/config/common.mk）
- 产品名称（twrp_k10）、品牌（kindle）、型号（K10）
- 构建指纹和 GMS 客户端 ID

### recovery.fstab
定义了恢复模式下所有分区的挂载信息，包括：
- 逻辑分区（system、vendor、product）
- 物理分区（boot、vbmeta、dtbo 等）
- 特殊分区（metadata、protect_f、protect_s 等）
- MediaTek 特定分区（tee1、tee2、scp1、scp2、sspm_1、sspm_2、md1img、md3img 等）

### init.recovery.mt6762.rc
恢复模式初始化脚本，配置：
- USB 配置和调试支持
- A/B 特性的 preloader 分区符号链接
- MTK 路径工具启动

## 构建和运行

### 前置条件

1. Android 构建环境（需要 AOSP 源码树）
2. 必须的构建工具：
   - `make` (Android 构建系统)
   - `adb` (Android Debug Bridge)
3. 设备专有文件（需要从设备提取）

### 构建步骤

1. **设置环境**：
   ```bash
   source build/envsetup.sh
   ```

2. **选择产品**：
   ```bash
   lunch twrp_k10-user
   # 或
   lunch twrp_k10-userdebug
   # 或
   lunch twrp_k10-eng
   ```

3. **构建 TWRP**：
   ```bash
   m recoveryimage
   ```

### 提取专有文件

如果需要从设备提取专有文件：

```bash
# 使用 adb 从连接的设备提取
./extract-files.sh

# 或者从特定的源提取
./extract-files.sh -n /path/to/device/files

# 选项说明：
# -n | --no-cleanup : 不清理 vendor 文件夹
# -k | --kang      : 使用 kang 模式
# -s | --section   : 提取特定部分
```

### 产品构建信息

- **构建指纹**: `BLU/G90/G0310WW:10/QP1A.190711.020/1585383273:user/release-keys`
- **私有构建描述**: `full_k10-user 11 RP1A.200720.011 mp1k61v164bspP1 dev-keys`
- **GMS 客户端 ID**: `android-bestone`
- **平台版本**: 16.1.0

### 设备路径

设备树在 Android 源码树中的路径：
```
device/kindle/k10
```

注意：虽然设备代码名称为 `k62v1_64_bsp_S30_254_incell_1036_dianshang`，但在设备树路径中使用的是简化的 `kindle/k10`。

## 开发约定

### 代码风格

- 所有配置文件遵循 Android Makefile 规范
- 使用 4 空格缩进
- 文件头部包含版权声明（Apache-2.0）

### 配置规范

- **分区大小**: 使用字节数定义（如 `67108864` = 64MB）
- **A/B 分区**: 支持 A/B OTA 更新，使用 `slotselect` 标志
- **内核配置**: 使用预构建内核，位于 `prebuilt/kernel`
- **安全补丁**: 设置为 2099-12-31 以防止回滚保护
- **平台配置**: TARGET_BOARD_PLATFORM := mt6765
- **内核源码**: kernel/kindle/k10 (当不使用预构建内核时)
- **目标设备**: TARGET_DEVICE := k62v1_64_bsp_S30_254_incell_1036_dianshang

### 设备特定配置

- **屏幕密度**: 260
- **TWRP 主题**: portrait_mdpi（优化为较小分辨率以减小镜像大小）
- **输入设备黑名单**: hbtp_vm
- **支持的语言**: TW_EXTRA_LANGUAGES = false（禁用以减小镜像大小）
- **默认语言**: zh_CN（简体中文）
- **包含工具**: TW_USE_TOOLBOX = false（禁用以减小镜像大小）
- **包含重新打包工具**: TW_INCLUDE_REPACKTOOLS = false（禁用以减小镜像大小）
- **排除 SU**: TW_EXCLUDE_SUPERSU = true（排除以减小镜像大小）
- **排除 TWRP 应用**: TW_EXCLUDE_TWRPAPP = true（排除以减小镜像大小）
- **启动时屏幕熄灭**: TW_SCREEN_BLANK_ON_BOOT = true

### 常见修改场景

1. **修改分区大小**: 编辑 `BoardConfig.mk` 中的 `BOARD_*_PARTITION_SIZE`
2. **更新内核**: 替换 `prebuilt/kernel` 文件
3. **添加 TWRP 功能**: 修改 `BoardConfig.mk` 中的 `TW_*` 配置
4. **修复分区挂载**: 编辑 `recovery.fstab`
5. **启用多语言支持**: 将 `TW_EXTRA_LANGUAGES` 改为 `true`
6. **启用工具箱**: 将 `TW_USE_TOOLBOX` 改为 `true`
7. **启用重新打包工具**: 将 `TW_INCLUDE_REPACKTOOLS` 改为 `true`
8. **启用 OTA 功能**: 在 `device.mk` 中取消注释 OTA 相关包
9. **启用 APEX 预优化**: 将 `DEXPREOPT_GENERATE_APEX_IMAGE` 改为 `true`

## 注意事项

### 镜像大小优化

项目经过专门优化以减小 TWRP 镜像大小，包括：
- 禁用 APEX 镜像预优化（`DEXPREOPT_GENERATE_APEX_IMAGE := false`）
- 禁用多语言支持（`TW_EXTRA_LANGUAGES := false`，仅保留默认中文）
- 禁用工具箱（`TW_USE_TOOLBOX := false`）
- 禁用重新打包工具（`TW_INCLUDE_REPACKTOOLS := false`）
- 排除 SuperSU（`TW_EXCLUDE_SUPERSU := true`）
- 排除 TWRP 应用（`TW_EXCLUDE_TWRPAPP := true`）
- 使用较小的主题分辨率（`TW_THEME := portrait_mdpi`）

这些优化措施显著减小了最终 TWRP 镜像的体积，使其更适合设备限制。如果需要这些功能，可以修改 `BoardConfig.mk` 和 `device.mk` 中的相应配置。

### 硬编码值警告

`BoardConfig.mk` 中存在两个硬编码的分区大小值，标注为 TODO：
- `BOARD_SUPER_PARTITION_SIZE := 9126805504`
- `BOARD_K10_DYNAMIC_PARTITIONS_SIZE := 9122611200`

这些值可能需要根据实际设备进行调整。

### APEX 配置

项目禁用了 APEX 镜像预优化以减小镜像大小：
- `DEXPREOPT_GENERATE_APEX_IMAGE := false`

这是为了减小 TWRP 镜像体积而做出的优化。

### 安全和回滚保护

项目使用以下配置防止回滚保护问题：
- `PLATFORM_SECURITY_PATCH := 2099-12-31`
- `VENDOR_SECURITY_PATCH := 2099-12-31`

### 缺失依赖

配置中启用了 `ALLOW_MISSING_DEPENDENCIES := true`，这意味着某些依赖可能缺失，构建系统会忽略这些缺失的依赖。

### 文件系统支持

恢复环境支持以下文件系统：
- ext4（用于 system、vendor、product、userdata 等分区）
- f2fs（用于用户数据分区）
- vfat（用于 USB 设备）

### USB 和调试支持

恢复模式配置了 USB 功能和 ADB 调试支持：
- 使用 configfs 进行 USB 配置
- 支持自动 USB 设备检测（外部设备和 MT_USB 平台）
- 默认启动 adbd 以支持 ADB 调试

### OTA 功能

默认情况下，OTA 功能相关的工具包已在 `device.mk` 中注释掉，以减小镜像大小。如需启用 OTA 更新功能，请编辑 `device.mk` 文件，取消注释以下包：
- otapreopt_script
- cppreopts.sh
- update_engine
- update_verifier
- update_engine_sideload

取消注释后，TWRP 将支持完整的 OTA 更新功能，但会增加镜像体积。

## 依赖项

### 内部依赖

- 预构建内核: `prebuilt/kernel`
- TWRP 公共配置: `vendor/twrp/config/common.mk`
- extract-utils: `tools/extract-utils/extract_utils.sh`
- Boot Control HAL: android.hardware.boot@1.0-impl, android.hardware.boot@1.0-service, bootctrl.mt6765, libgptutils, libz, libcutils

### 注释掉的依赖（用于减小镜像大小）

以下 OTA 工具包已在 `device.mk` 中注释掉，以减小镜像大小。如需 OTA 功能，请取消注释：
- otapreopt_script
- cppreopts.sh
- update_engine
- update_verifier
- update_engine_sideload

### 外部依赖

- Android 构建系统
- TWRP 源码
- MediaTek 平台特定 HAL（如 bootctrl.mt6765）

## 故障排除

### 构建失败

1. 检查 `device/kindle/k10` 目录是否正确放置在 Android 源码树中
2. 确认预构建内核存在且有效（`prebuilt/kernel`）
3. 验证专有文件已正确提取（通过 `./extract-files.sh` 脚本）
4. 确认 TWRP 源码和必要的构建工具已正确安装

### 设备无法启动

1. 检查 `recovery.fstab` 中的分区映射是否正确
2. 验证 `BoardConfig.mk` 中的分区大小是否与设备匹配
3. 确认内核配置与设备硬件兼容

### A/B OTA 问题

1. 确认所有 A/B 分区都正确配置了 `slotselect` 标志
2. 验证 Boot Control HAL 正确包含在产品包中
3. 检查 `vbmeta_system` 和 `vbmeta_vendor` 分区配置

## 联系信息

- **版权**: Copyright (C) 2026 The Android Open Source Project, Copyright (C) 2017-2020 The LineageOS Project
- **许可证**: Apache-2.0
- **生成工具**: SebaUbuntu's TWRP device tree generator

---

**最后更新**: 2026年2月4日
**文档版本**: 3.0