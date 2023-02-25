`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.01.2023 11:27:02
// Design Name: 
// Module Name: rca_8bit
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


// Top module of 8 bits input and output
module top_a1_q1_rca_8bit
(
    A, B, Cin, Sum, Cout
);

    // Declaring Ports and wires
    
    input [7:0]A, B;
    input Cin;
    
    wire [6:0]w; 
    
    output [7:0] Sum;
    output Cout;
    
   // Module instantiation of 1 bit FA to make RCA, output Cout is input to the next full adder 
    fa fa0(A[0], B[0], Cin, Sum[0], w[0]);
    fa fa1(A[1], B[1], w[0], Sum[1], w[1]);
    fa fa2(A[2], B[2], w[1], Sum[2], w[2]);
    fa fa3(A[3], B[3], w[2], Sum[3], w[3]);
    fa fa4(A[4], B[4], w[3], Sum[4], w[4]);
    fa fa5(A[5], B[5], w[4], Sum[5], w[5]);
    fa fa6(A[6], B[6], w[5], Sum[6], w[6]);
    fa fa7(A[7], B[7], w[6], Sum[7], Cout);
    
endmodule


// Code for 1 bit FA
module fa(A, B, Cin, Sum, Cout);

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
