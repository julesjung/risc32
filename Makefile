CC = riscv32-unknown-elf-gcc
OBJCOPY = riscv32-unknown-elf-objcopy
OBJDUMP = riscv32-unknown-elf-objdump
VL = verilator

CFLAGS = -march=rv32i -mabi=ilp32 -nostdlib
LDFLAGS = -T ld/link.ld
VLFLAGS = --cc --exe --top-module top --build

ASMSRC ?= asm/bitwise.s
HDLSRC = \
	sim/top.v \
	rtl/cpu.v \
	rtl/control.v \
	rtl/datapath.v \
	rtl/memory.v \
	rtl/regfile.v \
	rtl/alu.v
SIMSRC = sim/main.cpp

BUILD = build
ELF = $(BUILD)/program.elf
BIN = $(BUILD)/program.bin
MEM = $(BUILD)/program.mem
SIM = $(BUILD)/Vtop

.PHONY: all dump sim clean

all: $(BIN) $(MEM) $(SIM)

$(BUILD):
	mkdir -p build

$(ELF): $(ASMSRC) | $(BUILD)
	$(CC) $(CFLAGS) $(LDFLAGS) $(ASMSRC) -o $(ELF)

$(BIN): $(ELF) | $(BUILD)
	$(OBJCOPY) -O binary $(ELF) $(BIN)

$(MEM): $(ELF) | $(BUILD)
	$(OBJCOPY) -O verilog $(ELF) $(MEM)

dump: $(ELF)
	$(OBJDUMP) -d $(ELF)

$(SIM): $(HDLSRC) $(SIMSRC)
	$(VL) $(VLFLAGS) -Mdir $(BUILD) $(HDLSRC) $(SIMSRC)

sim: $(SIM) $(MEM)
	$(SIM) +mem=$(MEM)

clean:
	rm -rf $(BUILD)
