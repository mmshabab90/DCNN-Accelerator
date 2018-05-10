# ACCELERATOR BASE UNIT
vsim -gui work.accelerator

# Add Signals
add wave  \
sim:/accelerator/CLK \
sim:/accelerator/RST \
sim:/accelerator/Start \
sim:/accelerator/FilterSize \
sim:/accelerator/Instr \
sim:/accelerator/FilterDin \
sim:/accelerator/WindowDin \
sim:/accelerator/Done \
sim:/accelerator/Result \
sim:/accelerator/L5Results \
sim:/accelerator/L5ResultsLarge \
sim:/accelerator/L5OperationResults \
sim:/accelerator/L1Results
add wave -position insertpoint sim:/accelerator/L1(0)/L2(0)/G1/MINI_ALU/Filter
add wave -position insertpoint sim:/accelerator/L1(0)/L2(1)/G1/MINI_ALU/Filter
add wave -position insertpoint sim:/accelerator/L1(0)/L2(2)/G1/MINI_ALU/Filter
add wave -position insertpoint sim:/accelerator/L1(0)/L2(3)/G1/MINI_ALU/Filter
add wave -position insertpoint sim:/accelerator/L1(0)/L2(4)/G1/MINI_ALU/Filter

add wave -position insertpoint sim:/accelerator/L1(1)/L2(0)/G1/MINI_ALU/Filter
add wave -position insertpoint sim:/accelerator/L1(1)/L2(1)/G1/MINI_ALU/Filter
add wave -position insertpoint sim:/accelerator/L1(1)/L2(2)/G1/MINI_ALU/Filter
add wave -position insertpoint sim:/accelerator/L1(1)/L2(3)/G1/MINI_ALU/Filter
add wave -position insertpoint sim:/accelerator/L1(1)/L2(4)/G1/MINI_ALU/Filter

add wave -position insertpoint sim:/accelerator/L1(2)/L2(0)/G1/MINI_ALU/Filter
add wave -position insertpoint sim:/accelerator/L1(2)/L2(1)/G1/MINI_ALU/Filter
add wave -position insertpoint sim:/accelerator/L1(2)/L2(2)/G1/MINI_ALU/Filter
add wave -position insertpoint sim:/accelerator/L1(2)/L2(3)/G2/MINI_ALU/Filter
add wave -position insertpoint sim:/accelerator/L1(2)/L2(4)/G2/MINI_ALU/Filter


force -freeze sim:/accelerator/CLK 1 0, 0 {50 ns} -r 100
force -freeze sim:/accelerator/RST 1 0
force -freeze sim:/accelerator/Start 0 0
force -freeze sim:/accelerator/FilterSize 0 0
force -freeze sim:/accelerator/Instr 0 0

# Force Filters
force -freeze sim:/accelerator/WindowDin(0)(0) x\"00\" 0
force -freeze sim:/accelerator/WindowDin(0)(1) x\"00\" 0
force -freeze sim:/accelerator/WindowDin(0)(2) x\"00\" 0
force -freeze sim:/accelerator/WindowDin(0)(3) x\"00\" 0
force -freeze sim:/accelerator/WindowDin(0)(4) x\"00\" 0

force -freeze sim:/accelerator/WindowDin(1)(0) x\"00\" 0
force -freeze sim:/accelerator/WindowDin(1)(1) x\"00\" 0
force -freeze sim:/accelerator/WindowDin(1)(2) x\"00\" 0
force -freeze sim:/accelerator/WindowDin(1)(3) x\"00\" 0
force -freeze sim:/accelerator/WindowDin(1)(4) x\"00\" 0

force -freeze sim:/accelerator/WindowDin(2)(0) x\"FF\" 0
force -freeze sim:/accelerator/WindowDin(2)(1) x\"FF\" 0
force -freeze sim:/accelerator/WindowDin(2)(2) x\"FF\" 0
force -freeze sim:/accelerator/WindowDin(2)(3) x\"00\" 0
force -freeze sim:/accelerator/WindowDin(2)(4) x\"00\" 0

force -freeze sim:/accelerator/WindowDin(3)(0) x\"FF\" 0
force -freeze sim:/accelerator/WindowDin(3)(1) x\"FF\" 0
force -freeze sim:/accelerator/WindowDin(3)(2) x\"FF\" 0
force -freeze sim:/accelerator/WindowDin(3)(3) x\"00\" 0
force -freeze sim:/accelerator/WindowDin(3)(4) x\"00\" 0

force -freeze sim:/accelerator/WindowDin(4)(0) x\"FF\" 0
force -freeze sim:/accelerator/WindowDin(4)(1) x\"FF\" 0
force -freeze sim:/accelerator/WindowDin(4)(2) x\"FF\" 0
force -freeze sim:/accelerator/WindowDin(4)(3) x\"00\" 0
force -freeze sim:/accelerator/WindowDin(4)(4) x\"00\" 0


force -freeze sim:/accelerator/FilterDin(0)(0) x\"00\" 0
force -freeze sim:/accelerator/FilterDin(0)(1) x\"00\" 0
force -freeze sim:/accelerator/FilterDin(0)(2) x\"00\" 0
force -freeze sim:/accelerator/FilterDin(0)(3) x\"00\" 0
force -freeze sim:/accelerator/FilterDin(0)(4) x\"00\" 0

force -freeze sim:/accelerator/FilterDin(1)(0) x\"00\" 0
force -freeze sim:/accelerator/FilterDin(1)(1) x\"00\" 0
force -freeze sim:/accelerator/FilterDin(1)(2) x\"00\" 0
force -freeze sim:/accelerator/FilterDin(1)(3) x\"00\" 0
force -freeze sim:/accelerator/FilterDin(1)(4) x\"00\" 0

force -freeze sim:/accelerator/FilterDin(2)(0) x\"01\" 0
force -freeze sim:/accelerator/FilterDin(2)(1) x\"01\" 0
force -freeze sim:/accelerator/FilterDin(2)(2) x\"01\" 0
force -freeze sim:/accelerator/FilterDin(2)(3) x\"00\" 0
force -freeze sim:/accelerator/FilterDin(2)(4) x\"00\" 0

force -freeze sim:/accelerator/FilterDin(3)(0) x\"01\" 0
force -freeze sim:/accelerator/FilterDin(3)(1) x\"01\" 0
force -freeze sim:/accelerator/FilterDin(3)(2) x\"01\" 0
force -freeze sim:/accelerator/FilterDin(3)(3) x\"00\" 0
force -freeze sim:/accelerator/FilterDin(3)(4) x\"00\" 0

force -freeze sim:/accelerator/FilterDin(4)(0) x\"01\" 0
force -freeze sim:/accelerator/FilterDin(4)(1) x\"01\" 0
force -freeze sim:/accelerator/FilterDin(4)(2) x\"01\" 0
force -freeze sim:/accelerator/FilterDin(4)(3) x\"00\" 0
force -freeze sim:/accelerator/FilterDin(4)(4) x\"00\" 0

run
force -freeze sim:/accelerator/RST 0 0
force -freeze sim:/accelerator/Start 1 0
run
force -freeze sim:/accelerator/Start 0 0
