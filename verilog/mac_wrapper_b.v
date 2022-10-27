// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_wrapper_b (clk, out, a, b, c, a1, b1, a2, b2, a3, b3);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out;
input  [bw-1:0] a;
input  [bw-1:0] b;
input  [psum_bw-1:0] c;
input  clk;

input  [bw-1:0] a1;
input  [bw-1:0] b1;

input  [bw-1:0] a2;
input  [bw-1:0] b2;

input  [bw-1:0] a3;
input  [bw-1:0] b3;

reg    [bw-1:0] a_q;
reg    [bw-1:0] b_q;
reg    [psum_bw-1:0] c_q;

reg    [bw-1:0] a1_q;
reg    [bw-1:0] b1_q;

reg    [bw-1:0] a2_q;
reg    [bw-1:0] b2_q;

reg    [bw-1:0] a3_q;
reg    [bw-1:0] b3_q;

wire signed [psum_bw-1:0] c0;
wire signed [psum_bw-1:0] c1;

wire signed [psum_bw-1:0] out0;
wire signed [psum_bw-1:0] out1;

assign c0 = $signed({1'b0, a1_q}) * $signed(b1_q);
assign c1 = $signed({1'b0, a3_q}) * $signed(b3_q);

assign out = out0 + out1 + c_q;

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance_0 (
        .a(a_q), 
        .b(b_q),
        .c(c0),
	.out(out0)
); 

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance_1 (
        .a(a2_q), 
        .b(b2_q),
        .c(c1),
	.out(out1)
); 


always @ (posedge clk) begin
        b_q  <= b;
        a_q  <= a;
        c_q  <= c;

	
        b1_q  <= b1;
        a1_q  <= a1;


        b2_q  <= b2;
        a2_q  <= a2;


        b3_q  <= b3;
        a3_q  <= a3;
end

endmodule
