`timescale 1ns / 1ps
module hw3_tb();

	reg clk,rst;
	reg sw_r, sw_l;
	
	wire [2:0] state;
	wire [7:0] led_r;
	
	
	top uut(
		.clk(clk), .rst(rst),
		.sw_r(sw_r), .sw_l(sw_l),
		.state(state),
		.led_r(led_r)
	);
	
	initial begin
		rst = 1; clk = 1; 
		sw_r = 0; sw_l = 0;		
		#10 rst = 0;
		
		#10 sw_r = 1;
		#10 sw_r = 0;
		
		#70 sw_l = 1;
		#10  sw_l = 0;
		
		#30 sw_r = 1;
		#10 sw_r = 0;
		
		#190 sw_r = 1;
		#10 sw_r = 0;
		
		#130 sw_l = 1;
		#10 sw_l = 0;
		
		#190 sw_l = 1;
		#10 sw_l = 0;
		
		#70 sw_r = 1;
		#10 sw_r = 0;
		
		#50 sw_l = 1;
		#10 sw_l = 0;
		
		#130 sw_r = 1;
		#10 sw_r = 0;
		
		#2000 $finish;
	end
	
	initial forever #5 clk = ~clk;
endmodule
