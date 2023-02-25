`timescale 1ns / 1ps
module top_a2_q3_fifo_1(we, re, clk, rstn, full, empty, half_full, D_in, D_out);
    
    parameter N = 16 ;
    parameter M = 32 ;
    
    input bit we, re, clk, rstn ;
    input bit [N-1:0] D_in ;
    
    output bit full, empty, half_full ;
    output logic [N-1:0] D_out ;
    
    logic [N-1:0] fifo_reg [M-1:0] ; // fifo registers
    bit [$clog2(M)-1 :0] wr_pntr, rd_pntr ; // write and read pointers
    bit [$clog2(M)-1: 0] counter ; // counts the distance betwn pointers 
    // to flag empty, full or half_full ;
    bit flag_full, flag_empty ;
    
    always_ff @ (posedge clk or negedge rstn ) begin 
        
        if(rstn == 1'b0) begin
            counter = 0 ;
            wr_pntr = 0 ;
            rd_pntr = 0 ;
            full = 0;
            flag_full = 0;
            half_full = 0;
            empty = 1;
            flag_empty = 1;
        end
        
        else begin
        
            if ( we & ~re) begin
                assert (flag_full != 1'b1) begin
                    fifo_reg[wr_pntr] = D_in ;
                    wr_pntr = wr_pntr + 1'b1 ;
                    counter = counter + 1'b1 ;
                    
                    if (counter == 0) begin 
                        flag_full = 1;
                        full = 1;
                    end
                    else begin
                        flag_full = 0;
                        full = 0;
                        empty = 0;
                        flag_empty = 0;
                    end
                end
                else 
                    $error("Data_overwrite") ;
            end        
            else if ( ~we & re) begin
                assert (flag_empty != 1) begin 
                    D_out = fifo_reg[rd_pntr];
                    rd_pntr = rd_pntr + 1'b1 ;
                    counter = counter - 1'b1 ;
                    
                    if (counter == 0) begin
                        flag_empty = 1 ;
                        empty = 1;
                    end
                    else begin
                        flag_empty = 0;
                        empty = 0;
                        flag_full = 0;
                        full = 0;
                    end
                end
                else 
                    $error("No data to read");
            end 
            else if (we & re) begin 
            
                assert (flag_full != 1'b1) begin
                    fifo_reg[wr_pntr] = D_in ;
                    wr_pntr = wr_pntr + 1'b1 ;
                    counter = counter + 1'b1 ;
//                    empty = 0;
//                    flag_empty = 0;
                end
                else $error("Data_overwrite") ;
                
                assert (flag_empty != 1) begin 
                    D_out = fifo_reg[rd_pntr];
                    rd_pntr = rd_pntr + 1'b1 ;
                    counter = counter - 1'b1 ;
//                    full = 0;
//                    flag_full = 0;
                end
                else $error("No data to read");
                
                
                  empty = 0;
                  flag_empty = 0;
                  full = 0;
                  flag_full = 0;
            
                
            end
            else
                counter = counter ;
        
        
        if (counter == M/2)
            half_full = 1;
        else
            half_full = 0;
        
        
        
        end
    end
        

endmodule