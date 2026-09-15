`timescale 1ns / 1ps
module RV32I_tb;

    logic        clk;
    logic        reset;
    logic [31:0] pc_debug;
    logic [31:0] instr_debug;
    logic [31:0] alu_result_debug;

    int cycle_count;
    int errors = 0;
    
    RV32I u_rv32i (.*);

    always #5 clk = ~clk;
    
    
    initial begin
        clk = 0;
        reset = 1;
        cycle_count = 0;
      
        #23;
        reset = 0;
        
        #500;
        check_all_results();
        
        if (errors == 0) begin
            $display("PASSED");

        end else begin
           
            $display("FAILED");
 
        end
        
        $finish;
    end
    

    task check_all_results();
        $display("\n REGISTERS");
        for (int i = 0; i < 32; i++) begin
            if (u_rv32i.u_regfile.Reg_File[i] != 0) begin
                $display("x%0d\t= 0x%h (%0d)", i, 
                         u_rv32i.u_regfile.Reg_File[i], 
                         u_rv32i.u_regfile.Reg_File[i]);
            end
        end
        
        $display("\n TESTS");

        check("x1 (addi x1,x0,5)",     u_rv32i.u_regfile.Reg_File[1],  5);
        check("x2 (addi x2,x0,3)",     u_rv32i.u_regfile.Reg_File[2],  3);
        check("x3 (add x3,x1,x2)",     u_rv32i.u_regfile.Reg_File[3],  8);
        check("x4 (sub x4,x1,x2)",     u_rv32i.u_regfile.Reg_File[4],  2);
        

        check("x5 (and x5,x1,x2)",     u_rv32i.u_regfile.Reg_File[5],  1);
        check("x6 (or x6,x1,x2)",      u_rv32i.u_regfile.Reg_File[6],  7);
        check("x7 (xor x7,x1,x2)",     u_rv32i.u_regfile.Reg_File[7],  6);
        
 
        check("x8 (slli x8,x1,2)",     u_rv32i.u_regfile.Reg_File[8],  20);
        check("x9 (srli x9,x8,1)",     u_rv32i.u_regfile.Reg_File[9],  10);
   
        check("x10 (slt x10,x2,x1)",   u_rv32i.u_regfile.Reg_File[10], 1);
        check("x11 (sltu x11,x1,x2)",  u_rv32i.u_regfile.Reg_File[11], 0);
        
        check("x12 (lw x12,0(x0))",    u_rv32i.u_regfile.Reg_File[12], 5);
        check("x13 (lw x13,4(x0))",    u_rv32i.u_regfile.Reg_File[13], 3);

        check("x14 (beq taken)",       u_rv32i.u_regfile.Reg_File[14], 1);
        

        $display("x15 (jal return) = 0x%h", u_rv32i.u_regfile.Reg_File[15]);
        
        check("x16 (addi after jal)",  u_rv32i.u_regfile.Reg_File[16], 42);
        check_hex("x17 (lui)",         u_rv32i.u_regfile.Reg_File[17], 32'h12345000);
        

        $display("x18 (auipc) = 0x%h", u_rv32i.u_regfile.Reg_File[18]);
        
  
        check_mem("mem[0] (sw x1)",    u_rv32i.u_dmem.mem[0], 5);
        check_mem("mem[1] (sw x2)",    u_rv32i.u_dmem.mem[1], 3);
    endtask

    task check(input string name, input int actual, input int expected);
        if (actual == expected) begin
            $display("%s = %0d", name, actual);
        end else begin
            $display("%s = %0d (expected %0d)", name, actual, expected);
            errors++;
        end
    endtask
    
    task check_hex(input string name, input int actual, input int expected);
        if (actual == expected) begin
            $display("%s = 0x%h", name, actual);
        end else begin
            $display("%s = 0x%h (expected 0x%h)", name, actual, expected);
            errors++;
        end
    endtask

    task check_mem(input string name, input int actual, input int expected);
        if (actual == expected) begin
            $display("%s = %0d", name, actual);
        end else begin
            $display("%s = %0d (expected %0d)", name, actual, expected);
            errors++;
        end
    endtask

endmodule