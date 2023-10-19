`timescale 1ns / 1ps

module debouncer(clk, btn, btn_state);
	// inputs/outputs
	input clk, btn;
	output btn_state;
	
	parameter CLK_MAX = 32'd5000000;
	
	// assign outputs
	reg btn_state_reg = 0;
	assign btn_state = btn_state_reg;
	
	reg[31:0] counter;
	
	// determines the state of the button
	always @ (posedge clk) begin
		if (btn == 0) begin
			counter <= 0;
			btn_state_reg <= 0;
		end
		else begin
			counter <= counter + 1'b1;
			// means button has been down for awhile
			if (counter == CLK_MAX) begin
				btn_state_reg <= 1;
				counter <= 0;
			end
		end	
	end
	
endmodule
