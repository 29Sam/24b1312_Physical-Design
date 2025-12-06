##############################################################
# OpenLane Configuration for design: ks_adder 
#
# Instructions:
#   Set the variables in the "USER-SET PARAMETERS" section. (For ex. t=10.0)
#   Each variable affects the OpenLane flow (timing, area, PDN,
#   routing difficulty, signoff, etc.).
#
#   Do NOT change anything below the variable declarations
#   unless instructed — the rest of the file consumes these
#   variables automatically.
##############################################################

##############################################################
# =============== USER-SET PARAMETERS =========================
##############################################################

# --- Clock Parameters ---
set CLOCK_NAME              "clk"
set CLOCK_PERIOD_NS         t

# --- Floorplan Parameters ---
set DIE_X1                  a
set DIE_Y1                  b
set DIE_X2                  c
set DIE_Y2                  d
set CORE_UTILIZATION        e

# --- PDN Parameters ---
set PDN_VPITCH              f
set PDN_HPITCH              g

# --- Placement Density Constraints ---
set PLACE_MIN_UTIL          h
set PLACE_MAX_UTIL          i

# --- Flow Control (1 = enable, 0 = disable) ---
set ENABLE_SYNTH            0
set ENABLE_FLOORPLAN        0
set ENABLE_PDN              0
set ENABLE_PLACEMENT        0
set ENABLE_CTS              0
set ENABLE_RESIZER          0
set ENABLE_RTLMP            0
set ENABLE_ROUTING          0
set ENABLE_FILL             0
set ENABLE_DIODE_INSERT     0
set ENABLE_POSTCTS_RESIZE   0
set ENABLE_POSTCTS_GATE     0
set ENABLE_POSTPNR_TIMING   0

# --- Signoff Stages ---
set ENABLE_STA              0
set ENABLE_MAGIC            0
set ENABLE_MAGIC_DRC        0
set ENABLE_KLAYOUT          0
set ENABLE_LVS              0
# --- Additional Heavy Analyses ---
set ENABLE_SPEF             0
set ENABLE_IRDROP           0
set ENABLE_CVC              0

##############################################################
# =============== DO NOT EDIT BELOW THIS LINE ===============
##############################################################

set ::env(DESIGN_NAME) "ks_adder"

if {![info exists ::env(DESIGN_DIR)]} {
    set ::env(DESIGN_DIR) [file normalize \
        [file join [pwd] "designs" $::env(DESIGN_NAME)]]
}

# RTL sources
set ::env(VERILOG_FILES) \
    [glob -nocomplain -directory $::env(DESIGN_DIR) src/*.v]
if {$::env(VERILOG_FILES) == {}} {
    set ::env(VERILOG_FILES) \
        [glob -nocomplain $::env(DESIGN_DIR)/*.v]
}

# PDK / Std Cell Library
set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

# Clock & SDC
set ::env(CLOCK_PORT)        $CLOCK_NAME
set ::env(CLOCK_PERIOD)      $CLOCK_PERIOD_NS
set ::env(BASE_SDC_FILE)     "$::env(DESIGN_DIR)/ks_adder.sdc"

# Core configuration
set ::env(DESIGN_IS_CORE)    1
set ::env(USE_POWER_PINS)    0

# Floorplan
set ::env(FP_SIZING)         "absolute"
set ::env(DIE_AREA)          "$DIE_X1 $DIE_Y1 $DIE_X2 $DIE_Y2"
set ::env(FP_CORE_UTIL)      $CORE_UTILIZATION

# PDN
set ::env(FP_PDN_AUTO_ADJUST) 0
set ::env(FP_PDN_VPITCH)       $PDN_VPITCH
set ::env(FP_PDN_HPITCH)       $PDN_HPITCH

# Placement density
set ::env(PL_MIN_UTIL)         $PLACE_MIN_UTIL
set ::env(PL_MAX_UTIL)         $PLACE_MAX_UTIL
set ::env(RUN_SEED)            1234

##############################################################
# Flow stage enables
##############################################################

set ::env(RUN_SYNTH)                    $ENABLE_SYNTH
set ::env(RUN_FLOORPLAN)                $ENABLE_FLOORPLAN
set ::env(RUN_PDN)                      $ENABLE_PDN
set ::env(RUN_PL)                       $ENABLE_PLACEMENT
set ::env(RUN_CTS)                      $ENABLE_CTS
set ::env(RUN_RESIZER)                  $ENABLE_RESIZER
set ::env(RUN_RTLMP)                    $ENABLE_RTLMP
set ::env(RUN_ROUTING)                  $ENABLE_ROUTING
set ::env(RUN_FILL)                     $ENABLE_FILL
set ::env(RUN_DIODE_INSERTION)          $ENABLE_DIODE_INSERT
set ::env(RUN_POST_CTS_RESIZER_TIMING)  $ENABLE_POSTCTS_RESIZE
set ::env(RUN_POST_CTS_GATE_RESIZER_TIMING) $ENABLE_POSTCTS_GATE
set ::env(RUN_POST_PNR_TIMING)          $ENABLE_POSTPNR_TIMING

# Signoff
set ::env(RUN_STA)                      $ENABLE_STA
set ::env(RUN_MAGIC)                    $ENABLE_MAGIC
set ::env(RUN_MAGIC_DRC)                $ENABLE_MAGIC_DRC
set ::env(RUN_KLAYOUT)                  $ENABLE_KLAYOUT
set ::env(RUN_LVS)                      $ENABLE_LVS

# Heavy analysis
set ::env(RUN_SPEF_EXTRACTION)          $ENABLE_SPEF
set ::env(RUN_IRDROP_REPORT)            $ENABLE_IRDROP
set ::env(RUN_CVC)                      $ENABLE_CVC

##############################################################
# Optimization & debug
##############################################################

set ::env(ENABLE_TRANSFORMATIONS) 1
set ::env(PL_INSERT_BUFFERS)      1
set ::env(CLOCK_PORTS)            $::env(CLOCK_PORT)
set ::env(RUN_LOG_LEVEL)          "INFO"

##############################################################
# Optional tech-specific overrides
##############################################################

set tech_specific_config \
    "$::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl"

if {[file exists $tech_specific_config]} {
    source $tech_specific_config
}
