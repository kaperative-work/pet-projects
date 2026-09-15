`timescale 1ns / 1ps
module PC #( parameter WIDTH = 32)   
(
input  logic        clk,        
input  logic        rst_n,      
input  logic        pc_en,      
input  logic [WIDTH-1:0] pc_next, 
output logic [WIDTH-1:0] pc_out   
);

always_ff @(posedge clk or negedge rst_n)
begin 
    if (!rst_n) begin
        pc_out <= '0;
    end
    else if (pc_en) begin
        pc_out <= pc_next;
    end
end

endmodule