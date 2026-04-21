CC = riscv32-unknown-elf-gcc
OBJCOPY = riscv32-unknown-elf-objcopy
OBJDUMP = riscv32-unknown-elf-objdump
VL = verilator

CFLAGS = -march=rv32i -mabi=ilp32 -nostdlib
LDFLAGS = -T src/link.ld
VLFLAGS = --cc --exe --top-module top --build

SRC = examples/fibonacci.s
HDLSRC = \
	sim/top.v \
	hdl/cpu.v \
	hdl/control.v \
	hdl/datapath.v \
	hdl/memory.v \
	hdl/regfile.v \
	hdl/alu.v
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

$(ELF): $(SRC) | $(BUILD)
	$(CC) $(CFLAGS) $(LDFLAGS) $(SRC) -o $(ELF)

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
