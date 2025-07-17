`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:42:58 07/15/2025 
// Design Name: 
// Module Name:    signal_synchronizer 
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
module signal_synchronizer(
	  input clk,
    input async_in,
    output reg sync_out
);
  reg sync_ff1, sync_ff2;

    always @(posedge clk) begin
        sync_ff1 <= async_in;
        sync_ff2 <= sync_ff1;
    end

    always @(posedge clk) begin
        sync_out <= sync_ff2;
    end
endmodule
