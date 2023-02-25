

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.01.2023 15:42:42
// Design Name: 
// Module Name: top_fsm
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
module clk_divide(clk_in, rstn, clk_out);
    input bit clk_in, rstn ;
    output bit clk_out ;
    
    bit [28:0] counter ;
    
    always_ff @(posedge clk_in or posedge rstn ) begin
        if (rstn == 1)
            counter = 29'b0 ;     
        else  begin
            counter = counter + 1'b1 ;
            /// clk divider for 100 Mhz to be brought down to 0.4 Hz that is
            /// time period of 2.5 sec, so that 5 sec and 10 sec traffic light duration 
            /// in the question can be implemented with least complication
            
            /// 100 Mhz to 0.4 Hz which is 250_000_000 reduction
            // below is the binary value of 250_000_000 for trigger
            if (counter > 29'b1110_1110_0110_1011_0010_1000_0000_0) begin
                clk_out = ~clk_out ;
                counter = 29'b0 ;
            end
            else
                counter = counter + 1'b1 ; 
        end
    end         
endmodule

module top_a2_q1_fsm(clk_in, rstn, North,East,South,West );
    input bit clk_in, rstn ;
    output enum bit [2:0] {red = 3'b100, yellow = 3'b010, green = 3'b001} North,East,South,West ;
    
    bit flag, clk_out;
    enum bit [2:0]{A,B,C,D,E,F,G,H }state ;
    
    clk_divide inst1(clk_in, rstn, clk_out);
    
    always_ff @(posedge clk_out or posedge rstn) begin
        if (rstn == 1) begin      
           {North, East, South, West, state, flag} = {yellow, yellow, yellow, yellow, A, 1'b0};            
        end
        else begin
            unique case( {state,flag})
                {A,1'b0} : {North, East, South, West, state, flag} = {green, red, red, red, A, 1'b1 }; // 5 sec green
                {A,1'b1} : {North, East, South, West, state, flag} = {green, red, red, red, B, 1'b0 }; // 5 sec green// total 10 sec green
                
                {B,1'b0} : {North, East, South, West, state, flag} = {yellow, yellow, red, red, C, 1'b0 }; // transition period -yellow
                
                {C,1'b0} : {North, East, South, West, state, flag} = {red, green, red, red, C, 1'b1 }; // repeat for East
                {C,1'b1} : {North, East, South, West, state, flag} = {red, green, red, red, D, 1'b0 }; // East green
                
                {D,1'b0} : {North, East, South, West, state, flag} = {red, yellow, yellow, red, E, 1'b0 };
                
                {E,1'b0} : {North, East, South, West, state, flag} = {red, red, green, red, E, 1'b1 }; // South green
                {E,1'b1} : {North, East, South, West, state, flag} = {red, red, green, red, F, 1'b0 };
                
                {F,1'b0} : {North, East, South, West, state, flag} = {red, red, yellow, yellow, G, 1'b0 };
                
                {G,1'b0} : {North, East, South, West, state, flag} = {red, red, red, green, G, 1'b1 }; // West green
                {G,1'b1} : {North, East, South, West, state, flag} = {red, red, red, green, H, 1'b0 };
                
                {H,1'b0} : {North, East, South, West, state, flag} = {yellow, red, red, yellow, A, 1'b0 };
                
                default : {North, East, South, West, state, flag} = {yellow, red, red, yellow, A, 1'b0 };
                                
            endcase
        end
    end
    
endmodule

