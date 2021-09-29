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

    signal reg1,reg2,reg3,reg4:unsigned(7 downto 0);
    type reg_state is(breakcode, break_makecode,makecode);
    signal reg_current,reg_next:reg_state;
    signal counter,counter_next:unsigned(1 downto 0);


begin

    Controller_clock: process(clk,valid_code)
    begin
        if(rst='1')then
            reg_current<= makecode; --reset the values
            reg1<="00000000"; -- reg registers are used to store the pressed buttons (only 4 buttons can be stored)
            reg2<="00000000";
            reg3<="00000000";
            reg4<="00000000";
            counter<="00";
        elsif rising_edge(clk)then
            reg_current<=reg_next;  --(load the next keycode to the seven segment display
            counter <= counter_next;
            if reg_current=break_makecode and valid_code='1'then  --if a key has been pressed and then released, shift the registers and insert the new value
                reg1<=scan_code_in;
                reg2<=reg1;
                reg3<=reg2;
                reg4<=reg3;
            end if;
        end if;
    end process;



    State_machine: process(reg_current,valid_code,scan_code_in) --3 states, the sequence should go as: makecode->breakcode->breakmakecode
    begin
        case reg_current is
            when makecode => 
                if valid_code ='1' and scan_code_in="11110000"then  --check to see if a breakcode has been recieved
                    reg_next <= breakcode;
                else
                    reg_next <= makecode;
                end if;
            when breakcode =>
                if valid_code ='1' then
                    if scan_code_in="11110000"then
                        reg_next <= breakcode;
                    else
                        reg_next <=break_makecode; --when the key is released we reviece the code for that key, this is a 3rd state, diffrent from a simple makecode
                    end if;
                end if;
            when break_makecode => 
                if valid_code ='1' and scan_code_in="11110000"then 
                    reg_next <= breakcode;
                else
                    reg_next <=makecode;
                end if;
        end case;
    end process;


    Seg_driver: process(counter,reg1,reg2,reg3,reg4) -- scans each 7-seg display with a shift register, changes the code to display, according to the register enabled
    begin
        counter_next <= counter + 1;

        code_to_display <= "00000000";

        case counter is
            when "00" =>
                if reg1 = "00000000" then
                    seg_en <= "1111";
                else
                    code_to_display <= reg1;
                    seg_en <= "1110";
                end if;
            when "01" =>
                if reg2 = "00000000" then
                    seg_en <= "1111";
                else
                    code_to_display <= reg2;
                    seg_en <= "1101";
                end if;
            when "10" =>
                if reg3 = "00000000" then
                    seg_en <= "1111";
                else
                    code_to_display <= reg3;
                    seg_en <= "1011";
                end if;
            when "11" =>
                if reg4 = "00000000" then
                    seg_en <= "1111";
                else
                    code_to_display <= reg4;
                    seg_en <= "0111";
                end if;
            when others =>
                seg_en <= "1111";
        end case;
    end process;
end keyboard_ctrl_arch;
