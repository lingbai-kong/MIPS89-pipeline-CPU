vlib work
vlib activehdl

vlib activehdl/xpm
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../ipstatic" \
"M:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"M:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" \
"../../../../pipelineCPU.gen/sources_1/ip/clk_wiz_cpu/clk_wiz_cpu_clk_wiz.v" \
"../../../../pipelineCPU.gen/sources_1/ip/clk_wiz_cpu/clk_wiz_cpu.v" \

vlog -work xil_defaultlib \
"glbl.v"

