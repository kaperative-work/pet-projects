package OFA_pkg;

// OPCODE

// R-type
    localparam OPCODE_REG  = 7'b0110011;
     
     // I - type
     localparam OPCODE_IMM  = 7'b0010011;
     localparam OPCODE_LOAD   = 7'b0000011;
     localparam OPCODE_JALR   = 7'b1100111;
     localparam OPCODE_SYSTEM   = 7'b1110011;

     // S - type
     localparam OPCODE_STORE  = 7'b0100011;
     
     // B - type 
     localparam OPCODE_BRANCH = 7'b1100011;
     
     // J - type
     localparam OPCODE_JAL    = 7'b1101111;
     
     // U - type
     localparam OPCODE_LUI     = 7'b0110111;
     localparam OPCODE_AUIPC   = 7'b0010111; 

// FUNCT
// Branch - type opcode = 110 0011
    localparam FUNCT3_B_BEQ     = 3'b000;
    localparam FUNCT3_B_BNE     = 3'b001;
    localparam FUNCT3_B_BLT     = 3'b100;
    localparam FUNCT3_B_BLTU    = 3'b110;
    localparam FUNCT3_B_BGE     = 3'b101;
    localparam FUNCT3_B_BGEU    = 3'b111;


// Store - type opcode = 010 0011
    localparam FUNCT3_S_SB     = 3'b000;
    localparam FUNCT3_S_SH     = 3'b001;
    localparam FUNCT3_S_SW     = 3'b010;

// LOAD - type opcode = 000 0011
   localparam FUNCT3_L_LB      = 3'b000;
   localparam FUNCT3_L_LBU     = 3'b100;
   localparam FUNCT3_L_LH      = 3'b001;
   localparam FUNCT3_L_LHU     = 3'b101;
   localparam FUNCT3_L_LW      = 3'b010;

// REG -type opcode = 011 0011

   localparam FUNCT3_R_ADDSUB          = 3'b000;
   
   localparam FUNCT3_R_AND          = 3'b111;
   localparam FUNCT3_R_OR           = 3'b110;
   localparam FUNCT3_R_XOR          = 3'b100;
   localparam FUNCT3_R_SLL          = 3'b001;

   localparam FUNCT3_R_SR           = 3'b101;
   localparam FUNCT3_R_SLT          = 3'b010;
   localparam FUNCT3_R_SLTU         = 3'b011;

// Immediate -type opcode = 001 0011
  
  localparam FUNCT3_I_ADDI  = 3'b000;
  localparam FUNCT3_I_SLLI  = 3'b001;
  localparam FUNCT3_I_SLTI  = 3'b010;
  localparam FUNCT3_I_SLTIU = 3'b011;
  localparam FUNCT3_I_XORI  = 3'b100;
  localparam FUNCT3_I_SRXI  = 3'b101;
  localparam FUNCT3_I_ORI   = 3'b110;
  localparam FUNCT3_I_ANDI  = 3'b111;
   
// ALU
    localparam ALU_CODE_ADD	  =  4'b0000;
    localparam ALU_CODE_SUB	  =  4'b0001;
    localparam ALU_CODE_AND	  =  4'b0010;
    localparam ALU_CODE_OR	  =  4'b0011;
    localparam ALU_CODE_XOR	  =  4'b0100;
    localparam ALU_CODE_SLT	  =  4'b0101;
    localparam ALU_CODE_SLTU  =  4'b0110;
    localparam ALU_CODE_SLL	  =  4'b0111;
    localparam ALU_CODE_SRL	  =  4'b1000;
    localparam ALU_CODE_SRA	  =  4'b1001;
    localparam ALU_CODE_PASS  =  4'b1010;
    localparam ALU_CODE_NOP   =  4'b1111;

// MEMORY MASK CODE
    localparam MASK_CODE_BYTE = 2'b00;
    localparam MASK_CODE_HALF = 2'b01;
    localparam MASK_CODE_WORD = 2'b10;
// MEMORY MASK
    localparam MASK_VALUE_BYTE = 4'b0001;
    localparam MASK_VALUE_HALF = 4'b0011;
    localparam MASK_VALUE_WORD = 4'b1111;
    localparam MASK_VALUE_ERR  = 4'b0000;
  
endpackage
