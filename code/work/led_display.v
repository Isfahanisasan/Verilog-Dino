module Seven_segment_LED_Display_Controller(

    //Inputs
    input clk_500Hz, // 500 hz clock
    input [7:0] score,
	 input rst,
    
    //Outputs
    output reg [3:0] Anode_Activate, // anode signals of the 7-segment LED display
    output reg [6:0] LED_out// cathode patterns of the 7-segment LED display
    );
    
    reg [3:0] LED_BCD;
             // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
    reg [1:0] LED_activating_counter; 
                 // count     0    ->  1  ->  2  ->  3
              // activates    LED1    LED2   LED3   LED4
             // and repeat

    always @(posedge clk_500Hz or posedge rst)
    begin 
        if(rst==1) begin
            LED_activating_counter <= 2'b00;
        end else begin
				if(LED_activating_counter == 2'b11) begin
					LED_activating_counter <= 2'b00;
				end else begin
					LED_activating_counter <= LED_activating_counter + 1;
				end
			end
    end 
	 
 // anode activating signals for 4 LEDs, digit period of 2.6ms
    // decoder to generate anode signals 
    always @(*)
    begin
        case(LED_activating_counter)
        2'b00: begin
            Anode_Activate = 4'b0111; 
            // activate LED1 and Deactivate LED2, LED3, LED4
            //leftmost LED
            LED_BCD = (score/1000) % 10;
            // the first digit of the 16-bit number
              end
        2'b01: begin
            Anode_Activate = 4'b1011; 
            // activate LED2 and Deactivate LED1, LED3, LED4
            LED_BCD = (score/100) % 10;
            // the second digit of the 16-bit number
              end
        2'b10: begin
            Anode_Activate = 4'b1101; 
            // activate LED3 and Deactivate LED2, LED1, LED4
            LED_BCD = (score/10) % 10;
            // the third digit of the 16-bit number
                end
        2'b11: begin
            Anode_Activate = 4'b1110; 
            // activate LED4 and Deactivate LED2, LED3, LED1
            //rightmost LED
            LED_BCD = score % 10;
            // the fourth digit of the 16-bit number    
               end
        endcase
    end
    // Cathode patterns of the 7-segment LED display 
    always @(*)
    begin		
			 case(LED_BCD)
			  4'b0000: LED_out = 7'b1000000; // "0"  
			  4'b0001: LED_out = 7'b1111001; // "1"	
			  4'b0010: LED_out = 7'b0100100; // "2" 
			  4'b0011: LED_out = 7'b0110000; // "3" 
			  4'b0100: LED_out = 7'b0011001; // "4" 
			  4'b0101: LED_out = 7'b0010010; // "5" 
			  4'b0110: LED_out = 7'b0000010; // "6" 
			  4'b0111: LED_out = 7'b1111000; // "7" 
			  4'b1000: LED_out = 7'b0000000; // "8"     
			  4'b1001: LED_out = 7'b0010000; // "9"
			  default: LED_out = 7'b1000000; // "0"
			  endcase
    end
endmodule
