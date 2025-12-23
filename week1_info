# Physical Design Examples – Full Adder and Kogge–Stone Adder

This repository contains two ASIC design examples implemented using OpenLane’s full RTL to GDS flow on the Sky130A PDK:

- fa – clocked 1-bit full adder  
- ks_adder – multi-bit Kogge–Stone adder  

Each design includes:

- Synthesizable Verilog RTL  
- Validated OpenLane `config.tcl`  
- Ready-to-run full-flow invocation  

---

## Repository Structure

- `fa/`
  - `src/fa.v`
  - `config.tcl`
- `ks_adder/`
  - `src/ks_adder.v`
  - `config.tcl`

Both folders are complete and directly runnable with:

```bash
./flow.tcl -design <design_name> -tag run1 -overwrite
```
To add your design:

```bash
./flow.tcl -design <design_name> -init_design_config -add_to_designs -config_file config.tcl
```
# 1. Setup Instructions
Prerequisites

- Linux (Ubuntu recommended)

- Docker installed

- OpenLane installed (or use the official Docker image)

- Sky130A PDK installed (OpenLane downloads it automatically on first use)

## Enter the OpenLane environment:
```bash
cd /openlane
make mount
```
# 2. Running the Full Flow
## Full Adder (fa)

- Run the full RTL to GDS flow:
```bash
./flow.tcl -design fa -tag run1 -overwrite
```

### The following steps run automatically:

- Synthesis

- Static Timing Analysis

- Floorplanning

- PDN generation

- Placement

- Clock Tree Synthesis

- Routing

- Magic DRC

- LVS

- GDS export

### Results are located at:
```bash
designs/fa/runs/run1/
```
### fa Design Description

- RTL (fa.v)
- A synchronous 1-bit full adder with one pipeline stage.

- Inputs: clk, a, b, cin
- Outputs: sum, cout

### config.tcl notes

- `CLOCK_PORT = clk, CLOCK_PERIOD = 10ns`

- `Die area set to 50 × 50 microns`

- `PDN auto-adjust disabled`

- `CTS and STA enabled`

- `Magic, LVS, and GDS export enabled`

# 3. Running the Kogge–Stone Adder (ks_adder)
```bash
./flow.tcl -design ks_adder -tag run1 -overwrite
```
###  Results are located at:
```bash
designs/ks_adder/runs/run1/
```
### ks_adder Design Description

- RTL (ks_adder.v)
- A multi-bit Kogge–Stone parallel prefix adder.
- Synchronous version with a real clock input.

### config.tcl notes

- `CLOCK_PORT = clk, CLOCK_PERIOD = 10ns`

- `Die area set to 80 × 80 microns (adjust based on bit width)`

- `CTS and STA enabled`

- `PDN pitch fixed for reliability`

- `Magic, LVS, and GDS export enabled`
