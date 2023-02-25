`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.01.2023 11:56:46
// Design Name: 
// Module Name: array_multi_4bit
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




module top_a1_q2_array_multi_4bit
(
    A, B, Mult_out
 );
    
    input [3:0] A, B; 
    output [7:0] Mult_out;
    
    wire [3:0] and_r0, and_r1, and_r2, and_r3;
    wire [3:0] sum_r0, sum_r1, sum_r2, sum_r3, sum_r4;
    wire [3:0] cout_r0, cout_r1, cout_r2, cout_r3, cout_r4; 
    
    
    // Row 0 
    // Multiplying A[0] with all bits of B
    and (and_r0[0], A[0], B[0]);
    and (and_r0[1], A[0], B[1]);
    and (and_r0[2], A[0], B[2]);
    and (and_r0[3], A[0], B[3]);
    
    // Full adders producing sum at Row 0
    FA fa_r0_c0 (and_r0[0], 1'b0, 1'b0, sum_r0[0], cout_r0[0]);
    FA fa_r0_c1 (and_r0[1], 1'b0, 1'b0, sum_r0[1], cout_r0[1]);
    FA fa_r0_c2 (and_r0[2], 1'b0, 1'b0, sum_r0[2], cout_r0[2]);
    FA fa_r0_c3 (and_r0[3], 1'b0, 1'b0, sum_r0[3], cout_r0[3]);


    
    // Row 1
    // Multiplying A[1] with all bits of B
    and (and_r1[0], A[1], B[0]);
    and (and_r1[1], A[1], B[1]);
    and (and_r1[2], A[1], B[2]);
    and (and_r1[3], A[1], B[3]);
    
    // Full adders producing sum at Row 1
    FA fa_r1_c0 (and_r1[0], sum_r0[1], cout_r0[0], sum_r1[0], cout_r1[0]); 
    FA fa_r1_c1 (and_r1[1], sum_r0[2], cout_r0[1], sum_r1[1], cout_r1[1]); 
    FA fa_r1_c2 (and_r1[2], sum_r0[3], cout_r0[2], sum_r1[2], cout_r1[2]); 
    FA fa_r1_c3 (and_r1[3], 1'b0 , cout_r0[3], sum_r1[3], cout_r1[3]); 


    
    // Row 2
    // Multiplying A[2] with all bits of B
    and (and_r2[0], A[2], B[0]);
    and (and_r2[1], A[2], B[1]);
    and (and_r2[2], A[2], B[2]);
    and (and_r2[3], A[2], B[3]);
    
    // Full adders producing sum at Row 2
    FA fa_r2_c0 (and_r2[0], sum_r1[1], cout_r1[0], sum_r2[0], cout_r2[0]);
    FA fa_r2_c1 (and_r2[1], sum_r1[2], cout_r1[1], sum_r2[1], cout_r2[1]);
    FA fa_r2_c2 (and_r2[2], sum_r1[3], cout_r1[2], sum_r2[2], cout_r2[2]);
    FA fa_r2_c3 (and_r2[3], 1'b0, cout_r1[3], sum_r2[3], cout_r2[3]);
    

    
    // Row 3
    // Multiplying A[3] with all bits of B
    and (and_r3[0], A[3], B[0]);
    and (and_r3[1], A[3], B[1]);
    and (and_r3[2], A[3], B[2]);
    and (and_r3[3], A[3], B[3]);
    
    // Full adders producing sum at Row 3
    FA fa_r3_c0 (and_r3[0], sum_r2[1], cout_r2[0], sum_r3[0], cout_r3[0]);
    FA fa_r3_c1 (and_r3[1], sum_r2[2], cout_r2[1], sum_r3[1], cout_r3[1]);
    FA fa_r3_c2 (and_r3[2], sum_r2[3], cout_r2[2], sum_r3[2], cout_r3[2]);
    FA fa_r3_c3 (and_r3[3], 1'b0 , cout_r2[3], sum_r3[3], cout_r3[3]);
    
    
    // Row 4
    // Producing 1st 4 bits of the final multiplication result
    // Full adders producing sum at Row 4
    FA fa_r4_c0 (sum_r3[1], cout_r3[0], 1'b0, sum_r4[0], cout_r4[0]);
    FA fa_r4_c1 (sum_r3[2], cout_r3[1], cout_r4[0], sum_r4[1], cout_r4[1]);
    FA fa_r4_c2 (sum_r3[3], cout_r3[2], cout_r4[1], sum_r4[2], cout_r4[2]);
    FA fa_r4_c3 (1'b0, cout_r3[3], cout_r4[2], sum_r4[3], cout_r4[3]);
    
    
    assign Mult_out = {
                        sum_r4[3], sum_r4[2], sum_r4[1] ,sum_r4[0],
                        sum_r3[0] ,sum_r2[0] ,sum_r1[0] ,sum_r0[0] 
                       } ;   
    
endmodule



// Code for Full Adder, uses half adder ha for building 1 bit full adder
module FA(A, B, Cin, Sum, Cout);

    input A, B, Cin;
    output Sum, Cout; 
    
    wire S_ha, C_ha, C_ha2; 
    
    ha ha0(A, B, S_ha, C_ha);
    ha ha1(Cin, S_ha, Sum, C_ha2);
    
    or (Cout, C_ha, C_ha2) ;
    
    
endmodule



// Code for 1 bit HA
module ha(A,B,Sum,Cout);

    input A,B; 
    output Sum, Cout; 
    
    // Sum = A xor B, Cout = A and B
    
    xor (Sum, A, B);
    and (Cout, A, B);

endmodule 