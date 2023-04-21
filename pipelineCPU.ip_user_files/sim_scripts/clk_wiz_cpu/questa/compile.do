vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm  -sv "+incdir+../../../ipstatic" \
"M:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm  -93 \
"M:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  "+incdir+../../../ipstatic" \
"../../../../pipelineCPU.gen/sources_1/ip/clk_wiz_cpu/clk_wiz_cpu_clk_wiz.v" \
"../../../../pipelineCPU.gen/sources_1/ip/clk_wiz_cpu/clk_wiz_cpu.v" \

vlog -work xil_defaultlib \
"glbl.v"

