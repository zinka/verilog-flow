import os
import re
import sys

FSM = sys.argv[1]
if len(sys.argv) > 2:
    USERCODE = sys.argv[2]+'.tmp'
else:
    USERCODE = 'usercode.tmp'

regex = re.compile(r"// verilator lint_on CASEINCOMPLETE")
line_found = False

with open(FSM) as file1:
    for line in file1:
        if re.match(r"    \/\/ fizzim code generation ends", line):
            line_found = True
            break
    with open(USERCODE, "w+") as file2:
        if line_found:
            for line in file1:
                file2.write(line)

# delete the first and last lines
with open(USERCODE, 'r') as fin:
    data = fin.read().splitlines(True)
with open(USERCODE, 'w') as fout:
    fout.writelines(data[6:-1])