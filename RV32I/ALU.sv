`timescale 1ns / 1ps
import OFA_pkg::*;

module ALU (
    input  logic [31:0]     A,
    input  logic [31:0]     B,
    input  logic [3:0]      ALU_Code,
    
    output logic [31:0]     Result,
    output logic            Zero,
    output logic            Negative,
    output logic            Carry,
    output logic            Overflow
);

    logic           SmuxB;
    logic [31:0]    muxB;
    
    logic [31:0]    add_sub_result;
    logic           add_sub_carry;

    logic [31:0]    sll_res, srl_res, sra_res;
    logic [31:0]    and_res, or_res, xor_res, slt_res, sltu_res;
    
    // CH-01 
    assign  SmuxB    =   (ALU_Code == ALU_CODE_SUB) |
                         (ALU_Code == ALU_CODE_SLT) |
                         (ALU_Code == ALU_CODE_SLTU);
    
    assign  muxB     =  B ^ {32{SmuxB}};


    assign { add_sub_carry, add_sub_result } = { 1'b0, A } + { 1'b0, muxB } + SmuxB;

   
    assign sll_res  = A << B[4:0];
    assign srl_res  = A >> B[4:0];
    assign sra_res  = $signed(A) >>> B[4:0];

    assign and_res  = A & B;
    assign or_res   = A | B;
    assign xor_res  = A ^ B;

    assign slt_res  = {31'b0, add_sub_result[31] ^ Overflow};
    assign sltu_res = {31'b0, ~add_sub_carry};
  
    assign  Result  = (ALU_Code == ALU_CODE_ADD)  ? add_sub_result :
                      (ALU_Code == ALU_CODE_SUB)  ? add_sub_result :
                      (ALU_Code == ALU_CODE_SLL)  ? sll_res    :
                      (ALU_Code == ALU_CODE_SRL)  ? srl_res    :
                      (ALU_Code == ALU_CODE_SRA)  ? sra_res    :
                      (ALU_Code == ALU_CODE_SLT)  ? slt_res    :
                      (ALU_Code == ALU_CODE_SLTU) ? sltu_res   :
                      (ALU_Code == ALU_CODE_AND)  ? and_res    :
                      (ALU_Code == ALU_CODE_OR)   ? or_res     :
                      (ALU_Code == ALU_CODE_XOR)  ? xor_res    :
                      (ALU_Code == ALU_CODE_PASS) ? B          : 32'b0;

    assign Zero     = (Result == 32'b0);
    assign Negative =  Result[31];
    assign Carry    =  add_sub_carry;
    assign Overflow = (A[31] == muxB[31]) && (add_sub_result[31] != A[31]);

endmodule