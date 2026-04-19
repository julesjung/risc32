CC = riscv32-unknown-elf-gcc
OBJCOPY = riscv32-unknown-elf-objcopy
OBJDUMP = riscv32-unknown-elf-objdump
VERILATOR = verilator

CFLAGS = -march=rv32i -mabi=ilp32 -nostdlib
LDFLAGS = -T src/link.ld

SRC = examples/program.s
BUILD = build

ELF = $(BUILD)/program.elf
BIN = $(BUILD)/program.bin
MEM = $(BUILD)/program.mem

HDLSRC = \
	sim/top.v \
	hdl/cpu.v \
	hdl/regfile.v \
	hdl/control.v
SIMSRC = sim/main.cpp
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

$(SIM): $(HDLSRC)
	$(VERILATOR) --cc --exe --top-module top --build -Mdir $(BUILD) $(HDLSRC) $(SIMSRC)

sim: $(SIM) $(MEM)
	$(SIM) +mem=$(MEM)

clean:
	rm -rf $(BUILD)
