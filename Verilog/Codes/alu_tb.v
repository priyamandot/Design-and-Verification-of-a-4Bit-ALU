module alu_tb;
    reg [3:0] A, B;
    reg [1:0] S;
    wire [3:0] add_result, sub_result, and_result;
    wire bit5, sub_sign ;
    wire GT, EQ, LT;

    alu sunshine(
        .S(S), .A(A), .B(B),
        .add_result(add_result), .sub_result(sub_result),
        .bit5(bit5), .sub_sign(sub_sign),
        .and_result(and_result), .GT(GT), .EQ(EQ), .LT(LT)
    );

    initial begin 
        A = 4; B = 10; S = 2'b00;
        #5;
        A = 4'b1111; B = 4'b1101; S = 2'b01;
        #5;
        A = 4'b1010; B = 4'b0101; S = 2'b10;
        #5;
        A = 4'b1111; B = 4'b1111; S = 2'b10;
        #5;
        A = 4'b1111; B = 4'b1100; S = 2'b11;
        #5;
        A = 7; B = 1; S =2'b10;
        #5
        A = 13; B = 10; S = 2'b01;
        #5
        A = 2; B = 13; S = 0;
        #5
        $finish;
    end

    initial begin 
        $monitor("%t| A = %b| B = %b| S = %b| Sum = %b%b| Difference = %b%b| GT = %b, LT = %b, EQ= %b| And Result = %b", 
            $time, A, B, S, bit5, add_result, sub_sign, sub_result, GT, LT, EQ, and_result);
        $dumpfile("alu_tb_dump.vcd");
        $dumpvars(0, alu_tb);
    end

endmodule
