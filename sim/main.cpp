#include <verilated.h>
#include "Vtop.h"

int main(int argc, char** argv) {
    VerilatedContext* const contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);

    Vtop* const top = new Vtop{contextp};

    while (!contextp->gotFinish()) {
        top->clk = 0;
        top->eval();
        top->clk = 1;
        top->eval();
    }

    contextp->statsPrintSummary();
    top->final();

    delete top;

    return 0;
}
