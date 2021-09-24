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
        rst : in std_logic;
        kb_clk_sync : out std_logic;
        kb_data_sync : out std_logic
    );
end sync_keyboard;


architecture sync_keyboard_arch of sync_keyboard is

    signal kb_data_half_sync, kb_clk_half_sync: std_logic := '0'; --declare and intialise signal buffers

begin

    process(clk,rst)
    begin
        if(rising_edge(clk)) then
            if(rst='1') then --reset the signals
                kb_data_half_sync<='0';
                kb_clk_half_sync<='0';
                kb_data_sync<='0';
                kb_data_sync<='0';
                kb_clk_sync<='0';
            else
                kb_clk_half_sync <=kb_clk; --FF1
                kb_data_half_sync <=kb_data;
                kb_data_sync <=kb_data_half_sync; --FF2
                kb_clk_sync <=kb_clk_half_sync;
            end if;
        end if;
    end process;

end sync_keyboard_arch;
