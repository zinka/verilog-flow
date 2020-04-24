#!/bin/sh

FSM_name='txuart2'

# usercode backup
python formal.py ../${FSM_name}.v
echo "1: usercode backup done"

# fizzim to verilog
perl -f fizzim.pl <${FSM_name}.fzm> ../${FSM_name}.v
echo "2: fizzim to verilog done"