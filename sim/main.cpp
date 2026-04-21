#include <cstdio>
#include <iostream>
#include <sstream>
#include <verilated.h>
#include "Vtop.h"

void tick(Vtop* top) {
    top->clk = 0;
    top->eval();
    top->clk = 1;
    top->eval();
}

void step_instruction(Vtop* top) {
    do {
        tick(top);
    } while (top->state != 0);
}

int main(int argc, char** argv) {
    VerilatedContext* const contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);

    Vtop* const top = new Vtop{contextp};

    std::string line;

    while (true) {
        printf("%08x> ", top->pc);

        if (!std::getline(std::cin, line)) break;

        std::stringstream ss(line);

        std::string cmd = "s";
        ss >> cmd;

        if (cmd == "step" || cmd == "s") {
            int n = 1;
            ss >> n;

            for (int i = 0; i < n; i++) step_instruction(top);

        } else if (cmd == "run" || cmd == "R") {
            do {
                tick(top);
            } while (!contextp->gotFinish());

        } else if (cmd == "regs" || cmd == "r") {
            for (int i = 0; i < 32; i++)
                printf("x%02d=%08x\n", i, top->regs[i]);

        } else if (cmd == "instruction" || cmd == "ir" || cmd == "i" ) {
            printf("IR=%08x\n", top->instruction);

        } else if (cmd == "clear") {
            printf("\033[2J");
            printf("\033[H");

        } else if (cmd == "quit" || cmd == "q") {
            break;
        }
    }

    contextp->statsPrintSummary();
    top->final();

    delete top;

    return 0;
}
