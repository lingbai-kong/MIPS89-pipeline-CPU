`timescale 1ns / 1ps
module memory(
    input clk,
    input ena,
    input wena,
    input [31:0] addr,
    input [31:0] wdata,
    output [31:0] rdata,
    output [31:0] answer
);
    wire [31:0] d59;
    wire [31:0] e59;
    reg [31:0] regfiles [0:511];
    assign rdata = regfiles[addr[7:0]];
    assign d59=regfiles[239];
    assign e59=regfiles[299];
    assign answer=regfiles[0];
    always@(posedge clk)
    begin
        if(ena&&wena)
        begin
            regfiles[addr[7:0]] <= wdata;
        end
    end
endmodule