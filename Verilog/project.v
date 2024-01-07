module ps2_interface(
    input wire clk,          // Main system clock
    input wire reset,        // System reset
    input wire ps2_clk,      // PS2 clock line
    input wire ps2_data,     // PS2 data line
    output reg [7:0] data,   // 8-bit data output
    output reg valid         // Data valid signal
);
    // State Encoding
    localparam IDLE = 1'b0;
    localparam RECEIVE = 1'b1;

    // Registers for FSM and data storage
    reg state;
    reg [3:0] bit_count;     // Counter for bits received
    reg [10:0] shift_reg;    // Shift register for incoming data

    // Edge detection for PS2 clock
    reg ps2_clk_prev;
    always @(posedge clk) begin
        if (reset) begin
            ps2_clk_prev <= 1'b1;
        end
        else begin
            ps2_clk_prev <= ps2_clk;
        end
    end

    // Negative edge detection of PS2 clock
    wire negedge_ps2_clk = ps2_clk_prev & ~ps2_clk;

    // FSM Implementation
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            shift_reg <= 11'd0;
            valid <= 1'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (negedge_ps2_clk && ps2_data == 0) begin  // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 4'd10;  // Total bits to receive (1 start, 8 data, 1 parity, 1 stop)
                        valid <= 1'b0;
                    end
                end
                RECEIVE: begin
                    if (negedge_ps2_clk) begin
                        bit_count <= bit_count - 1;
                        shift_reg <= {ps2_data, shift_reg[10:1]};  // Shift in the new bit
                        if (bit_count == 0) begin
                            data <= shift_reg[8:1];  // Capture the 8 data bits
                            valid <= 1'b1;  // Data is now valid
                            state <= IDLE;  // Go back to idle state
                        end
                    end
                end
            endcase
        end
    end
endmodule
