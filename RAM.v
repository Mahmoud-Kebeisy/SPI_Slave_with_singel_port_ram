//==============================================================
// Project:     SPI Slave with Single Port RAM
// Author:      Mahmoud Alsayed Kebeisy
// Date:        2024-08-14
// Description: Implementation of a simple RAM module with
//              basic read and write operations. The module
//              stores data in memory and provides output based
//              on command signals.
//==============================================================
module RAM (rx_valid,CLK,rst_n,din,tx_valid,dout);
//==============================================================
// PARAMETERS
//==============================================================
    parameter MEM_DEPTH =256;
    parameter MEM_WIDTH=8;
    parameter ADDR_SIZE=$clog2(MEM_DEPTH);
//==============================================================
// INPUTS
//==============================================================
    input rx_valid,CLK,rst_n;
    input [9:0] din;
//==============================================================
// OUTPUTS
//==============================================================
    output reg tx_valid;
    output reg [7:0]dout;
//==============================================================
// assign Control and the internally address
//==============================================================
    reg [7:0] din_addr;
    reg [7:0] out_addr;
    wire [1:0] Control;
    assign Control=din[9:8];
//==============================================================
//RAM MEMORY
//==============================================================
    reg [MEM_WIDTH-1:0] mem [MEM_DEPTH-1:0];
 //===========================================================
// MAIN FUNCTIONALITY
//===========================================================
    always @(posedge CLK) begin
        if (!rst_n) begin
            dout<=0;
            tx_valid<=0;
        end
        else begin
            case (Control)
            2'b00:begin 
                        if (rx_valid) begin
                            din_addr<=din[7:0];
                            tx_valid<=0;    
                        end
                    end
            2'b01:begin
                        if (rx_valid) begin
                            mem[din_addr]<=din[7:0];
                            tx_valid<=0;        
                        end  
            end
            2'b10:begin
                        if (rx_valid) begin
                            out_addr<=din[7:0];
                            tx_valid<=0;
                        end            
            end
            2'b11:begin
                            if (rx_valid) begin
                                dout<=mem[out_addr];
                                tx_valid<=1;    
                            end               
            end
        endcase
        end
    end
endmodule