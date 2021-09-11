-------------------------------------------------------------------------------
-- Title      : sync_keyboard.vhd 
-- Project    : Keyboard VLSI Lab
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity sync_keyboard is
    port (
	     clk : in std_logic; 
	     kb_clk : in std_logic;
	     kb_data : in std_logic;
	     kb_clk_sync : out std_logic;
	     kb_data_sync : out std_logic
	 );
end sync_keyboard;


architecture sync_keyboard_arch of sync_keyboard is

signal kb_data_half_sync, kb_clk_half_sync: std_logic := '0'; --declare and intialise signal buffers

begin 

process(clk)
begin
if(clk='1' and clk'EVENT) then

kb_clk_half_sync <=kb_clk; --FF1
kb_data_half_sync <=kb_data;
kb_data_sync <=kb_data_half_sync; --FF2
kb_clk_sync <=kb_clk_half_sync;
--kb_clk_sync<=kb_clk;
--kb_data_sync<=kb_data;

end if;
end process;



end sync_keyboard_arch;
