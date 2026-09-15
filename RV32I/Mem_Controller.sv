`timescale 1ns / 1ps
import OFA_pkg::*;

module Mem_Controller (

    input  logic [31:0] AddressRaw,
    input  logic [31:0] WriteDataRaw,
    input  logic [1:0]  Mask_code, 

    output logic [3:0]  Mask,
    output logic [31:0] Address,
    output logic [31:0] WriteData 

    );

    logic [3:0]  WRMask_default;
    logic [1:0]  OffsetMask;

    assign  {WRMask_default, OffsetMask, WriteData } =   
                        ( Mask_code == MASK_CODE_BYTE)  ?    
                            {{ MASK_VALUE_BYTE },  { AddressRaw[1:0] }, {4{WriteDataRaw[7:0]}} }:
                        ( Mask_code == MASK_CODE_HALF )  ?    
                            {{ MASK_VALUE_HALF },   { { AddressRaw[1] }, { 1'b0 } }, { 2{WriteDataRaw[15:0]}} }:
                        ( Mask_code == MASK_CODE_WORD )  ?    
                            {{ MASK_VALUE_WORD },  { 2'b0 }, {WriteDataRaw}}:
                        {{ MASK_VALUE_ERR },       { 2'b0 }, {WriteDataRaw}};

    assign  Mask    =   WRMask_default << OffsetMask;  
    assign  Address =   AddressRaw     >> 2;                               

endmodule