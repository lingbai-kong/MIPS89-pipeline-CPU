`timescale 1ns / 1ps
module top(
    input clock_100MHZ,
    input reset,
    input [7:0] sel,
    output [7:0] o_seg,
    output [7:0] o_sel
    );
    wire clk_1;
    wire clk_2;
    wire cpu_clk;
    wire clk_wiz_lock;
    wire [31:0] inst;
    wire [31:0] pc;
    wire [31:0] ans;
    wire [31:0] r6;
    reg [31:0] show;
    wire [31:0] count;
    wire [31:0] compare;
    //clk_wiz_cpu wiz(.reset(~reset),.clk_in1(clock_100MHZ),.clk_out1(cpu_clk),.locked(clk_wiz_lock));
    time_divider#(10) Divider (.I_CLK(clock_100MHZ),.rst(~reset),.O_CLK(clk_1));
    time_divider#(5000000) Divider_slow (.I_CLK(clock_100MHZ),.rst(~reset),.O_CLK(clk_2));
    assign cpu_clk=sel[0]? clk_2:clk_1;
    sccomp_dataflow cpu (.clk_in(cpu_clk),.reset(~reset),.inst(inst),.pc(pc),.answer(ans),.count(count),.compare(compare)); 
    seg7x16 seg7 (.clk(clock_100MHZ),.reset(~reset),.cs(1'b1),.i_data(show),.o_seg(o_seg),.o_sel(o_sel));
    always@(*)
    begin
        case(sel[7:1])
        7'b000_0000:show<=ans;
        7'b000_0001:show<=pc;
        7'b000_0010:show<=inst;
        7'b000_0100:show<=count;
        7'b000_1000:show<=compare;
        endcase
    end
endmodule
