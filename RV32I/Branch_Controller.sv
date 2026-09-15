`timescale 1ns / 1ps
import OFA_pkg::*;

module Branch_Controller (
    input  logic         Branch,
    input  logic         Zero,
    input  logic         Negative,
    input  logic         Overflow,
    input  logic         Carry,
    input  logic [2:0]   funct3,
    
    output logic         BranchTaken
);

    logic less_than_signed;
    logic less_than_unsigned;
    logic condition_met;

    assign less_than_signed   =  Negative ^ Overflow;
    assign less_than_unsigned = ~Carry;

    assign condition_met      = (funct3 == FUNCT3_B_BEQ)  ? Zero :
                                (funct3 == FUNCT3_B_BNE)  ? ~Zero :
                                (funct3 == FUNCT3_B_BLT) |   
                                    (funct3 == FUNCT3_B_BLTU)  ?  less_than_signed :
                                (funct3 == FUNCT3_B_BGE) |   
                                    (funct3 == FUNCT3_B_BGEU)  ? ~less_than_signed : 1'b0;

    assign BranchTaken        = Branch & condition_met;

endmodule