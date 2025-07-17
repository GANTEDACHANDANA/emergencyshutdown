/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`module project (
    input  wire clk,
    input  wire [7:0] io_in,
    output wire [7:0] io_out
);

    esd_controller esd_inst (
        .clk(clk),
        .rst_n(io_in[0]),
        .estop_a_n(io_in[1]),
        .estop_b_n(io_in[2]),
        .ack_n(io_in[3]),
        .wdg_kick(io_in[4]),
        .shutdown_o(io_out[0]),
        .led_stat_o(io_out[1])
    );

    // Set unused outputs to 0
    assign io_out[7:2] = 6'b000000;

endmodule

