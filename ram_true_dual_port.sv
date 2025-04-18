// A true dual-port RAM with synchronous read and write operations on two ports.
// The RAM has a 64x8 configuration (64 locations, 8-bit data width) and uses a single clock
// for both ports, enabling simultaneous read/write access on ports A and B.
module ram_true_dual_port (
    output reg [7:0] q_a, q_b,    // 8-bit output data for ports A and B (read data)
    input [7:0] data_a, data_b,   // 8-bit input data for ports A and B (write data)
    input [5:0] addr_a, addr_b,   // 6-bit addresses for ports A and B (0 to 63)
    input we_a, we_b,             // Write enables for ports A and B (active high)
    input clk                     // Clock for both ports
);
    // Internal RAM storage: 64 locations, each 8 bits wide
    reg [7:0] ram [0:63];
    // Port A: Synchronous read/write process
    always @(posedge clk) begin
        if (we_a)
            ram[addr_a] <= data_a;  // Write data to RAM if we_a is high
        q_a <= ram[addr_a];         // Always output the data at addr_a
    end
    // Port B: Synchronous read/write process
    always @(posedge clk) begin
        if (we_b)
            ram[addr_b] <= data_b;  // Write data to RAM if we_b is high
        q_b <= ram[addr_b];         // Always output the data at addr_b
    end
endmodule
