library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity hazard_unit is
    port(

        --inputs
        rs1_d           : in std_logic_vector(19 downto 15);
        rs2_d           : in std_logic_vector(24 downto 20);
        rd_e            : in std_logic_vector(11 downto 7);
        rs2_e           : in std_logic_vector(24 downto 20);
        rs1_e           : in std_logic_vector(19 downto 15);
        pcsrc_e         : in std_logic;
        resultsrc_e0    : in std_logic;
        rd_m            : in std_logic_vector(11 downto 7);
        regwrite_m      : in std_logic;
        rd_w            : in std_logic_vector(11 downto 7);
        regwrite_w      : in std_logic;

        --outputs
        stall_f         : out std_logic;
        stall_d         : out std_logic;
        flush_d         : out std_logic;
        flush_e         : out std_logic;
        forward_ae      : out std_logic_vector(1 downto 0);
        forward_be      : out std_logic_vector(1 downto 0)

        --NN
        --inputs
        --;matrix          : in std_logic;
        --pooling         : in std_logic;
        --accoumuation    : in std_logic
    );
end hazard_unit;

architecture rtl of hazard_unit is

    signal lwStall : std_logic;
    signal stall_f_normal : std_logic :='0';
    signal stall_d_normal : std_logic :='0';
    signal flush_d_normal : std_logic :='0';
    signal flush_e_normal : std_logic :='0';

    signal stall_f_nn : std_logic :='0';
    signal stall_d_nn : std_logic :='0';
    signal flush_d_nn : std_logic :='0';
    signal flush_e_nn : std_logic :='0';

    begin

        stall_f <= stall_f_normal or stall_f_nn;
        stall_d <= stall_d_normal or stall_d_nn;
        flush_d <= flush_d_normal or flush_d_nn;
        flush_e <= flush_e_normal or flush_e_nn;

        --Forward to solve data hazards when possible
        process(rs1_e, rd_m, rd_w, regwrite_m, regwrite_w)begin

            --forwarding logic for SrcAE (forward_ae)
            if(((rs1_e = rd_m) and (regwrite_m = '1')) and (rs1_e /= b"00000")) then        --forward from memory stage
                forward_ae <= "10";
            elsif(((rs1_e = rd_w) and (regwrite_w = '1')) and (rs1_e /= b"00000")) then     -- forward from writeback stage
                forward_ae <= "01";
            else
                forward_ae <= "00";                                                       --no forwarding (use rf output)
            end if;
        end process;

        --forwarding logic for SrcBE (forward_be)
        process(rs2_e, rd_m, rd_w, regwrite_m, regwrite_w)begin

            --forwarding logic for SrcBE (forward_be)
            if((rs2_e = rd_m) and (regwrite_m = '1')) and (rs2_e /= b"00000") then        --forward from memory stage
                forward_be <= "10";
            elsif((rs2_e = rd_w) and (regwrite_w = '1')) and (rs2_e /= b"00000") then     -- forward from writeback stage
                forward_be <= "01";
            else
                forward_be <= "00";                                                     --no forwarding (use rf output)
            end if;
        end process;

        --Stall when a load hazard occurs
        process(rs1_d, rs2_d, rd_e, resultsrc_e0)begin

            if(((rs1_d = rd_e) or (rs2_d = rd_e)) and (resultsrc_e0 = '1'))then
                lwStall <= '1';
            else
                lwStall <= '0';
            end if;
            stall_f_normal <= lwStall;
            stall_d_normal <= lwStall;

        end process;

        --Flush when a branch is taken or a load introduces a bubble
        process(pcsrc_e, lwStall)begin
            if pcsrc_e = '1' then
                flush_d_normal <= '1';
                flush_e_normal <= '1';
            else
                flush_d_normal <= '0';
                flush_e_normal <= lwStall;
            end if;
        end process;


        --Stall/Flush the pipeline if the NNController wants it.
        --process(matrix, pooling, accoumuation)begin
        --    if matrix = '1' then

        --    elsif pooling = '1' then
            
        --    elsif accoumuation = '1' then

        --    end if;
        
        --end process;
                
                

      --  stall_f <= lwStall;
      --  stall_d <= lwStall;
end rtl;
