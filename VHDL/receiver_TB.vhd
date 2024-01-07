library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity receiver_tb is
end receiver_tb;

architecture TB_ARCHITECTURE of receiver_tb is
	-- Component declaration of the tested unit
	component receiver
	port(
		clk : in STD_LOGIC;
		ps2_clk : in STD_LOGIC;
		ps2_data : in STD_LOGIC;
		data : out STD_LOGIC_VECTOR(7 downto 0);
		data_ready : out STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal ps2_clk : STD_LOGIC;
	signal ps2_data : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal data : STD_LOGIC_VECTOR(7 downto 0);
	signal data_ready : STD_LOGIC;

	
	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : receiver
		port map (
			clk => clk,
			ps2_clk => ps2_clk,
			ps2_data => ps2_data,
			data => data,
			data_ready => data_ready
		);

    p: process
    begin
        clk  <= '1';
        wait for 10ns;
        clk <= '0';
        wait for 10ns;
    end process p;	 
    p2: process
    begin
        ps2_clk  <= '1';
        wait for 25ns;
        ps2_clk <= '0';
        wait for 25ns;
    end process p2;
	-- Add your stimulus here ...

		test: process
	begin
		ps2_data <= '1';							  
		wait for 55ns;
		ps2_data <= '0';
		wait for 50ns;	
		ps2_data <= '0';							  
		wait for 50ns;
		ps2_data <= '1';
		wait for 50ns;
		ps2_data <= '1';							  
		wait for 50ns;
		ps2_data <= '0';
		wait for 50ns;
		ps2_data <= '1';							  
		wait for 50ns;
		ps2_data <= '0';
		wait for 50ns; 
		ps2_data <= '0';
		wait for 50ns;		
		ps2_data <= '0';
		wait for 50ns;
		ps2_data <= '0';
		wait for 50ns;
		ps2_data <= '1';
		wait for 50ns;
		ps2_data <= '1';
		wait for 50ns;	 
		
		ps2_data <= '0';
		wait for 50ns;	
		ps2_data <= '1';							  
		wait for 50ns;
		ps2_data <= '0';
		wait for 50ns;
		ps2_data <= '1';							  
		wait for 50ns;
		ps2_data <= '0';
		wait for 50ns;
		ps2_data <= '1';							  
		wait for 50ns;
		ps2_data <= '0';
		wait for 50ns; 
		ps2_data <= '1';
		wait for 50ns;		
		ps2_data <= '0';
		wait for 50ns;
		ps2_data <= '1';
		wait for 50ns;
		ps2_data <= '1';
		wait for 50ns;  		
		
		wait;
	end process test;
	

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_receiver of receiver_tb is
	for TB_ARCHITECTURE
		for UUT : receiver
			use entity work.receiver(rtl);
		end for;
	end for;
end TESTBENCH_FOR_receiver;

