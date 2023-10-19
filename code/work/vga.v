`timescale 1ns / 1ps

module vga(refresh_clk, rst, sync_h, sync_v, pixel_x, pixel_y, vidon);
  input refresh_clk, rst;
  output sync_h, sync_v, pixel_x, pixel_y, vidon;
  
  reg vidon;
  wire sync_h, sync_v;
  reg [10:0] pixel_x, pixel_y;
  
  parameter h_pixels = 800;
  parameter v_lines = 521;
  parameter h_pulse = 96;
  parameter v_pulse = 2;
  parameter h_bp = 144;
  parameter h_fp= 784;
  parameter v_bp = 31;
  parameter v_fp = 511;
  
  reg [10:0] vertical_c;
  reg [10:0] horizontal_c;
  
  always @ (posedge refresh_clk) begin
	if (horizontal_c < h_pixels - 1)
	  horizontal_c <= horizontal_c + 1;
	else begin
	  horizontal_c <= 0;
	  if (vertical_c < v_lines - 1) 
		 vertical_c <= vertical_c + 1;
	  else
		 vertical_c <= 0;
	end
	 if (vertical_c >= v_bp && vertical_c < v_fp && horizontal_c >= h_bp && horizontal_c < h_fp) begin
      vidon <= 1;
      pixel_x <= horizontal_c - h_bp;
      pixel_y <= vertical_c - v_bp;
    end
    else begin
      pixel_x <= 0;
      pixel_y <= 0;
		vidon <= 0;
	 end
  end
  
  assign sync_h = (horizontal_c < h_pulse) ? 0:1;
  assign sync_v = (vertical_c < v_pulse) ? 0:1;

endmodule
