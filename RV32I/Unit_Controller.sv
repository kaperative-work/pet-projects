`timescale 1ns / 1ps
import OFA_pkg::*;

module Unit_Controller(
   input  logic            rst,
   input  logic[31:0]      Instruction, 

   output logic            Jump,
   output logic            JumpReg,
   output logic            Branch,
   output logic            src_ALU_A,
   output logic            src_ALU_B,
   output logic            W_mem,
   output logic            R_mem,
   output logic            W_reg,

   output logic[1:0]       src_W_Data_reg,

   output logic[4:0]       rd,
   output logic[4:0]       rs1,
   output logic[4:0]       rs2,

   output logic[2:0]       funct3,
   output logic[6:0]       funct7, 

   output logic[1:0]       Mask_code,
   output logic            ReadUnsigned,

   output logic[31:0]      Immediate,
   output logic[3:0]       ALU_code 
);



logic[6:0] opcode;
  
// OPCODE-type
logic          REG_type, IMM_type, LOAD_type, STORE_type, BRANCH_type;
logic          JAL_type, JALR_type, LUI_type, AUIPC_type, SYSTEM_type; 

// IMM
logic          Imm_Select_I, Imm_Select_S, Imm_Select_B, Imm_Select_J, Imm_Select_U; 
logic[31:0]    Imm_I, Imm_S, Imm_B, Imm_J, Imm_U;

logic          ALU_ADD, ALU_SUB, ALU_AND, ALU_XOR, ALU_OR, ALU_SLT, ALU_SLTU;
logic          ALU_SLL ,ALU_SRL, ALU_SRA, ALU_PASS, ALU_NOP;

   // ID
   assign opcode        = (rst)? 'b0 : Instruction[6:0];
   assign rd            = (rst)? 'b0 :      Instruction[11:7];
   assign rs1           = (rst)? 'b0 :     Instruction[19:15];
   assign rs2           = (rst)? 'b0 :  Instruction[24:20];
   assign funct3        = (rst)? 'b0 :     Instruction[14:12];
   assign funct7        = (rst)? 'b0 :     Instruction[31:25];

   // CS
   assign REG_type      = (rst)? 'b0 :      (opcode == OPCODE_REG);
   assign IMM_type      = (rst)? 'b0 :     (opcode == OPCODE_IMM);
   assign LOAD_type     = (rst)? 'b0 :     (opcode == OPCODE_LOAD);
   assign STORE_type    = (rst)? 'b0 :     (opcode == OPCODE_STORE);
   assign BRANCH_type   = (rst)? 'b0 :     (opcode == OPCODE_BRANCH);
   assign JAL_type      = (rst)? 'b0 :     (opcode == OPCODE_JAL);
   assign JALR_type     = (rst)? 'b0 :     (opcode == OPCODE_JALR);
   assign LUI_type      = (rst)? 'b0 :     (opcode == OPCODE_LUI);
   assign AUIPC_type    = (rst)? 'b0 :     (opcode == OPCODE_AUIPC);
   assign SYSTEM_type   = (rst)? 'b0 :     (opcode == OPCODE_SYSTEM);
   
   assign Jump          = (rst)? 'b0 :     JAL_type;
   assign JumpReg       = (rst)? 'b0 :     JALR_type;
   assign Branch        = (rst)? 'b0 :     BRANCH_type;
                         
   assign W_reg         = (rst)? 'b0 :     REG_type  | IMM_type | LOAD_type | JAL_type |
                             JALR_type | LUI_type | AUIPC_type;
                           
   assign W_mem         = (rst)? 'b0 :     STORE_type;
   assign R_mem         = (rst)? 'b0 :     LOAD_type;
   assign src_ALU_A     = (rst)? 'b0 :     JAL_type  | AUIPC_type;
                          
   assign src_ALU_B     = (rst)? 'b0 :     IMM_type  | LOAD_type | STORE_type | JAL_type |
                              JALR_type | AUIPC_type| LUI_type;
 
   assign src_W_Data_reg[0] = (rst)? 'b0 :  LOAD_type;
   assign src_W_Data_reg[1] = (rst)? 'b0 :  JAL_type  | JALR_type;

   //IMM_GEN
   assign Imm_I             = (rst)? 'b0 : { {20{Instruction[31]}}, Instruction[31:20] };

   assign Imm_S             = (rst)? 'b0 :{ {20{Instruction[31]}}, Instruction[31:25],Instruction[11:7]};
                            
   assign Imm_B             = (rst)? 'b0 :{ {19{Instruction[31]}}, Instruction[31], Instruction[7],
                              Instruction[30:25], Instruction[11:8], 1'b0 };
                              
   assign Imm_J             = (rst)? 'b0 :{ {11{Instruction[31]}}, Instruction[31], Instruction[19:12],
                               Instruction[20], Instruction[30:21], 1'b0 };
                              
   assign Imm_U             = (rst)? 'b0 :{ Instruction[31:12], 12'b0 };
                          
   assign Imm_Select_I      = (rst)? 'b0 : (opcode == OPCODE_IMM)  | (opcode == OPCODE_LOAD) |
                               (opcode == OPCODE_JALR) | (opcode == OPCODE_SYSTEM);       

   assign Imm_Select_S      =  (rst)? 'b0 :(opcode == OPCODE_STORE);
   assign Imm_Select_B      =  (rst)? 'b0 :(opcode == OPCODE_BRANCH);    
   assign Imm_Select_J      =  (rst)? 'b0 :(opcode == OPCODE_JAL);   
   assign Imm_Select_U      =  (rst)? 'b0 :(opcode == OPCODE_LUI)  | (opcode == OPCODE_AUIPC);   

   assign Immediate         = (rst)? 'b0 : Imm_Select_I ? Imm_I :
                               Imm_Select_S ? Imm_S :
                               Imm_Select_B ? Imm_B :
                               Imm_Select_J ? Imm_J :
                               Imm_Select_U ? Imm_U : 
                              32'b0;

   assign ALU_ADD           =  (rst)? 'b0 : ((opcode == OPCODE_REG) & 
                                    ((funct3 == FUNCT3_R_ADDSUB) & (funct7 == 7'b0000000))) |
                                ((opcode == OPCODE_IMM) & 
                                    ((funct3 == FUNCT3_I_ADDI))) | 
                                (opcode == OPCODE_LOAD)          |
                                (opcode == OPCODE_STORE)         |
                                (opcode == OPCODE_JAL)           |
                                (opcode == OPCODE_JALR)          |
                                (opcode == OPCODE_AUIPC);

   assign ALU_SUB           =  (rst)? 'b0 :  ((opcode == OPCODE_REG) & 
                                    ((funct3 == FUNCT3_R_ADDSUB) & (funct7 == 7'b0100000))) |             
                                 (opcode == OPCODE_BRANCH); 

   assign ALU_AND           =  (rst)? 'b0 :  ((opcode == OPCODE_REG) & 
                                    ((funct3 == FUNCT3_R_AND)    & (funct7 == 7'b0000000))) |             
                                 ((opcode == OPCODE_IMM) & 
                                    ((funct3 == FUNCT3_I_ANDI)));
                                
   assign ALU_XOR           =  (rst)? 'b0 :  ((opcode == OPCODE_REG) & 
                                    ((funct3 == FUNCT3_R_XOR)    & (funct7 == 7'b0000000))) |             
                                 ((opcode == OPCODE_IMM) & 
                                    ((funct3 == FUNCT3_I_XORI)));


   assign ALU_OR            =  (rst)? 'b0 :  ((opcode == OPCODE_REG) & 
                                    ((funct3 == FUNCT3_R_OR)   & (funct7 == 7'b0000000))) |             
                                 ((opcode == OPCODE_IMM) & 
                                    ((funct3 == FUNCT3_I_ORI))); 

   assign ALU_SLT           =  (rst)? 'b0 :  ((opcode == OPCODE_REG) & 
                                    ((funct3 == FUNCT3_R_SLT)  & (funct7 == 7'b0000000))) |             
                                 ((opcode == OPCODE_IMM) & 
                                    ((funct3 == FUNCT3_I_SLTI)));  

   assign ALU_SLTU          =  (rst)? 'b0 :  ((opcode == OPCODE_REG) & 
                                    ((funct3 == FUNCT3_R_SLTU) & (funct7 == 7'b0000000))) |             
                                 ((opcode == OPCODE_IMM) & 
                                    ((funct3 == FUNCT3_I_SLTIU)));


   assign ALU_SLL           =  (rst)? 'b0 :  ((opcode == OPCODE_REG)  & 
                                    ((funct3 == FUNCT3_R_SLL) & (funct7 == 7'b0000000))) |             
                                 ((opcode == OPCODE_IMM) & 
                                    ((funct3 == FUNCT3_I_SLLI)));      

   assign ALU_SRL           =  (rst)? 'b0 :  ((opcode == OPCODE_REG)  & 
                                    ((funct3 == FUNCT3_R_SR)   & (funct7 == 7'b0000000))) |             
                                 ((opcode == OPCODE_IMM) & 
                                    ((funct3 == FUNCT3_I_SRXI) & (funct7 == 7'b0000000)));

   assign ALU_SRA           =  (rst)? 'b0 :  ((opcode == OPCODE_REG)  & 
                                    ((funct3 == FUNCT3_R_SR)   & (funct7 == 7'b0100000))) |             
                                 ((opcode == OPCODE_IMM) & 
                                    ((funct3 == FUNCT3_I_SRXI) & (funct7 == 7'b0100000)));                                                                              
    
   assign ALU_PASS          =  (rst)? 'b0 :  (opcode == OPCODE_LUI);                                                            
   assign ALU_NOP           =  (rst)? 'b0 :  (opcode == OPCODE_SYSTEM);        
    
   assign ALU_code          =  (rst)? 'b0 :  ALU_ADD  ? ALU_CODE_ADD  :
                                 ALU_SUB  ? ALU_CODE_SUB  :
                                 ALU_AND  ? ALU_CODE_AND  :
                                 ALU_OR   ? ALU_CODE_OR   :
                                 ALU_XOR  ? ALU_CODE_XOR  :
                                 ALU_SLT  ? ALU_CODE_SLT  :
                                 ALU_SLTU ? ALU_CODE_SLTU :
                                 ALU_SLL  ? ALU_CODE_SLL  :
                                 ALU_SRL  ? ALU_CODE_SRL  :
                                 ALU_SRA  ? ALU_CODE_SRA  :
                                 ALU_PASS ? ALU_CODE_PASS : 
                                 ALU_CODE_NOP;

   assign Mask_code         = (rst)? 'b0 : (funct3[1]) ? MASK_CODE_WORD:
                               (funct3[0]) ? MASK_CODE_HALF:
                                             MASK_CODE_BYTE;
   assign ReadUnsigned      = (rst)? 'b0 : funct3[2]; 
endmodule
