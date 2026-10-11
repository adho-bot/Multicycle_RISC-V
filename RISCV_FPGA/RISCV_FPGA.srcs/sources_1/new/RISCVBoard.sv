
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2025 15:10:58
// Design Name: 
// Module Name: RISCVBoard
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


module RISCVBoard(
    input      logic        CLK_50MHZ_R,
    //Switches(1 WHEN NOT PRESSED)
    input      logic        FPGA_SW1,
    input      logic        FPGA_SW2,    
    input      logic        FPGA_SW3,
    input      logic        FPGA_SW4,
    
    //Leds
    output     logic        FPGA_RED1,
    output     logic        FPGA_YEL1,
    output     logic        FPGA_GRN1,
    output     logic        FPGA_BLU1,
    output     logic        FPGA_RED2,
    output     logic        FPGA_YEL2,
    output     logic        FPGA_GRN2,
    output     logic        FPGA_BLU2,
    output     logic        FPGA_LED_NEN,
    
    //LCDs
    output     logic        FPGA_LCD_NBL,
    inout      logic [10:0] FPGA_LCD
    
    );
   

logic [31:0] data_in;        
logic [31:0] address;     
logic [31:0] data_out;
logic [7:0]  LED_O;



//Control signals
logic clk, rst;
logic mem_rd, mem_wr;
logic locked;


assign rst = ~locked;//locked does something right now


//LEDs
assign FPGA_RED1    = LED_O[0];
assign FPGA_YEL1    = LED_O[1];
assign FPGA_GRN1    = LED_O[2];
assign FPGA_BLU1    = LED_O[3];
assign FPGA_RED2    = LED_O[4];
assign FPGA_YEL2    = LED_O[5];
assign FPGA_GRN2    = LED_O[6];
assign FPGA_BLU2    = LED_O[7];
assign FPGA_LED_NEN = 1'b0;

//Switches
logic [3:0] FPGA_SW;

assign FPGA_SW = {FPGA_SW4,FPGA_SW3,FPGA_SW2,FPGA_SW1};

//LCDs
assign FPGA_LCD_NBL = 1'b0;
logic [7:0] LCD_input;  //input to the lcd
logic [7:0] LCD_output; //output from the lcd
logic [2:0] LCD_control; //controlling the lcd

clk_wiz_0 clock_instance(
    .clk_out1(clk), 
    .locked(locked),
    .clk_in1(CLK_50MHZ_R)
 );

    
RISCV RISCV_instance (
    .clk(clk),                   
    .rst(rst),                 
    .data_in(data_in),        
    .address(address),      
    .data_out(data_out),      
    .mem_rd(mem_rd),              
    .mem_wr(mem_wr)               
);

// memory here
RISCV_memory memory_instance (
    .FPGA_SW(FPGA_SW),
    .clk(clk),
    .cs(1'b1),
    .rd(mem_rd),
    .wr(mem_wr),
    .LCD_output(LCD_output),
    .LCD_input(LCD_input),
    .LCD_control(LCD_control),
    .address(address),
    .wr_data(data_out),
    .rd_data(data_in),
    .LED_O(LED_O)  
);
   
   
//LCD 
genvar i;

assign FPGA_LCD[10:8] = LCD_control; 

generate 
    for(i = 0 ; i < 8; i++) begin
       IOBUF IOBUF_inst_LCD (
          .O(LCD_output[i]),     // Buffer output
          .IO(FPGA_LCD[i]),   // Buffer inout port (connect directly to top-level port)
          .I(LCD_input[i]),     // Buffer input
          .T(LCD_control[0])      // 3-state enable input, high=input, low=output
       );
    end
endgenerate
 
endmodule
