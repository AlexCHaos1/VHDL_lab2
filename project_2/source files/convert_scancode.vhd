-------------------------------------------------------------------------------
-- Title      : convert_scancode.vhd 
-- Project    : Keyboard VLSI Lab
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Description: 
-- 		        Implement a shift register to convert serial to parallel
-- 		        A counter to flag when the valid code is shifted in
--
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity convert_scancode is
    port (
        clk : in std_logic;
        rst : in std_logic;
        edge_found : in std_logic;
        serial_data : in std_logic;
        valid_scan_code : out std_logic;
        scan_code_out : out unsigned(7 downto 0)
    );
end convert_scancode;

architecture convert_scancode_arch of convert_scancode is

    signal data_reg: unsigned(10 downto 0);
    signal edge_counter: unsigned(3 downto 0);
    signal edge_counter_next: unsigned(3 downto 0);

begin
    Shift_register: process(clk, rst, edge_found) -- Shifts the data register, and transfers the 8bit data part to scan_code_out
    begin
        if rst = '1' then
            scan_code_out <= "00000000";
            data_reg <="00000000000";

        elsif rising_edge(clk) then
            if (edge_found ='1') then
                data_reg(10) <= serial_data;
                data_reg(9) <= data_reg(10);
                data_reg(8) <= data_reg(9);
                data_reg(7) <= data_reg(8);
                data_reg(6) <= data_reg(7);
                data_reg(5) <= data_reg(6);
                data_reg(4) <= data_reg(5);
                data_reg(3) <= data_reg(4);
                data_reg(2) <= data_reg(3);
                data_reg(1) <= data_reg(2);
                data_reg(0) <= data_reg(1);
                scan_code_out <= data_reg(8 downto 1);
            end if;
        end if;
    end process;

    Binary_Counter:process(clk,rst,edge_found)--increases the edge counter by 1 when an edge has been found
    begin
        if rst = '1' then
            edge_counter <="0000";
        elsif rising_edge(clk) and edge_found ='1' then
            edge_counter<=edge_counter_next; --edge next is defined below
        end if;
    end process;


    Valid_scancode_set_reset:  process(rst,edge_counter)
    begin
        if rst='1' then
            valid_scan_code<='0';
            edge_counter_next<="0000";
        else
            if edge_counter="1010" then
                valid_scan_code<='1';
                edge_counter_next<="0000";
            else
                valid_scan_code<='0';
                edge_counter_next<=edge_counter +"1"; 
            end if;
        end if;
    end process;

end convert_scancode_arch;