-------------------------------------------------------------------------------
-- Title      : keyboard_ctrl.vhd 
-- Project    : Keyboard VLSI Lab
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Description: 
-- 		        controller to handle the scan codes 
-- 		        
--
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


entity keyboard_ctrl is
    port (
        clk : in std_logic;
        rst : in std_logic;
        valid_code : in std_logic;
        scan_code_in : in unsigned(7 downto 0);
        code_to_display : out unsigned(7 downto 0);
        seg_en : out unsigned(3 downto 0)

    );
end keyboard_ctrl;

architecture keyboard_ctrl_arch of keyboard_ctrl is


    signal Break_code_recieved: std_logic;
    signal Break_code_recieved_buffer: std_logic;
    signal Key_code_recieved: std_logic;
    signal Key_code_register_enable: std_logic;
    signal Key_code_register_out_1,Key_code_register_out_2,Key_code_register_out_3,Key_code_register_out_4 : unsigned(7 downto 0);
    signal scan_code_in_buffer: unsigned(7 downto 0);
    signal Key_code_mux_out: unsigned(7 downto 0);
    signal seg_en_next: unsigned(3 downto 0);
    signal seg_en_buffer: unsigned(3 downto 0);
    signal Mux_new_output : std_logic;
begin

    Check_code_type: process (valid_code,rst,scan_code_in)
    begin
        if(rst='1') then
            Break_code_recieved<='0';
            Key_code_recieved<='0';
        elsif(valid_code='1') then
            if(scan_code_in="11110000")then
                Break_code_recieved<='1';
                Key_code_recieved<='0';
            else
                Break_code_recieved<='0';
                Key_code_recieved<='1';
            end if;
        else
            Break_code_recieved<='0';
            Key_code_recieved<='0';
        end if;
    end process;

    Break_code_register: process(clk,rst)
    begin

        if(rst='1') then
            Break_code_recieved_buffer<='0';
        elsif (rising_edge(clk)) then
            if Break_code_recieved='1' then
                Break_code_recieved_buffer<='1';
            else
                Break_code_recieved_buffer<='0';
            end if;
        end if;
    end process;

    Key_code_enable: process(rst,Break_code_recieved_buffer,Key_code_register_out_1,Key_code_recieved)
    begin
        if(rst='1') then
            Key_code_register_enable<='0';
        else
            if (Key_code_register_out_1="00000000" and Key_code_recieved='1') then
                Key_code_register_enable<='1';
            else
                Key_code_register_enable<='0';
            end if;
        end if;
    end process;

    Key_code_mux: process (rst,Key_code_register_enable,Key_code_recieved,Key_code_register_out_1,Break_code_recieved_buffer)
    begin
        if(rst='1') then
            Key_code_mux_out<="00000000";
            Mux_new_output<='0';
        elsif Key_code_register_enable='0' and (Break_code_recieved_buffer='0' or Key_code_recieved='0' ) then
            Key_code_mux_out<=Key_code_register_out_1;
            Mux_new_output<='0';
        elsif (Key_code_register_enable='1')and (Break_code_recieved_buffer='0' or Key_code_recieved='0') then
            Key_code_mux_out<=scan_code_in;
            Mux_new_output<='1';
        elsif (Key_code_register_enable='0')and (Break_code_recieved_buffer='1' and Key_code_recieved='1') then
            Key_code_mux_out<="00000000";
            Mux_new_output<='0';
        elsif (Key_code_register_enable='1')and (Break_code_recieved_buffer='1' and Key_code_recieved='1') then
            Key_code_mux_out<="00000000";
            Mux_new_output<='0';
        else
            Key_code_mux_out<="00000000";
            Mux_new_output<='0';
        end if;
    end process;

    Segment_display_counter: process(rst,clk)
    begin
        if(rst='1') then
            seg_en_buffer<="0000";
        elsif rising_edge(clk) then
            seg_en_buffer<=seg_en_next;
            
        end if;
    end process;
    seg_en<=seg_en_buffer;
    
    Segment_display_counter_wrap:  process(rst,seg_en_buffer)
    begin
        if rst='1' then
            seg_en_next<="0000";
        else
            if seg_en_next="0011" then
                seg_en_next<="0000";
            else
                seg_en_next<=seg_en_buffer +"1";
            end if;
        end if;
    end process;
    
    Key_code_out_shift_array: process (rst,clk,Key_code_register_out_1)
    begin
        if rst='1' then
            Key_code_register_out_1<="00000000";
            Key_code_register_out_2<="00000000";
            Key_code_register_out_3<="00000000";
            Key_code_register_out_4<="00000000";
        elsif rising_edge(clk) then
            if(Mux_new_output='1') then
                Key_code_register_out_1<=Key_code_mux_out;
                Key_code_register_out_2<=Key_code_register_out_1;
                Key_code_register_out_3<=Key_code_register_out_2;
                Key_code_register_out_4<=Key_code_register_out_3;
            end if;
        end if;
    end process;

    code_to_display_mux: process(rst,clk,seg_en_buffer)
    begin
        if rst='1' then
            code_to_display<="00000000";
        else
            case seg_en_buffer is
                when "0000" =>
                    code_to_display<=Key_code_register_out_1;
                when "0001" =>
                    code_to_display<=Key_code_register_out_2;
                when "0010" =>
                    code_to_display<=Key_code_register_out_3;
                when "0011" =>
                    code_to_display<=Key_code_register_out_4;
                when others =>
                    code_to_display<="00000000";
            end case;
        end if;
    end process;
end keyboard_ctrl_arch;
