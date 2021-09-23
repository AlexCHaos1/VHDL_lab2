-------------------------------------------------------------------------------
-- Title      : convert_to_binary.vhd 
-- Project    : Keyboard VLSI Lab
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Description: 
-- 		        Look-up-Table
-- 		
--
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


entity convert_to_binary is
    port (
	     scan_code_in : in unsigned(7 downto 0);
	     binary_out : out unsigned(3 downto 0)
	 );
end convert_to_binary;

architecture convert_to_binary_arch of convert_to_binary is
begin
process(scan_code_in)
begin
    case scan_code_in is
        when "00010110" =>
            binary_out <= "0001"; --1
        when "00011110" => 
            binary_out <= "0010"; --2
        when "00100110" =>
            binary_out <= "0011"; --3
        when "00100101" =>
            binary_out <= "0100"; --4
        when "00101110" =>
            binary_out <= "0101"; --5
        when "00110110" =>
            binary_out <= "0110"; --6
        when "00111101" =>
            binary_out <= "0111"; --7
        when "00111110" =>
            binary_out <= "1000"; --8
        when "01000110" =>
            binary_out <= "1001"; --9
        when "01000101" =>
            binary_out <= "0000"; --0
        when "00000000" =>
            binary_out <= "1111"; --15 (used to clear the segment display)                           
        when others =>
            binary_out <= "1010"; --E
    end case;
end process;
end convert_to_binary_arch;