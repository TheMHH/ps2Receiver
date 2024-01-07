`timescale 1ns / 1ps
`include "project.v"
module tb_ps2_interface_0xAA;

    // Inputs
    reg clk;
    reg reset;
    reg ps2_clk;
    reg ps2_data;

    // Outputs
    wire [7:0] data;
    wire valid;

    reg parity;

    // Instantiate the Unit Under Test (UUT)
    ps2_interface uut (
        .clk(clk),
        .reset(reset),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .data(data),
        .valid(valid)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Generate a clock with period 20ns
    end

    initial begin
        ps2_clk = 0;
        forever #20 ps2_clk = ~ps2_clk; // Generate a clock with period 20ns
    end


    initial begin
        $dumpfile("project_tb.vcd");
        $dumpvars(0, tb_ps2_interface_0xAA);
        // Initialize Inputs
        reset = 1;
        ps2_clk = 1;
        ps2_data = 1;

        #100;
        reset = 0; // Release reset

        // Send 0xAA
        send_ps2_packet(8'h45);
        #100;
        send_ps2_packet(8'h35);
        #100;
        send_ps2_packet(8'h55);
        #100;
        send_ps2_packet(8'haa);
        #100;
        send_ps2_packet(8'hff);
        #1000;
        $finish;
    end

    // Task to send a PS2 packet
    task send_ps2_packet;
        input [7:0] byte;
        begin
            // Calculate parity (example for even parity)
            parity = ~^byte; // XOR all bits and invert for even parity
            send_bit(0); // Start bit is always 0
            send_byte(byte); // Send the byte
            send_bit(parity); // Send parity bit
            send_bit(1); // Stop bit is always 1
        end
    endtask

    // Task to send a byte bit-by-bit
    task send_byte;
        input [7:0] byte;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                send_bit(byte[i]);
            end
        end
    endtask

    // Task to send a bit on the PS2 data line
    task send_bit;
        input bit_value;
        begin
            ps2_clk = 0; // Clock goes low
            ps2_data = bit_value; // Set data bit
            #20; ps2_clk = 1; // Clock goes high again, bit is sampled on the rising edge
            #20; // Hold bit for a short time
        end
    endtask

endmodule
