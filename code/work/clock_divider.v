module clock_divider (
							 // Inputs	
							 device_clock,
							 rst,
                      // Outputs
                      clk_25MHz,
							 clk_20Hz,
							 clk_500Hz);

	 output reg				              clk_25MHz;
	 output reg								  clk_20Hz;
	 output reg								  clk_500Hz;

	 
	 input				              device_clock;
	 input				              rst;
    // Counter variables
    reg [25:0] cnt25M;
	 reg [25:0] cnt20;
    reg [25:0] cnt500;
	 
    // Division factor for each output clock

    integer							    		DIV25M;
	 integer										DIV20;
	 integer										DIV500;
			
    // Main logic
    always @(posedge device_clock or posedge rst) begin
		if (rst) begin
	      clk_25MHz <= 1;
			cnt25M <= 0;
		   DIV25M <= 2;
			
			clk_20Hz <= 1;
			cnt20 <= 0;
			DIV20 <= 1250000;
			
			clk_500Hz <= 1;
			cnt500 <= 0;
			DIV500 <= 50000;
			//DIV1 <= 25000000;
		   //DIV60 <= 833333;
		end
		else begin
			cnt25M <= cnt25M + 1;
			cnt20 <= cnt20 + 1;
			cnt500 <= cnt500 + 1;
		 
		 
			if (cnt25M == DIV25M - 1) begin
			  cnt25M <= 0;
			  clk_25MHz <= ~clk_25MHz;
			end
			
			if (cnt20 == DIV20 - 1) begin
			  cnt20 <= 0;
			  clk_20Hz <= ~clk_20Hz;
			end
			
			if (cnt500 == DIV500 - 1) begin
			  cnt500 <= 0;
			  clk_500Hz <= ~clk_500Hz;
			end
		 
		end
    end

endmodule
