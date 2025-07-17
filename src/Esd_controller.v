`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:48:55 07/15/2025 
// Design Name: 
// Module Name:    Esd_controller 
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
module Esd_controller(
 input  clk,             // System clock
    input  rst_n,           // Asynchronous, active-low reset
    input  estop_a_n,       // E-STOP A (active-low)
    input  estop_b_n,       // E-STOP B (active-low)
    input  ack_n,           // ACK / Reset button (active-low)
    input  wdg_kick,        // Watchdog kick input
    output shutdown_o,      // Shutdown output
    output led_stat_o       // Status LED
);
parameter CLK_HZ = 24000000;
  wire estop_a, estop_b, ack_btn;
   debounce_button #(.CNT_WIDTH(20)) db_a (
        .clk(clk),
        .rst_n(rst_n),
        .noisy_btn(estop_a_n),
        .clean_btn(estop_a)
    );
debounce_button #(.CNT_WIDTH(20)) db_b (
        .clk(clk),
        .rst_n(rst_n),
        .noisy_btn(estop_b_n),
        .clean_btn(estop_b)
    );
 debounce_button #(.CNT_WIDTH(20)) db_ack (
        .clk(clk),
        .rst_n(rst_n),
        .noisy_btn(ack_n),
        .clean_btn(ack_btn)
    );
 wire estop_any = ~estop_a | ~estop_b;
  wire ack_pulse;
    Rising_edge_detector ed_ack (
        .clk(clk),
        .sig_in(~ack_btn),       // detect rising edge (btn released)
        .rise_pulse(ack_pulse)
    );
	  wire wdg_timeout;
    watchdogtimer #(
        .CLK_HZ(CLK_HZ),
        .TIMEOUT_MS(500)
    ) wdg_inst (
        .clk(clk),
        .rst_n(rst_n),
        .kick(wdg_kick),
        .timeout(wdg_timeout)
    );
	  wire shutdown, latched_fault;
    shutdown_FSM fsm_inst (
        .clk(clk),
        .rst_n(rst_n),
        .estop(estop_any),
        .ack_pulse(ack_pulse),
        .wdg_to(wdg_timeout),
        .shutdown(shutdown),
        .latched_fault(latched_fault)
    );
assign shutdown_o = shutdown;

    // Status LED blinker (active only if no fault)
    wire blink_led;
    slow_blinker #(.CLK_HZ(CLK_HZ)) blink_inst (
        .clk(clk),
        .rst_n(~latched_fault),  // LED blinks only when no fault
        .led(blink_led)
    );

    assign led_stat_o = latched_fault ? 1'b1 : blink_led;
 
endmodule
