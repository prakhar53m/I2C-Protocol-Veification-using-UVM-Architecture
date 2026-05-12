# ==========================================
# Makefile for I2C UVM Verification Environment
# ==========================================

# Test name to run (can be overridden from command line)
TESTNAME ?= i2c_test

# Simulator verbosity
VERBOSITY ?= UVM_LOW

# Compilation targets and options
# -sverilog : Enable SystemVerilog support
# -ntb_opts uvm-1.2 : Use UVM 1.2 library
# -timescale=1ns/1ps : Define simulation time units
COMP_OPTS = -sverilog -ntb_opts uvm-1.2 -full64 -timescale=1ns/1ps

# Include directories so the compiler can find `include statements
INCDIR = +incdir+./tb \
         +incdir+./read_agents \
         +incdir+./write_agents \
         +incdir+./test

# Source files (Compilation order matters!)
# 1. RTL (Assuming it's in an rtl folder or root directory based on previous steps)
# 2. Interfaces
# 3. Assertions
# 4. UVM Package (which includes all the class files)
# 5. Top Module
SRC_FILES = rtl/i2c_slave_rtl.sv \
            tb/i2c_if.sv \
            tb/i2c_sva.sv \
            test/i2c_pkg.sv \
            tb/tb_top.sv

# ---------------------------------------------------------
# Main Targets
# ---------------------------------------------------------

.PHONY: all compile run clean

# Default target
all: clean compile run

# Compile the design and testbench
compile:
	@echo "====================================="
	@echo "Starting Compilation..."
	@echo "====================================="
	vcs $(COMP_OPTS) $(INCDIR) $(SRC_FILES) -l compile.log

# Run the simulation
run:
	@echo "====================================="
	@echo "Running Simulation: $(TESTNAME)"
	@echo "====================================="
	./simv +UVM_TESTNAME=$(TESTNAME) +UVM_VERBOSITY=$(VERBOSITY) -l sim.log

# Clean up simulation artifacts
clean:
	@echo "====================================="
	@echo "Cleaning up workspace..."
	@echo "====================================="
	rm -rf simv simv.daidir csrc *.log *.key ucli.key vc_hdrs.h DVEfiles *.vpd *.vdb