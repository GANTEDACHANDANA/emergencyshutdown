`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:17:10 07/15/2025 
// Design Name: 
// Module Name:    debounce 
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
module debounce(
		clk,
    rst_n,
    noisy_btn,
    clean_btn
 
    );
	  input  clk;
    input  rst_n;
    input  noisy_btn;
    output clean_btn;
    reg    clean_btn;
 parameter CNT_WIDTH = 20;
 reg [CNT_WIDTH-1:0] cnt;
    reg sync1, sync2;
 always @(posedge clk) begin
        sync1 <= noisy_btn;
        sync2 <= sync1;
    end
	 always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 0;
            clean_btn <= 0;
        end else if (sync2 == clean_btn) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
            if (cnt == {CNT_WIDTH{1'b1}}) begin
                clean_btn <= sync2;
                cnt       <= 0;
            end
        end
    end


endmodule
