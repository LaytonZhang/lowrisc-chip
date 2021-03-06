export CROSSCOMPILE=riscv64-buildroot-linux-gnu-
export STRIP=${CROSSCOMPILE}strip
export XILINX_VER=2018.2
export XILINX_ROOT=/opt/Xilinx
export XILINX_VIVADO=$(XILINX_ROOT)/Vivado/$(XILINX_VER)
export PATH=$(XILINX_VIVADO)/bin:$(XILINX_ROOT)/SDK/$(XILINX_VER)/bin:/$(RISCV)/bin:/usr/sbin:/usr/bin:/sbin:/bin

VIVADO ?= vivado
VIVADOFLAGS ?= -nojournal -mode batch -source scripts/prologue.tcl

work-dir := work-fpga/$(BOARD)_$(CPU)
bit := $(work-dir)/$(CPU)_xilinx.bit
mcs := $(work-dir)/$(CPU)_xilinx.mcs
ip-dir := xilinx
ips := xlnx_axi_clock_converter.xci  \
       xlnx_axi_dwidth_converter.xci \
       xlnx_axi_quad_spi.xci         \
       xlnx_axi_gpio.xci             \
       xlnx_clk_$(BOARD).xci         \
       xlnx_clk_sd.xci               \
       xlnx_char_fifo.xci            \
       xlnx_ila_4.xci                \
       xlnx_ila_qspi.xci             \
       xlnx_ila_perf.xci             \
       xlnx_mig_7_ddr_$(BOARD).xci

ips := $(addprefix $(work-dir)/, $(ips))
ips-target := $(join $(addsuffix /$(BOARD)/ip/, $(addprefix $(ip-dir)/, $(basename $(ips)))), $(ips))

all: $(mcs)

ips: 
# Generate mcs from bitstream

$(mcs): $(bit) $(BBL)
	$(STRIP) $(BBL)
	$(VIVADO) $(VIVADOFLAGS) -source scripts/write_cfgmem.tcl -tclargs $@ $^ $(BBL)

$(bit): $(ips)
	mkdir -p $(work-dir)
	$(VIVADO) $(VIVADOFLAGS) -source scripts/run.tcl
	cp $(BOARD)_$(CPU)/$(CPU).runs/impl_1/$(CPU)_xilinx* ./$(work-dir)

$(ips): %.xci :
	mkdir -p $(work-dir)
	@echo Generating $(@F)
	@cd $(ip-dir)/$(basename $(@F)) && make clean && make
	@cp $(ip-dir)/$(basename $(@F))/$(BOARD)/ip/$(@F) $@

mcs: $(mcs)

program: $(work-dir)/$(CPU)_xilinx.bit
	env JTAG_PART="$(JTAG_PART)" JTAG_BITFILE="$(work-dir)/$(CPU)_xilinx.bit" $(VIVADO) -nojournal -nolog -mode batch -source scripts/program.tcl

cfgmem: $(work-dir)/$(CPU)_xilinx.mcs
	env JTAG_PART="$(JTAG_PART)" JTAG_MCSFILE="$(work-dir)/$(CPU)_xilinx.mcs" $(VIVADO) -nojournal -nolog -mode batch -source scripts/program_cfgmem.tcl

cfgmem_new: $(work-dir)/$(CPU)_xilinx.new.mcs
	env JTAG_PART="$(JTAG_PART)" JTAG_MCSFILE="$(work-dir)/$(CPU)_xilinx.new.mcs" $(VIVADO) -nojournal -nolog -mode batch -source scripts/program_cfgmem.tcl

newmcs: $(work-dir)/$(CPU)_xilinx.new.mcs

$(work-dir)/$(CPU)_xilinx.new.mcs: $(work-dir)/$(CPU)_xilinx.new.bit $(BBL)
	$(STRIP) $(BBL)
	env XILINX_PART="xc7a100t-csg324-1" XILINX_BOARD="digilentinc.com:nexys4_ddr:part0:1.1" vivado -nojournal -mode batch -source scripts/prologue.tcl -source scripts/write_cfgmem.tcl -tclargs $@ $< $(BBL)

new: $(work-dir)/$(CPU)_xilinx.bit $(work-dir)/search-ramb.log scripts/cnvmem.v $(work-dir)/boot.bmm 
	make BOARD=$(BOARD) CPU=$(CPU) VENDOR=$(VENDOR) MEMSIZE=$(MEMSIZE) -C src/etherboot
	data2mem -bm $(work-dir)/boot.bmm -bd src/etherboot/$(BOARD)_$(CPU).mem -bt $< -o b $(work-dir)/$(CPU)_xilinx.new.bit

$(work-dir)/search-ramb.log: scripts/search_ramb.tcl $(work-dir)/$(CPU)_xilinx_routed.dcp
	vivado -mode batch -source $< -tclargs $(work-dir)/$(CPU)_xilinx_routed > $@

$(work-dir)/boot.bmm: $(work-dir)/search-ramb.log
	python scripts/bmm_gen.py $< $@ 128 32768

clean:
	rm -rf *.log *.jou *.str *.mif *.xpr $(work-dir) $(CPU).cache $(CPU).hw $(CPU).ip_user_files

.PHONY:
	clean

