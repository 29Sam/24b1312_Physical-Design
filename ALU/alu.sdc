# ==============================================================================
# alu.sdc  –  Timing Constraints File for ALU
#
# This SDC describes:
#  - Basic timing units
#  - Clock definition
#  - Input/output delays
#  - Clock uncertainty
#  - Input transition times
#  - Reset as a false path
#
# Each line is commented so students can understand why the constraint exists.
# ==============================================================================


# ------------------------------------------------------------------------------
# Units: Define the units the tool should assume for time and capacitance.
# ------------------------------------------------------------------------------
set_units -time 1ns
set_units -capacitance 1pF


# ------------------------------------------------------------------------------
# Clock Definition
# ------------------------------------------------------------------------------
set EXTCLK        "clk"      ;# Name of the clock port in the design
set EXTCLK_PERIOD 10.0       ;# 100 MHz clock → 10 ns period

# Create the primary clock on port `clk`
create_clock -name $EXTCLK -period $EXTCLK_PERIOD [get_ports $EXTCLK]


# ------------------------------------------------------------------------------
# Basic Timing Margins (safety buffers)
# These margins model uncertainty, skew, and real-world jitter.
# ------------------------------------------------------------------------------
set SETUP    0.100           ;# Extra margin before clock edge (setup time)
set HOLD     0.100           ;# Extra margin after clock edge (hold time)
set INDELAY  0.100           ;# External input delay from upstream logic
set OUTDELAY 0.100           ;# External output delay to downstream logic

# Add uncertainty on the clock (tool considers this during STA)
set_clock_uncertainty -setup $SETUP [get_clocks $EXTCLK]
set_clock_uncertainty -hold  $HOLD  [get_clocks $EXTCLK]


# ------------------------------------------------------------------------------
# Input Delays
# These model the time taken for external logic → ALU inputs.
# ------------------------------------------------------------------------------
set_input_delay -clock [get_clocks $EXTCLK] $INDELAY [get_ports reset]
set_input_delay -clock [get_clocks $EXTCLK] $INDELAY [get_ports {A[*]}]
set_input_delay -clock [get_clocks $EXTCLK] $INDELAY [get_ports {B[*]}]
set_input_delay -clock [get_clocks $EXTCLK] $INDELAY [get_ports {ALU_Sel[*]}]


# ------------------------------------------------------------------------------
# Output Delays
# These model ALU → external logic timing.
# ------------------------------------------------------------------------------
set_output_delay -clock [get_clocks $EXTCLK] $OUTDELAY [get_ports {ALU_Out[*]}]
set_output_delay -clock [get_clocks $EXTCLK] $OUTDELAY [get_ports CarryOut]


# ------------------------------------------------------------------------------
# Input Transition Times
# These model how fast the external signals switch.
# IMPORTANT: value must come FIRST (numeric-first formatting).
# ------------------------------------------------------------------------------
# A bus
set_input_transition 0.8 -min  -rise [get_ports {A[*]}]
set_input_transition 0.8 -min  -fall [get_ports {A[*]}]
set_input_transition 0.8 -max  -rise [get_ports {A[*]}]
set_input_transition 0.8 -max  -fall [get_ports {A[*]}]

# B bus
set_input_transition 0.8 -min  -rise [get_ports {B[*]}]
set_input_transition 0.8 -min  -fall [get_ports {B[*]}]
set_input_transition 0.8 -max  -rise [get_ports {B[*]}]
set_input_transition 0.8 -max  -fall [get_ports {B[*]}]

# ALU select bus
set_input_transition 0.8 -min  -rise [get_ports {ALU_Sel[*]}]
set_input_transition 0.8 -min  -fall [get_ports {ALU_Sel[*]}]
set_input_transition 0.8 -max  -rise [get_ports {ALU_Sel[*]}]
set_input_transition 0.8 -max  -fall [get_ports {ALU_Sel[*]}]


# ------------------------------------------------------------------------------
# (Optional) Output transition times
# Uncomment if outputs must meet external rising/falling speed.
# ------------------------------------------------------------------------------
# set_output_transition 0.8 -min -rise [get_ports {ALU_Out[*]}]
# set_output_transition 0.8 -max -fall [get_ports CarryOut]


# ------------------------------------------------------------------------------
# Asynchronous reset handling
# RESET is not part of timing paths → mark it as false path.
# ------------------------------------------------------------------------------
set_false_path -from [get_ports reset]
set_false_path -to   [get_ports reset]


# End of SDC
