## copyright by xiao_laba_cn@yahoo.com, year 2025
##

ARCH = hc908
FORMAT = S19

# Source directory
SRC_DIR = src

# Intermediate files directory (object files and other build artifacts)
OUT_DIR = obj

# Firmware output directory (final .S19 file)
FIRM_DIR = firmware

# Source files (all .c files in src/)
SRCS = $(wildcard $(SRC_DIR)/*.c)

# Object files in output/
OBJS = $(SRCS:$(SRC_DIR)/%.c=$(OUT_DIR)/%.rel)

# Dependencies (headers in src/, plus Makefile)
DEPS = $(wildcard $(SRC_DIR)/*.h) Makefile

TARGET = $(FIRM_DIR)/$(ARCH)rtos_Win11_make.$(FORMAT)

CC = sdcc

## *.h in ./src, tell SDCC to search ./src for header files
INCS = -I$(SRC_DIR)

#### mc68hc908gp32 settings
CFLAGS  = -mhc08 --data-loc 0x40 --stack-loc 0x1BF --code-loc 0xEE00 $(INCS)
LDFLAGS = -mhc08 --data-loc 0x40 --stack-loc 0x1BF --code-loc 0xEE00

## Alternative for HC908QT4 (uncomment if needed)
##CFLAGS  = -mhc08 --data-loc 0x40 --stack-loc 0xFF --code-loc 0xE800 $(INCS)
##LDFLAGS = -mhc08 --data-loc 0x40 --stack-loc 0xFF --code-loc 0xE800

# Tell make where to find source files
VPATH = $(SRC_DIR)

# Compile rule: %.rel depends on corresponding .c (found via VPATH)
$(OUT_DIR)/%.rel: %.c $(DEPS)
	$(CC) $(CFLAGS) -c $< -o $@

# Default target
all: $(TARGET)

# Link to create the final .S19 file
$(TARGET): $(OBJS) | $(FIRM_DIR)
	$(CC) $(LDFLAGS) -o $@ $^

# Create directories if they don't exist
$(OUT_DIR) $(FIRM_DIR):
	mkdir -p $@

# Ensure directories exist before building objects/target
$(OBJS): | $(OUT_DIR)
$(TARGET): | $(FIRM_DIR)

# Install/flash target
install: $(TARGET)
	hc908sh /dev/ttyS0 -start -erase -upload $(TARGET) -end

# Clean build artifacts
clean:
	rm -rf $(OUT_DIR) $(FIRM_DIR)/*.S19
	rm -f *.asm *.lnk *.lst *.map *.mem *.rst *.sym *.cdb *.lk