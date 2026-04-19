CC = riscv32-unknown-elf-gcc
OBJCOPY = riscv32-unknown-elf-objcopy
OBJDUMP = riscv32-unknown-elf-objdump
VERILATOR = verilator

CFLAGS = -march=rv32i -mabi=ilp32 -nostdlib
LDFLAGS = -T src/link.ld

SOURCES = examples/program.s
BUILD = build

ELF = $(BUILD)/program.elf
BIN = $(BUILD)/program.bin
MEM = $(BUILD)/program.mem

HDLSRC = hdl/cpu.v
EMULATOR = $(BUILD)/Vcpu

.PHONY: all dump emulate clean

all: $(BIN) $(MEM) $(EMULATOR)

$(BUILD):
	mkdir -p build

$(ELF): $(SOURCES) | $(BUILD)
	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@

$(BIN): $(ELF) | $(BUILD)
	$(OBJCOPY) -O binary $< $@

$(MEM): $(ELF) | $(BUILD)
	$(OBJCOPY) -O verilog $< $@

dump: $(ELF)
	$(OBJDUMP) -d $<

$(EMULATOR): $(HDLSRC)
	$(VERILATOR) --binary $^ --top-module cpu --build -Mdir $(BUILD)

emulate: $(EMULATOR) $(MEM)
	$(EMULATOR) +mem=$(MEM)

clean:
	rm -rf $(BUILD)
