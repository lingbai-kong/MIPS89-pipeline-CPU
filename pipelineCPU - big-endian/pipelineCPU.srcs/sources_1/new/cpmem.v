`timescale 1ns / 1ps
`define ENDIAN 0//0 for little-endian 1 for big-endian
//2021.4.4修复了大端小端的错误
//2021.5.13重新恢复了大端模式
module cpmem(
    input [3:0] data_type,
    input [31:0] exact_addr,
    output [31:0] appr_addr,
    output reg [31:0] rdata32,
    output reg [15:0] rdata16,
    output reg [7:0] rdata8,
    input [31:0] rdata,
    input [31:0] wdata32,
    input [15:0] wdata16,
    input [7:0] wdata8,
    output reg [31:0] wdata
);
    wire [1:0] offset;
    assign offset = exact_addr[1:0];
    assign appr_addr = exact_addr & 32'hfffffffc;
    parameter Wdata=4'd0,Hdata=4'd1,Bdata=4'd2,Ldata=4'd3,Rdata=4'd4;
    always@(*)
    begin
        case(data_type)
`ifdef ENDIAN
        //big-endian
        Wdata:begin
            rdata32<=rdata;
            wdata<=wdata32;
        end
        Hdata:begin
            case(offset)
            2'b00:begin
                rdata16<=rdata[31:16];
                wdata<={wdata16,rdata[15:0]};
            end
            2'b10:begin
                rdata16<=rdata[15:0];
                wdata<={rdata[31:16],wdata16};
            end
            endcase
        end
        Bdata:begin
            case(offset)
            2'b00:begin
                rdata8<=rdata[31:24];
                wdata<={wdata8,rdata[23:0]};
            end
            2'b01:begin
                rdata8<=rdata[23:16];
                wdata<={rdata[31:24],wdata8,rdata[15:0]};
            end
            2'b10:begin
                rdata8<=rdata[15:8];
                wdata<={rdata[31:16],wdata8,rdata[7:0]};
            end
            2'b11:begin
                rdata8<=rdata[7:0];
                wdata<={rdata[31:8],wdata8};
            end
            endcase
        end
        Ldata:begin
            case(offset)
            2'b00:begin
                rdata32<=rdata;
                wdata<=wdata32;
            end
            2'b01:begin
                rdata32<={rdata[23:0],wdata32[7:0]};
                wdata<={rdata[31:24],wdata32[31:8]};
            end
            2'b10:begin
                rdata32<={rdata[15:0],wdata32[15:0]};
                wdata<={rdata[31:16],wdata32[31:16]};
            end
            2'b11:begin
                rdata32<={rdata[7:0],wdata32[23:0]};
                wdata<={rdata[31:8],wdata32[31:24]};
            end
            endcase
        end
        Rdata:begin
            case(offset)
            2'b00:begin
                rdata32<={wdata32[31:8],rdata[31:24]};
                wdata<={wdata32[7:0],rdata[23:0]};
            end
            2'b01:begin
                rdata32<={wdata32[31:16],rdata[31:16]};
                wdata<={wdata32[15:0],rdata[15:0]};
            end
            2'b10:begin
                rdata32<={wdata32[31:24],rdata[31:8]};
                wdata<={wdata32[23:0],rdata[7:0]};
            end
            2'b11:begin
                rdata32<=rdata;
                wdata<=wdata32;
            end
            endcase
        end
`else
        //little-endian
        Wdata:begin
            rdata32<={rdata[7:0],rdata[15:8],rdata[23:16],rdata[31:24]};
            wdata<={wdata32[7:0],wdata32[15:8],wdata32[23:16],wdata32[31:24]};
        end
        Hdata:begin
            case(offset)
            2'b00:begin
                rdata16<={rdata[23:16],rdata[31:24]};
                wdata<={wdata16[7:0],wdata16[15:8],rdata[15:0]};
            end
            2'b10:begin
                rdata16<={rdata[7:0],rdata[15:8]};
                wdata<={rdata[31:16],wdata16[7:0],wdata16[15:8]};
            end
            endcase
        end
        Bdata:begin
            case(offset)
            2'b00:begin
                rdata8<=rdata[31:24];
                wdata<={wdata8,rdata[23:0]};
            end
            2'b01:begin
                rdata8<=rdata[23:16];
                wdata<={rdata[31:24],wdata8,rdata[15:0]};
            end
            2'b10:begin
                rdata8<=rdata[15:8];
                wdata<={rdata[31:16],wdata8,rdata[7:0]};
            end
            2'b11:begin
                rdata8<=rdata[7:0];
                wdata<={rdata[31:8],wdata8};
            end
            endcase
        end
        Ldata:begin
            case(offset)
            2'b00:begin
                rdata32<={rdata[31:24],wdata32[23:0]};
                wdata<={wdata32[31:24],rdata[23:0]};
            end
            2'b01:begin
                rdata32<={rdata[23:16],rdata[31:24],wdata32[15:0]};
                wdata<={wdata32[23:16],wdata32[31:24],rdata[15:0]};
            end
            2'b10:begin
                rdata32<={rdata[15:8],rdata[23:16],rdata[31:24],wdata32[7:0]};
                wdata<={wdata32[15:8],wdata32[23:16],wdata32[31:24],rdata[7:0]};
            end
            2'b11:begin
                rdata32<={rdata[7:0],rdata[15:8],rdata[23:16],rdata[31:24]};
                wdata<={wdata32[7:0],wdata32[15:8],wdata32[23:16],wdata32[31:24]};
            end
            endcase
        end
        Rdata:begin
            case(offset)
            2'b00:begin
                rdata32<={rdata[7:0],rdata[15:8],rdata[23:16],rdata[31:24]};
                wdata<={wdata32[7:0],wdata32[15:8],wdata32[23:16],wdata32[31:24]};
            end
            2'b01:begin
                rdata32<={wdata32[31:24],rdata[7:0],rdata[15:8],rdata[23:16]};
                wdata<={rdata[31:24],wdata32[7:0],wdata32[15:8],wdata32[23:16]};
            end
            2'b10:begin
                rdata32<={wdata32[31:16],rdata[7:0],rdata[15:8]};
                wdata<={rdata[31:16],wdata32[7:0],wdata32[15:8]};
            end
            2'b11:begin
                rdata32<={wdata32[31:8],rdata[7:0]};
                wdata<={rdata[31:8],wdata32[7:0]};
            end
            endcase
        end
`endif
        endcase
    end
endmodule