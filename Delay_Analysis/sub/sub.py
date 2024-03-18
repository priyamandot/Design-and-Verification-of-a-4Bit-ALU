import os
import subprocess
import re
import time

# This clears the output file
fp3 = open("output_sub.txt", 'w')
fp3.close()

# this is the command this helps to choose which file to run
command = "ngspice destination_sub.ckt"

# Dictionary to store delays for each path
path_delays = {}

for j in range(0, 8):  # j represents the iteration of input. since we have 8 inputs we have kept it as 0,8
    if j < 4:
        s1 = "a" + str(j)  # for input sequence 0000 1111 output = 1111 s1 indicates string1
    else:
        s1 = "b" + str(j - 4)  # for input sequence 1111 0000 output = 1111

    for i in range(0, 4):  # i is for output sequence

        s2 = "sub" + str(i)  # s2 indicates string 2.
        mode1 = "RISE"
        mode2 = "FALL"
        # fp1 is src file since you can't modify it you open it in read mode
        if j < 4:
            fp1 = open("sub1delay.ckt", 'r')  # for input sequence 1
            fp2 = open("destination_sub.ckt", 'w')  # destination file for running
            fp3 = open("output_sub.txt", 'a')  # final output file
            mode1 = "RISE"
            mode2 = "FALL"

            data = fp1.read()  # reading data from file to a string

            search_text = "*target text"
            replace_text = f'''
.measure tran trise 
+ TRIG v({s1}) VAL = 'SUPPLY/2' {mode1} =1
+ TARG v({s2}) VAL = 'SUPPLY/2' {mode1} =1 

.measure tran tfall 
+ TRIG v({s1}) VAL = 'SUPPLY/2' {mode2} =1 
+ TARG v({s2}) VAL = 'SUPPLY/2' {mode2}=1

.measure tran tpd param = '(trise + tfall)/2' goal = 0
            '''

        else:
            fp1 = open("sub2delay.ckt", 'r')  # for input sequence 2
            fp2 = open("destination_sub.ckt", 'w')  # destination file for running
            fp3 = open("output_sub.txt", 'a')  # final output file
          
            data = fp1.read()  # reading data from file to a string

            search_text = "*target text"
            replace_text = f'''
.measure tran trise 
+ TRIG v({s1}) VAL = 'SUPPLY/2' {mode1} =1
+ TARG v({s2}) VAL = 'SUPPLY/2' {mode2} =1 

.measure tran tfall 
+ TRIG v({s1}) VAL = 'SUPPLY/2' {mode2} =1 
+ TARG v({s2}) VAL = 'SUPPLY/2' {mode1}=1

.measure tran tpd param = '(trise + tfall)/2' goal = 0
            '''
        # if you have any other input sequences you can add

        # now we replace search text with replace text in the file
        data = data.replace(search_text, replace_text)
        fp2.write(data)  # this writes the modified text into a new file called temp2.ckt
        fp1.close()
        fp2.close()

        # just use this block as it is so that your command is run in the terminal and output is stored into the string named as output
        completed_process = subprocess.run(command, shell=True, text=True, stdout=subprocess.PIPE,
                                           stderr=subprocess.PIPE)
        if completed_process.returncode == 0:
            # Capture the standard output into a string
            output = completed_process.stdout
        else:
            output = ("Command execution failed. at", str(i), str(j))

        output_lines = output.split('\n')
        # Extract the numerical value using regular expression
        tpd_line = [line for line in output_lines if 'tpd' in line][0]
        tpd_value = re.search(r'\d+\.\d+e[+-]\d+', tpd_line).group()

        additional_text = f" input = {s1} output = {s2}\n"

        fp3.write(tpd_value + additional_text)
        time.sleep(0.4)

        # Store the delay in the dictionary
        path_delays[f" input = {s1} output = {s2}"] = float(tpd_value)

# Find the critical path with the maximum delay
cri_path = max(path_delays, key=path_delays.get)
max_delay = path_delays[cri_path]

print(f"Critical Path: {cri_path}\nMaximum Delay: {max_delay}")
