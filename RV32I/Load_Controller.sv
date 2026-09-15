`timescale 1ns / 1ps
import OFA_pkg::*;

module Load_Controller (
    input  logic [3:0]  Mask, 
    input  logic [1:0]  Mask_code, 
    input  logic        isUnsigned, 

    input  logic [31:0] ReadDataRaw,  

    output logic [31:0] ReadData 
);

    logic [31:0]    shifted_data;

    logic [7:0]     final_byte;
    logic [15:0]    final_half;

    logic [23:0]    extension_byte;
    logic [15:0]    extension_half;

    assign shifted_data  = Mask[0] ? (ReadDataRaw )      :
                           Mask[1] ? (ReadDataRaw >> 8)  :
                           Mask[2] ? (ReadDataRaw >> 16) :
                           Mask[3] ? (ReadDataRaw >> 24) :
                                      ReadDataRaw;

    assign final_byte     = shifted_data[7:0];
    assign final_half     = shifted_data[15:0];
    
    assign extension_byte = isUnsigned ? 24'b0: {24{final_byte[7]}};
    assign extension_half = isUnsigned ? 16'b0: {16{final_half[15]}};

    assign ReadData       = (Mask_code == MASK_CODE_BYTE) ? {extension_byte, final_byte}:
                            (Mask_code == MASK_CODE_HALF) ? {extension_half, final_half}:
                            (Mask_code == MASK_CODE_WORD) ?  ReadDataRaw:  
                            32'b0;   

endmodule