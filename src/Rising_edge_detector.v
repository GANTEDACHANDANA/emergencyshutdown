`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:53:54 07/15/2025 
// Design Name: 
// Module Name:    Rising_edge_detector 
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
module Rising_edge_detector(
	input  wire clk,
    input  wire sig_in,
    output wire rise_pulse
    );
	 reg d;

    always @(posedge clk) begin
        d <= sig_in;
    end
    assign rise_pulse = sig_in & ~d;
endmodule
