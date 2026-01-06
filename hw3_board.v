`timescale 1ns / 1ps
module top(
    input clk, rst, 
	input sw_r, sw_l,
	output [7:0] led_r
);
	
	wire led_clk;

	wire click_r;
	wire click_l;
	
	wire [2:0] state;
	wire [2:0] state1;
	wire [2:0] state2;
	
	wire [3:0] score_r, score_l;
	
	button R1(
		.in(sw_r),
		.clk(clk), 
		.rst(rst),
		.click(click_r)
	);
	
	button L1(
		.in(sw_l),
		.clk(clk), 
		.rst(rst),
		.click(click_l)
	);
	
	divclk U1(
		.clk(clk), .rst(rst),
		.led_clk(led_clk)
	);
	
    FSM_state U2(
        .clk(clk), .rst(rst),
		.sw_r(click_r), .sw_l(click_l),
		.led_r(led_r),
		.score_r(score_r),
		.score_l(score_l),
        .state(state),
		.state1(state1),
		.state2(state2)
    );    
    
    led_ctr U3(
        .clk(led_clk), .rst(rst), 
        .state(state),
		.state2(state2),
		.score_r(score_r), .score_l(score_l),
        .led_r(led_r)
    );
	
	score_ctr U4(
        .clk(clk), .rst(rst), 
        .state(state),
		.state1(state1),
        .score_r(score_r),
		.score_l(score_l)
    );
        
endmodule

module button(
	output click,
	input in,clk,rst
);

	parameter bound = 20'd1000000;

	reg [19:0] decnt;
	reg sig_dly,sig;
	
	always@(posedge clk or posedge rst)begin
		if(rst)begin
			decnt <= 20'd0;
			sig <= 1'd0;
		end
		else begin
			if(in == 1'b1)begin
				if(decnt < bound)begin
					decnt <= decnt + 20'd1;
					sig <= 1'b0;
				end
				else begin
					decnt <= decnt;
					sig <= 1'b1;
				end
			end
			else begin
				decnt <= 20'd0;
				sig <= 1'd0;
			end
		end
	end
	
	always@(posedge clk or posedge rst)begin
		if(rst)begin
			sig_dly <= 1'b0;
		end
		else begin
			sig_dly <= sig;
		end
	end
	
	assign click = sig & ~sig_dly;
	
endmodule

module divclk (
	input clk, rst,
	output led_clk
);
	reg [27:0] cnt;
	
	assign led_clk = cnt[24];
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			cnt <= 0;
		end
		else begin
			cnt <= cnt + 1;
		end
	end
endmodule 

module FSM_state(
    input clk, rst,
    input sw_r, sw_l,
    input [7:0] led_r,     
	input [3:0] score_r,
	input [3:0] score_l,
	input [3:0] state2,
	output reg [2:0]  state1,
    output reg [2:0]  state
);
    parameter init = 3'd5,
			  ball_r = 3'd0,  
              ball_l = 3'd1,  
			  win_r = 3'd2,  
              win_l = 3'd3,  
              play = 3'd4;  
	 
	reg win;
	
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= init;
			state1 <= init;
			win <= 0;
        end 
		else begin
			state1 <= state;
            case (state)
				init : begin
					if (sw_r) begin
						state <= ball_r;
					end
					else if (sw_l) begin
						state <= ball_l;
					end
				end
                ball_r: begin
					if (led_r == 8'b1000_0000 && sw_l == 1) begin
						state <= ball_l;
					end
					else if ((led_r == 8'b0000_0000 && !sw_l)|| sw_l == 1) begin
						state <= win_r;
					end
                end
                ball_l: begin
                    if (led_r == 8'b0000_0001 && sw_r == 1) begin
						state <= ball_r;
					end
					else if ((led_r == 8'b0000_0000 && !sw_r)|| sw_r == 1) begin
						state <= win_l;
					end
                end
                win_r: begin
					state <= play;
                end
                win_l: begin
					state <= play;
                end
                play: begin
					case (state2)
						win_r : begin
							if (sw_r) begin
								state <= ball_r;   
							end
						end
						win_l : begin
							if (sw_l) begin
								state <= ball_l;   
							end
						end
					endcase
                end
            endcase
        end
    end
endmodule

module score_ctr(
    input clk, rst,
    input [2:0] state,
	input [2:0] state1,
    output reg [3:0] score_r, score_l
);
	parameter init = 3'd5,
			  ball_r = 3'd0,  
              ball_l = 3'd1,  
			  win_r = 3'd2,  
              win_l = 3'd3,  
              play = 3'd4;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			score_r <= 0;
			score_l <= 0;
		end 
		else begin
			case(state)
				win_r: begin
					if (state1 == ball_r) begin
						score_r <= score_r + 1; 
					end
				end
				win_l: begin
					if (state1 == ball_l) begin
						score_l <= score_l + 1; 
					end 
				end
				default: begin
					score_r <= score_r;
					score_l <= score_l;
				end
			endcase
		end
	end
endmodule

module led_ctr(
    input clk, rst,
    input [2:0] state,
	input [3:0] score_r, score_l,
	output [2:0] state2,
    output reg [7:0] led_r
);
    parameter init = 3'd5,
			  ball_r = 3'd0,  
              ball_l = 3'd1,  
			  win_r = 3'd2,  
              win_l = 3'd3,  
              play = 3'd4; 
			  
	reg [2:0] state2;
	
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            led_r <= 8'b0000_0001;
        end 
		else begin
			state2 <= state;
            case (state)
				init: begin
					led_r <= 8'b0000_0001;
				end
                ball_r: begin
					if (state2 == play) begin
						led_r <= 8'b0000_0001;
					end
					else begin
						led_r <= led_r << 1;
					end
                end
                ball_l: begin 
					if (state2 == play) begin
						led_r <= 8'b1000_0000;
					end
					else begin
						led_r <= led_r >> 1;
					end
                end
                win_r: begin
                    led_r <= {score_l, score_r};
                end
                win_l: begin
                    led_r <= {score_l, score_r};
                end
                play: begin
					led_r <= {score_l, score_r};
                end
				default : begin
					led_r <= led_r;
				end
            endcase
        end
    end
endmodule
