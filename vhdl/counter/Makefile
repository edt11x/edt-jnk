# vhdl files
FILES = source/*
VHDLEX = .vhd

# testbench
TESTBENCHPATH = testbench/${TESTBENCHFILE}${VHDLEX}
TESTBENCHFILE = ${TESTBENCH}_tb

#GHDL CONFIG
GHDL_CMD = /Applications/ghdl-0.35-llvm-macosx/bin/ghdl
GHDL_FLAGS = --ieee=synopsys --warn-no-vital-generic

SIMDIR = simulation
STOP_TIME = 500ns
# Simulation break condition
#GHDL_SIM_OPT = --assert-level=error
GHDL_SIM_OPT = --stop-time=$(STOP_TIME)

WAVEFORM_VIEWER = open /Applications/gtkwave.app --args

.PHONY: clean

all: clean make run view

compile:
	@echo "compiling"
	@$(GHDL_CMD) -i $(GHDL_FLAGS) --workdir=simulation --work=work $(TESTBENCHPATH) $(FILES)
	@$(GHDL_CMD) -m $(GHDL_FLAGS) --workdir=simulation --work=work $(TESTBENCHFILE)
	@echo "compiled"

make:
ifeq ($(strip $(TESTBENCH)),)
	@echo "TESTBENCH not set. Use TESTBENCH=<value> to set it."
	@exit 1
endif
	@echo "making"
	@mkdir -p simulation
	make compile TESTBENCH=${TESTBENCH}
	@mv ${TESTBENCHFILE} simulation/${TESTBENCHFILE}
	@echo "make done"

run:
	@echo "running"
	@${SIMDIR}/${TESTBENCHFILE} ${GHDL_SIM_OPT} --vcdgz=${SIMDIR}/${TESTBENCHFILE}.vcdgz
	@echo "run done"

view:
	@echo "viewing"
	@gunzip --stdout ${SIMDIR}/${TESTBENCHFILE}.vcdgz | ${WAVEFORM_VIEWER} --vcd
	@echo "view done"

clean:
	@rm -rf ${SIMDIR}

