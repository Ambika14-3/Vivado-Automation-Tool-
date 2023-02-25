// Code your design here
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.08.2022 13:11:34
// Design Name: 
// Module Name: pri_encoder_8x3
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


module top_a1_q3_pri_encoder_8x3(

    I, O

    );
    
    // Declaring the ports 

    input [7:0] I; 
    output reg [2:0] O; 
    

    // Defining the behaviour of the circuit following the truth table 

    always @(I) 
    begin  
    
        casez (I) 
            8'b00000001 : O = 3'b000;                  // As per the truth table
            8'b0000001? : O = 3'b001;
            8'b000001?? : O = 3'b010;
            8'b00001??? : O = 3'b011;
            8'b0001???? : O = 3'b100;
            8'b001????? : O = 3'b101;
            8'b01?????? : O = 3'b110;
            8'b1??????? : O = 3'b111; 
            
            default : O = 3'bxxx ;                // For any invalid input, output should not be valid binary form
                         
        endcase     
    
    end 

endmodule
