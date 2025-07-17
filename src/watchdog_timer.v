`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:57:03 07/15/2025 
// Design Name: 
// Module Name:    watchdog_timer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module watchdog_timer(
	 clk,
    rst_n,
    kick,
    timeout
    );
	 input  clk;      // system clock
    input  rst_n;    // active‑low async reset
    input  kick;     // rising edge restarts the timer
    output timeout;  // asserted when timer expires
    reg    timeout;
	 parameter CLK_HZ     = 24000000;  // override when you instantiate
    parameter TIMEOUT_MS = 500;       // timeout in milliseconds
	  function integer C_LOG2;
        input integer val;
        integer i;
        begin
            val = val - 1;
            for (i = 0; val > 0; i = i + 1)
                val = val >> 1;
            C_LOG2 = i;
        end
    endfunction
	 localparam integer CNT_MAX   = ((CLK_HZ / 1000) * TIMEOUT_MS > 0) ?
                                   (CLK_HZ / 1000) * TIMEOUT_MS : 1;
    localparam integer CNT_WIDTH = C_LOG2(CNT_MAX) + 1;
	 reg  [CNT_WIDTH-1:0] cnt;
    reg  kick_ff1, kick_ff2;
    wire kick_rise;
	 always @(posedge clk) begin
        kick_ff1 <= kick;
        kick_ff2 <= kick_ff1;
    end
    assign kick_rise = kick_ff1 & ~kick_ff2;
	 always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            timeout <= 1'b0;
        end else begin
            if (kick_rise) begin
                cnt     <= 0;
                timeout <= 1'b0;
					 end else if (cnt >= CNT_MAX) begin
                timeout <= 1'b1;      // stay high until next kick or reset
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end


endmodule
