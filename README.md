# PIPELINED-RISC-V in VHDL

![image](https://github.com/Seb1Bastian/PIPELINED-RISC-V-EXTENSION/blob/main/RISC-V_with_Extension.png)

## Requirements
* **GHDL**
* **GTKWave**
* **VHDL**

## Quick Instruction

### compiling VHDL code and looking on wave diagrams in GTKWave

      $ ghdl -s test_file.vhdl                 #Syntax Check  
      $ ghdl -a test_file.vhdl                 #Analyse  
      $ ghdl -e test_file.vhdl                 #Build   
      $ ghdl -r test_file --vcd=testbench.vcd  #VCD-Dump  
      $ gtkwave testbench.vcd                  #Start GTKWave  

Also you can compile and look on wave diagrams in GTKWave with command  
  
      $ bash script_v3.sh
      $ ghdl -r pipe_risc_v_nn_tb --vcd=testbench.vcd  #VCD-Dump  
      $ gtkwave testbench.vcd                          #Start GTKWave
      
Bash must be open in the directory of the project!
 

## References

1. David M. Harris and Sarah L. Harris, "Digital Design and Computer Architecture, RISC-V Edition"  
  http://pages.hmc.edu/harris/class/e85/old/fall21/lect23.pdf

2. David A. Patterson, John L. Hennessy, “Computer Organization and Design RISC-V Edition: The Hardware Software Interface”, Morgan Kaufmann, 2017.

3. ISA Specification RISC-V  
  https://riscv.org/technical/specifications/
  
4. https://github.com/TUD-CPU/PIPELINED-RISC-V

5. http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
 
