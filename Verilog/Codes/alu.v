module alu(S, A, B,  add_result, sub_result,bit5, sub_sign, and_result, GT, EQ, LT);
    input wire [3:0] A,B;
    input wire [1:0] S;
    output wire [3:0] add_result, sub_result, and_result;
    output wire bit5, sub_sign ;
    output wire GT, EQ, LT;
    wire [3:0] d;
    wire [1:0] s;
    wire f;

    not(s[0], S[0]);
    not(s[1], S[1]);

    and(d[0],s[1],s[0]); //00
    and(d[1],s[1],S[0]); //01
    and(d[2],S[1],s[0]); //10
    and(d[3],S[1],S[0]); //11
    and(f, d[0], d[1]);

    bit4_adder_subtractor Ares(.A(A),.B(B),.M(f),.s(add_result),.d(d[0]), .sign(bit5));
    bit4_adder_subtractor Sres(.A(A),.B(B),.M(d[1]),.s(sub_result),.d(d[1]), .sign(sub_sign));
    comparator comp(.A(A), .B(B), .d(d[2]), .gt(GT), .eq(EQ), .lt(LT));
    and_block Nres (.A(A), .B(B), .d(d[3]), .out(and_result));

endmodule

module enable_block(X,en,x);
    input wire [3:0] X;
    input wire en;
    output wire [3:0] x;

    and(x[0],X[0],en);
    and(x[1],X[1],en);
    and(x[2],X[2],en);
    and(x[3],X[3],en);

endmodule

module updateB(M,b,bu);
    input wire [3:0] b;
    input wire M;
    output wire [3:0]bu;

    xor(bu[0],b[0],M);
    xor(bu[1],b[1],M);
    xor(bu[2],b[2],M);
    xor(bu[3],b[3],M);

endmodule

module full_adder(x,y,c_in,s_0,c_out);
    output wire s_0, c_out;
    input wire x,y,c_in;

    wire o1, o2, o3;

    xor(o1,x,y);
    xor(s_0,o1,c_in);
    and(o2, c_in, o1);
    and(o3,x,y);
    or(c_out,o2,o3);

endmodule

module bit4_adder_subtractor(A,B,M,s,d,sign);
    input wire [3:0] A,B;
    input wire M,d;
    output wire [3:0] s;
    output wire sign;

    wire [3:0] c;
    wire [3:0] a,b,bu;
    
    enable_block forA(.X(A), .en(d), .x(a));
    enable_block forB(.X(B), .en(d), .x(b));
    
    updateB b_processed(.M(M),.b(b),.bu(bu));

    full_adder s0(.x(a[0]),.y(bu[0]),.c_in(M),.s_0(s[0]), .c_out(c[1]));
    full_adder s1(.x(a[1]),.y(bu[1]),.c_in(c[1]),.s_0(s[1]), .c_out(c[2]));
    full_adder s2(.x(a[2]),.y(bu[2]),.c_in(c[2]),.s_0(s[2]), .c_out(c[3]));
    full_adder s3(.x(a[3]),.y(bu[3]),.c_in(c[3]),.s_0(s[3]), .c_out(sign));

endmodule

module and_block(A,B,d,out);
    input wire [3:0] A,B;
    input wire d;
    output wire [3:0] out;

    wire [3:0] a,b;

    enable_block forA(.X(A), .en(d), .x(a));
    enable_block forB(.X(B), .en(d), .x(b));

    and(out[0],a[0],b[0]);
    and(out[1],a[1],b[1]);
    and(out[2],a[2],b[2]);
    and(out[3],a[3],b[3]);   

endmodule

module comparator(A,B,d,gt,eq,lt);
    input wire [3:0] A,B;
    input wire d;
    output wire gt,eq,lt;

    wire [3:0] a,b,e,g,l,bu,au;
    wire e0, e1 , eh;
    

    enable_block forA(.X(A), .en(d), .x(a));
    enable_block forB(.X(B), .en(d), .x(b));

    //equal check
    xnor(e[0],a[0],b[0]);
    xnor(e[1],a[1],b[1]);
    xnor(e[2],a[2],b[2]);
    xnor(e[3],a[3],b[3]);

    and(e0,e[3],e[2]);
    and(e1,e0,e[1]);
    and(eq,e1,e[0],d);
    

    //greater than

    updateB bp(.M(d),.b(b),.bu(bu));
    and(g[3],a[3],bu[3]);
    and(g[2],bu[2],a[2],e[3]);
    and(g[1],bu[1],a[1],e0);
    and(g[0],bu[0],a[0],e1);
    or(gt,g[3],g[2],g[1],g[0]);
    
    not(gc,gt);
    not(ec,eq);
    and(lt,ec, gc, d);

endmodule
