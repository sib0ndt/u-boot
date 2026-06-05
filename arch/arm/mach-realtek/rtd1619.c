// SPDX-License-Identifier: GPL-2.0+

#include <cpu_func.h>
#include <init.h>
#include <asm/armv8/mmu.h>
#include <asm/global_data.h>
#include <linux/sizes.h>

DECLARE_GLOBAL_DATA_PTR;

static struct mm_region rtd1619_mem_map[] = {
	{
		.virt = 0x00000000UL,
		.phys = 0x00000000UL,
		.size = 0x80000000UL,
		.attrs = PTE_BLOCK_MEMTYPE(MT_NORMAL) | PTE_BLOCK_INNER_SHARE,
	}, {
		.virt = 0x80000000UL,
		.phys = 0x80000000UL,
		.size = 0x80000000UL,
		.attrs = PTE_BLOCK_MEMTYPE(MT_DEVICE_NGNRNE) |
			 PTE_BLOCK_NON_SHARE | PTE_BLOCK_PXN | PTE_BLOCK_UXN,
	}, {
		/* List terminator */
		0,
	}
};

struct mm_region *mem_map = rtd1619_mem_map;

int dram_init(void)
{
	gd->ram_base = 0x0002e000;
	gd->ram_size = 0x7ffd2000;
	return 0;
}

int dram_init_banksize(void)
{
	gd->bd->bi_dram[0].start = 0x0002e000;
	gd->bd->bi_dram[0].size = 0x7ffd2000;
	return 0;
}

int print_cpuinfo(void)
{
	return 0;
}

void reset_cpu(void)
{
}

void enable_caches(void)
{
	/* Chainloaded by vendor firmware; keep inherited cache state. */
}
