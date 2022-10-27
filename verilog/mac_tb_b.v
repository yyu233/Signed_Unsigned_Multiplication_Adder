// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module mac_tb_b;

parameter bw = 4;
parameter psum_bw = 16;

reg clk = 0;

reg  [bw-1:0] a;
reg  [bw-1:0] b;
reg  [psum_bw-1:0] c;
wire [psum_bw-1:0] out;
reg  [psum_bw-1:0] expected_out = 0;

reg  [bw-1:0] a1;
reg  [bw-1:0] b1;

reg  [bw-1:0] a2;
reg  [bw-1:0] b2;

reg  [bw-1:0] a3;
reg  [bw-1:0] b3;

integer w_file ; // file handler
integer w_scan_file ; // file handler

integer x_file ; // file handler
integer x_scan_file ; // file handler

integer x_dec;
integer w_dec;
integer i; 
integer u; 

function [3:0] w_bin ;
  input integer  weight ;
  begin

    if (weight>-1)
     w_bin[3] = 0;
    else begin
     w_bin[3] = 1;
     weight = weight + 8;
    end

    if (weight>3) begin
     w_bin[2] = 1;
     weight = weight - 4;
    end
    else 
     w_bin[2] = 0;

    if (weight>1) begin
     w_bin[1] = 1;
     weight = weight - 2;
    end
    else 
     w_bin[1] = 0;

    if (weight>0) 
     w_bin[0] = 1;
    else 
     w_bin[0] = 0;

  end
endfunction



function [3:0] x_bin ;
    input integer x;
    begin
        if (x == 0) begin
            x_bin = 4'b0000;
        end
        if (x == 1) begin
            x_bin = 4'b0001;
        end
        if (x == 2) begin
            x_bin = 4'b0010;
        end
        if (x == 3) begin
            x_bin = 4'b0011;
        end
        if (x == 4) begin
            x_bin = 4'b0100;
        end
        if (x == 5) begin
            x_bin = 4'b0101;
        end
        if (x == 6) begin
            x_bin = 4'b0110;
        end
        if (x == 7) begin
            x_bin = 4'b0111;
        end
        if (x == 8) begin
            x_bin = 4'b1000;
        end
        if (x == 9) begin
            x_bin = 4'b1001;
        end
        if (x == 10) begin
            x_bin = 4'b1010;
        end
        if (x == 11) begin
            x_bin = 4'b1011;
        end
        if (x == 12) begin
            x_bin = 4'b1100;
        end        
        if (x == 13) begin
            x_bin = 4'b1101;
        end
        if (x == 14) begin
            x_bin = 4'b1110;
        end
        if (x == 15) begin
            x_bin = 4'b1111;
        end
    end
    
        
endfunction


// Below function is for verification
function [psum_bw-1:0] mac_predicted;
  input unsigned [bw-1:0] a;
  input signed [bw-1:0] b;
  input signed [psum_bw-1:0] c;

  input unsigned [bw-1:0] a1;
  input signed [bw-1:0] b1;

  input unsigned [bw-1:0] a2;
  input signed [bw-1:0] b2;

  input unsigned [bw-1:0] a3;
  input signed [bw-1:0] b3;
  reg signed [2*bw-1:0] psum1;
  reg signed [2*bw-1:0] psum2;
 
  begin 
      psum1 = $signed({1'b0, a}) * b + $signed({1'b0, a1}) * b1;
      psum2 = $signed({1'b0, a2}) * b2 + $signed({1'b0, a3}) * b3;
      mac_predicted =  psum1 + psum2 + c;
  end   


endfunction



mac_wrapper_b #(.bw(bw), .psum_bw(psum_bw)) mac_wrapper_b_instance(
	.clk(clk), 
	.out(out), 
	.a(a), 
	.b(b), 
	.c(c),
       	.a1(a1),
	.b1(b1),
	.a2(a2),
	.b2(b2),
	.a3(a3),
	.b3(b3)
);
 

initial begin 

  w_file = $fopen("b_data.txt", "r");  //weight data
  x_file = $fopen("a_data.txt", "r");  //activation

  $dumpfile("mac_tb_b.vcd");
  $dumpvars(0,mac_tb_b);
 
  #1 clk = 1'b0;  
  #1 clk = 1'b1;  
  #1 clk = 1'b0;

  $display("-------------------- Computation start --------------------");
  

  for (i=0; i<20; i=i+1) begin  // Data lenght is 10 in the data files

     #1 clk = 1'b1;
     #1 clk = 1'b0;

     w_scan_file = $fscanf(w_file, "%d\n", w_dec);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec);

     a = x_bin(x_dec); // unsigned number
     b = w_bin(w_dec); // signed number
     c = expected_out;

     w_scan_file = $fscanf(w_file, "%d\n", w_dec);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec);

     a1 = x_bin(x_dec); // unsigned number
     b1 = w_bin(w_dec); // signed number

     w_scan_file = $fscanf(w_file, "%d\n", w_dec);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec);

     a2 = x_bin(x_dec); // unsigned number
     b2 = w_bin(w_dec); // signed number

     w_scan_file = $fscanf(w_file, "%d\n", w_dec);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec);

     a3 = x_bin(x_dec); // unsigned number
     b3 = w_bin(w_dec); // signed number
     
     expected_out = mac_predicted(a, b, c, a1, b1, a2, b2, a3, b3);

  end



  #1 clk = 1'b1;
  #1 clk = 1'b0;

  $display("-------------------- Computation completed --------------------");

  #10 $finish;


end

endmodule




