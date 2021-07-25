`timescale 1ns/1ps//291,355
module cp0(
    input clk,
    input rst,
    input delay,
    input mfc0,
    input mtc0,
    input [31:0] pc,//此处输入的是pc而不是pc4，每一次eret时用指令手动处理epc使其加4
    input [4:0] Rd,
    input [31:0] wdata,
    input [5:0] int_i,
    input exception,
    input eret,
    input [4:0] cause,
    //input intr,
    output [31:0] rdata,
    output [31:0] status,
    output [31:0] count,
    output [31:0] compare,
    output reg [31:0] exc_addr,
    output reg timer_int_o
);
    parameter EXC_Int=5'd0,EXC_Sys=5'd8,EXC_Bp=5'd9,EXC_RI=5'd10,EXC_Ov=5'd12,EXC_Tr=5'd13;
    parameter reg_Count=5'd9,reg_Compare=5'd11,reg_Status=5'd12,reg_Cause=5'd13,reg_EPC=5'd14,reg_PRid=5'd15,reg_Config=5'd16;
    parameter IE=5'd0,EXL=5'd1,IM2=5'd10;
    reg [31:0] regfiles [0:31];
    assign rdata = mfc0? regfiles[Rd]:32'hxxxxxxxx;
    assign status = regfiles[reg_Status];
    assign count=regfiles[reg_Count];
    assign compare=regfiles[reg_Compare];
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            timer_int_o<=0;
        else
        begin
//            if(mtc0&&Rd==reg_Compare)
//                timer_int_o<=0;
//            else if(regfiles[reg_Compare]!=32'h0&&regfiles[reg_Count]==regfiles[reg_Compare])
//                timer_int_o<=1;
            if(regfiles[reg_Compare]!=32'h0&&regfiles[reg_Count]==regfiles[reg_Compare])
                timer_int_o<=1;
            else
                timer_int_o<=0;
        end
    end
    always@(*)
    begin
        if(rst)
        begin
            exc_addr<=32'h0;
        end
        else
        begin
            if(exception&&!mtc0)
            begin
                if(eret)
                begin
                    exc_addr<=regfiles[reg_EPC];
                end
                else 
                begin
                    case(cause)
                        EXC_Int:
                        begin
                            if(regfiles[reg_Status][IE]&~regfiles[reg_Status][EXL]&regfiles[reg_Status][IM2])
                                exc_addr<=32'h00400004;
                            else
                                exc_addr<=pc;
                        end
                        EXC_Sys:
                        begin
                            if(regfiles[reg_Status][IE])
                                exc_addr<=32'h00400004;
                            else
                                exc_addr<=pc+32'd4;
                        end
                        EXC_Bp:
                        begin
                            if(regfiles[reg_Status][IE])
                                exc_addr<=32'h00400004;
                            else
                                exc_addr<=pc+32'd4;
                        end
                        EXC_Tr:
                        begin
                            if(regfiles[reg_Status][IE])
                                exc_addr<=32'h00400004;
                            else
                                exc_addr<=pc+32'd4;
                        end               
                    endcase
                end
            end
        end
    end
    always@(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            regfiles[reg_Count]<=32'h0;
            regfiles[reg_Compare]<=32'h0;
            regfiles[reg_Status]<=32'b0001_0000_0000_0000_1111_1111_0000_0001;//32'h00000701;
            regfiles[reg_Cause]<=32'h0;
            regfiles[reg_EPC]<=32'h0;
            regfiles[reg_PRid]<=32'h01852146;//Read only
            regfiles[reg_Config]<=32'b0000_0000_0000_0000_0000_0000_0000_0000;//Read only
        end
        else 
        begin
            regfiles[reg_Count]<=((delay&&(regfiles[reg_Compare]==(regfiles[reg_Count]+32'h1)))? regfiles[reg_Count]:regfiles[reg_Count]+32'h1);
            regfiles[reg_Cause][15:10]<=int_i;
            if(mtc0)
            begin
                if(Rd==reg_Cause)
                begin
                    regfiles[reg_Cause][9:8]<=wdata[9:8];
                    regfiles[reg_Cause][23:22]<=wdata[23:22];
                end
                else
                    regfiles[Rd]<=wdata;
            end  
            else if(exception)
            begin
                if(eret)
                begin
                    regfiles[reg_Status][EXL]<=0;
                end
                else if(regfiles[reg_Status][IE])
                begin
                    case(cause)
                        EXC_Int:
                        begin
                            if(~regfiles[reg_Status][EXL]&regfiles[reg_Status][IM2])
                            begin
                                regfiles[reg_EPC]<=pc;
                                regfiles[reg_Status][EXL]<=1;
                                regfiles[reg_Cause][6:2]<=EXC_Int;
                            end
                        end
                        EXC_Sys:
                        begin
                            if(~regfiles[reg_Status][EXL])
                            begin
                                regfiles[reg_EPC]<=pc;
                            end
                            regfiles[reg_Status][EXL]<=1;
                            regfiles[reg_Cause][6:2]<=EXC_Sys;
                        end
                        EXC_Bp:
                        begin
                            if(~regfiles[reg_Status][EXL])
                            begin
                                regfiles[reg_EPC]<=pc;
                            end
                            regfiles[reg_Status][EXL]<=1;
                            regfiles[reg_Cause][6:2]<=EXC_Bp;
                        end
                        EXC_Tr:
                        begin
                            if(~regfiles[reg_Status][EXL])
                            begin
                                regfiles[reg_EPC]<=pc;
                            end
                            regfiles[reg_Status][EXL]<=1;
                            regfiles[reg_Cause][6:2]<=EXC_Tr;
                        end
                    endcase
                end
            end
        end
    end
endmodule