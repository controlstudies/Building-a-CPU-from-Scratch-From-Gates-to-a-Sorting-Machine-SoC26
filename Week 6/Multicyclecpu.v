module Multicyclecpu(
    input clk,
    input reset
);
    wire [22:0] opdec;
    wire [15:0] mem_rdata; 
    wire [1:0]  Rx, Ry;
    wire [5:0] pcout;
    wire [15:0] ir_out,mdr_out,A_out,B_out,aluout_reg,regport0,regport1,regwrite,aluout;      
    wire zero, carry, overflow;
    wire sz, sc, so;
    wire RegWrite, ALUSrcA, MemRead, MemWrite, MemtoReg, IorD, IRWrite, PCWrite, PCWriteCond;
    wire [1:0] ALUSrcB, PCSource,ALUOp; 
    wire [1:0] reg_raddr0, reg_raddr1, reg_waddr;
    wire [5:0] pc_next = (PCSource == 2'b01) ? ir_out[5:0] : aluout[5:0]; 
	 wire pc_en = PCWrite | (PCWriteCond & ((opdec[19] & sz) |(opdec[20] & !sz) | (opdec[21] & !sz & !sc) | (opdec[22] & !sc)));
    pc program_counter(
        .clk(clk),
        .rst(reset),
        .load(pc_en), 
        .inc(1'b0),
        .load_val(pc_next),           
        .pc_out(pcout)
    );
    wire [5:0] mem_addr = (IorD) ? aluout_reg[5:0] : pcout;
    datam memory( 
        .clk(clk), .memr(MemRead), .memw(MemWrite), .addr(mem_addr), .wdata(B_out), .out(mem_rdata)
    );
    IR instruction_register(.clk(clk), .write(IRWrite),  .instruct(mem_rdata), .ir(ir_out)
    );
    mdr memory_data_register( 
        .clk(clk),
        .dmem_out(mem_rdata),
        .mem(mdr_out)
    );
    extrareg reg_buffer_A(.clk(clk), .d(regport0), .q(A_out)); 
    extrareg reg_buffer_B(.clk(clk), .d(regport1), .q(B_out)); 
    extrareg reg_buffer_ALUOut(.clk(clk), .d(aluout), .q(aluout_reg)); 
    opdecoder decoder(
        .c(ir_out),
        .en(1'b1),
        .out(opdec),
        .Rx(Rx),
        .Ry(Ry)
    );
    cu control_unit(
        .clk(clk),
        .reset(reset),
        .opcoderes({1'b0, opdec}), 
        .Rx(Rx),
        .Ry(Ry),
        .RegWrite(RegWrite),
        .ALUSrcA(ALUSrcA),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .IorD(IorD),
        .IRWrite(IRWrite),
        .PCWrite(PCWrite),
        .PCWriteCond(PCWriteCond),
        .ALUSrcB(ALUSrcB),
        .PCSource(PCSource),
        .ALUOp(ALUOp),
        .reg_raddr0(reg_raddr0),
        .reg_raddr1(reg_raddr1),
        .reg_waddr(reg_waddr)
    );
    assign regwrite = (MemtoReg) ? mdr_out : aluout_reg; 

    regfile cpu_registers (
        .clk(clk), .we(RegWrite), .raddr0(reg_raddr0), .raddr1(reg_raddr1), .waddr(reg_waddr),  .wdata(regwrite), .rdata0(regport0), .rdata1(regport1)
    );
    wire [15:0] a; 
    wire [15:0] b;
    wire [2:0] alu_ctrl_out; 
    Aluc alucontrol( 
        .aluscrb(ALUSrcB), .aluop(ALUOp), .aluscra(ALUSrcA), .A(A_out), .B(B_out), .ir(ir_out), .pcout(pcout), .a(a), .b(b), .op(alu_ctrl_out)
    );
    alu cpu_alu(
        .a(a), .b(b), .op(alu_ctrl_out), .result(aluout), .zero(zero),.carry(carry), .overflow(overflow)                 
    );
    wire flag_we = (alu_ctrl_out != 3'b111) && (ALUSrcA == 1); 
    flags status_flags (
        .clk(clk),.we(flag_we),.zin(zero),.cin(carry),.oin(overflow),.zout(sz),.cout(sc), .oout(so)  
    );
    
endmodule