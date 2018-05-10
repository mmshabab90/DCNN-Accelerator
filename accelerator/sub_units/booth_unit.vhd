LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY booth_unit IS
    GENERIC(n : INTEGER := 17);
    PORT(
        CLK                         : IN  STD_LOGIC;
        RST                         : IN  STD_LOGIC;
        Start                       : IN  STD_LOGIC;
        Instr                       : IN  STD_LOGIC;
        LoopingAndResultNotReady    : IN  STD_LOGIC;
    
        Filter                      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        Window                      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        AdderBoothResult            : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        
        BoothXORCheck               : OUT STD_LOGIC;
        BoothResult                 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        BoothAddingOperand          : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        BoothP                      : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        LargeWindowShifted          : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch_booth_unit OF booth_unit IS
    --
    -- A, S & P Register Signals.
    --
    SIGNAL RegisterPEN      : STD_LOGIC;
    SIGNAL RegisterADin     : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL RegisterSDin     : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL RegisterPDin     : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL RegisterADout    : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL RegisterSDout    : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL RegisterPDout    : STD_LOGIC_VECTOR(n-1 DOWNTO 0);

    --
    -- Muxes Signals.
    --
    SIGNAL SelBoothOperand  : STD_LOGIC;
    SIGNAL SelPInput        : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL PMuxInputC       : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL PMuxInputD       : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL PMuxOutput       : STD_LOGIC_VECTOR(n-1 DOWNTO 0);

BEGIN

    --
    -- Output
    --
    BoothXORCheck       <= RegisterPDout(0) XOR RegisterPDout(1);
    BoothResult         <= RegisterPDout(8 DOWNTO 1);
    BoothP              <= RegisterPDout;
    LargeWindowShifted  <= PMuxInputC;

    --
    -- A, S & P Register Signals.
    --
    RegisterPEN     <= Start OR LoopingAndResultNotReady;
    RegisterADin    <= Filter & "000000000";
    RegisterSDin    <= STD_LOGIC_VECTOR(TO_UNSIGNED(TO_INTEGER(UNSIGNED((NOT Filter))) + 1, 8)) & "000000000";
    RegisterPDin    <= PMuxOutput;

    --
    -- Booth Operands (A/S) Mux Signals.
    --
    SelBoothOperand <= (NOT RegisterPDout(0));

    --
    -- P DataIn 4-1 Mux Signals.
    --
    PMuxInputC      <= "00000000" & Window & '0';
    PMuxInputD      <= "000000000" & Window;
    SelPInput       <= Start & Instr;

    --
    -- A, S & P Registers.
    --
    REGISTER_A:
    ENTITY work.register_edge_falling
    GENERIC MAP(n => 17)
    PORT MAP(CLK => CLK, RST => RST, EN => Start, Din => RegisterADin, Dout => RegisterADout);

    REGISTER_S:
    ENTITY work.register_edge_falling
    GENERIC MAP(n => 17)
    PORT MAP(CLK => CLK, RST => RST, EN => Start, Din => RegisterSDin, Dout => RegisterSDout);

    REGISTER_P:
    ENTITY work.register_edge_falling
    GENERIC MAP(n => 17)
    PORT MAP(CLK => CLK, RST => RST, EN => RegisterPEN, Din => RegisterPDin, Dout => RegisterPDout);

    --
    -- Booth Operands (A/S) Mux.
    --
    BoothAddingOperand      <=  RegisterADout       WHEN SelBoothOperand='0'    ELSE
                                RegisterSDout;

    --
    -- P DataIn 4-1 Mux.
    --
    PMuxOutput              <=  AdderBoothResult    WHEN SelPInput="00"         ELSE
                                AdderBoothResult    WHEN SelPInput="01"         ELSE
                                PMuxInputC          WHEN SelPInput="10"         ELSE
                                PMuxInputD;

END ARCHITECTURE;