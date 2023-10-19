`timescale 1ns / 1ps

module gamelogic(clk, clk_20Hz, pixel_x, pixel_y, rst, sel, red, green, blue, score);
  // input/output declarations
  input clk, clk_20Hz, rst, sel;
  input [10:0] pixel_x, pixel_y;
  output red, green, blue, score;
  
  // reg and size declarations
  reg [2:0] red, green;
  reg [1:0] blue;
  
  //player box
  parameter player_base = 400;
  parameter player_left = 100;
  parameter player_width = 20;
  parameter player_height = 40;
  parameter jump_height = 45;
  
  
  //obstacle
  parameter obstacle_width = 20;
  parameter obstacle_height = 20;
  parameter obstacle_x_base = 500;
  
  parameter [10:0] obstacle_pos = 596; 
  //collision detection
  
  reg [10:0] obstacle_x_change;
  reg [10:0] obstacle_y;
  reg signed [10:0] player_bottom;
  reg pause;
  reg [10:0] score;
  
  reg [5:0] idx;
  reg jump_state;
  reg [10:0] cur_jump;
  reg rising;

	always @ (posedge clk_20Hz or posedge rst) begin
		if (rst) begin
			obstacle_x_change = 0;
			score = 0;
			
			cur_jump = 0;
			rising = 0;
			jump_state = 0;
			obstacle_y = 400;
			idx = 0;
			end
		
		else begin
		
			if(obstacle_x_change == 500) begin
				obstacle_x_change = 0;
				score = score + 1;
				
				if(obstacle_pos[idx] == 0) begin
					obstacle_y = 400;
				end
				else begin
					obstacle_y = 350;
				end
				
				if(idx < 10) begin
					idx = idx + 1;
				end
				else begin
					idx = 0;
				end

			end
			else if (!pause) begin 
				obstacle_x_change = obstacle_x_change + 5;
			end
			
			if(sel && !pause && !jump_state) begin
				jump_state = 1;
				rising = 1;
			end	
			else if(jump_state && !pause) begin

				if(rising) begin
					cur_jump = cur_jump + 3;
				end
				else begin
					cur_jump = cur_jump - 3;
				end
				
				if(cur_jump >= 48) begin
					rising = 0;
				end
				
				if (!rising && !cur_jump) begin
					jump_state = 0;
					cur_jump = 0;
				end
			end
			
		end

		
	end

  always @ (posedge clk) begin
		//jump stuff
		if(rst) begin
			pause = 0;
		end
		
		player_bottom <= player_base - cur_jump;

		if((obstacle_x_base - obstacle_x_change) <= (player_left + player_width)
			&& ((obstacle_x_base - obstacle_x_change + obstacle_width) > player_left)
			&& (player_bottom >= obstacle_y - obstacle_height)
			&& ((player_bottom - player_height) < obstacle_y)) begin
			pause = 1;
		end

			
		//graphics
		if(pixel_y > 400) begin // grass
		  red[2:0] = 3'b000;
        green[2:0] = 3'b111;
        blue[1:0] = 2'b01;
		end
		else if ((pixel_y < player_bottom && pixel_y > (player_bottom-player_height))
					&& (pixel_x > player_left && pixel_x < (player_left+player_width))) begin
		  red[2:0] = 3'b000;
        green[2:0] = 3'b000;
        blue[1:0] = 2'b00;		
		end
		else if ((pixel_y < obstacle_y && pixel_y > (obstacle_y-obstacle_height))
					&& (pixel_x > (obstacle_x_base - obstacle_x_change)
					&& pixel_x < ((obstacle_x_base - obstacle_x_change) + obstacle_width))) begin // obstacle
		  red[2:0] = 3'b111;
		  green[2:0] = 3'b000;
		  blue[1:0] = 2'b00;
		end 
		else if(pause) begin // lost sky
			red[2:0] = 3'b001;
        green[2:0] = 3'b000;
        blue[1:0] = 2'b00;
		end
		else begin // sky
			red[2:0] = 3'b000;
        green[2:0] = 3'b001;
        blue[1:0] = 2'b11;
		end

	end

endmodule
