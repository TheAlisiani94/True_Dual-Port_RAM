# True Dual-Port RAM in Verilog

This project implements a true dual-port RAM in Verilog with a 64x8 configuration (64 locations, 8-bit data width). The RAM supports synchronous read and write operations on two independent ports (A and B) using a single clock, allowing simultaneous access to the same memory array. A testbench is included to verify the RAM’s functionality across various scenarios, including simultaneous read/write operations and write-write conflicts.

## Project Overview

The true dual-port RAM enables two independent ports (A and B) to read from or write to any address in the 64x8 memory array. Both ports operate synchronously on the same clock (`clk`), supporting simultaneous read and write operations. The design is suitable for FPGA or ASIC block RAMs, particularly in applications requiring concurrent memory access, such as data buffers, shared memory systems, or dual-core processors.

### Files in the Project

- **`ram_true_dual_port.sv`**: The main Verilog module implementing the true dual-port RAM. It defines a 64x8 memory array and uses separate clocked processes for synchronous read/write operations on ports A and B.

- **`ram_true_dual_port_tb.sv`**: The testbench for the RAM module. It tests read and write operations on both ports, simultaneous access scenarios, edge cases, and write-write conflicts.

- **`README.md`**: This file, providing documentation and instructions for the project.
