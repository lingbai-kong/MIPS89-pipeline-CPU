`timescale 1ns / 1ps
module sccomp_dataflow(
    input clk_in,
    input reset,
    output [31:0] inst,
    output [31:0] pc,
    output [31:0] answer,
    output [31:0] count,
    output [31:0] compare
);
    wire IM_ena;
    wire IM_w;
    wire DM_ena;
    wire DM_w;
    wire [31:0] addr;
    wire [31:0] rdata;
    wire [31:0] wdata;
    wire [31:0] IM_wdata;
    wire [5:0] int_i;
    wire timer_int;
    cpu sccpu(
        .clk(clk_in),
        .rst(reset),
        .stall(1'b0),
        .IM_ena(IM_ena),
        .IM_w(IM_w),
        .pc(pc),
        .inst(inst),
        .DM_ena(DM_ena),
        .DM_w(DM_w),
        .addr(addr),
        .rdata(rdata),
        .wdata(wdata),
        .int_i(int_i),
        .timer_int(timer_int),
        .count(count),
        .compare(compare)
    );
    //memory IMEM (clk_in,IM_ena,IM_w,(pc-32'h00400000)/4,IM_wdata,inst);
    imem IMEM(pc[13:2],inst);
    memory DMEM (clk_in,DM_ena,DM_w,(addr-32'h10010000)/4,wdata,rdata,answer);
    //DMEM DMEM(addr[12:2],wdata,clk_in,DM_w,rdata);
    assign IM_wdata = 32'b0;
    assign int_i={5'b0,timer_int};
endmodule