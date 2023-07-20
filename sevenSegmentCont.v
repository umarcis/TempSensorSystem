`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2023 01:09:37 AM
// Design Name: 
// Module Name: sevenSegmentCont
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


module sevenSegmentCont(input clk_100MHz,               //100MHZ BUILITIN CLOCK
    input enable,                        //if 0 input will come from tempreture sensor otherwise from switches
    input [12:0]manualSwitch,           // 13-bit input from swithches 
    input reset,
    input [15:0] temp_data,          // 16-bit tempreture data coming from I2C master
    output reg [6:0] CA,           // 7 Segments of Displays(cathodes) used to show digits
    output reg [7:0] AN,            // for enabling the segments
    output reg dp
    );
    reg [4:0] first;  // first seven segment
    reg [4:0] second; //second seven segment
    reg [4:0] third; //third seven segment
    reg [4:0] fourth; // fourth seven segment
    reg [4:0] fifth; //fifth seven segment
    reg [4:0] sixth; //sixth seven segment
    reg [4:0] seventh; //seventh seven segment
    reg [4:0] eighth; //eighth seven segment
    reg[4:0]switch;    // temporary register for storing the input values
    reg [17:0] Counter=0; //18 bit counter
    reg [15:0] temp_register;

    
    
    

    
    always@(posedge clk_100MHz or posedge reset)
    begin
    if(reset)
        Counter <= 0;
    else
    Counter<=Counter+1;
    end
    
    always@(*)        
     begin
     if(enable)
     begin
         temp_register[15:0] = temp_data[15:0];
         if(temp_register[15] == 0)
         begin                                      // logic for display positive tempreture
            sixth = temp_register[14:7] / 10;           // Tens value of temp data
            fifth = temp_register[14:7] % 10;           // Ones value of temp data
         end
         else if(temp_register[15] == 1)
         begin
            temp_register[15:3] =  (~(temp_data[15:3])+1);                                      //logic for display negative tempreture
            sixth = (temp_register[14:7]) / 10;           // Tens value of temp data
            fifth = (temp_register[14:7]) % 10;           // Ones value of temp data
            seventh = 5'b10000;
         end
         
     end
     else if(enable == 0)
     begin
         temp_register[15:3] = manualSwitch[12:0];
         if(temp_register[15] == 0)
         begin                                                      //logic for display positive dummy tempreture coming from switches
            seventh = (temp_register[14:7] >= 100)?(temp_register[14:7] / 100): 5'bxxxxx;                // hundreds value of dummy tempreture coming from switches
            sixth = (temp_register[14:7] >= 10)?((temp_register[14:7] % 100) / 10):5'bxxxxx;           // Tens value of dummy tempreture coming from switches
            fifth = temp_register[14:7] % 10;           // Ones value of dummy tempreture coming from switches
         end
         else if(temp_register[15] == 1)
         begin 
            temp_register[15:3] =  (~(manualSwitch[12:0])+1);                                                            //logic for display negative dummy tempreture coming from switches
            seventh = ((temp_register[14:7]) >= 100)?((temp_register[14:7]) / 100):(((temp_register[14:7]) >= 10)?5'b10000:5'bxxxxx);          // hundreds value of dummy tempreture coming from switches      
            sixth = ((temp_register[14:7]) >= 10)?(((temp_register[14:7])%100) / 10):(((temp_register[14:7]) >= 0)?5'b10000:5'bxxxxx);         // Tens value of temp data
            fifth = ((temp_register[14:7])%100) % 10;           // Ones value of temp data
            eighth = ((temp_register[14:7])>= 100)?5'b10000:5'bxxxxx;
         end
         
     end
     
         case(switch)
        0 : CA = 7'b1000000; //0
        1 : CA = 7'b1111001; //1
        2 : CA = 7'b0100100; //2
        3 : CA = 7'b0110000; //3
        4 : CA = 7'b0011001; //4
        5 : CA = 7'b0010010; //5
        6 : CA = 7'b0000010; //6
        7 : CA = 7'b1111000; //7
        8 : CA = 7'b0000000; //8
        9 : CA = 7'b0011000; //9
        10: CA = 7'b0001000; //A
        11: CA = 7'b0000011; //B
        12: CA = 7'b1000110; //C
        13: CA = 7'b0100001; //D
        14: CA = 7'b0000110; //E
        15: CA = 7'b0001110; //F
        16: CA = 7'b0111111; // DASH (NEGATIVE SIGN)
        endcase
        
        case (temp_register[6:3])               // logic for fractional part using lookup tables
        4'b0000: begin first  <= 4'b00000;
                       second <= 4'b00000;
                       third  <= 4'b00000;
                       fourth <= 4'b00000;end
        4'b0001: begin first  <= 4'b00101;
                       second <= 4'b00010;
                       third  <= 4'b00110;
                       fourth <= 4'b00000;end
        4'b0010: begin first  <= 4'b00000;
                       second <= 4'b00101;
                       third  <= 4'b00010;
                       fourth <= 4'b00001;end
        4'b0011: begin first  <= 4'b00101;
                       second <= 4'b00111;
                       third  <= 4'b01000;
                       fourth <= 4'b00001;end
        4'b0100: begin first  <= 4'b00000;
                       second <= 4'b00000;
                       third  <= 4'b00101;
                       fourth <= 4'b00010;end
        4'b0101: begin first  <= 4'b00101;
                       second <= 4'b00010;
                       third  <= 4'b00001;
                       fourth <= 4'b00011;end
        4'b0110: begin first  <= 4'b00000;
                       second <= 4'b00101;
                       third  <= 4'b00111;
                       fourth <= 4'b00011;end
        4'b0111: begin first  <= 4'b00101;
                       second <= 4'b00111;
                       third  <= 4'b00011;
                       fourth <= 4'b00100;end
        4'b1000: begin first  <= 4'b00000;
                       second <= 4'b00000;
                       third  <= 4'b00000;
                       fourth <= 4'b00101;end               
        4'b1001: begin first  <= 4'b00101;
                       second <= 4'b00010;
                       third  <= 4'b00110;
                       fourth <= 4'b00101;end
        4'b1010: begin first  <= 4'b00000;
                       second <= 4'b00101;
                       third  <= 4'b00010;
                       fourth <= 4'b00110;end
        4'b1011: begin first  <= 4'b00101;
                       second <= 4'b00111;
                       third  <= 4'b01000;
                       fourth <= 4'b00110;end
        4'b1100: begin first  <= 4'b00000;
                       second <= 4'b00000;
                       third  <= 4'b00101;
                       fourth <= 4'b00111;end
        4'b1101: begin first  <= 4'b00101;
                       second <= 4'b00010;
                       third  <= 4'b00001;
                       fourth <= 4'b01000;end
        4'b1110: begin first  <= 4'b00000;
                       second <= 4'b00101;
                       third  <= 4'b00111;
                       fourth <= 4'b01000;end
        4'b1111: begin first  <= 4'b00101;
                       second <= 4'b00111;
                       third  <= 4'b00011;
                       fourth <= 4'b01001;end
        default: begin first  <= 4'b00000;
                       second <= 4'b00000;
                       third  <= 4'b00000;
                       fourth <= 4'b00000;end
           endcase
           
           case (Counter[17:15])
            
            3'b000: begin
                        switch <= first;
                        AN <= 8'b11111110;
                        dp <= 1'b1;
                    end
            3'b001: begin
                        switch <= second;
                        AN <= 8'b11111101;
                        dp <= 1'b1;
                    end
            3'b010: begin
                        switch <= third;
                        AN <= 8'b11111011;
                        dp <= 1'b1;
                    end
            3'b011: begin
                        switch <= fourth;
                        AN <= 8'b11110111;
                        dp <= 1'b1;
                    end
            3'b100: begin
                        switch <= fifth;
                        AN <= 8'b11101111;
                        dp <= 1'b0;
                   end
            3'b101: begin
                        switch <= sixth;
                        AN <= 8'b11011111;
                        dp <= 1'b1;
                   end
            3'b110: begin
                        switch <= seventh;
                        AN <= 8'b10111111;
                        dp <= 1'b1;
                   end
            3'b110: begin
                        switch <= eighth;
                        AN <= 8'b10111111;
                        dp <= 1'b1;
                   end
            default: begin AN <=8'b11111111; dp <= 1'b1;end
           
            endcase

        
         
        
        end

    
    
    
endmodule
