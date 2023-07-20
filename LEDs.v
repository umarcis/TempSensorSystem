`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2023 01:06:18 AM
// Design Name: 
// Module Name: LEDs
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


module LEDs(
    input enable,
    input [12:0]manualSwitch,
    input [15:0] temp_data,
    output reg[15:0]LED );
    
    always@(*)
    begin
    if(enable)
         LED[15:3] = temp_data[15:3];
    else if(enable == 0)
         LED[15:3] = manualSwitch[12:0];
    end
endmodule
