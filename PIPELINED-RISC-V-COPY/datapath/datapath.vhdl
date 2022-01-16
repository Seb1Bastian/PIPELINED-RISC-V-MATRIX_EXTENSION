library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
    port(
        --inputs
        clk                 : in std_logic;
        reset               : in std_logic;
        en_pc               : in std_logic;
        en_fd               : in std_logic;
        en_de               : in std_logic;
        en_em               : in std_logic;
        en_mw               : in std_logic;
        clr_pc              : in std_logic;
        clr_fd              : in std_logic;
        clr_de              : in std_logic;
        clr_em              : in std_logic;
        clr_mw              : in std_logic;
        pcsrc_e             : in std_logic;

        immsrc_d            : in std_logic_vector(1 downto 0);
        regwrite_d          : in std_logic;
        resultsrc_d         : in std_logic_vector(1 downto 0);
        memwrite_d          : in std_logic;
        jump_d              : in std_logic;
        branch_d            : in std_logic;
        alucontrol_d        : in std_logic_vector(2 downto 0);
        alusrc_d            : in std_logic;
        forward_ae          : in std_logic_vector(1 downto 0);
        forward_be          : in std_logic_vector(1 downto 0);

        --buffers
        rd_w                : buffer std_logic_vector(4 downto 0);
        regwrite_w          : buffer std_logic;
        rd_e                : buffer std_logic_vector(4 downto 0);
        regwrite_m          : buffer std_logic;
        rd_m                : buffer std_logic_vector(4 downto 0);
        instr_d             : buffer std_logic_vector(31 downto 0);
        --outputs
        jump_e              : out std_logic;
        branch_e            : out std_logic;
        zero_e              : out std_logic;
        rs1_e               : out std_logic_vector(4 downto 0);
        rs2_e               : out std_logic_vector(4 downto 0);
        resultsrc_e0        : out std_logic;


        --NN

        --inputs
        toAccelerator_d     : in std_logic;
        fromAccelerator_d   : in std_logic;
        onlyByte_d          : in std_logic;
        --outputs
        toAccelerator_e     : out std_logic;
        toAccelerator_w     : out std_logic;
        fromAccelerator     : out std_logic;
        dataToAccelerator   : out std_logic_vector(31 downto 0)

    );
end datapath;

architecture rtl of datapath is

    --signals
    signal pcplus4_f            : std_logic_vector(31 downto 0);
    signal pctarget_e           : std_logic_vector(31 downto 0);
    signal pcf_in               : std_logic_vector(31 downto 0);
    signal pcf_buf              : std_logic_vector(31 downto 0);
    signal rd_instr             : std_logic_vector(31 downto 0);
    signal pc_d                 : std_logic_vector(31 downto 0);
    signal pcplus4_d            : std_logic_vector(31 downto 0);
    signal result_w             : std_logic_vector(31 downto 0);
    signal rd1                  : std_logic_vector(31 downto 0);
    signal rd2                  : std_logic_vector(31 downto 0);
    signal immext_d             : std_logic_vector(31 downto 0);
    signal rd1_e                : std_logic_vector(31 downto 0);
    signal rd2_e                : std_logic_vector(31 downto 0);
    signal regwrite_e           : std_logic;
    signal memwrite_e           : std_logic;
    signal alucontrol_e         : std_logic_vector(2 downto 0);
    signal alusrc_e             : std_logic;
    signal pcplus4_e            : std_logic_vector(31 downto 0);
    signal aluresult_m          : std_logic_vector(31 downto 0);
    signal forward_ae_mux_o     : std_logic_vector(31 downto 0);
    signal forward_be_mux_o     : std_logic_vector(31 downto 0);
    signal aluresult_d          : std_logic_vector(31 downto 0);
    signal resultsrc_m          : std_logic_vector(1 downto 0);
    signal memwrite_m           : std_logic;
    signal writedata_m          : std_logic_vector(31 downto 0);
    signal pcplus4_m            : std_logic_vector(31 downto 0);
    signal resultsrc_w          : std_logic_vector(1 downto 0);
    signal aluresult_w          : std_logic_vector(31 downto 0);
    signal readdata_w           : std_logic_vector(31 downto 0);
    signal pcplus4_w            : std_logic_vector(31 downto 0);
    signal rd_memr              : std_logic_vector(31 downto 0);
    signal immext_e             : std_logic_vector(31 downto 0);
    signal pc_e                 : std_logic_vector(31 downto 0);
    signal srcb_e               : std_logic_vector(31 downto 0);
    signal writedata_e          : std_logic_vector(31 downto 0);
    signal resultsrc_e          : std_logic_vector(1 downto 0);
    signal not_clk              : std_logic;
    signal not_en_pc            : std_logic;
    signal not_en_fd            : std_logic;
    signal not_en_de            : std_logic;
    signal not_en_em            : std_logic;
    signal not_en_mw            : std_logic;

    --NN
    signal toAccelerator_e_intern   : std_logic;
    signal toAccelerator_m          : std_logic;
    signal toAccelerator_w_intern   : std_logic;
    signal fromAccelerator_e        : std_logic;
    signal aluresultbyte_w          : std_logic_vector(31 downto 0);
    signal onlyByte_e               : std_logic;
    signal onlyByte_m               : std_logic;
    signal dataToAccelerator_w      : std_logic_vector(31 downto 0);

    begin
        --instantiation multiplexer 2 to 1
        inst_mux : entity work.mux_2(rtl)
            generic map(32)
            port map(
                port_in1    => pcplus4_f,
                port_in2    => pctarget_e,
                sel         => pcsrc_e,
                port_out    => pcf_in
            );


        --instantiation program counter
        not_en_pc <= not en_pc;
        inst_pc : entity work.pc(rtl)
            port map(
                clk     => clk,
                reset   => reset,
                PCNext  => pcf_in,
                PC_cur  => pcf_buf,
                en      => not_en_pc
            );

        --instantiation instruction memory
        inst_instr_mem : entity work.instr_mem(rtl)
            port map(
                addr_instr => pcf_buf,
                rd_instr => rd_instr
            );

        --instantiation adder +4
        inst_pcplus4 : entity work.adder(rtl)
            port map(
                a_in    => pcf_buf,
                b_in    => x"00000004",
                c_out   => pcplus4_f
            );
        --instantiation Register between fetch and decode
        not_en_fd   <= not en_fd;
        inst_reg_fd : entity work.reg_fd(rtl)
            port map(
                clk         => clk,
                en          => not_en_fd,
                clr         => clr_fd,
                rd          => rd_instr,
                pc_f        => pcf_buf,
                pcplus4_f   => pcplus4_f,
                instr_d     => instr_d,
                pc_d        => pc_d,
                pcplus4_d   => pcplus4_d
            );
        --instantiation register file
        inst_reg_file : entity work.reg_file(rtl)
            port map(
                read_port_addr1     => instr_d(19 downto 15),
                read_port_addr2     => instr_d(24 downto 20),
                write_port_addr     => rd_w,
                write_data          => result_w,
                write_en            => regwrite_w,
                clk                 => clk,
                read_data1          => rd1,
                read_data2          => rd2
            );

        --instantiation extend
        inst_extend : entity work.extend(rtl)
            port map(
                ImmSrc => immsrc_d,
                instruction => instr_d(31 downto 7),
                ImmExt => immext_d
            );

        --instantiation Register between decode and execute
        not_en_de <= not en_de;
        inst_reg_de : entity work.reg_de(rtl)
            port map(
                clk             => clk,
                clr_de          => clr_de,
                en_de           => not_en_de,
                regwrite_d      => regwrite_d,
                resultsrc_d     => resultsrc_d,
                memwrite_d      => memwrite_d,
                jump_d          => jump_d,
                branch_d        => branch_d,
                alucontrol_d    => alucontrol_d,
                alusrc_d        => alusrc_d,
                rd1             => rd1,
                rd2             => rd2,
                pc_d            => pc_d,
                rs1_d           => instr_d(19 downto 15),
                rs2_d           => instr_d(24 downto 20),
                rd_d            => instr_d(11 downto 7),
                immext_d        => immext_d,
                pcplus4_d       => pcplus4_d,
                toAccelerator_d => toAccelerator_d,
                fromAccelerator_d => fromAccelerator_d,
                onlyByte_d      => onlyByte_d,

                regwrite_e      => regwrite_e,
                resultsrc_e     => resultsrc_e,
                memwrite_e      => memwrite_e,
                jump_e          => jump_e,
                branch_e        => branch_e,
                alucontrol_e    => alucontrol_e,
                alusrc_e        => alusrc_e,
                rd1_e           => rd1_e,
                rd2_e           => rd2_e,
                pc_e            => pc_e,
                rs1_e           => rs1_e,
                rs2_e           => rs2_e,
                rd_e            => rd_e,
                immext_e        => immext_e,
                pcplus4_e       => pcplus4_e,
                toAccelerator_e => toAccelerator_e_intern,
                fromAccelerator_e => fromAccelerator_e,
                onlyByte_e      => onlyByte_e

            );

            resultsrc_e0 <= resultsrc_e(0);

            --instantiation multiplexer for SrcAE
            inst_mux_3_src_ae : entity work.mux_3(rtl)
                generic map(32)
                port map(
                    a    => rd1_e,
                    b    => result_w,
                    c    => aluresult_m,
                    sel         => forward_ae,
                    y    => forward_ae_mux_o
                );

            --instantiation multiplexer for SrcBE
            inst_mux_3_src_be : entity work.mux_3(rtl)
                generic map(32)
                port map(
                    a    => rd2_e,
                    b    => result_w,
                    c    => aluresult_m,
                    sel  => forward_be,
                    y    => forward_be_mux_o
                );

            --instantiation multiplexer 2 to 1
            inst_mux_2 : entity work.mux_2(rtl)
                generic map(32)
                port map(
                    port_in1    => forward_be_mux_o,
                    port_in2    => immext_e,
                    sel         => alusrc_e,
                    port_out    => srcb_e
                );

            --instantiation adder
            inst_adder : entity work.adder(rtl)
                port map(
                    a_in    => pc_e,
                    b_in    => immext_e,
                    c_out   => pctarget_e
                );


            --instantiation ALU
            inst_alu : entity work.ALU(rtl)
                port map(
                    SrcA            => forward_ae_mux_o,
                    SrcB            => srcb_e,
                    ALUControl      => alucontrol_e,
                    Zero            => zero_e,
                    ALUResult       => aluresult_d
                );

            --instantiation Register between execute and memory
            writedata_e <= forward_be_mux_o;
            not_en_em   <= not en_em;
            inst_reg_em : entity work.reg_em(rtl)
                port map(
                    clk             => clk,
                    clr_em          => clr_em,
                    en_em           => not_en_em,
                    regwrite_e      => regwrite_e,
                    resultsrc_e     => resultsrc_e,
                    memwrite_e      => memwrite_e,
                    aluresult       => aluresult_d,
                    writedata_e     => writedata_e,
                    rd_e            => rd_e,
                    pcplus4_e       => pcplus4_e,
                    toAccelerator_e => toAccelerator_e_intern,
                    onlyByte_e      => onlyByte_e,

                    regwrite_m      => regwrite_m,
                    resultsrc_m     => resultsrc_m,
                    memwrite_m      => memwrite_m,
                    aluresult_m     => aluresult_m,
                    writedata_m     => writedata_m,
                    rd_m            => rd_m,
                    pcplus4_m       => pcplus4_m,
                    toAccelerator_m => toAccelerator_m,
                    onlyByte_m      => onlyByte_m

                );

            --instantiation data memory
            inst_data_memr : entity work.data_memr(rtl)
                port map(
                    addr_port       => aluresult_m,
                    write_data      => writedata_m,
                    clk             => clk,
                    byte_en         => onlyByte_m,
                    write_en        => memwrite_m,
                    read_data       => rd_memr
                );

            --instantiation Register between memory and writeback
            not_en_mw <= not en_mw;
            inst_reg_mw : entity work.reg_mw(rtl)
                port map(
                    clk             => clk,
                    clr_mw          => clr_mw,
                    en_mw           => not_en_mw,
                    regwrite_m      => regwrite_m,
                    resultsrc_m     => resultsrc_m,
                    aluresult_m     => aluresult_m,
                    rd              => rd_memr,
                    rd_m            => rd_m,
                    pcplus4_m       => pcplus4_m,
                    toAccelerator_m => toAccelerator_m,

                    regwrite_w      => regwrite_w,
                    resultsrc_w     => resultsrc_w,
                    aluresult_w     => aluresult_w,
                    readdata_w      => readdata_w,
                    rd_w            => rd_w,
                    pcplus4_w       => pcplus4_w,
                    toAccelerator_w => toAccelerator_w_intern
                );


            aluresultbyte_w <= x"000000" & aluresult_w(7 downto 0);
            --instantiation multiplexer 3 to 1
            inst_mux_4 : entity work.mux_4(rtl)
                generic map(32)
                port map(
                    a    => aluresult_w,
                    b    => readdata_w,
                    c    => pcplus4_w,
                    d    => aluresultbyte_w,
                    sel  => resultsrc_w,
                    y    => result_w
                );


            inst_mux_2_toAcc : entity work.mux_2(rtl)
                generic map(32)
                port map(
                    port_in1    => x"00000000",
                    port_in2    => result_w,
                    sel         => toAccelerator_w_intern,
                    port_out    => dataToAccelerator_w
                );


            toAccelerator_e     <= toAccelerator_e_intern;
            toAccelerator_w     <= toAccelerator_w_intern;
            dataToAccelerator   <= dataToAccelerator_w;

    end rtl;
