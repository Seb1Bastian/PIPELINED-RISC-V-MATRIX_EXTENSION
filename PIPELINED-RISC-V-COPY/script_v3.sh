#!/bin/bash

ghdl -s rtl/adder.vhdl
ghdl -a rtl/adder.vhdl
ghdl -e adder

ghdl -s rtl/eightBitAdder.vhdl
ghdl -a rtl/eightBitAdder.vhdl
ghdl -e eightBitAdder

ghdl -s rtl/alu.vhdl
ghdl -a rtl/alu.vhdl
ghdl -e alu

ghdl -s rtl/alu_Decoder.vhdl
ghdl -a rtl/alu_Decoder.vhdl
ghdl -e alu_Decoder

ghdl -s rtl/data_memr.vhdl
ghdl -a rtl/data_memr.vhdl
ghdl -e data_memr

ghdl -s rtl/extend.vhdl
ghdl -a rtl/extend.vhdl
ghdl -e extend

ghdl -s rtl/hazard_unit.vhdl
ghdl -a rtl/hazard_unit.vhdl
ghdl -e hazard_unit

ghdl -s rtl/instr_mem.vhdl
ghdl -a rtl/instr_mem.vhdl
ghdl -e instr_mem

ghdl -s rtl/main_decoder.vhdl
ghdl -a rtl/main_decoder.vhdl
ghdl -e main_decoder

ghdl -s rtl/control_unit.vhdl
ghdl -a rtl/control_unit.vhdl
ghdl -e control_unit

ghdl -s rtl/mux_2.vhdl
ghdl -a rtl/mux_2.vhdl
ghdl -e mux_2

ghdl -s rtl/mux_3.vhdl
ghdl -a rtl/mux_3.vhdl
ghdl -e mux_3

ghdl -s rtl/mux_4.vhdl
ghdl -a rtl/mux_4.vhdl
ghdl -e mux_4

ghdl -s rtl/pc.vhdl
ghdl -a rtl/pc.vhdl
ghdl -e pc

ghdl -s rtl/reg_fd.vhdl
ghdl -a rtl/reg_fd.vhdl
ghdl -e reg_fd

ghdl -s rtl/reg_de.vhdl
ghdl -a rtl/reg_de.vhdl
ghdl -e reg_de

ghdl -s rtl/reg_em.vhdl
ghdl -a rtl/reg_em.vhdl
ghdl -e reg_em

ghdl -s rtl/reg_mw.vhdl
ghdl -a rtl/reg_mw.vhdl
ghdl -e reg_mw

ghdl -s rtl/reg_file.vhdl
ghdl -a rtl/reg_file.vhdl
ghdl -e reg_file

ghdl -s rtl/datapath.vhdl
ghdl -a rtl/datapath.vhdl
ghdl -e datapath

ghdl -s rtl/pipe_risc_v.vhdl
ghdl -a rtl/pipe_risc_v.vhdl
ghdl -e pipe_risc_v

ghdl -s rtl/fifo_pack.vhdl
ghdl -a rtl/fifo_pack.vhdl

ghdl -s rtl/pipo.vhdl
ghdl -a rtl/pipo.vhdl
ghdl -e pipo

ghdl -s rtl/fifo_demux.vhdl
ghdl -a rtl/fifo_demux.vhdl
ghdl -e fifo_demux

ghdl -s rtl/fifo_mux.vhdl
ghdl -a rtl/fifo_mux.vhdl
ghdl -e fifo_mux

ghdl -s rtl/vec_combiner.vhdl
ghdl -a rtl/vec_combiner.vhdl
ghdl -e vec_combiner

ghdl -s rtl/siso.vhdl
ghdl -a rtl/siso.vhdl
ghdl -e siso

ghdl -s rtl/d_ff.vhdl
ghdl -a rtl/d_ff.vhdl
ghdl -e d_ff

ghdl -s rtl/greyCode_to_bitCode.vhdl
ghdl -a rtl/greyCode_to_bitCode.vhdl
ghdl -e greyCode_to_bitCode

ghdl -s rtl/bitCode_to_greyCode.vhdl
ghdl -a rtl/bitCode_to_greyCode.vhdl
ghdl -e bitCode_to_greyCode

ghdl -s rtl/greyCodeCounter.vhdl
ghdl -a rtl/greyCodeCounter.vhdl
ghdl -e greyCodeCounter

ghdl -s rtl/fifo_mem.vhdl
ghdl -a rtl/fifo_mem.vhdl
ghdl -e fifo_mem

ghdl -s rtl/interface.vhdl
ghdl -a rtl/interface.vhdl
ghdl -e interface

ghdl -s rtl/fifo_grid.vhdl
ghdl -a rtl/fifo_grid.vhdl
ghdl -e fifo_grid

ghdl -s rtl/fifo_grid_vertical.vhdl
ghdl -a rtl/fifo_grid_vertical.vhdl
ghdl -e fifo_grid_vertical

ghdl -s rtl/fifo_mem_loader.vhdl
ghdl -a rtl/fifo_mem_loader.vhdl
ghdl -e fifo_mem_loader

ghdl -s rtl/nn_unloader.vhdl
ghdl -a rtl/nn_unloader.vhdl
ghdl -e nn_unloader

ghdl -s rtl/nn_controller.vhdl
ghdl -a rtl/nn_controller.vhdl
ghdl -e nn_controller

ghdl -s rtl/sa.vhdl
ghdl -a rtl/sa.vhdl
ghdl -e sa

ghdl -s rtl/nn.vhdl
ghdl -a rtl/nn.vhdl
ghdl -e nn

ghdl -s rtl/pipe_risc_v_nn.vhdl
ghdl -a rtl/pipe_risc_v_nn.vhdl
ghdl -e pipe_risc_v_nn
