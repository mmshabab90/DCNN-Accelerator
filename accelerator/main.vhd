LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.COMMON.ALL;

ENTITY main IS
    PORT(
        CLK, RST            : IN  STD_LOGIC;
        Start               : IN  STD_LOGIC;
        FilterSize          : IN  STD_LOGIC;    -- 0: 3x3, 1: 5x5
        Stride              : IN  STD_LOGIC;    -- Step = Stride + 1
        Instr               : IN  STD_LOGIC;    -- 0: Convolution, 1: Pooling
        Done                : OUT STD_LOGIC     -- Finish the whole operation
    );
END ENTITY;

ARCHITECTURE arch_main OF main IS

    SIGNAL FirstCycle       : STD_LOGIC;

    SIGNAL MemRD            : STD_LOGIC;
    SIGNAL MemWR            : STD_LOGIC;
    SIGNAL MemAddr          : STD_LOGIC_VECTOR(17 DOWNTO 0);
    SIGNAL MemDin           : STD_LOGIC_VECTOR( 7 DOWNTO 0);
    SIGNAL MemDout          : STD_LOGIC_VECTOR(39 DOWNTO 0);

    SIGNAL CacheRST         : STD_LOGIC;

    SIGNAL CacheFilterWR    : STD_LOGIC;
    SIGNAL CacheWindowWR    : STD_LOGIC;
    SIGNAL CacheResultWR    : STD_LOGIC;

    SIGNAL CacheFilter      : MATRIX_BYTE(0 TO 4, 0 TO 4);
    SIGNAL CacheWindow      : MATRIX_BYTE(0 TO 4, 0 TO 4);

    SIGNAL AccStartCalc     : STD_LOGIC;
    SIGNAL AccFinishCalc    : STD_LOGIC;
    SIGNAL AccResult        : STD_LOGIC_VECTOR( 7 DOWNTO 0);

BEGIN

    --===================================================================================
    --
    -- Controller
    --

    CONTROLLER:
    ENTITY work.controller
    PORT MAP(
        CLK                 => CLK,
        RST                 => RST,
        Start               => Start,
        FilterSize          => FilterSize,
        Stride              => Stride,
        Instr               => Instr,
        
        CalcFinished        => AccFinishCalc,
        Calc                => AccStartCalc,

        MemRD               => MemRD,
        MemWR               => MemWR,
        MemAddr             => MemAddr,

        CacheFilterWR       => CacheFilterWR,
        CacheWindowWR       => CacheWindowWR,

        FirstCycle          => FirstCycle,
        Done                => Done
    );

    --===================================================================================
    --
    -- Accelerator
    --

    ACCELERATOR:
    ENTITY work.accelerator
    PORT MAP(
        CLK                 => CLK,
        RST                 => RST,
        Start               => AccStartCalc,
        FilterSize          => FilterSize,
        Instr               => Instr,

        FilterDin           => CacheFilter,
        WindowDin           => CacheWindow,

        Done                => AccFinishCalc,
        Result              => AccResult
    );

    --===================================================================================
    --
    -- RAM & Cache
    --

    RAM:
    ENTITY work.RAM
    GENERIC MAP(n => 8, m => 18)
    PORT MAP(
        CLK                 => CLK,
        WR                  => MemWR,
        Address             => MemAddr,
        Din                 => MemDin,
        Dout                => MemDout
    );

    CacheRST <= RST OR FirstCycle;

    CACHE:
    ENTITY work.cache
    PORT MAP(
        CLK                 => CLK,
        RST                 => CacheRST,

        FilterSize          => FilterSize,
        FilterWR            => CacheFilterWR,
        WindowWR            => CacheWindowWR,
        Din                 => MemDout,

        FilterDout          => CacheFilter,
        WindowDout          => CacheWindow,

        ResultWR            => CacheResultWR,
        ResultDin           => AccResult,
        ResultDout          => MemDin
    );

END ARCHITECTURE;