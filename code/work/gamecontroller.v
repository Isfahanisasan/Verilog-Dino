`timescale 1ns / 1ps
module gamecontroller(clk, rst, sel, sync_h, sync_v, vgaRed, vgaGreen, vgaBlue, LED_out, Anode_Activate);
  input clk, rst, sel;
  output sync_h, sync_v, vgaRed, vgaGreen, vgaBlue;   
  output wire [6:0] LED_out;
  output wire [3:0] Anode_Activate;
	
  reg[2:0] vgaRed, vgaGreen;
  reg[1:0] vgaBlue;
  
  wire clk_25;
  wire clk_20Hz;
  wire clk_500Hz;
  
  wire sync_h_out;
	wire sync_v_out;
  wire vidon;
	 
	wire [10:0] pixel_x;
	wire [10:0] pixel_y;
	 
	wire [2:0] im_game_r;
	wire [2:0] im_game_g;
	wire [1:0] im_game_b;
  
  wire rst_st, sel_st;
	 
	wire [10:0] score;
	
	assign sync_h = ~sync_h_out;
	assign sync_v = ~sync_v_out;
  
  always @ (posedge clk_25) begin	
    if (vidon) begin
			vgaRed[2:0] = im_game_r;
			vgaGreen[2:0] = im_game_g;
			vgaBlue[1:0] = im_game_b;
    end
    else begin
      vgaRed[2:0] = 3'b000;
			vgaGreen[2:0] = 3'b000;
			vgaBlue[1:0] = 2'b00;
    end
	end
  
  gamelogic game(.clk(clk),
					  .clk_20Hz(clk_20Hz),
						 .pixel_x(pixel_x),
						 .pixel_y(pixel_y),
						 .rst(rst_st),
						 .sel(sel_st),
						 .red(im_game_r),
						 .green(im_game_g),
						 .blue(im_game_b),
						 .score(score));
  
  vga vgacontrol(.refresh_clk(clk_25),
      .rst(rst_st),
      .sync_h(sync_h_out),
      .sync_v(sync_v_out),
      .pixel_x(pixel_x),
      .pixel_y(pixel_y),
      .vidon(vidon));
      
  debouncer rst_button (.clk(clk),
                        .btn(rst),
                        .btn_state(rst_st));
                        
  debouncer sel_button (.clk(clk),
                        .btn(sel),
                        .btn_state(sel_st));
								
	
   clock_divider clkDiv(.device_clock(clk),
								.rst(rst_st),
								.clk_25MHz(clk_25),
								.clk_20Hz(clk_20Hz),
								.clk_500Hz(clk_500Hz)
								);
								
	Seven_segment_LED_Display_Controller led (
								.clk_500Hz(clk_500Hz),
								.score(score),
								.rst(rst_st),
								.Anode_Activate(Anode_Activate),
								.LED_out(LED_out));
												

endmodule
