LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY mini_alu IS
    GENERIC(n: INTEGER := 17);
    PORT(
        CLK, RST                        : IN  STD_LOGIC;
        Start                           : IN  STD_LOGIC;
        Instr                           : IN  STD_LOGIC;
        Size                            : IN  STD_LOGIC;
        ResultReady                     : IN  STD_LOGIC;
        CalculatingBooth                : IN  STD_LOGIC;
        FilterCell                      : IN  STD_LOGIC_VECTOR(  7 DOWNTO 0);
        WindowCell                      : IN  STD_LOGIC_VECTOR(  7 DOWNTO 0);
        AdderFirstOperand               : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        AdderSecondOperand              : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    
        Result                          : OUT STD_LOGIC_VECTOR(  7 DOWNTO 0);
        AdderResult                     : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        OperationResult                 : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch_mini_alu OF mini_alu IS

    --
    -- Booth Unit Signals.
    --
    SIGNAL AddPToBoothOperand           : STD_LOGIC;
    SIGNAL BoothOperand                 : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL BoothP                       : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL WindowCellShiftedLeft        : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    
    --  
    -- Booth Adder Signals. 
    --  
    SIGNAL SelectBoothOperandsForAdder  : STD_LOGIC;
    SIGNAL NewBoothP                    : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL TmpAdderResult               : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    
    --  
    -- Operation Result Mux Signals.    
    --  
    SIGNAL OperationResultBeforeShift   : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    
    --  
    -- Result Shift Mux Signals.    
    --  
    SIGNAL ConvolutionResult            : STD_LOGIC_VECTOR(  7 DOWNTO 0);
    
    --  
    -- Pooling Shift Mux Signals.   
    --  
    SIGNAL PoolingSmallWindow           : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL PoolingLargeWindow           : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL PoolingResult                : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    --
    -- Outputs.
    --
    OperationResult         <= OperationResultBeforeShift(n-1) & OperationResultBeforeShift(n-1 DOWNTO 1);
    AdderResult             <= TmpAdderResult;
    
    --  
    -- Result Shift Mux.    
    --  
    ConvolutionResult       <= TmpAdderResult(7 DOWNTO 0);
    
    --  
    -- Pooling Shift Mux
    --  
    PoolingSmallWindow      <= "000"   & TmpAdderResult(7 DOWNTO 3);
    PoolingLargeWindow      <= "00000" & TmpAdderResult(7 DOWNTO 5);

    --
    -- Booth Adder.
    --
    SelectBoothOperandsForAdder <= Instr NOR ResultReady;


    BOOTH_ADDER:
    ENTITY work.booth_adder
    GENERIC MAP(n => n)
    PORT MAP( 
        AdderFirstOperand           => AdderFirstOperand,
        AdderSecondOperand          => AdderSecondOperand,
        BoothOperand                => BoothOperand,
        BoothP                      => BoothP,

        SelectBoothOperandsForAdder => SelectBoothOperandsForAdder,
        AddPToBoothOperand          => AddPToBoothOperand,

        AdderResult                 => TmpAdderResult,
        NewBoothP                   => NewBoothP
    );

    --
    -- Booth Unit.
    --
    BOOTH_UNIT:
    ENTITY work.booth_unit
    GENERIC MAP(n => n)
    PORT MAP(
        CLK                         => CLK,
        RST                         => RST, 
        Start                       => Start, 
        Instr                       => Instr, 
        CalculatingBooth            => CalculatingBooth, 
        FilterCell                  => FilterCell, 
        WindowCell                  => WindowCell,
        NewBoothP                   => NewBoothP, 
        AddPToBoothOperand          => AddPToBoothOperand, 
        BoothOperand                => BoothOperand,
        BoothP                      => BoothP, 
        WindowCellShiftedLeft       => WindowCellShiftedLeft
    );

    --
    -- Operation Result Mux.
    --
    OperationResultBeforeShift  <=  BoothP                  WHEN Instr='0' ELSE
                                    WindowCellShiftedLeft;
                                
    --
    -- Result Shift Mux.
    --
    Result                      <=  ConvolutionResult       WHEN Instr='0' ELSE
                                    PoolingResult;
    --
    -- Pooling Result Mux.
    --
    PoolingResult               <=  PoolingSmallWindow      WHEN Size='0' ELSE
                                    PoolingLargeWindow;

END ARCHITECTURE;
