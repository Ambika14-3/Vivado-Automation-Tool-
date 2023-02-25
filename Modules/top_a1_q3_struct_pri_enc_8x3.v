`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.01.2023 22:28:13
// Design Name: 
// Module Name: pri_enc_8x3
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


module top_a1_q3_struct_pri_enc_8x3(D, O);

    // Declaring the ports

    input [7:0] D;
    output [2:0] O;
 
    // Declaring the internal wires
   
    wire [7:0] not_D;
    wire [6:0] comb;  
    
    // Making each combinations - 1xxxxx, 01xxxx, 001xxxx, etc
    
    not (not_D[7], D[7]);       // Taking invert of every input
    not (not_D[6], D[6]); 
    not (not_D[5], D[5]); 
    not (not_D[4], D[4]); 
    not (not_D[3], D[3]); 
    not (not_D[2], D[2]); 
    not (not_D[1], D[1]); 
    not (not_D[0], D[0]); 
    
    and (comb[6], not_D[7], D[6]);            // Making every combination of input possible except the last one
    and (comb[5], not_D[7], not_D[6], D[5]);  // These combinations are made as per the truth table, ignoring the last input bits that are don't cares
    and (comb[4], not_D[7], not_D[6], not_D[5], D[4]);
    and (comb[3], not_D[7], not_D[6], not_D[5], not_D[4], D[3]);
    and (comb[2], not_D[7], not_D[6], not_D[5], not_D[4], not_D[3], D[2]);
    and (comb[1], not_D[7], not_D[6], not_D[5], not_D[4], not_D[3], not_D[2], D[1]);
    and (comb[0], not_D[7], not_D[6], not_D[5], not_D[4], not_D[3], not_D[2], not_D[1], D[0]);
    
    
    
     
    // generating the output bits  
    or (O[2], D[7], comb[6], comb[5], comb[4]);    
    or (O[1], D[7], comb[6], comb[3], comb[2]);
    or (O[0], D[7], comb[5], comb[3], comb[1]);
      

endmodule
