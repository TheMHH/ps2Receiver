LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY Receiver IS
    PORT (
        clk : IN STD_LOGIC;
        ps2_clk : IN STD_LOGIC;
        ps2_data : IN STD_LOGIC;
        data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        data_ready : OUT STD_LOGIC
    );
END Receiver;
ARCHITECTURE rtl OF Receiver IS
    SIGNAL ps2_neg_edge : STD_LOGIC;
    SIGNAL last_ps2_clk : STD_LOGIC := '1';
    SIGNAL temp_data : STD_LOGIC_VECTOR(8 DOWNTO 0);
BEGIN								   						  
	
    ps2_neg_edge <= last_ps2_clk AND (NOT ps2_clk);
    data <= temp_data(8 DOWNTO 1);

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            last_ps2_clk <= ps2_clk;
        END IF;
    END PROCESS;

    PROCESS (clk)
        VARIABLE index : INTEGER range -20 to 20 := - 1;
    BEGIN
        IF rising_edge(clk) THEN
            IF ps2_neg_edge = '1' THEN
                IF index = -1 AND ps2_data = '0' THEN
                    index := 0;
                    data_ready <= '0';
                ELSIF index > -1 THEN
                    temp_data(8 - index) <= ps2_data;
                    index := index + 1;
                    IF index = 9 THEN
                        data_ready <= '1';
                        index := - 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE rtl;