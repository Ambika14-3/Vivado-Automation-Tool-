`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2022 09:29:26
// Design Name: 
// Module Name: fsm_1101_ovr
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


module top_a1_q4_mealy_fsm( IN,clock_disp, y, clk, reset_n) ;
  
  // Declaring Ports

  input clk, reset_n; 
  output reg y;
  output IN;                 // Just to display the input (bit generated by the random sequence) to the FSM in LED of FPGA
  output clock_disp;         // Just to display the clock in LED of FPGA
  
  reg x = 0;
  // A => Reset, B => 0, C => 00, D => 001
  parameter A = 0, B = 1, C = 2, D = 3; 

    
  reg [1:0] PS;    // Present State
  reg [1:0] NS;    // Next State
 
 wire clk_slow;
 
 reg [19:0]random_seq = 20'b0111_0011_1000_1110_01101;  // 3 times output should go '1' when 0011 is detected
 
 assign IN  = x; 
 assign clock_disp = clk_slow;
 
 // Instantiating the below module in order to generate a clock whose frequency is low enough to see output on FPGA
 clock_main uut (clk, clk_slow);
 
  // To update the State
  always @(negedge reset_n,posedge clk_slow) 
  begin
  
    if(!reset_n)
      PS <= A;
    
    else
      x = random_seq[19] ; 
      random_seq <= random_seq << 1;      
      PS <= NS; 
    
  end 
  
   
  
  // To update the State and output 
  always @(x or PS)
  begin 
    
    case(PS)
      
      A : 
      begin 
          NS = x ? A : B; 
          y <= 0;
      end
          
      B : 
      begin 
        NS = x ? A : C;
        y <= 0; 
      end
          
      C : 
      begin 
        NS = x ? D : C;
        y <= 0; 
      end 
       
      D : 
      begin 
        NS = x ? A : B;
        if(x == 1) 
            y <= 1; 
            
        else 
            y <= 0; 
          
      end
      
    endcase 
    
  end 
  
  
endmodule 






