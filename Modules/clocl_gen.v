`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2022 09:29:56
// Design Name: 
// Module Name: clock_main
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_main
(
    clock_in, 
    clock_slow
    );
    
    // Declaring the ports 
    input clock_in;             // Higher Frequency input
    output clock_slow; 		// Lower Frequency output
    
    reg clock_out = 0;          // Internal register 
    reg [25:0] counter = 0;     // Counter Value


    // The output changes after the maximum counter value is reached
    always @(posedge clock_in) 
    begin 
    
        counter <= counter + 1;
        
        if(counter == 50_000_000)
        begin 
           counter <= 0;  
           clock_out <= ~clock_out ;
        end 
    
    end  
    
    assign clock_slow = clock_out ;
    
endmodule
