
module RISCV_memory(input  logic        clk,
                    input  logic        cs,
                    input  logic        rd,
                    input  logic        wr,
                    input  logic [31:0] address,
                    input  logic [31:0] wr_data,
                    input  logic [3:0]  FPGA_SW,
                    input  logic [7:0] LCD_output,
                    
                    output logic [31:0] rd_data,
                    
                    output logic [7:0]  LED_O,
                    output logic [7:0] LCD_input,
                    output logic [2:0] LCD_control
                    );
       
       
 
logic [31:0] memory [0:2047];
logic [31:0] address_w;
logic [7:0] LED_pin_output;


//initial $readmemh("/home/n77335ci/bin/code.hex", memory);
initial begin  
    $readmemh("/home/gary/bin/code.hex", memory);
    LED_pin_output[0] <= 1'b1; 
    LED_pin_output[1] <= 1'b1; 
    LED_pin_output[2] <= 1'b1; 
    LED_pin_output[3] <= 1'b1; 
    LED_pin_output[4] <= 1'b1; 
    LED_pin_output[5] <= 1'b1;   
    LED_pin_output[6] <= 1'b1;  
    LED_pin_output[7] <= 1'b1; 

end

always @ (negedge clk) begin
    if (cs && rd) begin
        case(address_w[12:2])
            //Buttons      
            11'h0100:  begin     //need to feed in h'0400
                rd_data <= FPGA_SW;  
                   
            end
            11'h0102: begin     //need to feed in h'0408
            
                rd_data <= LCD_output; 
            end
            default:
            rd_data <= memory[address_w[12:2]];
        endcase
    end
end

//Might need to initialised LED_pin_ouitput. check alter
always @ (negedge clk)
begin 
    if (cs && wr) begin
        case(address_w[12:2]) 
            //LED
            11'h0101: begin    //need to feed in h'0404
                LED_pin_output[0] <= wr_data[0]; //D3
                LED_pin_output[1] <= wr_data[1]; //D5   
                LED_pin_output[2] <= wr_data[2]; //D7   
                LED_pin_output[3] <= wr_data[3]; //D9   
                LED_pin_output[4] <= wr_data[4]; //D4
                LED_pin_output[5] <= wr_data[5]; //D6       
                LED_pin_output[6] <= wr_data[6]; //D8
                LED_pin_output[7] <= wr_data[7]; //D10        
            end
            11'h0102: begin       //Need to feed in h'408
                LCD_input <= wr_data;     
            end    
            11'h0103: begin       //Need to feed in h'40c
                LCD_control <= wr_data;
            end
            default:
                memory[address_w[12:2]] <= wr_data;
        endcase 
    end    
end

//Ensure addresses must be a multiple of 4)
assign address_w = (address[1:0] == 2'b00) ? address : 32'hXXXX;  

assign LED_O = LED_pin_output;
endmodule




/*

Ensure you are not loading an instruction greater than 12 bits or else it will take 2 instruction cycles and not work(for li). take into consideration the 2 bit shift)
*/


/*
FEEDING STRIGHT ADDRESSES TO THE MEMORY WILL OVERWRITE IN WRONG LOCATION
EG, STORE INSTRUCTION AT 100(001100100), WHEN FEEDING THIS INTO MEMORY, IT WILL BE CUT OFF, OVERWRITING INSTRUCTION AT ADDRESS 11001(25)
NEED TO GIVE VALUE OF 400 IN ASSEMBLY CODE
currently doing word addessing. need to change to byte addressing when done
*/
