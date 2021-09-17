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

begin

    Handle_scancode :process (valid_code,scan_code_in,clk,rst)

        variable Break_code_recieved: std_logic;
        variable Break_code_recieved_buffer: std_logic;
        variable Key_code_recieved: std_logic;
        variable scan_code_in_buffer: unsigned(7 downto 0);

    begin

        if(rst='1') then
            code_to_display<=X"00";
            Break_code_recieved:='0';
            Key_code_recieved:='0';
            scan_code_in_buffer:=X"00";
            Break_code_recieved_buffer:='0';

else
        if(valid_code='1') then
            if(scan_code_in=X"f0") then
                Break_code_recieved:='1';
                Key_code_recieved:='0';
            else
                Key_code_recieved:='1';
                Break_code_recieved:='0';
            end if;
        end if;
       if rising_edge(clk) then

            Break_code_recieved_buffer:=Break_code_recieved;
            
               if(Break_code_recieved_buffer='1') and (Key_code_recieved='1') then --Clear the output register
                scan_code_in_buffer:=X"00";
                         
              elsif(scan_code_in_buffer=X"00") and (Key_code_recieved='1') then --Fill the output register
                scan_code_in_buffer:=scan_code_in;              
               end if;  
               code_to_display<=scan_code_in_buffer;  
         end if;
    end if;
    end process;

end keyboard_ctrl_arch;
