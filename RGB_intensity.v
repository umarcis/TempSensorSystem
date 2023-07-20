`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2023 12:00:30 AM
// Design Name: 
// Module Name: RGB_intensity
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


module RGB_intensity(
    input clk_100MHz,
    input enable,
    input [12:0]manualSwitch,
    input [15:0] temp_data,
    output reg R,
    output reg G,
    output reg B);
    
    reg [7:0]counter=0;
    reg [15:0] temp_register;
    
    
    //logic for counter with the help of which we will generate intensities
    always@(posedge clk_100MHz)
    begin
        if (counter < 100)
            counter <=  counter + 1;
        else 
            counter <= 0;
    end
    
    
    always@(*)
    begin
        temp_register[15:0] = temp_data[15:0];
        if(temp_register[15] == 0)
        begin
            if(temp_register[15:7] > 30)    // IF THE TEMPRETURE IS GREATER THAN 30 CELCIUS THEN THE TRI COLOR LED GLOW WITH 80% DUTY CYCLE
            begin
                R = (counter <100)? 1:0;
                G = (counter <100)? 1:0;
                B = (counter <100)? 1:0;
            end
                
            else if(temp_register[15:7] < 30 && temp_register[15:7] > 0)    // IF THE TEMPRETURE IS LESS THAN 30 CELCIUS AND GREATER THAN 0 CELCIUS THEN THE TRI COLOR LED GLOW WITH 50% DUTY CYCLE
            begin
                R = (counter <50)? 1:0;
                G = (counter <50)? 1:0;
                B = (counter <50)? 1:0;
            end
            
            
        end    
        else if(temp_register[15] == 1)
            begin
               if((temp_register[15:7] - 512) < 0) // IF THE TEMPRETURE IS LESS THAN 0 CELCIUS  THEN THE TRI COLOR LED GLOW WITH 25% DUTY CYCLE
               begin
                    R = (counter <25)? 1:0;
                    G = (counter <25)? 1:0;
                    B = (counter <25)? 1:0;
               end
               else
               begin
                    R = (counter <25)? 1:0;
                    G = (counter <25)? 1:0;
                    B = (counter <25)? 1:0;
               end
            end
              
            
            
        else if(enable == 0)
        begin
            temp_register[15:0] = manualSwitch[12:0];
            if(temp_register[15] == 0)
            begin
                if(temp_register[15:7] > 30)    // IF THE TEMPRETURE IS GREATER THAN 30 CELCIUS THEN THE TRI COLOR LED GLOW WITH 80% DUTY CYCLE
                begin
                    R = (counter <100)? 1:0;
                    G = (counter <100)? 1:0;
                    B = (counter <100)? 1:0;
                end
                
                else if(temp_register[15:7] < 30 && temp_register[15:7] > 0)    // IF THE TEMPRETURE IS LESS THAN 30 CELCIUS AND GREATER THAN 0 CELCIUS THEN THE TRI COLOR LED GLOW WITH 50% DUTY CYCLE
                begin
                    R = (counter <50)? 1:0;
                    G = (counter <50)? 1:0;
                    B = (counter <50)? 1:0;
                end
             end 
             
             else if(temp_register[15] == 1)
            begin
               if((temp_register[15:7] - 512) < 0) // IF THE TEMPRETURE IS LESS THAN 0 CELCIUS  THEN THE TRI COLOR LED GLOW WITH 25% DUTY CYCLE
               begin
                    R = (counter <25)? 1:0;
                    G = (counter <25)? 1:0;
                    B = (counter <25)? 1:0;
               end
               else
               begin
                    R = (counter <25)? 1:0;
                    G = (counter <25)? 1:0;
                    B = (counter <25)? 1:0;
               end
            end  
        end        
    end
    
    
    
    
endmodule
