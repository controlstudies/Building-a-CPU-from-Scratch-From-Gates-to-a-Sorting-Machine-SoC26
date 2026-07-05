
module singlecyclecpu(
    input clk,
    input reset
);
    wire [22:0] opdec;
    wire [15:0] instr;
    wire [1:0]  Rx, Ry;
    // PC wires
    wire [5:0] pcout;
    // datapath wires
    wire [15:0] regport0, regport1, regwrite;
    wire [15:0] operand_b;

    // aLU Output wires
    wire zero, carry, overflow,sz,sc,so;
    wire [15:0] aluout;
	 wire [15:0] dmemout;
    // control Wires
    wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18;
    pc program_counter(
        .clk(clk),
        .rst(reset),
        .inc(c3),
        .load(c2),                
        .load_val(instr[5:0]),     
        .pc_out(pcout)
    );
	 flags f(
	 .we(c14),
	 .clk(clk),
	 .zin(zero),
	 .cin(carry),
	 .oin(overflow),
	 .oout(so),
	 .zout(sz),
	 .cout(sc));
    opdecoder decoder(
        .c(instr),
        .en(1'b1),
        .out(opdec),
        .Rx(Rx),
        .Ry(Ry)
    );
    cu control_unit(
        .opcoderes({1'b0, opdec}), 
        .Rx(Rx),
        .Ry(Ry),
		  .flagz(sz),.flagc(sc),.flago(so),
        .c1(c1), .c2(c2), .c3(c3), .c4(c4), .c5(c5), .c6(c6), .c7(c7), .c8(c8), .c9(c9),
        .c10(c10), .c11(c11), .c12(c12), .c13(c13), .c14(c14), .c15(c15), .c16(c16), .c17(c17), .c18(c18)
    );
	 	 assign operand_b = (c11) ? {8'b00000000, instr[7:0]} : regport1;
    regfile cpu_registers (
        .clk(clk),
        .we(c10),
        .raddr0({c4, c5}),
        .raddr1({c6, c7}),
        .waddr({c8, c9}),
        .wdata(regwrite),
        .rdata0(regport0),
        .rdata1(regport1)
    );
	     datam data_memory (
        .clk(clk),
        .we(c17),                  
        .addr(aluout[5:0]),        
        .wdata(regport1),          
        .out(dmemout)            
    );
    
    alu cpu_alu(
        .a(regport0),
        .b(operand_b),                 
        .op({c15, c13, c12}),      
        .result(aluout),             
        .zero(zero),                     
        .carry(carry),                     
        .overflow(overflow)  
			
    );
    assign regwrite = (c18) ? dmemout: aluout;
	  code_memory rom(
        .address(pcout),
        .instruction(instr)
    );
	 
endmodule