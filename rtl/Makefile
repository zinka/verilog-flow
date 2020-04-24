.PHONY: all
.DELETE_ON_ERROR:

TOPMOD  := thruwire
# TOPMOD  := maskbus
# TOPMOD  := blinky
# TOPMOD  := ppsii
# TOPMOD  := ppsi
# TOPMOD  := ledwalker
# TOPMOD  := reqwalker
# TOPMOD  := helloworld

FBDIR := .
VLOGFIL := $(TOPMOD).v
VDIRFB  := ../bench/cpp/lib

VERILATOR=verilator
VFLAGS := -O3 -MMD --trace -Wall -Mdir $(VDIRFB)

$(VDIRFB)/V$(TOPMOD).cpp: $(wildcard *.v)
	$(VERILATOR) $(VFLAGS) -cc $(VLOGFIL)
