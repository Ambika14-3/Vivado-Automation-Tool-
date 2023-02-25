`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.01.2023 14:39:07
// Design Name: 
// Module Name: RegFile
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


module top_a2_q2_RegFile(
data_in, q1, q2, clk, we, rw, r1, r2
    );
    
    parameter M = 32;                      // addr_width 
    parameter N = 32;                      // data_width 
    
    input [N-1:0]data_in;
    output logic [N-1:0] q1, q2; 
    input clk, we; 
    input [$clog2(M) -1  : 0] rw, r1, r2 ; 
    
    logic [N-1 :0] register [M-1:0];
    
    integer k; 
    
    initial
    
    for(k = 0; k<= M-1; k = k+1)
    begin 
        register[k] = '0; 
    end
    
    always_ff @(posedge clk)  
    begin 
    
        q1 <= register[r1] ; 
        q2 <= register[r2] ; 
        
        if(we == 1'b1) 
        begin 
            register[rw] <= data_in ; 
        end 
    end  
   
endmodule
