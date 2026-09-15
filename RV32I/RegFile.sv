`timescale 1ns / 1ps
module RegFile (
    input  logic       clk,
    input  logic       W_EN,
    
    input  logic[4:0]  W_Addr,
    input  logic[31:0] W_Data,
    
    input  logic[4:0]  R_Addr_0,
    input  logic[4:0]  R_Addr_1,
    
    output logic[31:0] R_Data_0,
    output logic[31:0] R_Data_1
);

logic [31:0] Reg_File [0:31];
 
assign R_Data_0 = (R_Addr_0 == 5'b0) ? 32'b0 : Reg_File[R_Addr_0];
assign R_Data_1 = (R_Addr_1 == 5'b0) ? 32'b0 : Reg_File[R_Addr_1];
    
always_ff @(posedge clk)    
begin
    if (W_EN && W_Addr != 5'b0) 
        Reg_File[W_Addr] <= W_Data;
end

endmodule
