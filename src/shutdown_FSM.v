`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:30:24 07/15/2025 
// Design Name: 
// Module Name:    shutdown_FSM 
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
module shutdown_FSM(
    input  wire clk,
    input  wire rst_n,
    input  wire estop,          // active‑high (after debouncing)
    input  wire ack_pulse,      // 1‑cycle pulse from ACK button
    input  wire wdg_to,         // watchdog timeout
    output reg  shutdown,       // HIGH = machine should be stopped
    output reg  latched_fault 
    );
	  localparam [1:0] S_RUN        = 2'b00,
                     S_SHUTDOWN   = 2'b01,
                     S_WAIT_ACK   = 2'b10;

    reg [1:0] state, nxt;
	  always @(posedge clk or negedge rst_n)
        if (!rst_n)
            state <= S_SHUTDOWN;   // Safe startup state
        else
            state <= nxt;
				  always @(*) begin
        nxt = state;
        case (state)
            S_RUN:      if (estop | wdg_to) nxt = S_SHUTDOWN;
            S_SHUTDOWN: if (~estop && ack_pulse) nxt = S_WAIT_ACK;
            S_WAIT_ACK: if (~latched_fault) nxt = S_RUN;
        endcase
    end
	 always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shutdown      <= 1'b1;
            latched_fault <= 1'b1;
        end else begin
            case (nxt)
                S_RUN: begin
                    shutdown      <= 1'b0;
                    latched_fault <= 1'b0;
                end
					  S_SHUTDOWN: begin
                    shutdown      <= 1'b1;
                    latched_fault <= 1'b1;
                end
                S_WAIT_ACK: begin
                    shutdown      <= 1'b1;
                    // latched_fault remains until estop is released
                end
            endcase
        end
    end
endmodule
