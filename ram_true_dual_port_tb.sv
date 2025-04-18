// Testbench for the true dual-port RAM module with two ports sharing a single clock.
module ram_true_dual_port_tb;
    // Testbench signals
    reg [7:0] data_a, data_b;    // 8-bit input data for ports A and B
    reg [5:0] addr_a, addr_b;    // 6-bit addresses for ports A and B
    reg we_a, we_b;              // Write enables for ports A and B
    reg clk;                     // Clock for both ports
    wire [7:0] q_a, q_b;         // 8-bit output data for ports A and B

    // Instantiate the RAM module (unit under test)
    ram_true_dual_port uut (
        .q_a(q_a),
        .q_b(q_b),
        .data_a(data_a),
        .data_b(data_b),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .we_a(we_a),
        .we_b(we_b),
        .clk(clk)
    );

    // Clock generation: 10 time units period (5 units high, 5 units low)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus process
    initial begin
        // Initialize inputs
        data_a = 8'b0;
        data_b = 8'b0;
        addr_a = 6'b0;
        addr_b = 6'b0;
        we_a = 1'b0;
        we_b = 1'b0;

        // Monitor inputs and outputs
        $monitor("Time=%0t clk=%b we_a=%b we_b=%b addr_a=%h data_a=%h addr_b=%h data_b=%h q_a=%h q_b=%h",
                 $time, clk, we_a, we_b, addr_a, data_a, addr_b, data_b, q_a, q_b);

        // Test sequence
        #10; // Wait for initial stabilization

        // Test 1: Write to address 0 using port A
        @(negedge clk);
        we_a = 1; addr_a = 6'h00; data_a = 8'hAA;
        @(negedge clk);
        we_a = 0;

        // Test 2: Read from address 0 using port B (expect 0xAA)
        @(negedge clk);
        addr_b = 6'h00;
        @(negedge clk); // Wait for q_b to update

        // Test 3: Write to address 63 using port B
        @(negedge clk);
        we_b = 1; addr_b = 6'h3F; data_b = 8'h55;
        @(negedge clk);
        we_b = 0;

        // Test 4: Read from address 63 using port A (expect 0x55)
        @(negedge clk);
        addr_a = 6'h3F;
        @(negedge clk); // Wait for q_a to update

        // Test 5: Write to multiple addresses using both ports
        @(negedge clk);
        we_a = 1; addr_a = 6'h01; data_a = 8'h11;
        we_b = 1; addr_b = 6'h02; data_b = 8'h22;
        @(negedge clk);
        we_a = 0; we_b = 0;

        // Test 6: Read from multiple addresses using both ports
        @(negedge clk);
        addr_a = 6'h01; // Port A reads from addr 1 (expect 0x11)
        addr_b = 6'h02; // Port B reads from addr 2 (expect 0x22)
        @(negedge clk); // Wait for q_a and q_b to update

        // Test 7: Simultaneous read and write (port A writes, port B reads)
        @(negedge clk);
        we_a = 1; addr_a = 6'h0A; data_a = 8'hFF; // Port A writes to addr 10
        addr_b = 6'h00;                           // Port B reads from addr 0 (expect 0xAA)
        @(negedge clk);
        we_a = 0;

        // Test 8: Read from address 10 using port B (expect 0xFF)
        @(negedge clk);
        addr_b = 6'h0A;
        @(negedge clk); // Wait for q_b to update

        // Test 9: Write-write conflict (both ports write to the same address)
        @(negedge clk);
        we_a = 1; addr_a = 6'h05; data_a = 8'h33; // Port A writes 0x33 to addr 5
        we_b = 1; addr_b = 6'h05; data_b = 8'h44; // Port B writes 0x44 to addr 5
        @(negedge clk);
        we_a = 0; we_b = 0;

        // Test 10: Read from address 5 using port A (expect 0x44 due to simulation scheduling)
        @(negedge clk);
        addr_a = 6'h05;
        @(negedge clk); // Wait for q_a to update

        // End simulation
        #20 $finish;
    end
endmodule
