module ProgramCounter(

    input wire clk,
    input wire reset,              // Active-high synchronous reset
    input wire [31:0] next_pc,     // Next PC value
    output reg [31:0] pc           // Current PC
);

always @(posedge clk)
begin
    if (reset)
        pc <= 32'd0;
    else
        pc <= next_pc;
end

endmodule


module InstructionMem(

    input  wire [31:0] address,
    output reg  [31:0] instruction

);

    // 1024 × 32-bit instruction memory
    reg [31:0] instrmem [0:1023];

    initial
    begin
        $readmemh("instr.mem", instrmem);
    end

    always @(*)
    begin
        // Convert byte address to word address
        instruction = instrmem[address[11:2]];
    end

endmodule


module RegisterFile(

    input wire clk,
    input wire rst,

    input wire RegWrite,

    input wire [4:0] Rs,
    input wire [4:0] Rt,
    input wire [4:0] Rd,

    input wire [31:0] WriteData,

    output wire [31:0] ReadDataA,
    output wire [31:0] ReadDataB

);

    // Register File (32 × 32)
    reg [31:0] Register [0:31];
    integer i;

    // Initialize Registers
    initial begin
        for(i = 0; i < 32; i = i + 1)
            Register[i] = 32'd0;
    end

    // Asynchronous Read
    assign ReadDataA = (Rs == 5'd0) ? 32'd0 : Register[Rs];
    assign ReadDataB = (Rt == 5'd0) ? 32'd0 : Register[Rt];

    // Synchronous Write
    always @(posedge clk) begin
        if(rst) begin
            for(i = 0; i < 32; i = i + 1)
                Register[i] <= 32'd0;
        end
        else if(RegWrite && (Rd != 5'd0))
            Register[Rd] <= WriteData;
    end

endmodule


module SignExtend(

    input wire [15:0] imm,
    output wire [31:0] sign_ext_imm

);

    // Sign Extend 16-bit Immediate to 32-bit
    assign sign_ext_imm = {{16{imm[15]}}, imm};

endmodule


module ZeroExtend(

    input wire [15:0] imm,
    output wire [31:0] zero_ext_imm

);

    // Zero Extend 16-bit Immediate to 32-bit
    assign zero_ext_imm = {16'b0, imm};

endmodule


module ALU(

    input wire [31:0] OperandA,
    input wire [31:0] OperandB,
    input wire [3:0] alu_control,

    output reg [31:0] result,
    output wire zero

);

    // ALU Operations
    always @(*) begin
        case (alu_control)

            4'b0000: result = OperandA & OperandB;                                  // AND
            4'b0001: result = OperandA | OperandB;                                  // OR
            4'b0010: result = OperandA + OperandB;                                  // ADD
            4'b0011: result = OperandA ^ OperandB;                                  // XOR
            4'b0100: result = OperandA << OperandB[4:0];                                 // SLL
            4'b0101: result = OperandA >> OperandB[4:0];                                 // SRL
            4'b0110: result = OperandA - OperandB;                                  // SUB
            4'b0111: result = ($signed(OperandA) < $signed(OperandB)) ? 32'd1 : 32'd0; // SLT
            4'b1000: result = $signed(OperandA) >>> OperandB[4:0];                       // SRA
            4'b1001: result = OperandB << 16;                                       // LUI
            4'b1010: result = OperandA | OperandB;   // ORI
            4'b1100: result = ~(OperandA | OperandB);   // NOR                               

            default: result = 32'd0;

        endcase
    end

    // Zero Flag
    assign zero = (result == 32'd0);

endmodule


module ControlUnit(

    input wire [5:0] opcode,

    output reg RegDst,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg [2:0] ALUOp

);

    always @(*) begin

        case(opcode)

            // R-Type
            6'b000000: begin
                RegDst   = 1'b1;
                ALUSrc   = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 3'b010;
            end

            // LW
            6'b100011: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b1;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                MemRead  = 1'b1;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 3'b000;
            end

            // SW
            6'b101011: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b1;
                Branch   = 1'b0;
                ALUOp    = 3'b000;
            end

            // BEQ
            6'b000100: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b1;
                ALUOp    = 3'b001;
            end

            // ADDI
            6'b001000: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 3'b000;
            end

            // LUI
            6'b001111: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 3'b011;
            end

            // ORI
            6'b001101: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 3'b100;
            end

            default: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 3'b000;
            end

        endcase

    end

endmodule


module ALUControl(

    input wire [2:0] ALUOp,
    input wire [5:0] funct,

    output reg [3:0] alu_control

);

    always @(*) begin

        case(ALUOp)

            // ADD (LW, SW, ADDI)
            3'b000: alu_control = 4'b0010;

            // SUB (BEQ)
            3'b001: alu_control = 4'b0110;

            // R-Type
            3'b010: begin

                case(funct)

                    6'b000000: alu_control = 4'b0100; // SLL
                    6'b000010: alu_control = 4'b0101; // SRL
                    6'b000011: alu_control = 4'b1000; // SRA
                    6'b100000: alu_control = 4'b0010; // ADD
                    6'b100010: alu_control = 4'b0110; // SUB
                    6'b100100: alu_control = 4'b0000; // AND
                    6'b100101: alu_control = 4'b0001; // OR
                    6'b100110: alu_control = 4'b0011; // XOR
                    6'b100111: alu_control = 4'b1100; // NOR
                    6'b101010: alu_control = 4'b0111; // SLT

                    default:   alu_control = 4'b1111;

                endcase

            end

            // LUI
            3'b011: alu_control = 4'b1001;

            // ORI
            3'b100: alu_control = 4'b1010;

            default: alu_control = 4'b1111;

        endcase

    end

endmodule


module DataMemory(

    input wire clk,
    input wire mem_read,
    input wire mem_write,

    input wire [31:0] addr,
    input wire [31:0] write_data,

    output reg [31:0] read_data

);

    // 1024 × 32-bit Data Memory
    reg [31:0] memory [0:1023];

    // Read Operation
    always @(*) begin
        if(mem_read)
            read_data = memory[addr[11:2]];
        else
            read_data = 32'd0;
    end

    // Write Operation
    always @(posedge clk) begin
        if(mem_write)
            memory[addr[11:2]] <= write_data;
    end

endmodule


module Mux2to1 #(parameter WIDTH = 32)(

    input wire [WIDTH-1:0] in0,
    input wire [WIDTH-1:0] in1,
    input wire sel,

    output wire [WIDTH-1:0] out

);

    assign out = sel ? in1 : in0;

endmodule


module MIPS_SingleCycle(

    input wire clk,
    input wire reset,

    output wire halt

);

    // PC Signals
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] pc_plus4;
    wire [31:0] pc_branch;

    // Instruction
    wire [31:0] instruction;

    // Control Signals
    wire RegDst;
    wire ALUSrc;
    wire MemtoReg;
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire Branch;
    wire [2:0] ALUOp;

    // Register File
    wire [4:0] write_reg_addr;
    wire [31:0] ReadDataA;
    wire [31:0] ReadDataB;
    wire [31:0] WriteBackData;

    // Immediate Extension
    wire [31:0] sign_ext_imm;
    wire [31:0] zero_ext_imm;
    wire [31:0] immediate;

    // ALU
    wire [31:0] OperandA;
    wire [31:0] OperandB;
    wire [31:0] ALUResult;
    wire [3:0] alu_control;
    wire zero;

    // Data Memory
    wire [31:0] ReadData;

    // Branch
    wire branch_taken;

    // Shift Instructions
    wire is_shift_instruction;
    wire [31:0] shamt;

    // Program Counter
    ProgramCounter PC(
        .clk(clk),
        .reset(reset),
        .next_pc(pc_next),
        .pc(pc_current)
    );

    assign pc_plus4 = pc_current + 32'd4;

    // Instruction Memory
    InstructionMem InstructionMemory(
        .address(pc_current),
        .instruction(instruction)
    );

    // Control Unit
    ControlUnit CU(
        .opcode(instruction[31:26]),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    // Destination Register MUX
    Mux2to1 #(5) RegDstMux(
        .in0(instruction[20:16]),
        .in1(instruction[15:11]),
        .sel(RegDst),
        .out(write_reg_addr)
    );

    // Register File
    RegisterFile RF(
        .clk(clk),
        .rst(reset),
        .RegWrite(RegWrite),
        .Rs(instruction[25:21]),
        .Rt(instruction[20:16]),
        .Rd(write_reg_addr),
        .WriteData(WriteBackData),
        .ReadDataA(ReadDataA),
        .ReadDataB(ReadDataB)
    );

    // Immediate Extension
    SignExtend SignExt(
        .imm(instruction[15:0]),
        .sign_ext_imm(sign_ext_imm)
    );

    ZeroExtend ZeroExt(
        .imm(instruction[15:0]),
        .zero_ext_imm(zero_ext_imm)
    );

    // ORI uses Zero Extend
    assign immediate =
        (instruction[31:26] == 6'b001101) ?
        zero_ext_imm :
        sign_ext_imm;

    // Shift Instruction Detection
    assign is_shift_instruction =
        (instruction[31:26] == 6'b000000) &&
        (
            (instruction[5:0] == 6'b000000) ||
            (instruction[5:0] == 6'b000010) ||
            (instruction[5:0] == 6'b000011)
        );

    assign shamt = {27'd0, instruction[10:6]};

    // ALU Operand A
    assign OperandA =
        is_shift_instruction ?
        ReadDataB :
        ReadDataA;

    // ALU Operand B
    wire [31:0] ALUSrcIn0;
    
    assign ALUSrcIn0 = is_shift_instruction ? shamt : ReadDataB;

    Mux2to1 #(32) ALUSrcMux(
        .in0(ALUSrcIn0),
        .in1(immediate),
        .sel(ALUSrc),
        .out(OperandB)
    );

    // ALU Control
    ALUControl ALUCtrl(
        .ALUOp(ALUOp),
        .funct(instruction[5:0]),
        .alu_control(alu_control)
    );

        // ALU
    ALU ALUUnit(
        .OperandA(OperandA),
        .OperandB(OperandB),
        .alu_control(alu_control),
        .result(ALUResult),
        .zero(zero)
    );

    // Data Memory
    DataMemory DataMem(
        .clk(clk),
        .mem_read(MemRead),
        .mem_write(MemWrite),
        .addr(ALUResult),
        .write_data(ReadDataB),
        .read_data(ReadData)
    );

    // Write Back MUX
    Mux2to1 #(32) MemtoRegMux(
        .in0(ALUResult),
        .in1(ReadData),
        .sel(MemtoReg),
        .out(WriteBackData)
    );

    // Branch Logic
    assign pc_branch = pc_plus4 + (sign_ext_imm << 2);
    assign branch_taken = Branch & zero;

    // Next PC
    assign pc_next = branch_taken ? pc_branch : pc_plus4;

    // HALT Instruction
    assign halt = (instruction == 32'hFFFFFFFF);

endmodule