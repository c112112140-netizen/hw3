`timescale 1ns / 1ps
module top(
    input clk, rst, 
	input sw_r, sw_l,
    output [2:0] state,
	output [7:0] led_r
);
	
	wire led_clk;

	wire click_r;
	wire click_l;
	
	wire [2:0] state1;
	
	wire [3:0] score_r, score_l;
	
	divclk U1(
		.clk(clk), .rst(rst),
		.led_clk(led_clk)
	);
	
    FSM_state U2(
        .clk(clk), .rst(rst),
		.sw_r(sw_r), .sw_l(sw_l),
		.led_r(led_r),
		.score_r(score_r),
		.score_l(score_l),
        .state(state),
		.state1(state1)
    );    
    
    led_ctr U3(
        .clk(led_clk), .rst(rst), 
        .state(state),
		.state1(state1),
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

module divclk (
	input clk, rst,
	output led_clk
);
	reg [27:0] cnt;
	
	assign led_clk = cnt[0];
	
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
        end 
		else begin
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
					else if ((led_r == 8'b1000_0000 && !sw_l)|| sw_l == 1) begin
						state <= win_r;
					end
                end
                ball_l: begin
                    if (led_r == 8'b0000_0001 && sw_r == 1) begin
						state <= ball_r;
					end
					else if ((led_r == 8'b0000_0001 && !sw_r)|| sw_r == 1) begin
						state <= win_l;
					end
                end
                win_r: begin
					state <= play;
					state1 <= state;
                end
                win_l: begin
					state <= play;
					state1 <= state;
                end
                play: begin
					case (state1)
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

	always @(*) begin
		if (rst) begin
			score_r = 0;
			score_l = 0;
		end 
		else begin
			case(state)
				win_r: begin
					score_r = score_r + 1; 
				end
				win_l: begin
					score_l = score_l + 1; 
				end
				default: begin
					score_r = score_r;
					score_l = score_l;
				end
			endcase
		end
	end
endmodule

module led_ctr(
    input clk, rst,
    input [2:0] state,
	input [2:0] state1,
	input [3:0] score_r, score_l,
    output reg [7:0] led_r
);
    parameter init = 3'd5,
			  ball_r = 3'd0,  
              ball_l = 3'd1,  
			  win_r = 3'd2,  
              win_l = 3'd3,  
              play = 3'd4; 
	
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            led_r <= 8'b0000_0001;
        end 
		else begin;
            case (state)
				init: begin
					led_r <= 8'b0000_0001;
				end
                ball_r: begin
					led_r <= led_r << 1;
                end
                ball_l: begin 
					led_r <= led_r >> 1;
                end
                win_r: begin
                    led_r <= {score_l, score_r};
                end
                win_l: begin
                    led_r <= {score_l, score_r};
                end
                play: begin
					if(state1 == win_r) begin
						led_r <= 8'b0000_0001;
					end
					else if(state1 == win_l) begin
						led_r <= 8'b1000_0000;
					end
                end
				default : begin
					led_r <= led_r;
				end
            endcase
        end
    end
endmodule
