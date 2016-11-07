----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:57:16 11/06/2015 
-- Design Name: 
-- Module Name:    chuan - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_signed.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity chuan is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           ready : in  STD_LOGIC;
           data : inout  STD_LOGIC_VECTOR(7 downto 0);
           mode : inout  STD_LOGIC_VECTOR(1 downto 0);
           data_in : in  STD_LOGIC_VECTOR(7 downto 0);
			  data_out : out STD_LOGIC_VECTOR(7 downto 0);
			  
			  tbre:in STD_LOGIC;
			  tsre:in STD_LOGIC;
			  wrn:out STD_LOGIC;
			  rdn:out STD_LOGIC;
			
			  ram1o : out STD_LOGIC;
			  ram1w : out STD_LOGIC;
			  ram1e : out STD_LOGIC
			  );
end chuan;

architecture Behavioral of chuan is
	shared variable state : integer range 0 to 13 := 0;
	shared variable tmp_data : std_logic_vector(7 downto 0) := "00000000";
	shared variable sig : integer range 0 to 1024 := 0;
begin
	process(clk,rst)
	begin
		if (rst = '0') then
			state:=0;
			data_out <= "00000000";
			ram1e <='1';
			ram1o <='1';
			ram1w <='1';
		elsif (clk' event and clk = '1') then
			if (sig = 1023) then
				if (mode = "00") then--write
					case state is
							when 0 =>
								wrn<='1';
								ram1e <='1';
								ram1o <='1';
								ram1w<='1';
								state:=1;
							when 1 => 
								data<=data_in;
								wrn<='0';
								state := 2;
							when 2 =>
								wrn<='1';
								state := 3;
							when 3 =>
								if (tbre = '1') then
									state := 4;
								end if;
							when 4 =>
								if (tsre = '1') then 
									state := 0;	
								end if;
							when others=>
					end case;
				elsif (mode = "01") then--read
					case state is
							when 0 =>
								ram1e <='1';
								ram1o <='1';
								ram1w<='1';
								state:=1;
							when 1 => 
								data <="ZZZZZZZZ";
								rdn<='1';
								state := 2;
							when 2 =>
								if (ready = '1') then
									rdn <= '0';
									state := 3;
								elsif (ready = '0') then
									state := 1;
								end if;
							when 3 =>
								data_out <= data;
								state :=1;
							when others=>
					end case;
				elsif (mode = "11") then--read and feedback
					case state is
						when 0 =>
							ram1e <='1';
							ram1o <='1';
							ram1w <='1';
							wrn  <='1';
							state:=state+1;
						when 1 => 
							rdn  <='1';
							data <="ZZZZZZZZ";
							state:=state+1;
						when 2 =>
							if (ready = '1') then
								rdn <= '0';
								state := 3;
							else
								state := 1;
							end if;
						when 3 =>
							data_out <= data;
							tmp_data:=data;
							rdn <= '1';
							wrn<='1';
							state:=state+1;
						when 4 =>
							tmp_data := tmp_data+1;
							state:=state+1;
						when 5 => 
							wrn<='0';
							data<=tmp_data;
							data_out<=tmp_data;
							state:=state+1;
						when 6 =>
							wrn<='1';
							state:=state+1;
		
						when 7 =>
							if (tbre = '1') then
								state:=state+1;

							end if;
						when 8 =>					
							if (tsre = '1') then 
								state:=0;
								
							end if;
						when others=>
					end case;
				end if;
				sig := 0;
			else
				if (sig < 1023) then
					sig := sig + 1;
				end if;
			end if;
		end if;
	end process;
end Behavioral;

