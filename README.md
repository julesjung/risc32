# RISC32

A minimal RV32I implementation written in Verilog, featuring a Verilator-based simulator.

## Installation

1. Get the official [RISC-V GNU Compiler Toolchain](https://github.com/riscv/riscv-gnu-toolchain). Use `--with-arch=rv32i --with-abi=ilp32` when running `./configure` to target RV32I.
2. Install [Verilator](https://www.veripool.org/verilator).
3. Build the project with: 

```sh
make
```

And run the simulator:

```sh
make sim
```

## Development

- You can use [Bear](https://github.com/rizsotto/Bear) to generate a `compile_commands.json` database:

```sh
bear -- make
```

- This enables better support with tools like [clangd](https://github.com/clangd/clangd) and [asm-lsp](https://github.com/bergercookie/asm-lsp).
- For Verilog, consider [slang-server](https://github.com/hudson-trading/slang-server).
