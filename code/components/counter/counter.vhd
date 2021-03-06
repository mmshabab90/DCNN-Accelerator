LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY counter IS
    GENERIC(n: INTEGER := 4);
    PORT(
        CLK, RST, EN        : IN    STD_LOGIC;
        Dout                : INOUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch_counter OF counter IS
BEGIN

    PROCESS(CLK, RST)
    BEGIN
        IF RST='1' THEN
            Dout <= (OTHERS => '0');
        ELSIF RISING_EDGE(CLK) THEN
            IF EN='1' THEN
                Dout <= Dout + 1;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;