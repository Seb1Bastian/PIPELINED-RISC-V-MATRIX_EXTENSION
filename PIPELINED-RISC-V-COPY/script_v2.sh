#!/bin/bash

ghdl -s adder/adder.vhdl
ghdl -a adder/adder.vhdl
ghdl -e adder
ghdl -s adder/adder_tb.vhdl
ghdl -a adder/adder_tb.vhdl
ghdl -e adder_tb

ghdl -s alu/alu.vhdl
ghdl -a alu/alu.vhdl
ghdl -e alu
ghdl -s alu/alu_tb.vhdl
ghdl -a alu/alu_tb.vhdl
ghdl -e alu_tb

ghdl -s ALU_Decoder/ALU_Decoder.vhdl
ghdl -a ALU_Decoder/ALU_Decoder.vhdl
ghdl -e ALU_Decoder
ghdl -s ALU_Decoder/ALU_Decoder_tb.vhdl
ghdl -a ALU_Decoder/ALU_Decoder_tb.vhdl
ghdl -e ALU_Decoder_tb

ghdl -s data_memory/data_memr.vhdl
ghdl -a data_memory/data_memr.vhdl
ghdl -e data_memr
ghdl -s data_memory/data_memr_tb.vhdl
ghdl -a data_memory/data_memr_tb.vhdl
ghdl -e data_memr_tb

ghdl -s extend/extend.vhdl
ghdl -a extend/extend.vhdl
ghdl -e extend
ghdl -s extend/extend_tb.vhdl
ghdl -a extend/extend_tb.vhdl
ghdl -e extend_tb

ghdl -s hazard_unit/hazard_unit.vhdl
ghdl -a hazard_unit/hazard_unit.vhdl
ghdl -e hazard_unit
ghdl -s hazard_unit/hazard_unit_tb.vhdl
ghdl -a hazard_unit/hazard_unit_tb.vhdl
ghdl -e hazard_unit_tb

ghdl -s instr_mem/instr_mem.vhdl
ghdl -a instr_mem/instr_mem.vhdl
ghdl -e instr_mem
ghdl -s instr_mem/instr_mem_tb.vhdl
ghdl -a instr_mem/instr_mem_tb.vhdl
ghdl -e instr_mem_tb

ghdl -s main_decoder/main_decoder.vhdl
ghdl -a main_decoder/main_decoder.vhdl
ghdl -e main_decoder
ghdl -s main_decoder/main_decoder_tb.vhdl
ghdl -a main_decoder/main_decoder_tb.vhdl
ghdl -e main_decoder_tb

ghdl -s mux_2/mux_2.vhdl
ghdl -a mux_2/mux_2.vhdl
ghdl -e mux_2
ghdl -s mux_2/mux_2_tb.vhdl
ghdl -a mux_2/mux_2_tb.vhdl
ghdl -e mux_2_tb

ghdl -s mux_3/mux_3.vhdl
ghdl -a mux_3/mux_3.vhdl
ghdl -e mux_3
ghdl -s mux_3/mux_3_tb.vhdl
ghdl -a mux_3/mux_3_tb.vhdl
ghdl -e mux_3_tb

ghdl -s mux_4/mux_4.vhdl
ghdl -a mux_4/mux_4.vhdl
ghdl -e mux_4
#ghdl -s mux_4/mux_4_tb.vhdl
#ghdl -a mux_4/mux_4_tb.vhdl
#ghdl -e mux_4_tb

ghdl -s pc/pc.vhdl
ghdl -a pc/pc.vhdl
ghdl -e pc
ghdl -s pc/pc_tb.vhdl
ghdl -a pc/pc_tb.vhdl
ghdl -e pc_tb

ghdl -s PCPlus4/PCPlus4.vhdl
ghdl -a PCPlus4/PCPlus4.vhdl
ghdl -e PCPlus4
ghdl -s PCPlus4/PCPlus4_tb.vhdl
ghdl -a PCPlus4/PCPlus4_tb.vhdl
ghdl -e PCPlus4_tb

ghdl -s reg_de/reg_de.vhdl
ghdl -a reg_de/reg_de.vhdl
ghdl -e reg_de
ghdl -s reg_de/reg_de_tb.vhdl
ghdl -a reg_de/reg_de_tb.vhdl
ghdl -e reg_de_tb

ghdl -s reg_em/reg_em.vhdl
ghdl -a reg_em/reg_em.vhdl
ghdl -e reg_em
ghdl -s reg_em/reg_em_tb.vhdl
ghdl -a reg_em/reg_em_tb.vhdl
ghdl -e reg_em_tb

ghdl -s reg_fd/reg_fd.vhdl
ghdl -a reg_fd/reg_fd.vhdl
ghdl -e reg_fd
ghdl -s reg_fd/reg_fd_tb.vhdl
ghdl -a reg_fd/reg_fd_tb.vhdl
ghdl -e reg_fd_tb

ghdl -s reg_file/reg_file.vhdl
ghdl -a reg_file/reg_file.vhdl
ghdl -e reg_file
ghdl -s reg_file/reg_file_tb.vhdl
ghdl -a reg_file/reg_file_tb.vhdl
ghdl -e reg_file_tb

ghdl -s reg_mw/reg_mw.vhdl
ghdl -a reg_mw/reg_mw.vhdl
ghdl -e reg_mw
ghdl -s reg_mw/reg_mw_tb.vhdl
ghdl -a reg_mw/reg_mw_tb.vhdl
ghdl -e reg_mw_tb

ghdl -s control_unit/control_unit.vhdl
ghdl -a control_unit/control_unit.vhdl
ghdl -e control_unit
ghdl -s control_unit/control_unit_tb.vhdl
ghdl -a control_unit/control_unit_tb.vhdl
ghdl -e control_unit_tb

ghdl -s datapath/datapath.vhdl
ghdl -a datapath/datapath.vhdl
ghdl -e datapath
ghdl -s datapath/datapath_tb.vhdl
ghdl -a datapath/datapath_tb.vhdl
ghdl -e datapath_tb

ghdl -s pipelined_risc_v/pipe_risc_v.vhdl
ghdl -a pipelined_risc_v/pipe_risc_v.vhdl
ghdl -e pipe_risc_v
ghdl -s pipelined_risc_v/pipe_risc_v_tb.vhdl
ghdl -a pipelined_risc_v/pipe_risc_v_tb.vhdl
ghdl -e pipe_risc_v_tb
