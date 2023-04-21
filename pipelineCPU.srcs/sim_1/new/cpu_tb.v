`timescale 10ps / 1ps
module test;
    reg         clk;
    reg         reset;
    wire [31:0] inst;
    wire [31:0] pc;
    wire [31:0] answer;
    wire [31:0] count;
    wire [31:0] compare;
    
    reg         ok;
    integer    done;
    sccomp_dataflow uut (clk,reset,inst,pc,answer,count,compare);
  
    initial clk<=1;
    always #5 clk<=~clk;
    
    integer file_output;
    integer inst_count;
    reg [31:0] pc4;
    reg [31:0] pc3;
    reg [31:0] pc2;
    reg [31:0] pc1;
    reg [31:0] inst4;
    reg [31:0] inst3;
    reg [31:0] inst2;
    reg [31:0] inst1;
    initial
    begin
        //$readmemh("G:/document/semester6/ComputerSystemExperiment/PipelineCPU/test/68_t.hex.txt",test.uut.IMEM.regfiles);//输入文件路径
        $readmemh("G:/document/semester6/ComputerSystemExperiment/PipelineCPU/test/DMEM.txt",test.uut.DMEM.regfiles);
        file_output=$fopen("G:/document/semester6/ComputerSystemExperiment/PipelineCPU/result/result.out");//输出文件路径
        #1;
        reset<=1;
        #27;
        reset<=0;
        inst_count<=0;
        pc4<=0;
        pc3<=0;
        pc2<=0;
        pc1<=0;
        inst4<=0;
        inst3<=0;
        inst2<=0;
        inst1<=0;
        ok<=1;
        done<=5;
//        #1000;
//        $stop;
    end

    always@(posedge clk)
    begin
        if(ok&&inst4===32'bx)
            done<=done-1;
        if(done==0)
            $stop;
        if(inst_count<4)
        begin
            inst_count<=inst_count+1;
            pc1<=pc;
            pc2<=pc1;
            pc3<=pc2;
            pc4<=pc3;
            inst1<=inst;
            inst2<=inst1;
            inst3<=inst2;
            inst4<=inst3;
        end
        else if(ok)
        begin
            $fdisplay(file_output,"pc: %h",pc4);
            //$fdisplay(file_output,"pc: %h",pc4-32'h00400000);
            $fdisplay(file_output,"instr: %h",inst4);
//            $fdisplay(file_output,"cpr12-status: %h",test.uut.sccpu.CP0.regfiles[12]);
//            $fdisplay(file_output,"cpr13-cause: %h",test.uut.sccpu.CP0.regfiles[13]);
//            $fdisplay(file_output,"cpr14-epc: %h",test.uut.sccpu.CP0.regfiles[14]);
            $fdisplay(file_output,"regfile0: %h",test.uut.sccpu.ID.REGFILE.array_reg[0]);
            $fdisplay(file_output,"regfile1: %h",test.uut.sccpu.ID.REGFILE.array_reg[1]);
            $fdisplay(file_output,"regfile2: %h",test.uut.sccpu.ID.REGFILE.array_reg[2]);
            $fdisplay(file_output,"regfile3: %h",test.uut.sccpu.ID.REGFILE.array_reg[3]);
            $fdisplay(file_output,"regfile4: %h",test.uut.sccpu.ID.REGFILE.array_reg[4]);
            $fdisplay(file_output,"regfile5: %h",test.uut.sccpu.ID.REGFILE.array_reg[5]);
            $fdisplay(file_output,"regfile6: %h",test.uut.sccpu.ID.REGFILE.array_reg[6]);
            $fdisplay(file_output,"regfile7: %h",test.uut.sccpu.ID.REGFILE.array_reg[7]);
            $fdisplay(file_output,"regfile8: %h",test.uut.sccpu.ID.REGFILE.array_reg[8]);
            $fdisplay(file_output,"regfile9: %h",test.uut.sccpu.ID.REGFILE.array_reg[9]);
            $fdisplay(file_output,"regfile10: %h",test.uut.sccpu.ID.REGFILE.array_reg[10]);
            $fdisplay(file_output,"regfile11: %h",test.uut.sccpu.ID.REGFILE.array_reg[11]);
            $fdisplay(file_output,"regfile12: %h",test.uut.sccpu.ID.REGFILE.array_reg[12]);
            $fdisplay(file_output,"regfile13: %h",test.uut.sccpu.ID.REGFILE.array_reg[13]);
            $fdisplay(file_output,"regfile14: %h",test.uut.sccpu.ID.REGFILE.array_reg[14]);
            $fdisplay(file_output,"regfile15: %h",test.uut.sccpu.ID.REGFILE.array_reg[15]);
            $fdisplay(file_output,"regfile16: %h",test.uut.sccpu.ID.REGFILE.array_reg[16]);
            $fdisplay(file_output,"regfile17: %h",test.uut.sccpu.ID.REGFILE.array_reg[17]);
            $fdisplay(file_output,"regfile18: %h",test.uut.sccpu.ID.REGFILE.array_reg[18]);
            $fdisplay(file_output,"regfile19: %h",test.uut.sccpu.ID.REGFILE.array_reg[19]);
            $fdisplay(file_output,"regfile20: %h",test.uut.sccpu.ID.REGFILE.array_reg[20]);
            $fdisplay(file_output,"regfile21: %h",test.uut.sccpu.ID.REGFILE.array_reg[21]);
            $fdisplay(file_output,"regfile22: %h",test.uut.sccpu.ID.REGFILE.array_reg[22]);
            $fdisplay(file_output,"regfile23: %h",test.uut.sccpu.ID.REGFILE.array_reg[23]);
            $fdisplay(file_output,"regfile24: %h",test.uut.sccpu.ID.REGFILE.array_reg[24]);
            $fdisplay(file_output,"regfile25: %h",test.uut.sccpu.ID.REGFILE.array_reg[25]);
            $fdisplay(file_output,"regfile26: %h",test.uut.sccpu.ID.REGFILE.array_reg[26]);
            $fdisplay(file_output,"regfile27: %h",test.uut.sccpu.ID.REGFILE.array_reg[27]);
            $fdisplay(file_output,"regfile28: %h",test.uut.sccpu.ID.REGFILE.array_reg[28]);
            $fdisplay(file_output,"regfile29: %h",test.uut.sccpu.ID.REGFILE.array_reg[29]);
            $fdisplay(file_output,"regfile30: %h",test.uut.sccpu.ID.REGFILE.array_reg[30]);
            $fdisplay(file_output,"regfile31: %h",test.uut.sccpu.ID.REGFILE.array_reg[31]);
            pc1<=pc;
            pc2<=pc1;
            pc3<=pc2;
            pc4<=pc3;
            inst1<=inst;
            inst2<=inst1;
            inst3<=inst2;
            inst4<=inst3;
        end
    end
endmodule
module top_test;
    reg         clk;
    reg         reset;
    wire [7:0]  o_seg;
    wire [7:0]  o_sel;
    wire [31:0] debug;
    top prj(.clock_100MHZ(clk),.reset(reset),.sel(8'b0),.o_seg(o_seg),.o_sel(o_sel));
    initial clk<=0;
    always #1 clk<=~clk;
    initial
    begin
        reset<=1;
        # 10 reset<=0;
        # 10 reset<=1; 
        //# 100 $stop;
    end
endmodule