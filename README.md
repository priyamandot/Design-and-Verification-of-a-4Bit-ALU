## Title: Design and Verification of a 4-Bit ALU in Verilog

**Introduction:**
This project entails the design and verification of a 4-Bit Arithmetic Logic Unit (ALU) capable of performing addition, subtraction, comparison, and logical AND operations. Various tools such as _NG-SPICE_ for circuit design, _Magic_ for layout, and _Verilog_ for verification are utilized throughout the project.

**Block Diagram:**
![image](https://github.com/priyamandot/Design-and-Verification-of-a-4Bit-ALU/assets/139869341/16731152-347a-47b2-b207-6b440b2456f9)

**1) ALU-Block:**
The ALU block functions as a router for computational circuits. Operations are determined by the inputs S1 and S0 as follows:
- 00: Addition
- 01: Subtraction
- 10: Comparison
- 11: Logical AND

To implement this functionality, a 2-to-4 decoder is utilized.

**2) Enable Block:**
Comprising 8 AND gates, this block facilitates the transfer of values A3A2A1A1 and B3B2B1B0 to their respective circuits based on the enable signal.

**3) Adder/Subtractor:**
A unified block serves as both an adder and subtractor. By tying the carry-out (C0) or borrow-out (M) to the selector input (S0), the operation can switch between addition and subtraction accordingly.

Addition operation: A3A2A1A1 + B3B2B1B0
Subtraction operation: A3A2A1A1 - B3B2B1B0

**4) Comparator:**
This block compares the two 4-bit numbers and outputs whether A3A2A1A1 is greater than, less than, or equal to B3B2B1B0.

**5) AND Block:**
This block performs the logical AND operation on specific bits of the input.

**Conclusion:**
The ALU is assembled by integrating these functional blocks, enabling it to execute the desired arithmetic and logical operations on 4-bit binary numbers.

**Verification:**
The functionality of the ALU is verified using Verilog and NG-SPICE, ensuring that it performs the specified operations accurately.

**Design Comparison:**
Pre-layout and post-layout results are compared to evaluate any discrepancies and ensure design integrity.

**Critical Path Analysis:**
The critical path and maximum delay in the circuit are estimated to optimize performance and meet timing requirements.

The final design implementation details and results are documented in the repository for reference.
