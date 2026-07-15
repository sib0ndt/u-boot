/* SPDX-License-Identifier: GPL-2.0+ */
#ifndef __RTD1619_H
#define __RTD1619_H

#define CFG_SYS_SDRAM_BASE		0x0002e000
#define CFG_SYS_INIT_SP_ADDR		0x07f00000
#define CFG_SYS_BOOTM_LEN		0x04000000

/* Extlinux/Distro boot support - USB and MMC (eMMC & SD) */
#define BOOT_TARGET_DEVICES(func) \
	func(USB, usb, 0) \
	func(MMC, mmc, 0) \
	func(MMC, mmc, 1)

#include <config_distro_bootcmd.h>

#define CFG_EXTRA_ENV_SETTINGS \
	"kernel_addr_r=0x08000000\0" \
	"fdt_addr_r=0x0a000000\0" \
	"scriptaddr=0x09000000\0" \
	"ramdisk_addr_r=0x0b000000\0" \
	"fdtfile=realtek/rtd1619-x1-prime-c.dtb\0" \
	BOOTENV

#endif
