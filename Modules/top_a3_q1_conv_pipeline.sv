`timescale 1ns / 1ps


// Defining a class to store the value of red, green and blue content of a pixel
class RGB #(parameter int M = 13);

    bit [M:0] red_px, blue_px, green_px;

endclass 


// Defining a class to store the RGB matrix associated with an image
class RGB_image  #(parameter int M = 13, N = 512);
    
    bit [M:0] red_img[N+1:0][N+1:0]; 
    bit [M:0] green_img[N+1:0][N+1:0];
    bit [M:0] blue_img[N+1:0][N+1:0];
    
endclass


// Main module
module top_a3_q1_conv_pipeline(in_r, in_g, in_b, out, clk);
    parameter N = 8;
    parameter M = 13;
    parameter H = 8 ;
    input clk ;
    input [H:0]in_r, in_g, in_b; 
   
    output logic signed [M:0]out;
    
    RGB_image image_in = new() ;
    
    logic signed [M:0] image_out [N-1:0][N-1:0] ;

    bit [4:0] stage = 5'b00001 ;                             // To indicate which stage is operational, initially the first is ON
    
    integer i = 1 ;
    integer j = 1 ;
    


    // Stage 1: Image Loading, storing the input R,G,B values in a 2D array of pixels
    always @ (posedge clk ) begin
        if (stage[0] == 1'b1) begin  
            if ( (i < (N+1)) && ~( i==N && j==(N+1) ) ) begin
                if ( j < N+1) begin
                    
                    image_in.red_img[i][j] = in_r ;
                    image_in.blue_img[i][j] = in_b ;
                    image_in.green_img[i][j] = in_g ;
               
                    j = j+1 ;
                end 
                else begin
                    j = 1;

                    image_in.red_img[i][j] = in_r ;
                    image_in.blue_img[i][j] = in_b ;
                    image_in.green_img[i][j] = in_g ; 
                    
                    i = i+1 ;
                    j = j+1 ;
                end
                
                if (i >= 4)
                    stage[1] = 1'b1 ;
                else 
                    stage[1] = 1'b0 ;
                    
            end else begin
                j = 1 ;
                i = 1;
                stage[0] = 1'b0 ;
            end
        end
    end 
 
    integer i3 = 0 ;
    integer j3 = 0 ;
    

    // Storing the products (after multiplying each array element with the Laplacian Kernel) in data type RGB
    RGB product[5]; 
    integer k ;
    initial begin 
        for(k = 0; k<5; k = k+1) 
        begin 
            product[k] = new(); 
        end
    end
    
   
    // Stage 2: Multiplication, performing multplication with the Laplacian Kernel once enough input data is avalaible 
    always @(posedge clk) begin
        if (stage[1] == 1'b1) begin 
              if ( (i3 < N) && ~( i3==(N-1) && j3==N ) ) begin
                   if ( j3 < N) begin
                            
                            product[0].red_px = image_in.red_img[i3+1][j3+1]*4;
                            
                            product[1].red_px = -image_in.red_img[i3][j3+1];
                            product[2].red_px = -image_in.red_img[i3+1][j3];
                            product[3].red_px = -image_in.red_img[i3+2][j3+1];
                            product[4].red_px = -image_in.red_img[i3+1][j3+2];
                            
                            
                            product[0].green_px = image_in.green_img[i3+1][j3+1]*4;
                            
                            product[1].green_px = -image_in.green_img[i3][j3+1];
                            product[2].green_px = -image_in.green_img[i3+1][j3];
                            product[3].green_px = -image_in.green_img[i3+2][j3+1];
                            product[4].green_px = -image_in.green_img[i3+1][j3+2];
                            
                            
                            product[0].blue_px = image_in.blue_img[i3+1][j3+1]*4;
                            
                            product[1].blue_px = -image_in.blue_img[i3][j3+1];
                            product[2].blue_px = -image_in.blue_img[i3+1][j3];
                            product[3].blue_px = -image_in.blue_img[i3+2][j3+1];
                            product[4].blue_px = -image_in.blue_img[i3+1][j3+2];
                            
                            j3 = j3+1 ;
                            
                            stage[2] = 1'b1 ;
                            end   

                    else begin 
                            j3 = 0 ;
                            i3 = i3+ 1;
                            
                            product[0].red_px = image_in.red_img[i3+1][j3+1]*4;
                            
                            product[1].red_px = -image_in.red_img[i3][j3+1];
                            product[2].red_px = -image_in.red_img[i3+1][j3];
                            product[3].red_px = -image_in.red_img[i3+2][j3+1];
                            product[4].red_px = -image_in.red_img[i3+1][j3+2];
                            
                            
                            product[0].green_px = image_in.green_img[i3+1][j3+1]*4;
                            
                            product[1].green_px = -image_in.green_img[i3][j3+1];
                            product[2].green_px = -image_in.green_img[i3+1][j3];
                            product[3].green_px = -image_in.green_img[i3+2][j3+1];
                            product[4].green_px = -image_in.green_img[i3+1][j3+2];
                            
                            
                            product[0].blue_px = image_in.blue_img[i3+1][j3+1]*4;
                            
                            product[1].blue_px = -image_in.blue_img[i3][j3+1];
                            product[2].blue_px = -image_in.blue_img[i3+1][j3];
                            product[3].blue_px = -image_in.blue_img[i3+2][j3+1];
                            product[4].blue_px = -image_in.blue_img[i3+1][j3+2];
                            
                            j3 = j3+1 ;
   
                         end
                end  
            end              
        end
        

        logic signed [M:0]sum2 ;


	// To store the accumulated products of the multiplied matrix in sum (RGB datatype)        
        RGB sum;
        initial begin
            sum = new(); 
        end
        

	// Stage 3: Accumulation/Addition, adding all the product terms of the multiplied matrix
        always @(posedge clk) begin
            if (stage[2] == 1'b1) begin
                sum.red_px = 0;
                sum.green_px = 0;
                sum.blue_px = 0;

                sum.red_px = product[0].red_px + product[1].red_px + product[2].red_px
                            + product[3].red_px + product[4].red_px ;
                

                ///////////////////////////////////////////////////
                sum.green_px = product[0].green_px + product[1].green_px + product[2].green_px
                            + product[3].green_px + product[4].green_px ;
                
               
                
                //////////////////////////////////////////////////
                sum.blue_px = product[0].blue_px + product[1].blue_px + product[2].blue_px
                            + product[3].blue_px + product[4].blue_px ;
                
                
                stage[3] = 1'b1 ;
            end
        end
        

        // Stage 4: Combining, adding all the components of the Convolved matrix in the RGB domain
        always @(posedge clk) begin
            if (stage[3] == 1'b1) begin
            
                sum2 = (sum.blue_px + sum.red_px + sum.green_px) ; //+ 8'b1000_0000 ;
                if (sum2[13] == 1'b1) 
                    sum2 = 0;
                else
                    sum2 = sum2 ;

		
		stage[4] = 1'b1 ;
                
                //out = sum2 ;
                $display("______out:%d", sum2 );
            end
        
        end

    integer i4 = 0 ;
    integer j4 = 0 ;
    
    // Step 5: Convolution output serially
    always @ (posedge clk ) begin
        if (stage[4] == 1'b1) begin  
            if ( (i < (N)) && ~( i==(N-1) && j==(N) ) ) begin
                if ( j < N) begin
		    image_out[i][j] = sum2 ;
		    out = sum2 ; 
                    j = j+1 ;
                end 
                else begin
                    j = 0;
		    i = i+1 ;
		    image_out[i][j] = sum2 ;
		    out = sum2 ; 
                    j = j+1 ;
                end
            end
        end
    end 

    
endmodule
