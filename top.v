module top(
    input         CLK100MHZ,        // nexys clk signal
    input         enable,
    input         [15:0]manualSwitch, 
    input         reset,            // btnC on nexys
    inout         TMP_SDA,          // i2c sda on temp sensor - bidirectional
    output        TMP_SCL,          // i2c scl on temp sensor
    output [6:0]  CA,              // 7 segments of each display
    output [7:0]  AN,               // 4 anodes of 4 displays
    output dp,              // 4 anodes always OFF
    output R,G,B,
    output [15:0]  LED               // nexys leds = binary temp in deg C
    );
    
    wire sda_dir;                   // direction of SDA signal - to or from master
    wire w_200kHz;                  // 200kHz SCL
    wire [15:0] w_data;              // 8 bits of temperature data

    // Instantiate i2c master
    i2c_master master(
        .clk_200kHz(w_200kHz),
        .reset(reset),
        .temp_data(w_data),
        .SDA(TMP_SDA),
        .SDA_dir(sda_dir),
        .SCL(TMP_SCL)
    );
    
    // Instantiate 200kHz clock generator
    clkgen_200kHz cgen(
        .clk_100MHz(CLK100MHZ),
        .clk_200kHz(w_200kHz)
    );
    
    // Instantiate 7 segment control
    
    
    sevenSegmentCont   S1(
    .clk_100MHz(CLK100MHZ),               //100MHZ BUILITIN CLOCK
    .enable(enable),                        //if 0 input will come from tempreture senson otherwise from switches
    .manualSwitch(manualSwitch),           // 13-bit input from swithches 
    .reset(reset),
    .temp_data(w_data),          // 16-bit tempreture data coming from I2C master
    .CA(CA),           // 7 Segments of Displays(cathodes) used to show digits
    .AN(AN),            // for enabling the segments
    .dp(dp)
    );
    
    
    // instantiate LED module
    
    LEDs    l1(
    .enable(enable),
    .manualSwitch(manualSwitch),
    .temp_data(w_data),
    .LED (LED)
    );
    
    
    
    // instantiate RGB INTENSITY MODULE
    RGB_intensity   RGB(
    .clk_100MHz(CLK100MHZ),
    .enable(enable),
    .manualSwitch(manualSwitch),
    .temp_data(w_data),
    .R(R),
    .G(G),
    .B(B)
    );
    
    
    

endmodule