`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:04:27 07/15/2025 
// Design Name: 
// Module Name:    slow_blinker 
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
module slow_blinker(
 clk,
    rst_n,
    led
    );
	 input  clk;
    input  rst_n;
    output led;
    reg    led;
	 parameter CLK_HZ = 24000000;
	 function integer C_LOG2;
        input integer value;
        integer i;
        begin
            value = value - 1;
            for (i = 0; value > 0; i = i + 1)
                value = value >> 1;
            C_LOG2 = i;
        end
    endfunction
	 localparam integer CNT_MAX   = (CLK_HZ / 2 > 0) ? CLK_HZ / 2 : 1;  // 0.5 s
    localparam integer CNT_WIDTH = C_LOG2(CNT_MAX) + 1;
	 reg [CNT_WIDTH-1:0] cnt; 
	 always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            led <= 1'b0;
        end else if (cnt >= CNT_MAX) begin
            cnt <= 0;
            led <= ~led;
        end else begin
		   cnt <= cnt + 1'b1;
        end
    end

endmodule
