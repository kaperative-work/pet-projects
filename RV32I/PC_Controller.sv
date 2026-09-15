`timescale 1ns / 1ps

module PC_Controller (
    input  logic         Jump,
    input  logic         JumpReg,
    input  logic         BranchTaken,
    input  logic [31:0]  JumpPointer,   
    input  logic [31:0]  PC,            
    input  logic [31:0]  Immediate,  
    
    output logic [31:0]  PC_next,
    output logic [31:0]  PC_plus_4
);
    logic [31:0]         PC_plus;    
    logic [31:0]         PC_target;  

    assign PC_plus   = PC + 4;
    assign PC_target = PC + Immediate;
  
     always_comb begin
       
        if (JumpReg) begin
            PC_next = JumpPointer;     
        end else if (Jump) begin
            PC_next = PC_target;          
        end else if (BranchTaken) begin
            PC_next = PC_target;           
        end else begin
            PC_next = PC_plus;       
        end
    end
                       
    assign PC_plus_4 = PC_plus;

endmodule