ASM=nasm

SRC_DIR=src
BUILD_DIR=build

.PHONY: all floppy_image bootloader kernel clean always

#
# Floppy image
#
floppy_image: $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/main_floppy.img: bootloader kernel
	# First generate 1440k of memory
	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880
	# Create file system
	mkfs.fat -F 12 -n "MyOS" $(BUILD_DIR)/main_floppy.img
	# Next put bootloader in first sector of the disk
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main_floppy.img conv=notrunc
	# Copy files to image
	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/kernel.bin "::kernel.bin"

#
# Bootloader
#
bootloader: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: always
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin

#
# Kernel
#
kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin

#
# Always
#
always:
	mkdir -p $(BUILD_DIR)

#
# Clean
#
clean:
	rm -rf $(BUILD_DIR)/*
	rmdir $(BUILD_DIR)
