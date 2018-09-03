set vsim=\intelFPGA_lite\18.0\modelsim_ase\win32aloem\vsim.exe
title Verilog ModelSim builder
echo Cleaning up
del *.wlf
del start_time.txt
rmdir /S /Q work

echo Compile and simulate
vsim -i -do compile.tcl
echo Do these actions in ModelSim 