`timescale 1ns / 1ps
module ii(
    input [3:0] a,
    input [25:0] b,
    output [31:0] r
    );
    assign r = {a, b<<2};
endmodule