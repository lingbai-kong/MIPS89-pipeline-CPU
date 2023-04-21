-makelib xcelium_lib/xpm -sv \
  "M:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "M:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../pipelineCPU.gen/sources_1/ip/clk_wiz_cpu/clk_wiz_cpu_clk_wiz.v" \
  "../../../../pipelineCPU.gen/sources_1/ip/clk_wiz_cpu/clk_wiz_cpu.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

