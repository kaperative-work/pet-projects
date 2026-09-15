`timescale 1ns / 1ps
(* keep_hierarchy = "yes" *)
(* dont_touch = "yes" *)
module Instruction_Memory #(
    parameter SIZE = 1024 
)(
    input  logic [31:0] address,        
    output logic [31:0] instruction   
);
    logic [31:0] mem [0:SIZE-1];

    // ? dont touch wire
    wire  [31:0] word_addr = address >> 2; 
    wire  [9:0]  index     = word_addr[9:0];   
    

    assign instruction     = mem[index];

    initial begin
    $readmemh("init/instr_mem/program.hex", mem);
    end

endmodule