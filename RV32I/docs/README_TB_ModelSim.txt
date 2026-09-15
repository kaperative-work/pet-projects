Запуск симуляции (ModelSim/QuestaSim)

Откройте ModelSim.

В консоли перейдите в папку проекта: 	cd C:\\Users\\user\\Desktop\\rv32i_git\\RV32I

Выполните скрипт: 
cd C:\\Users\\user\\Desktop\\rv32i_git\\RV32I
quit -sim
if [file exists work] {
    vdel -all
}
vlib work

set PROJ_DIR "."

vlog -sv $PROJ_DIR/pkg/OFA.sv

vlog -sv $PROJ_DIR/ALU.sv
vlog -sv $PROJ_DIR/RegFile.sv
vlog -sv $PROJ_DIR/PC.sv
vlog -sv $PROJ_DIR/PC_Controller.sv
vlog -sv $PROJ_DIR/PC_Plus4.sv
vlog -sv $PROJ_DIR/Branch_Controller.sv

vlog -sv $PROJ_DIR/Mem_Controller.sv
vlog -sv $PROJ_DIR/Load_Controller.sv
vlog -sv $PROJ_DIR/Instruction_Memory.sv
vlog -sv $PROJ_DIR/Data_Memory.sv
vlog -sv $PROJ_DIR/Unit_Controller.sv
vlog -sv $PROJ_DIR/RV32I.sv

vlog -sv $PROJ_DIR/TB/RV32I_TB.sv

vsim -voptargs="+acc" work.RV32I_tb
add wave -position end sim:/RV32I_tb/u_rv32i/*

run -all